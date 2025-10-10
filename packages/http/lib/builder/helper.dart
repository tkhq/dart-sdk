import 'dart:convert';
import 'dart:io';
import 'package:swagger_dart_code_generator/src/swagger_models/responses/swagger_response.dart';
import 'package:swagger_dart_code_generator/src/swagger_models/requests/swagger_request_parameter.dart';
import 'package:path/path.dart' as path;
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'types.dart';


/// Formats a Dart document using the `dart format` command.
///
/// Parameters:
/// - [targetPath]: The [String] path to the file or directory to be formatted.
/// 
/// Throws:
/// - Prints an error message if the formatting process fails or encounters an exception.
Future<void> formatDocument(String targetPath) async {
  try {
    final result = await Process.run(
      'dart',
      ['format', targetPath],
      runInShell: true,
    );

    if (result.exitCode != 0) {
      print('Failed to format $targetPath: ${result.stderr}');
    }
  } catch (e) {
    print('Error while formatting $targetPath: $e');
  }
}

/// Writes content to a file asynchronously, ensuring the parent directory exists.
///
/// Parameters:
/// - [targetPath]: The [String] path of the file to write to.
/// - [content]: The [String] content to write to the file.
Future<void> safeWriteFileAsync(String targetPath, String content) async {
  final file = File(targetPath);

  try {
    await file.parent.create(recursive: true);

    await file.writeAsString(content, mode: FileMode.write, flush: true);
  } catch (e) {
    print('Error writing to file $targetPath: $e');
    rethrow;
  }
}

/// Extracts `$ref` values from Swagger responses and parameters and maps them to readable strings.
///
/// Parameters:
/// - [responses]: A map of [SwaggerResponse] objects, keyed by status codes (e.g., "200").
/// - [parameters]: A list of [SwaggerRequestParameter] objects to extract `$ref` values from.
///
/// Returns:
/// - A map ([Map<String, String>]) where:
///   - The key is either "response" (for response `$ref`s) or "parameter" (for parameter `$ref`s).
///   - The value is the capitalized string extracted from the `$ref` path.
Map<String, String> extractRefsFromOperation(
    Map<String, SwaggerResponse> responses,
    List<SwaggerRequestParameter> parameters) {
  final Map<String, String> extractedRefs = {};

  String capitalize(String input) {
    if (input.isEmpty) return input;
    return '${input[0].toUpperCase()}${input.substring(1)}';
  }

  if (responses.containsKey('200')) {
    final SwaggerResponse response200 = responses['200']!;
    if (response200.schema?.ref.isNotEmpty == true) {
      extractedRefs['response'] =
          capitalize(response200.schema!.ref.split('/').last);
    }
  }

  final bodyParameter = parameters.firstWhere(
    (param) =>
        param.inParameter == 'body' && param.schema?.ref.isNotEmpty == true,
    orElse: () => SwaggerRequestParameter(), // Default empty parameter
  );

  if (bodyParameter.schema?.ref.isNotEmpty == true) {
    extractedRefs['parameter'] =
        capitalize(bodyParameter.schema!.ref.split('/').last);
  }

  return extractedRefs;
}

/// Verifies the validity of a list of [SwaggerRequestParameter] objects based on their `inParameter` type.
///
/// Parameters:
/// - [parameterList]: A list of [SwaggerRequestParameter] objects to validate.
void verifyParameterList(List<SwaggerRequestParameter> parameterList) {
  for (final parameter in parameterList) {
    switch (parameter.inParameter) {
      case 'body':
        break;

      case 'path':
        // Validate that `name` is a valid Dart variable name
        final name = parameter.name;
        if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(name)) {
          throw Exception(
            'Invalid path substitution key: "${name}" is not a valid variable name in Dart',
          );
        }
        break;

      case 'query':
        break;

      case 'header':
      case 'formData':
        throw Exception(
          'Unsupported parameter type: "${parameter.inParameter}"',
        );

      default:
        throw Exception(
          'Unknown parameter type: "${parameter.inParameter}"',
        );
    }
  }
}

/// Assembles a Dart documentation comment from a list of strings.
///
/// Parameters:
/// - [lineList]: A list of [String?] lines to be included in the Dart doc comment.
///
/// Returns:
/// - A [String] representing the formatted Dart doc comment, with each line prefixed by `///`
///   and empty comment lines added between entries (except after the last one).
String assembleDartDocComment(List<String?> lineList) {
  final List<String> result = [];
  final List<String> filtered = lineList
      .map((line) => line?.trim())
      .where((line) => line != null && line.isNotEmpty)
      .cast<String>()
      .toList();

  for (int i = 0; i < filtered.length; i++) {
    final String line = filtered[i];
    result.add('/// $line');
    if (i != filtered.length - 1) {
      // Add an empty comment line between entries (except after the last one)
      result.add('///');
    }
  }

  return result.join('\n');
}

/// Gets the relative import path between two file paths and normalizes it for Dart imports.
///
/// Parameters:
/// - [from]: The [String] source file path.
/// - [to]: The [String] target file path.
///
/// Returns:
/// - A [String] representing the normalized relative import path from [from] to [to].
String getImportRelativePath(String from, String to) {
  final raw = path.relative(to, from: from);
  final isTrulyUpperLevel = RegExp(r'^\.\./\.\./').hasMatch(raw);
  return raw.replaceFirst(RegExp(r'^\.\./'), isTrulyUpperLevel ? '' : './');
}

/// Resolves and processes a list of `.swagger.json` files in the specified directory.
///
/// Parameters:
/// - [rootPath]: The [String] root directory path to search for `.swagger.json` files.
///
/// Returns:
/// - A [Future] containing a [List<TFileInfo>] with the absolute paths and parsed JSON data of the files.
Future<List<TFileInfo>> resolveFileList(String rootPath) async {
  // Define the glob pattern for finding .swagger.json files
  final glob = Glob('*.swagger.json');
  final absolutePathList = glob.listSync(root: rootPath, followLinks: false);

  final fileList = <TFileInfo>[];

  for (final entity in absolutePathList) {
    if (entity is File) {
      try {
        final file = File(entity.path); 
        final content = await file.readAsString(); 
        final parsedData =
            jsonDecode(content) as Map<String, dynamic>;

        fileList.add(TFileInfo(
          absolutePath: file.absolute.path,
          parsedData: parsedData,
        ));
      } catch (e) {
        print(
            'Error reading or parsing file: ${entity.absolute.path}. Error: $e');
      }
    }
  }

  return fileList;
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}