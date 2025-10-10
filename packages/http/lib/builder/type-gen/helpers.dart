String refToName(String ref) {
    return ref.replaceFirst(RegExp(r'^#\/definitions\/'), '').replaceAll(r'.', "");
}

bool isValidDartIdentifier(String name) =>
    RegExp(r'^[A-Za-z_][A-Za-z0-9_]*$').hasMatch(name);

String sanitizeFieldName(String key) {
  // Keep original JSON key for mapping; field name must be a valid identifier.
  if (isValidDartIdentifier(key)) return key;
  // Replace invalid chars with underscores, and prefix if starts with digit.
  var s = key.replaceAll(RegExp(r'[^A-Za-z0-9_]'), '');
  // if (!RegExp(r'^[A-Za-z_]').hasMatch(s)) s = '$s';
  return s;
}

String sanitizeEnumValue(String raw) {
  // Convert arbitrary strings to a safe enum value token.
  // Lower + non-alnum to underscore, collapse repeats.
  String v = raw.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');
  v = v.replaceAll(RegExp(r'^_+|_+$'), '');
  if (v.isEmpty) v = 'value';
  if (RegExp(r'^\d').hasMatch(v)) v = '_$v';
  return v;
}

String methodTypeFromMethodName(String methodName, String prefix) {
  final lower = methodName.toLowerCase();
  if (['approveactivity', 'rejectactivity'].contains(lower)) {
    return 'activityDecision';
  }
  if (lower.startsWith('noop')) return 'noop';
  if (prefix.toLowerCase() == 'proxy') return 'proxy';
  if (lower.startsWith('tget') || lower.startsWith('tlist') || lower.startsWith('ttest')) {
    return 'query';
  }
  return 'command';
}

class LatestVersionInfo {
  LatestVersionInfo(this.fullName, this.formattedKeyName, this.versionSuffix);
  final String fullName;
  final String formattedKeyName;
  final String? versionSuffix;
}

Map<String, LatestVersionInfo> extractLatestVersions(
  Map<String, dynamic> definitions,
) {
  final latest = <String, LatestVersionInfo>{};
  final re = RegExp(r'^(v\d+)([A-Z][A-Za-z0-9]*?)(V\d+)?$');
  for (final k in definitions.keys) {
    final m = re.firstMatch(k);
    if (m == null) continue;
    final full = m.group(0)!;
    final base = m.group(2)!;
    final suf = m.group(3);
    final formatted = '${base[0].toLowerCase()}${base.substring(1)}${suf ?? ''}';

    final prev = latest[base];
    if (prev == null || (suf ?? '').compareTo(prev.versionSuffix ?? '') > 0) {
      latest[base] = LatestVersionInfo(full, formatted, suf);
    }
  }
  return latest;
}

/// Swagger type -> Dart type string; returns pair (dartType, importHint)
String typeToDart(String? type, Map<String, dynamic>? schema) {
  if (type == 'integer' || type == 'number') return 'num';
  if (type == 'boolean') return 'bool';
  if (type == 'string') return 'String';
  if (type == 'array') {
    final items = schema?['items'];
    if (items is Map<String, dynamic>) {
      if (items[r'$ref'] is String) {
        return 'List<${refToName(items[r"$ref"] as String)}>';
      } else if (items['type'] is String) {
        return 'List<${typeToDart(items['type'] as String, items)}>';
      }
    }
    return 'List<dynamic>';
  }
  if (type == 'object') {

    if (schema?['properties'] is Map) return 'Map<String, dynamic>';
    return 'Map<String, dynamic>';
  }
  return 'dynamic';
}

