// tool/push_package_tags.dart
//
// Reads release meta and pushes git tags for each bumped package.
// Tag format: {package_name}-{version}

import 'dart:io';

import 'changeset_lib.dart';

void main(List<String> args) {
  final dryRun = args.contains('--dry-run');

  final metaFile = File('$changesetDirName/$releaseMetaFileName');
  if (!metaFile.existsSync()) {
    stdout.writeln('No release meta file found - nothing to tag');
    return;
  }

  final meta = readReleaseMeta();

  if (meta.packages.isEmpty) {
    stdout.writeln('No packages in release meta - nothing to tag');
    return;
  }

  stdout.writeln(dryRun ? 'Would push tags:' : 'Pushing package tags:');

  for (final pkg in meta.packages) {
    final tag = '${pkg.name}-${pkg.toVersion}';
    stdout.writeln('  - $tag');

    if (!dryRun) {
      // Create the tag
      var result = Process.runSync('git', ['tag', tag]);
      if (result.exitCode != 0) {
        stderr.writeln('Failed to create tag $tag: ${result.stderr}');
        exitCode = result.exitCode;
        return;
      }

      // Push the tag
      result = Process.runSync('git', ['push', 'origin', tag]);
      if (result.exitCode != 0) {
        stderr.writeln('Failed to push tag $tag: ${result.stderr}');
        exitCode = result.exitCode;
        return;
      }
    }
  }

  stdout.writeln(dryRun ? '\nDry run complete' : '\nAll tags pushed');
}
