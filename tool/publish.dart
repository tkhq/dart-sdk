// tool/publish.dart
//
// Publishes packages listed in .changeset/.last_bumped_packages to pub.dev.
// Uses trusted publishing (OIDC) when run in GitHub Actions.

import 'dart:io';

import 'changeset_lib.dart';

void main(List<String> args) {
  final dryRun = args.contains('--dry-run');

  final bumpedFile = File('$changesetDirName/.last_bumped_packages');
  if (!bumpedFile.existsSync()) {
    stdout.writeln('No .last_bumped_packages file found - nothing to publish');
    return;
  }

  final packageNames = bumpedFile
      .readAsLinesSync()
      .where((line) => line.trim().isNotEmpty)
      .toList();

  if (packageNames.isEmpty) {
    stdout.writeln('No packages to publish');
    return;
  }

  stdout.writeln(dryRun ? 'Dry run publishing:' : 'Publishing:');

  for (final pkgName in packageNames) {
    final pkgDir = Directory('$packagesRootDirName/$pkgName');
    if (!pkgDir.existsSync()) {
      stderr.writeln('Warning: package directory ${pkgDir.path} not found');
      continue;
    }

    stdout.writeln('  - $pkgName...');

    final result = Process.runSync(
      'dart',
      ['pub', 'publish', if (dryRun) '--dry-run' else '--force'],
      workingDirectory: pkgDir.path,
    );

    stdout.write(result.stdout);
    if (result.stderr.toString().isNotEmpty) {
      stderr.write(result.stderr);
    }

    if (result.exitCode != 0) {
      stderr.writeln('Failed to publish $pkgName');
      exitCode = result.exitCode;
      return;
    }
  }

  stdout.writeln(dryRun ? '\nDry run complete' : '\nPublish complete');
}
