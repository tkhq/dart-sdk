// tool/changeset.dart
//
// Simple changeset creator for our Dart monorepo.
//
// - Discovers packages under ./packages/*/pubspec.yaml
// - Lets you choose which packages are affected
// - Lets you pick a bump (patch/minor/major) per package
// - Prompts for a title and multi-line note
// - Writes a .changesets/*.md file with YAML frontmatter + markdown body

import 'dart:io';
import 'changeset_lib.dart';

const changesetDirName = '.changesets';
const packagesRootDirName = 'packages';

void main(List<String> args) {
  _run().catchError((e, st) {
    stderr.writeln('error: $e');
    stderr.writeln(st);
    exitCode = 1;
  });
}

Future<void> _run() async {
  stdout.writeln('=== Create Dart Changeset ===');

  final packages = discoverPackages();
  if (packages.isEmpty) {
    stdout.writeln(
      'No packages found. Looking for $packagesRootDirName/*/pubspec.yaml',
    );
    return;
  }

  stdout.writeln('\nDetected packages:');
  for (var i = 0; i < packages.length; i++) {
    stdout.writeln('  ${i + 1}) ${packages[i].name}  (${packages[i].path})');
  }

  final selectedIndexes = _promptPackageSelection(packages.length);
  if (selectedIndexes.isEmpty) {
    stdout.writeln('No packages selected, aborting.');
    return;
  }

  // Map of packageName -> bump
  final packageBumps = <String, String>{};
  for (final idx in selectedIndexes) {
    final pkg = packages[idx];
    final bump = _promptBumpForPackage(pkg.name);
    packageBumps[pkg.name] = bump;
  }

  final title = _promptLine('Short title for this change: ');
  if (title.trim().isEmpty) {
    throw Exception('title cannot be empty');
  }

  stdout.writeln(
      '\nEnter a longer description (markdown allowed). '
      'End input with a single "." on its own line:');
  final note = _promptMultiline();

  final now = DateTime.now();
  final fileName =
      '${_formatTimestamp(now)}-${_slugify(title)}.md'; // e.g. 20251204-141530-add-passkey-support.md
  final changesetDir = Directory(changesetDirName);
  if (!changesetDir.existsSync()) {
    changesetDir.createSync(recursive: true);
  }

  final filePath = '${changesetDir.path}/$fileName';
  final content = _buildChangesetFile(
    title: title,
    note: note,
    packages: packageBumps,
    now: now,
  );

  File(filePath).writeAsStringSync(content);
  stdout.writeln('\n✅ Changeset written to $filePath');
}

List<int> _promptPackageSelection(int packageCount) {
  stdout.writeln(
      '\nSelect affected packages by number (space or comma-separated). '
      'Example: 1 3 4');
  stdout.write('Selection: ');
  final line = stdin.readLineSync() ?? '';
  final tokens = line.split(RegExp(r'[,\s]+')).where((t) => t.isNotEmpty);

  final result = <int>[];
  for (final t in tokens) {
    final idx = int.tryParse(t);
    if (idx == null) continue;
    if (idx < 1 || idx > packageCount) continue;
    result.add(idx - 1); // convert to 0-based
  }

  // Deduplicate while preserving order
  final seen = <int>{};
  final deduped = <int>[];
  for (final i in result) {
    if (seen.add(i)) deduped.add(i);
  }
  return deduped;
}

String _promptBumpForPackage(String packageName) {
  stdout.writeln('\nSelect bump type for "$packageName":');
  stdout.writeln('  1) patch');
  stdout.writeln('  2) minor');
  stdout.writeln('  3) major');

  while (true) {
    stdout.write('Choice (1-3): ');
    final line = stdin.readLineSync()?.trim() ?? '';
    switch (line) {
      case '1':
        return 'patch';
      case '2':
        return 'minor';
      case '3':
        return 'major';
      default:
        stdout.writeln('Invalid choice, please enter 1, 2, or 3.');
    }
  }
}

String _promptLine(String label) {
  stdout.write(label);
  return stdin.readLineSync() ?? '';
}

String _promptMultiline() {
  final lines = <String>[];

  while (true) {
    final line = stdin.readLineSync();
    if (line == null) break;

    // Stop when the user types a single dot.
    if (line.trim() == '.') {
      break;
    }
    lines.add(line);
  }

  // Trim trailing blank lines
  while (lines.isNotEmpty && lines.last.trim().isEmpty) {
    lines.removeLast();
  }

  if (lines.isEmpty) {
    return '_No additional notes._';
  }
  return lines.join('\n');
}

String _formatTimestamp(DateTime dt) {
  // yyyyMMdd-HHmmss
  String two(int n) => n.toString().padLeft(2, '0');
  return '${dt.year}'
      '${two(dt.month)}'
      '${two(dt.day)}-'
      '${two(dt.hour)}'
      '${two(dt.minute)}'
      '${two(dt.second)}';
}

String _dateOnly(DateTime dt) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${dt.year}-${two(dt.month)}-${two(dt.day)}';
}

String _buildChangesetFile({
  required String title,
  required String note,
  required Map<String, String> packages,
  required DateTime now,
}) {
  final sb = StringBuffer();

  sb.writeln('---');
  sb.writeln('title: "${_escapeYamlString(title)}"');
  sb.writeln('date: "${_dateOnly(now)}"');
  sb.writeln('packages:');
  final sortedKeys = packages.keys.toList()..sort();
  for (final pkg in sortedKeys) {
    final bump = packages[pkg] ?? 'patch';
    sb.writeln('  $pkg: "$bump"');
  }
  sb.writeln('---\n');

  sb.writeln(note);
  if (!note.endsWith('\n')) {
    sb.writeln();
  }

  return sb.toString();
}

String _escapeYamlString(String input) {
  // Very minimal escaping for double-quoted YAML strings.
  return input
      .replaceAll(r'\', r'\\')
      .replaceAll('"', r'\"');
}

String _slugify(String input) {
  final lower = input.toLowerCase().trim();
  final buf = StringBuffer();
  var prevDash = false;

  for (final codeUnit in lower.codeUnits) {
    final c = String.fromCharCode(codeUnit);
    final isLetter =
        (codeUnit >= 97 && codeUnit <= 122); // a-z
    final isDigit =
        (codeUnit >= 48 && codeUnit <= 57); // 0-9

    if (isLetter || isDigit) {
      buf.write(c);
      prevDash = false;
    } else if (c == ' ' || c == '-' || c == '_') {
      if (!prevDash) {
        buf.write('-');
        prevDash = true;
      }
    } // drop everything else
  }

  var slug = buf.toString();
  slug = slug.replaceAll(RegExp(r'^-+'), '');
  slug = slug.replaceAll(RegExp(r'-+$'), '');
  if (slug.isEmpty) slug = 'changeset';
  return slug;
}
