import 'dart:convert';
import 'package:turnkey_dart_api_stamper/api_stamper.dart';
import 'package:turnkey_encoding/encoding.dart';
import 'config.dart';

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

  final String sealedBody = stableStringify(body);

  final String signature = await signWithApiKey(
    apiPublicKey,
    apiPrivateKey,
    sealedBody,
  );

  final String sealedStamp = stableStringify({
    'publicKey': apiPublicKey,
    'scheme': 'SIGNATURE_SCHEME_TK_API_P256',
    'signature': signature,
  });

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
