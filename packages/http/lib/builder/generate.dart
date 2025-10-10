import 'constant.dart';
import 'helper.dart';
import 'types.dart';
import 'package:swagger_dart_code_generator/src/swagger_models/swagger_root.dart';
import 'package:swagger_dart_code_generator/src/swagger_models/requests/swagger_request_parameter.dart';

/// Generates mapped types from Swagger specifications.
///
/// This function processes each file in [fileList] to:
/// - Parse the Swagger specification into structured objects.
/// - Extract namespaces, endpoints, and operation details.
/// - Generate Dart types and mappings for API endpoints.
/// - Ensure compliance with Dart naming conventions.
///
/// Additionally, it:
/// - Validates namespaces and operation IDs.
/// - Formats the generated files using `dart format`.
///
/// Parameters:
/// - [fileList]: A list of [TFileInfo] containing parsed Swagger specifications and file metadata.
/// - [targetPath]: The directory where the generated files should be stored.
Future<void> generateMappedSwaggerTypes({
  required List<TFileInfo> fileList,
  required String targetPath,
  String prefix = '',
}) async {
  for (final fileInfo in fileList) {
    final SwaggerRoot spec = SwaggerRoot.fromJson(fileInfo.parsedData);
    final sourceAbsolutePath = fileInfo.absolutePath;

    final namespace = spec.tags.map((tag) => tag.name).firstWhere(
          (name) => name.isNotEmpty,
          orElse: () => throw Exception(
            'Invalid namespace in file "$sourceAbsolutePath"',
          ),
        );
    if (namespace.isEmpty) {
      throw Exception(
          'Invalid namespace "$namespace" in file "$sourceAbsolutePath');
    }

    final List<String> currentCodeBuffer = [];
    final Set<String> importStatementSet = {};
    final Set<String> globalStatementSet = {};

    for (final endpointEntry in spec.paths.entries) {
      final String endpointPath = endpointEntry.key;
      final methodMap = endpointEntry.value.requests;

      for (final method in ['get', 'post']) {
        if (methodMap[method] == null) {
          continue;
        }

        if (methodMap['post']!.operationId.isEmpty) {
          throw Exception(
            'Invalid operationId in path ${endpointPath}',
          );
        }

        final operation = methodMap[method]!;
        final operationId = operation.operationId;

        final bool isEndpointDeprecated = operation.deprecated;

        final List<SwaggerRequestParameter> parameterList =
            operation.parameters;

        final String upperCasedMethod = method.toUpperCase();

        final String endpointInfo = '`$upperCasedMethod $endpointPath`';

        final dartDocCommentForType = assembleDartDocComment([
          endpointInfo,
          isEndpointDeprecated ? "@deprecated" : null,
        ]);

        final refs =
            extractRefsFromOperation(operation.responses, operation.parameters);

        final TBinding responseTypeBinding = TBinding(
          name: '${prefix}T${operationId}Response',
          isBound: true,
          value: !operation.responses.containsKey('200')
              ? 'void'
              : refs['response']!,
        );

        final TBinding queryTypeBinding = TBinding(
          name: '${prefix}T${operationId}Query',
          isBound: parameterList.any((item) => item.inParameter == 'query'),
          value: 'operations["$operationId"]["parameters"]["query"]',
        );

        final TBinding bodyTypeBinding = TBinding(
          name: '${prefix}T${operationId}Body',
          isBound: method == 'post' &&
              parameterList.any((item) => item.inParameter == 'body'),
          value: refs['parameter'] ?? "Never",
        );

        final TBinding substitutionTypeBinding = TBinding(
          name: 'T${prefix}${operationId}Substitution',
          isBound: parameterList.any((item) => item.inParameter == 'path'),
          value: 'operations["$operationId"]["parameters"]["path"]',
        );

        verifyParameterList(parameterList);

        final TBinding sharedHeadersTypeBinding = TBinding(
          name: 'TStampHeaders',
          isBound: false,
          value: '{ "$STAMP_HEADER_FIELD_KEY": String }',
        );

        final TBinding inputTypeBinding = TBinding(
          name: '${prefix}T${operationId}Input',
          isBound: bodyTypeBinding.isBound ||
              queryTypeBinding.isBound ||
              substitutionTypeBinding.isBound ||
              sharedHeadersTypeBinding.isBound,
          value: '{ ${[
            if (bodyTypeBinding.isBound) 'body: ${bodyTypeBinding.name}',
            if (queryTypeBinding.isBound) 'query: ${queryTypeBinding.name}',
            if (substitutionTypeBinding.isBound)
              'substitution: ${substitutionTypeBinding.name}',
            if (sharedHeadersTypeBinding.isBound)
              'headers?: ${sharedHeadersTypeBinding.name}', // Optional, because a hook will be injecting the stamp
          ].join(', ')} }',
        );

        currentCodeBuffer.addAll(
          [queryTypeBinding, substitutionTypeBinding]
              .where((binding) => binding.isBound)
              .map((binding) => '''
                $dartDocCommentForType
                typedef ${binding.name} = ${binding.value};
              '''),
        );

        currentCodeBuffer.addAll(
          [responseTypeBinding, inputTypeBinding, bodyTypeBinding]
              .where((binding) => binding.isBound)
              .map((binding) {
            // If the binding is `inputTypeBinding`, generate a class.
            if (binding == inputTypeBinding) {
              final fields = binding.value
                  .replaceAll(RegExp(r'[{}]'), '')
                  .split(',')
                  .map((field) {
                final parts = field.split(':').map((p) => p.trim()).toList();
                final type = parts[1];
                final name = parts[0];
                return '  final $type $name;';
              }).join('\n');

              final constructorParams = binding.value
                  .replaceAll(RegExp(r'[{}]'), '')
                  .split(',')
                  .map((field) {
                final parts = field.split(':').map((p) => p.trim()).toList();
                final type = parts[1];
                final name = parts[0];
                final isOptional = type.endsWith('?');
                return isOptional ? 'this.$name,' : 'required this.$name,';
              }).join('\n    ');

              return '''
            $dartDocCommentForType
            class ${binding.name} {
              $fields

              ${binding.name}({
                $constructorParams
              });
            }
          ''';
            } else {
              return '''
            $dartDocCommentForType
            typedef ${binding.name} = ${binding.value};
          ''';
            }
          }),
        );
      }
    }

    if (currentCodeBuffer.length == 0) {
      // Nothing to generate for the current file
      return;
    }

    currentCodeBuffer.insert(
      0,
      '''
        $COMMENT_HEADER
        ${importStatementSet.where((statement) => statement.isNotEmpty).join('\n')}
        import 'public_api.swagger.dart';
        ${globalStatementSet.where((statement) => statement.isNotEmpty).join('\n')}
      ''',
    );

    await safeWriteFileAsync(
        "$targetPath/public_api.types.dart", currentCodeBuffer.join("\n\n"));
    await formatDocument(targetPath);
  }
}

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

   if (fileList.length != 1) {
      throw Exception(
          'Expected 1 spec in public API folder. Got ${fileList.length}');
    }

  final SwaggerRoot spec =
        SwaggerRoot.fromJson(fileList[0].parsedData);


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

  final importStatementSet = <String>[
    'import "public_api.types.dart";',
    'import "../../../../base.dart";',
    'import "../../../../version.dart";'
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
      
    ''');

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
    final operationId = operation.operationId;

    final bool isEndpointDeprecated = operation.deprecated;

    final String methodName = operationId[0].toLowerCase() +
        operationId.substring(1);

    final inputType = 'T${operationId}Body';
    final responseType = 'T${operationId}Response';

    codeBuffer.add(assembleDartDocComment([
      operation.description,
      'Sign the provided `$inputType` with the client\'s `stamp` function and submit the request (POST $endpointPath).',
      'See also: `stamp$operationId`.',
      if (isEndpointDeprecated) '@deprecated',
    ]));

    codeBuffer.add('''
      Future<$responseType> $methodName({
        required $inputType input,
      }) async {
        return await request<$inputType, $responseType>(
          "$endpointPath",
          input,
          (json) => $responseType.fromJson(json)
        );
      }
    ''');

    codeBuffer.add(assembleDartDocComment([
      'Produce a `SignedRequest` from `$inputType` by using the client\'s `stamp` function.',
      'See also: `$operationId`.',
      if (isEndpointDeprecated) '@deprecated',
      '\n',
    ]));

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
