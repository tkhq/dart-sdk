class TFileInfo {
  final String absolutePath;
  final Map<String, dynamic> parsedData;

  TFileInfo({required this.absolutePath, required this.parsedData});
}

class TBinding {
  final String name;
  final bool isBound;
  final String value;

  TBinding({
    required this.name,
    required this.isBound,
    required this.value,
  });
}