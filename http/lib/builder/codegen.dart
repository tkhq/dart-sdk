import 'package:build/build.dart';
import 'constant.dart';
import 'generate.dart';
import 'helper.dart';

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

    await generateMappedSwaggerTypes(fileList: fileList, targetPath: OUTPUT_GENERATED_DIRECTORY);
    await generateClientFromSwagger(fileList: fileList, targetPath: OUTPUT_GENERATED_DIRECTORY );
  }
}
