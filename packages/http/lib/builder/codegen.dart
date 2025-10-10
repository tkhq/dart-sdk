import 'constant.dart';
import 'generate.dart';
import 'helper.dart';
import 'type-generator.dart';

void main() async {
    final fileList = await resolveFileList(INPUT_SWAGGER_DIRECTORY);
    // await generateMappedSwaggerTypes(fileList: fileList, targetPath: OUTPUT_GENERATED_DIRECTORY);
    await generateClientFromSwagger(fileList: fileList, targetPath: OUTPUT_GENERATED_DIRECTORY);
    generateTypesFromSwagger();
}
