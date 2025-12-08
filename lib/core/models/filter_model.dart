class FilterModel {
  final String key;
  final dynamic value;
  final String? label;

  FilterModel({
    required this.key,
    required this.value,
    this.label,
  });

  String get displayLabel => label ?? _formatKey(key);

  String _formatKey(String key) {
    // Convert camelCase or snake_case to Title Case
    return key
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => ' ${match.group(0)}',
        )
        .replaceAll('_', ' ')
        .trim()
        .split(' ')
        .map((word) => word.isEmpty
            ? ''
            : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}
