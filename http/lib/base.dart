import 'dart:convert';
import 'dart:io';
import 'package:turnkey_dart_api_stamper/api_stamper.dart';
import 'package:turnkey_encoding/encoding.dart';
import 'config.dart';
import 'webauth.dart';

typedef TBasicType = String;
typedef TQueryShape = Map<String, TBasicType>;
typedef THeadersShape = Map<String, TBasicType>?;
typedef TBodyShape = dynamic;
typedef TSubstitutionShape = Map<String, dynamic>;

final THeadersShape sharedHeaders = {};

final Map<String, dynamic> sharedRequestOptions = {
  'redirect': 'follow',
};

@Deprecated('This function is deprecated.')
Future<SignedRequest> signedRequest<B extends Map<String, dynamic>?,
    Q extends Map<String, dynamic>?, S extends Map<String, dynamic>?>({
  required String uri,
  Q? query,
  B? body,
  S? substitution,
}) async {
  final Q inputQuery = query ?? {} as Q;
  final S inputSubstitution = substitution ?? {} as S;
  final B inputBody = body ?? {} as B;

  final Uri url = constructUrl(
    uri: uri,
    query: inputQuery as Map<String, dynamic>,
    substitution: inputSubstitution as Map<String, dynamic>,
  );

  final jsonBody = jsonEncode(inputBody);

  final stamp = await getWebAuthnAssertion(jsonBody);

  // Return the signed request
  return SignedRequest(
    url: url.toString(),
    body: jsonBody,
    stamp: stamp,
  );
}

Future<TResponse> request<
    TResponse,
    TBody extends TBodyShape,
    TQuery extends TQueryShape,
    TSubstitution extends TSubstitutionShape,
    THeaders extends THeadersShape>({
  required String uri,
  required String method,
  THeaders? headers,
  TQuery? query,
  TBody? body,
  TSubstitution? substitution,
}) async {
  // Construct the URL with query parameters and substituted placeholders
  final Uri url = constructUrl(
    uri: uri,
    query: query ?? {},
    substitution: substitution ?? {},
  );

  // Seal and stamp the request body
  final Map<String, String> sealedBodyAndStamp =
      await sealAndStampRequestBody(body: body ?? {});
  final String sealedBody = sealedBodyAndStamp['sealedBody']!;
  final String xStamp = sealedBodyAndStamp['xStamp']!;

  // Merge headers
  final Map<String, String> requestHeaders = {
    ...?sharedHeaders,
    ...?headers,
    'X-Stamp': xStamp,
  };

  final HttpClient httpClient = HttpClient();
  late HttpClientRequest httpRequest;
  late HttpClientResponse response;

  try {
    // Ensure the request is POST
    if (method.toUpperCase() != 'POST') {
      throw ArgumentError('Unsupported method: $method');
    }

    // Create a POST request
    httpRequest = await httpClient.postUrl(url);

    // Add headers
    requestHeaders.forEach((key, value) {
      httpRequest.headers.set(key, value);
    });

    // Add the body to the request
    httpRequest.write(sealedBody);

    // Await the response
    response = await httpRequest.close();

    // Handle non-OK responses
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final String errorBody = await response.transform(utf8.decoder).join();
      try {
        final Map<String, dynamic> errorData = jsonDecode(errorBody);
        throw TurnkeyRequestError(GrpcStatus.fromJson(errorData));
      } catch (_) {
        throw Exception('${response.statusCode} ${response.reasonPhrase}');
      }
    }

    // Parse and return the response body
    final String responseBody = await response.transform(utf8.decoder).join();
    return jsonDecode(responseBody) as TResponse;
  } finally {
    httpClient.close();
  }
}

/// Constructs a URL with query parameters and substituted placeholders.
///
/// Parameters:
/// - [input]: An object containing:
///   - [uri]: The [String] URI containing placeholders in the format `{key}`.
///   - [query]: A [Map<String, dynamic>] representing query parameters.
///   - [substitution]: A [Map<String, dynamic>] for substituting placeholders in the URI.
///
/// Returns:
/// - A [Uri] object with the base URL, substituted path, and query parameters.
Uri constructUrl({
  required String uri,
  required Map<String, dynamic> query,
  required Map<String, dynamic> substitution,
}) {
  final String baseUrl = getBaseUrl();

  // Substitute placeholders in the URI
  final String substitutedPath = substitutePath(uri, substitution);

  // Create the base URL with the substituted path
  final Uri baseUri = Uri.parse(baseUrl).resolve(substitutedPath);

  // Add query parameters
  final Map<String, String> queryParams = {};
  query.forEach((key, value) {
    if (value is List) {
      for (final item in value) {
        queryParams[key] = item.toString();
      }
    } else {
      queryParams[key] = value?.toString() ?? '';
    }
  });

  return baseUri.replace(queryParameters: queryParams);
}

/// Retrieves the base URL from the configuration.
///
/// First attempts to get it from [getConfig], and if that fails,
/// falls back to [getBrowserConfig].
String getBaseUrl() {
  try {
    final config = getConfig();
    return config.baseUrl;
  } catch (e) {
    final browserConfig = getBrowserConfig();
    return browserConfig.baseUrl;
  }
}

/// Substitutes placeholders in the given URI with values from the [substitutionMap].
///
/// Parameters:
/// - [uri]: The [String] URI containing placeholders in the format `{key}`.
/// - [substitutionMap]: A [Map<String, dynamic>] containing key-value pairs for substitution.
///
/// Returns:
/// - A [String] with all placeholders replaced by their corresponding values.
///
/// Throws:
/// - [Exception]: If a placeholder is not found in the substitution map or if
///   unsubstituted placeholders remain in the URI.
String substitutePath(String uri, Map<String, dynamic> substitutionMap) {
  String result = uri;

  for (final key in substitutionMap.keys) {
    final output = result.replaceAll('{$key}', substitutionMap[key].toString());
    invariant(
      output != result,
      'Substitution error: cannot find "$key" in URI "$uri". `substitutionMap`: ${jsonEncode(substitutionMap)}',
    );

    result = output;
  }

  invariant(
    !RegExp(r'\{.*\}').hasMatch(result),
    'Substitution error: found unsubstituted components in "$result"',
  );

  return result;
}

/// Throws an [Exception] if the given [condition] is not true.
///
/// Parameters:
/// - [condition]: The condition to evaluate.
/// - [message]: The error message to throw if the condition is false.
void invariant(bool condition, String message) {
  if (!condition) {
    throw Exception(message);
  }
}

/// Converts a [Map<String, dynamic>] into a JSON string representation.
///
/// Parameters:
/// - [input]: The [Map<String, dynamic>] to stringify.
///
/// Returns:
/// - A [String] containing the JSON representation of the input.
String stableStringify(Map<String, dynamic> input) {
  return jsonEncode(input);
}

/// Seals and stamps the request body with your Turnkey API credentials.
///
/// You can either:
/// - Before calling [sealAndStampRequestBody], initialize with your Turnkey API credentials via `init(...)`.
/// - Or, provide [apiPublicKey] and [apiPrivateKey] here as arguments.
Future<Map<String, String>> sealAndStampRequestBody({
  required Map<String, dynamic> body,
  String? apiPublicKey,
  String? apiPrivateKey,
}) async {
  // Fallback to configuration if keys are not provided
  apiPublicKey ??= getConfig().apiPublicKey;
  apiPrivateKey ??= getConfig().apiPrivateKey;

  // Serialize the body to a stable string format
  final String sealedBody = stableStringify(body);

  // Generate the signature
  final String signature = await signWithApiKey(
    apiPublicKey,
    apiPrivateKey,
    sealedBody,
  );

  // Create the sealed stamp
  final String sealedStamp = stableStringify({
    'publicKey': apiPublicKey,
    'scheme': 'SIGNATURE_SCHEME_TK_API_P256',
    'signature': signature,
  });

  // Convert the sealed stamp to base64 URL-safe string
  final String xStamp = stringToBase64urlString(sealedStamp);

  return {
    'sealedBody': sealedBody,
    'xStamp': xStamp,
  };
}

class THttpConfig {
  final String baseUrl;

  THttpConfig({
    required this.baseUrl,
  });
}

// Deprecated
class SignedRequest {
  final String body;
  final String stamp;
  final String url;

  SignedRequest({
    required this.body,
    required this.stamp,
    required this.url,
  });
}


/// Represents a signed request ready to be POSTed to Turnkey
class TSignedRequest {
  final String body;
  final TStamp stamp;
  final String url;

  TSignedRequest({
    required this.body,
    required this.stamp,
    required this.url,
  });
}

// Represents a stamp header name/value pair
class TStamp {
  final String stampHeaderName;
  final String stampHeaderValue;

  TStamp({
    required this.stampHeaderName,
    required this.stampHeaderValue,
  });
}

class GrpcStatus {
  final String message;
  final int code;
  final List<dynamic>? details;

  GrpcStatus({
    required this.message,
    required this.code,
    this.details,
  });

  factory GrpcStatus.fromJson(Map<String, dynamic> json) {
    return GrpcStatus(
      message: json['message'] as String,
      code: json['code'] as int,
      details: json['details'] as List<dynamic>?, // This can be null
    );
  }
}

/// Interface to implement if you want to provide your own stampers for your [TurnkeyClient].
///
/// Currently, Turnkey provides two stampers:
/// - Applications signing requests with Passkeys or WebAuthn devices should use `@turnkey/webauthn-stamper`.
/// - Applications signing requests with API keys should use `@turnkey/api-key-stamper`.
abstract class TStamper {
  Future<TStamp> stamp(String input);
}

class TurnkeyRequestError implements Exception {
  final List<dynamic>? details;
  final int code;
  final String message;

  TurnkeyRequestError(GrpcStatus status)
      : details = status.details,
        code = status.code,
        message = _generateMessage(status);

  static String _generateMessage(GrpcStatus status) {
    var errorMessage = 'Turnkey error ${status.code}: ${status.message}';

    if (status.details != null) {
      errorMessage += ' (Details: ${jsonEncode(status.details)})';
    }

    return errorMessage;
  }

  @override
  String toString() => message;
}
