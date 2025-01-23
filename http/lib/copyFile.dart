import 'dart:convert';
import 'dart:io';

import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' show join;
import 'package:swagger_dart_code_generator/src/swagger_models/swagger_root.dart';
import 'package:swagger_dart_code_generator/src/extensions/file_name_extensions.dart';
import 'package:swagger_dart_code_generator/src/extensions/yaml_extensions.dart';
import 'package:yaml/yaml.dart';

class CustomSwaggerGenerator implements Builder {
  CustomSwaggerGenerator(this.options);

  final BuilderOptions options;

  @override
  Map<String, List<String>> get buildExtensions => {
        '.swagger.json': ['.swagger.custom.swagger.dart'],
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    final contents = await buildStep.readAsString(inputId);

    print('good morning');

    Map<String, dynamic> contentMap;


    contentMap = jsonDecode(contents) as Map<String, dynamic>;



    final swaggerRoot = SwaggerRoot.fromJson(contentMap);

    final namespace = swaggerRoot.tags.firstWhere((element) => element.name != null)?.name;

    if (namespace == null) {
      throw Exception('Invalid namespace in spec, cannot generate HTTP client');
    }

    final importStatements = [
      'import \'package:http/http.dart\' as http;',
      'import \'dart:convert\';',
    ];

    final codeBuffer = StringBuffer();

    codeBuffer.writeln('class TurnkeyClient {');
    codeBuffer.writeln('  final String baseUrl;');
    codeBuffer.writeln('  final Stamper stamper;');
    codeBuffer.writeln('');
    codeBuffer.writeln('  TurnkeyClient({required this.baseUrl, required this.stamper});');
    codeBuffer.writeln('');
    codeBuffer.writeln('  Future<T> request<T>(String url, dynamic body) async {');
    codeBuffer.writeln('    final fullUrl = baseUrl + url;');
    codeBuffer.writeln('    final stringifiedBody = jsonEncode(body);');
    codeBuffer.writeln('    final stamp = await stamper.stamp(stringifiedBody);');
    codeBuffer.writeln('');
    codeBuffer.writeln('    final response = await http.post(');
    codeBuffer.writeln('      Uri.parse(fullUrl),');
    codeBuffer.writeln('      headers: {');
    codeBuffer.writeln('        stamp.stampHeaderName: stamp.stampHeaderValue,');
    codeBuffer.writeln('        \'X-Client-Version\': \'1.0.0\',');
    codeBuffer.writeln('      },');
    codeBuffer.writeln('      body: stringifiedBody,');
    codeBuffer.writeln('    );');
    codeBuffer.writeln('');
    codeBuffer.writeln('    if (response.statusCode != 200) {');
    codeBuffer.writeln('      throw Exception(\'Failed to load data\');');
    codeBuffer.writeln('    }');
    codeBuffer.writeln('');
    codeBuffer.writeln('    return jsonDecode(response.body) as T;');
    codeBuffer.writeln('  }');
    codeBuffer.writeln('');

    swaggerRoot.paths.forEach((path, pathItem) {
      for (var operation in pathItem.requests.entries) {

        if (operation.key == 'post') {
          final operationId = operation.value.operationId;
          final operationNameWithoutNamespace = operationId.replaceFirst('${namespace}_', '').toLowerCase();
          final methodName = operationNameWithoutNamespace.replaceFirst(operationNameWithoutNamespace[0], operationNameWithoutNamespace[0].toUpperCase());

         // codeBuffer.writeln('  Future<${operation.value.responses.values.first.schema!.type}> $methodName(${operation.value.parameters.first.type} input) async {');
          codeBuffer.writeln('    return request(\'$path\', input);');
          codeBuffer.writeln('  }');
          codeBuffer.writeln('');
        }
      }
    });

    codeBuffer.writeln('}');

    final imports = importStatements.join('\n');
    final formattedCode = _tryFormatCode(imports + '\n\n' + codeBuffer.toString());

    final outputId = inputId.changeExtension('.custom.swagger.dart');
    await buildStep.writeAsString(outputId, formattedCode);
  }

  String _tryFormatCode(String code) {
    return code;
    try {
      final formattedResult = DartFormatter().format(code);
      return formattedResult;
    } catch (e) {
      print('''[WARNING] Code formatting failed.
          Please raise an issue on https://github.com/epam-cross-platform-lab/swagger-dart-code-generator/issues/
          Reason: $e''');
      return code;
    }
  }
}