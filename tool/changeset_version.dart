// tool/changeset_version.dart
//
// Computes per-package version bumps from .changesets/*.md and updates
// each affected pubspec.yaml. Writes a release meta file used by the
// changelog command.

import 'dart:io';

import 'changeset_lib.dart';

void main(List<String> args) {
  try {
    _run();
  } catch (e, st) {
    stderr.writeln('error: $e');
    stderr.writeln(st);
    exitCode = 1;
  }
}

void _run() {
  final changesets = loadChangesets();
  if (changesets.isEmpty) {
    stdout.writeln('No pending changesets found – nothing to version.');
    return;
  }

  final packages = discoverPackages();
  if (packages.isEmpty) {
    throw Exception('No packages discovered under "$packagesRootDirName/".');
  }

  final pkgByName = {for (var p in packages) p.name: p};

  // packageName -> list of PackageChange
  final pkgChanges = <String, List<PackageChange>>{};

  for (final cs in changesets) {
    cs.packages.forEach((pkgName, bump) {
      final pkg = pkgByName[pkgName];
      if (pkg == null) {
        stderr.writeln(
            'warning: changeset ${cs.path} references unknown package "$pkgName" – skipping that entry.');
        return;
      }
      final list = pkgChanges.putIfAbsent(pkgName, () => []);
      list.add(PackageChange(
        title: cs.title,
        bump: bump,
        note: cs.note,
        changesetPath: cs.path,
      ));
    });
  }

  if (pkgChanges.isEmpty) {
    stdout.writeln(
        'No valid package entries in changesets – nothing to version.');
    return;
  }

  final now = DateTime.now();
  final meta = ReleaseMeta(
    created: now.toIso8601String(),
    date: todayDate(),
    packages: [],
  );

  stdout.writeln('Applying version bumps:');

  pkgChanges.forEach((pkgName, changes) {
    final pkg = pkgByName[pkgName]!;
    final bumps = changes.map((c) => c.bump);
    final bump = maxBump(bumps);

    final currentVersion = readPubspecVersion(pkg.pubspecPath);
    final newVersion = nextVersion(currentVersion, bump);

    writePubspecVersion(pkg.pubspecPath, newVersion);

    stdout.writeln(
        '  - $pkgName: $currentVersion -> $newVersion ($bump) [${pkg.path}]');

    meta.packages.add(PackageRelease(
      name: pkgName,
      path: pkg.path,
      fromVersion: currentVersion,
      toVersion: newVersion,
      bump: bump,
      changes: changes,
    ));
  });

  writeReleaseMeta(meta);
  stdout.writeln(
      '\nWrote release meta to $changesetDirName/$releaseMetaFileName');
}
