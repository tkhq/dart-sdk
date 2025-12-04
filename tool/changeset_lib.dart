// tool/changesets_lib.dart
//
// Shared helpers for Dart changeset tooling.

import 'dart:convert';
import 'dart:io';

const changesetDirName = '.changesets';
const packagesRootDirName = 'packages';
const releaseMetaFileName = '_current_release.json';

typedef PackageBumps = Map<String, String>;

class ChangesetFile {
  final String path;
  final String title;
  final String date; // YYYY-MM-DD
  final PackageBumps packages;
  final String note;

  ChangesetFile({
    required this.path,
    required this.title,
    required this.date,
    required this.packages,
    required this.note,
  });
}

class PackageInfo {
  final String name;
  final String path; // path to package dir (e.g. packages/core)
  final String pubspecPath;

  PackageInfo({
    required this.name,
    required this.path,
    required this.pubspecPath,
  });
}

// A single change entry for a specific package coming from a changeset file.
class PackageChange {
  final String title;
  final String bump; // patch|minor|major
  final String note;
  final String changesetPath;

  PackageChange({
    required this.title,
    required this.bump,
    required this.note,
    required this.changesetPath,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'bump': bump,
        'note': note,
        'changesetPath': changesetPath,
      };

  static PackageChange fromJson(Map<String, dynamic> json) => PackageChange(
        title: json['title'] as String,
        bump: json['bump'] as String,
        note: json['note'] as String,
        changesetPath: json['changesetPath'] as String,
      );
}

// Release info for one package.
class PackageRelease {
  final String name;
  final String path;
  final String fromVersion;
  final String toVersion;
  final String bump; // max bump for this package
  final List<PackageChange> changes;

  PackageRelease({
    required this.name,
    required this.path,
    required this.fromVersion,
    required this.toVersion,
    required this.bump,
    required this.changes,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'path': path,
        'fromVersion': fromVersion,
        'toVersion': toVersion,
        'bump': bump,
        'changes': changes.map((c) => c.toJson()).toList(),
      };

  static PackageRelease fromJson(Map<String, dynamic> json) => PackageRelease(
        name: json['name'] as String,
        path: json['path'] as String,
        fromVersion: json['fromVersion'] as String,
        toVersion: json['toVersion'] as String,
        bump: json['bump'] as String,
        changes: (json['changes'] as List<dynamic>)
            .map((e) => PackageChange.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

// Top-level release meta for all packages in this release.
class ReleaseMeta {
  final String created; // ISO timestamp
  final String date; // YYYY-MM-DD
  final List<PackageRelease> packages;

  ReleaseMeta({
    required this.created,
    required this.date,
    required this.packages,
  });

  Map<String, dynamic> toJson() => {
        'created': created,
        'date': date,
        'packages': packages.map((p) => p.toJson()).toList(),
      };

  static ReleaseMeta fromJson(Map<String, dynamic> json) => ReleaseMeta(
        created: json['created'] as String,
        date: json['date'] as String,
        packages: (json['packages'] as List<dynamic>)
            .map((e) => PackageRelease.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

// Discover packages under ./packages/*/pubspec.yaml
List<PackageInfo> discoverPackages() {
  final root = Directory(packagesRootDirName);
  if (!root.existsSync()) return [];

  final packages = <PackageInfo>[];

  for (final entity in root.listSync(followLinks: false)) {
    if (entity is! Directory) continue;
    final pubspec = File('${entity.path}/pubspec.yaml');
    if (!pubspec.existsSync()) continue;

    final name = _readPubspecName(pubspec) ?? _basename(entity.path);
    packages.add(PackageInfo(
      name: name,
      path: entity.path,
      pubspecPath: pubspec.path,
    ));
  }

  packages.sort((a, b) => a.name.compareTo(b.name));
  return packages;
}

String? _readPubspecName(File pubspec) {
  try {
    final lines = pubspec.readAsLinesSync();
    for (final line in lines) {
      final trimmed = line.trimLeft();
      if (trimmed.startsWith('name:')) {
        final value = trimmed.substring('name:'.length).trim();
        if (value.isNotEmpty) {
          return value;
        }
      }
    }
  } catch (_) {
    // ignore; fallback to directory name
  }
  return null;
}

String _basename(String path) {
  final sep = Platform.pathSeparator;
  final parts = path.split(sep);
  return parts.isEmpty ? path : parts.lastWhere((p) => p.isNotEmpty);
}

// Load all .changesets/*.md (excluding files starting with "_")
List<ChangesetFile> loadChangesets() {
  final dir = Directory(changesetDirName);
  if (!dir.existsSync()) return [];

  final out = <ChangesetFile>[];

  for (final entity in dir.listSync(followLinks: false)) {
    if (entity is! File) continue;
    final name = _basename(entity.path);
    if (!name.endsWith('.md')) continue;
    if (name.startsWith('_')) continue;

    final parsed = _parseChangesetFile(entity);
    if (parsed != null) {
      out.add(parsed);
    } else {
      stderr.writeln('warning: failed to parse changeset ${entity.path}');
    }
  }

  return out;
}

// Parse frontmatter 🫨 + body for a changeset file.
ChangesetFile? _parseChangesetFile(File file) {
  final raw = file.readAsStringSync().trim();
  if (!raw.startsWith('---')) {
    stderr.writeln('warning: changeset missing frontmatter: ${file.path}');
    return null;
  }

  final parts = raw.split(RegExp(r'^---\s*$', multiLine: true));
  if (parts.length < 3) {
    stderr.writeln('warning: invalid frontmatter in ${file.path}');
    return null;
  }

  // parts[0] = "" or leading stuff, parts[1] = frontmatter, parts[2..] = body
  final front = parts[1].trim();
  final body = parts.sublist(2).join('---').trim();

  var title = '';
  var date = '';
  final packages = <String, String>{};

  var inPackages = false;

  for (final line in front.split('\n')) {
    final rawLine = line;
    final trimmed = rawLine.trimRight();
    if (trimmed.isEmpty) continue;

    final noIndent = trimmed.trimLeft();

    if (noIndent.startsWith('title:')) {
      title = _stripYamlValue(noIndent.substring('title:'.length));
      continue;
    }
    if (noIndent.startsWith('date:')) {
      date = _stripYamlValue(noIndent.substring('date:'.length));
      continue;
    }
    if (noIndent.startsWith('packages:')) {
      inPackages = true;
      continue;
    }

    if (inPackages) {
      // Indented lines under packages:
      if (rawLine.startsWith(' ') || rawLine.startsWith('\t')) {
        final lineTrim = noIndent;
        if (lineTrim.startsWith('#') || lineTrim.isEmpty) continue;
        final colon = lineTrim.indexOf(':');
        if (colon <= 0) continue;
        final pkg = lineTrim.substring(0, colon).trim();
        var val = lineTrim.substring(colon + 1).trim();
        val = _stripYamlValue(val);
        if (pkg.isNotEmpty && val.isNotEmpty) {
          packages[pkg] = val;
        }
      } else {
        // out of packages block
        inPackages = false;
      }
    }
  }

  if (title.isEmpty) {
    stderr.writeln('warning: changeset missing title: ${file.path}');
    return null;
  }
  if (date.isEmpty) {
    // not critical, but fill with today
    date = todayDate();
  }

  return ChangesetFile(
    path: file.path,
    title: title,
    date: date,
    packages: packages,
    note: body.isEmpty ? '_No additional notes._' : body,
  );
}

String _stripYamlValue(String raw) {
  var v = raw.trim();
  if (v.startsWith('"') && v.endsWith('"') && v.length >= 2) {
    v = v.substring(1, v.length - 1);
  } else if (v.startsWith("'") && v.endsWith("'") && v.length >= 2) {
    v = v.substring(1, v.length - 1);
  }
  return v.trim();
}

// Bump logic ===============================================================

int _bumpLevel(String bump) {
  switch (bump) {
    case 'major':
      return 3;
    case 'minor':
      return 2;
    default:
      return 1; // patch or unknown
  }
}

String maxBump(Iterable<String> bumps) {
  var level = 0;
  for (final b in bumps) {
    final l = _bumpLevel(b);
    if (l > level) level = l;
  }
  switch (level) {
    case 3:
      return 'major';
    case 2:
      return 'minor';
    default:
      return 'patch';
  }
}

// Version manipulation: bump X.Y.Z based on patch/minor/major.
// NB: this trims off any pre-release/build metadata.
String nextVersion(String current, String bump) {
  final base = current.split(RegExp(r'[-+]'))[0].trim();
  final parts = base.split('.');
  if (parts.length != 3) {
    throw FormatException('invalid version "$current", expected X.Y.Z');
  }
  var major = int.parse(parts[0]);
  var minor = int.parse(parts[1]);
  var patch = int.parse(parts[2]);

  switch (bump) {
    case 'major':
      major++;
      minor = 0;
      patch = 0;
      break;
    case 'minor':
      minor++;
      patch = 0;
      break;
    default:
      patch++;
  }

  return '$major.$minor.$patch';
}

// Read & update pubspec.yaml's version line.
String readPubspecVersion(String pubspecPath) {
  final file = File(pubspecPath);
  if (!file.existsSync()) {
    throw Exception('pubspec not found: $pubspecPath');
  }
  final lines = file.readAsLinesSync();
  final regex = RegExp(r'^(\s*version\s*:\s*)([^\s#]+)(.*)$');

  for (final line in lines) {
    final m = regex.firstMatch(line);
    if (m != null) {
      return m.group(2)!;
    }
  }

  throw Exception('no version: line found in $pubspecPath');
}

void writePubspecVersion(String pubspecPath, String newVersion) {
  final file = File(pubspecPath);
  if (!file.existsSync()) {
    throw Exception('pubspec not found: $pubspecPath');
  }
  final lines = file.readAsLinesSync();
  final regex = RegExp(r'^(\s*version\s*:\s*)([^\s#]+)(.*)$');
  var replaced = false;

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    final m = regex.firstMatch(line);
    if (m != null) {
      final prefix = m.group(1)!;
      final suffix = m.group(3)!;
      lines[i] = '$prefix$newVersion$suffix';
      replaced = true;
      break;
    }
  }

  if (!replaced) {
    throw Exception('no version: line to replace in $pubspecPath');
  }

  file.writeAsStringSync(lines.join('\n') + '\n');
}

// Meta read/write ==========================================================

ReleaseMeta readReleaseMeta() {
  final file = File('$changesetDirName/$releaseMetaFileName');
  final jsonStr = file.readAsStringSync();
  final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
  return ReleaseMeta.fromJson(decoded);
}

void writeReleaseMeta(ReleaseMeta meta) {
  final dir = Directory(changesetDirName);
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }
  final file = File('${dir.path}/$releaseMetaFileName');
  final jsonStr = const JsonEncoder.withIndent('  ').convert(meta.toJson());
  file.writeAsStringSync(jsonStr);
}

void deleteProcessedChangesets(ReleaseMeta meta) {
  final seen = <String>{};
  for (final pkg in meta.packages) {
    for (final change in pkg.changes) {
      if (seen.add(change.changesetPath)) {
        final f = File(change.changesetPath);
        if (f.existsSync()) {
          f.deleteSync();
        }
      }
    }
  }
  final metaFile = File('$changesetDirName/$releaseMetaFileName');
  if (metaFile.existsSync()) {
    metaFile.deleteSync();
  }
}

String todayDate() {
  final now = DateTime.now();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${now.year}-${two(now.month)}-${two(now.day)}';
}
