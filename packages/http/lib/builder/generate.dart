import 'constant.dart';
import 'helper.dart';
import 'types.dart';
import 'type-gen/helpers.dart';
import 'package:swagger_dart_code_generator/src/swagger_models/swagger_root.dart';
// import 'package:swagger_dart_code_generator/src/swagger_models/requests/swagger_request_parameter.dart';

/// Generates a Dart HTTP client class from a Swagger specification.
///
/// Parameters:
/// - [spec]: The [SwaggerRoot] containing the parsed Swagger specification.
/// - [targetPath]: The [String] file path where the generated client code will be written.
///
/// This function performs the following:
/// - Extracts the namespace from the Swagger tags.
/// - Validates namespace and operation IDs for compliance.
/// - Generates an `HTTP Client` class with methods to interact with API endpoints.
/// - Adds methods for stamping and sending POST requests, as well as generating signed requests.
/// - Organizes and writes the generated code into a Dart file at the specified [targetPath].
///
/// Returns:
/// - A [Future] that resolves when the client generation process is complete.
Future<void> generateClientFromSwagger({
  required List<TFileInfo> fileList,
  required String targetPath,
}) async {
  final importStatementSet = <String>[
    'import "models.dart";',
    'import "../base.dart";',
    'import "../version.dart";',
    'import "dart:convert";',
    'import "dart:async";',
    'import "dart:io";',
  ];

  final List<String> codeBuffer = [];

  codeBuffer.add('''
      /// HTTP Client for interacting with Turnkey API
      class TurnkeyClient {
        final THttpConfig config;
        final TStamper stamper;

        TurnkeyClient({required this.config, required this.stamper}) {
          if (config.baseUrl.isEmpty) {
            throw Exception('Missing base URL. Please verify environment variables.');
          }
        }

        Future<TResponseType> request<TBodyType, TResponseType>(
          String url,
          TBodyType body,
          TResponseType Function(Map<String, dynamic>) fromJson,

        ) async {
          final fullUrl = '\${config.baseUrl}\$url';
          final stringifiedBody = jsonEncode(body);
          final stamp = await stamper.stamp(stringifiedBody);

          final client = HttpClient();
          try {
            final request = await client.postUrl(Uri.parse(fullUrl));
            request.headers.set(stamp.stampHeaderName, stamp.stampHeaderValue);
            request.headers.set('X-Client-Version', VERSION);
            request.headers.contentType = ContentType.json;
            request.write(stringifiedBody);

            final response = await request.close();

            if (response.statusCode != 200) {
              final errorBody = await response.transform(utf8.decoder).join();
              throw TurnkeyRequestError(
                GrpcStatus.fromJson(jsonDecode(errorBody)),
              );
            }

            final responseBody = await response.transform(utf8.decoder).join();
            final decodedJson = jsonDecode(responseBody) as Map<String, dynamic>;

            return fromJson(decodedJson);
          } finally {
            client.close();
          }
        }

        Future<TResponseType> authProxyRequest<TBodyType, TResponseType>(
          String url,
          TBodyType body,
          TResponseType Function(Map<String, dynamic>) fromJson,

        ) async {
          if (config.authProxyConfigId == null || config.authProxyConfigId!.isEmpty) {
            throw Exception('Missing Auth Proxy config ID. Please verify environment variables.');
          }
          final fullUrl = '\${config.authProxyBaseUrl}\$url';
          final stringifiedBody = jsonEncode(body);

          final client = HttpClient();
          try {
            final request = await client.postUrl(Uri.parse(fullUrl));
            request.headers.set("X-Auth-Proxy-Config-ID", config.authProxyConfigId!);
            request.headers.set('X-Client-Version', VERSION);
            request.headers.contentType = ContentType.json;
            request.write(stringifiedBody);

            final response = await request.close();

            if (response.statusCode != 200) {
              final errorBody = await response.transform(utf8.decoder).join();
              throw TurnkeyRequestError(
                GrpcStatus.fromJson(jsonDecode(errorBody)),
              );
            }

            final responseBody = await response.transform(utf8.decoder).join();
            final decodedJson = jsonDecode(responseBody) as Map<String, dynamic>;

            return fromJson(decodedJson);
          } finally {
            client.close();
          }
        }

        /// Build the server envelope.
        Map<String, dynamic> makeEnvelope({
          required String organizationId,
          String? timestampMs,
          required Map<String, dynamic> parameters,
        }) {
          return {
            'organizationId': organizationId,
            'timestampMs': timestampMs ?? DateTime.now().millisecondsSinceEpoch.toString(),
            'parameters': parameters,
          };
        }

        /// Build `parameters` by taking everything from [src] except the keys in [exclude].
        /// Null values are dropped by default to keep payloads lean.
        Map<String, dynamic> paramsFromBody(
          Map<String, dynamic> src, {
          Iterable<String> exclude = const [],
          bool dropNulls = true,
        }) {
          final out = Map<String, dynamic>.from(src);
          for (final k in exclude) {
            out.remove(k);
          }
          // Optionally drop nulls
          if (dropNulls) {
            out.removeWhere((_, v) => v == null);
          }
          return out;
        }

        /// For command/activityDecision bodies generated by codegen:
        Map<String, dynamic> packActivityBody({
          required Map<String, dynamic> bodyJson,
          required String fallbackOrganizationId,
        }) {
          final orgId = (bodyJson['organizationId'] as String?) ?? fallbackOrganizationId;
          final ts = bodyJson['timestampMs'] as String?;

          // Exclude envelope keys (and guard against accidental nesting)
          final params = paramsFromBody(
            bodyJson,
            exclude: const ['organizationId', 'timestampMs', 'parameters'],
          );

          return makeEnvelope(
            organizationId: orgId,
            timestampMs: ts,
            parameters: params,
          );
        }
      
    ''');

  for (final file in fileList) {
    print('Processing file: ${file.absolutePath}');

    final SwaggerRoot spec = SwaggerRoot.fromJson(file.parsedData);

    final namespace = spec.tags.map((tag) => tag.name).firstWhere(
          (name) => name.isNotEmpty,
          orElse: () => throw Exception(
            'Invalid namespace in spec, cannot generate HTTP client',
          ),
        );

    if (namespace.isEmpty) {
      throw Exception(
          'Invalid namespace "$namespace" in spec, cannot generate HTTP client');
    }

    final String prefix = NAMESPACE_TO_DART_PREFIX[namespace] ??
        (throw Exception(
            'No Dart prefix mapping found for namespace "$namespace"'));
    final bool isProxy = prefix == 'Proxy';

    for (final endpointEntry in spec.paths.entries) {
      final String endpointPath = endpointEntry.key;
      final methodMap = endpointEntry.value.requests;
      if (methodMap['post'] == null) {
        throw Exception(
          'Found a non-POST endpoint in public API swagger!',
        );
      }

      if (methodMap['post']!.operationId.isEmpty) {
        throw Exception(
          'Invalid operationId in path ${endpointPath}',
        );
      }

      final operation = methodMap['post']!;
      // Remove the MethodId_ prefix if it exists
      final operationId = operation.operationId.indexOf('_') != -1
          ? operation.operationId.split('_')[1]
          : operation.operationId;

      final bool isEndpointDeprecated = operation.deprecated;

      final String methodName =
          operationId[0].toLowerCase() + operationId.substring(1);

      final mType = methodTypeFromMethodName("t$methodName", prefix);

      final inputType = '${prefix}T${operationId}Body';
      final responseType = '${prefix}T${operationId}Response';

      codeBuffer.add(assembleDartDocComment([
        operation.description,
        'Sign the provided `$inputType` with the client\'s `stamp` function and submit the request (POST $endpointPath).',
        'See also: `stamp$operationId`.',
        if (isEndpointDeprecated) '@deprecated',
      ]));

      if (mType == 'activityDecision' || mType == 'command') {
        codeBuffer.add('''
      Future<$responseType> ${prefix.toLowerCase()}${prefix.isEmpty ? methodName : methodName.capitalize()}({
        required $inputType input,
      }) async {
        final body = packActivityBody(
          bodyJson: input.toJson(),
          fallbackOrganizationId: config.organizationId!,
        );
        return await request<Map<String, dynamic>, $responseType>(
          "$endpointPath",
          body,
          (json) => $responseType.fromJson(json)
        );
      }
    ''');
      } else if (mType == 'noop' || mType == 'query') {
        codeBuffer.add('''
      Future<$responseType> ${prefix.toLowerCase()}${prefix.isEmpty ? methodName : methodName.capitalize()}({
        required $inputType input,
      }) async {
        return await request<$inputType, $responseType>(
          "$endpointPath",
          input,
          (json) => $responseType.fromJson(json)
        );
      }
    ''');
      } else if (mType == 'proxy') {
        codeBuffer.add('''
      Future<$responseType> ${prefix.toLowerCase()}${prefix.isEmpty ? methodName : methodName.capitalize()}({
        required $inputType input,
      }) async {
        return await authProxyRequest<$inputType, $responseType>(
          "$endpointPath",
          input,
          (json) => $responseType.fromJson(json)
        );
      }
    ''');
      } else {
        throw Exception('Unknown method type "$mType"');
      }

      codeBuffer.add(assembleDartDocComment([
        'Produce a `SignedRequest` from `$inputType` by using the client\'s `stamp` function.',
        'See also: `$operationId`.',
        if (isEndpointDeprecated) '@deprecated',
        '\n',
      ]));

      if (!isProxy) {
        codeBuffer.add('''
      Future<TSignedRequest> stamp$operationId({
        required $inputType input,
        }) async {
          final fullUrl = '\${config.baseUrl}$endpointPath';
          final body = jsonEncode(input);
          final stamp = await stamper.stamp(body);

          return TSignedRequest(
            body: body,
            stamp: stamp,
            url: fullUrl,
          );
        }
    ''');
      }
    }
  }

  // End of the TurnkeyClient class definition
  codeBuffer.add('}');

  final imports = importStatementSet
      .where((importStatement) => importStatement.isNotEmpty)
      .join("\n");

// Combine the comment header, imports, and code buffer
  final output = [
    COMMENT_HEADER,
    imports,
    ...codeBuffer,
  ].join("\n\n");

  await safeWriteFileAsync("$targetPath/public_api.client.dart", output);
  await formatDocument(targetPath);
}
