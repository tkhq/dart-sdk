// tool/changeset_changelog.dart
//
// Uses the release meta produced by changeset_version.dart to update
// per-package CHANGELOG.md files, then cleans up processed changesets.

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

const _changelogHeader = '# Changelog';

void _run() {
  final meta = readReleaseMeta();
  final date = meta.date;

  if (meta.packages.isEmpty) {
    stdout.writeln('No packages in release meta – nothing to changelog.');
    return;
  }

  for (final pkg in meta.packages) {
    final changelogPath = '${pkg.path}/CHANGELOG.md';
    _updatePackageChangelog(
      changelogPath: changelogPath,
      version: pkg.toVersion,
      date: date,
      changes: pkg.changes,
    );
  }

  deleteProcessedChangesets(meta);
  stdout.writeln(
      '\nUpdated changelogs and deleted processed changesets + release meta.');
}

void _updatePackageChangelog({
  required String changelogPath,
  required String version,
  required String date,
  required List<PackageChange> changes,
}) {
  final existingFile = File(changelogPath);
  final existing = existingFile.existsSync()
      ? existingFile.readAsStringSync()
      : '';

  final newSection = _buildReleaseSection(version, date, changes);
  final merged = _mergeChangelog(existing, newSection);

  existingFile.writeAsStringSync(merged);
  stdout.writeln('  - updated $changelogPath for v$version');
}

String _buildReleaseSection(
    String version, String date, List<PackageChange> changes) {
  final sb = StringBuffer();

  sb.writeln('## $version — $date');

  // Group by bump type.
  final byBump = <String, List<PackageChange>>{
    'patch': [],
    'minor': [],
    'major': [],
  };

  for (final c in changes) {
    final key = (c.bump == 'major' || c.bump == 'minor' || c.bump == 'patch')
        ? c.bump
        : 'patch';
    byBump[key]!.add(c);
  }

  // Order: Patch, Minor, Major.
  const order = [
    ['patch', 'Patch Changes'],
    ['minor', 'Minor Changes'],
    ['major', 'Major Changes'],
  ];

  for (final entry in order) {
    final key = entry[0];
    final heading = entry[1];
    final list = byBump[key]!;
    if (list.isEmpty) continue;

    sb.writeln('### $heading');
    for (final change in list) {
      // Using note as the bullet item.
      sb.writeln('- ${change.note}');
    }
  }

  sb.writeln();
  return sb.toString();
}

String _mergeChangelog(String existing, String newSection) {
  if (existing.trim().isEmpty) {
    return '$_changelogHeader\n\n$newSection';
  }

  final trimmed = existing.trimLeft();
  if (!trimmed.startsWith(_changelogHeader)) {
    // No header: prepend one.
    return '$_changelogHeader\n\n$newSection$existing';
  }

  // Assume # Changelog is the first line.
  final lines = existing.split('\n');
  if (lines.isEmpty) {
    return '$_changelogHeader\n\n$newSection';
  }

  final header = lines.first;
  final rest = lines.skip(1).join('\n').trimLeft();

  final sb = StringBuffer();
  sb.writeln(header);
  sb.writeln();
  sb.writeln(newSection);
  if (rest.isNotEmpty) {
    // Ensure at least one blank line before older sections.
    if (!rest.startsWith('## ')) {
      sb.writeln();
    }
    sb.writeln(rest);
  }

  return sb.toString();
}
