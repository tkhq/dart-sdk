import 'constant.dart';
import 'generate.dart';
import 'helper.dart';
import 'type-generator.dart';

String _extractNamespace(Map<String, dynamic> spec) {
  final tags = spec['tags'];
  if (tags is! List) {
    return '';
  }

  for (final tag in tags) {
    if (tag is Map<String, dynamic>) {
      final name = tag['name'];
      if (name is String && name.isNotEmpty) {
        return name;
      }
    }
  }

  return '';
}

int _namespaceSortKey(Map<String, dynamic> spec) {
  final orderedNamespaces = NAMESPACE_TO_DART_PREFIX.keys.toList();
  final namespace = _extractNamespace(spec);
  final index = orderedNamespaces.indexOf(namespace);
  return index == -1 ? orderedNamespaces.length : index;
}

void main() async {
  final fileList = await resolveFileList(INPUT_SWAGGER_DIRECTORY);
  fileList.sort((a, b) {
    // Keep generated client output stable across filesystems and CI runners.
    final namespaceCompare = _namespaceSortKey(a.parsedData).compareTo(
      _namespaceSortKey(b.parsedData),
    );
    if (namespaceCompare != 0) {
      return namespaceCompare;
    }

    return a.absolutePath.compareTo(b.absolutePath);
  });

  // await generateMappedSwaggerTypes(fileList: fileList, targetPath: OUTPUT_GENERATED_DIRECTORY);
  await generateClientFromSwagger(
      fileList: fileList, targetPath: OUTPUT_GENERATED_DIRECTORY);
  generateTypesFromSwagger();
}
