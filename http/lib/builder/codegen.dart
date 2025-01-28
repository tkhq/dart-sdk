import 'package:build/build.dart';
import 'constant.dart';
import 'generate.dart';
import 'helper.dart';
import 'package:swagger_dart_code_generator/src/swagger_models/swagger_root.dart';

class Codegen implements Builder {
  Codegen(this.options);

  final BuilderOptions options;

  @override
  Map<String, List<String>> get buildExtensions => {
        '.swagger.json': ['.swagger.custom.swagger.dart'],
      };

  @override
  Future<void> build(BuildStep buildStep) async {

    final fileList = await resolveFileList(INPUT_SWAGGER_DIRECTORY);

    await generateFetchers(fileList: fileList, targetPath: OUTPUT_GENERATED_DIRECTORY);

    if (fileList.length != 1) {
      throw Exception(
          'Expected 1 spec in public API folder. Got ${fileList.length}');
    }

    final SwaggerRoot publicApiSwaggerSpec =
        SwaggerRoot.fromJson(fileList[0].parsedData);

    print('hellos');
    await generateClientFromSwagger(spec: publicApiSwaggerSpec, targetPath: OUTPUT_GENERATED_DIRECTORY );
  }
}
