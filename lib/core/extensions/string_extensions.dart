/// String utility extensions.
extension StringExtensions on String {
  /// Capitalize first letter.
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalize each word.
  String get titleCase {
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Mask email: j***@gmail.com
  String get maskEmail {
    final parts = split('@');
    if (parts.length != 2) return this;
    final name = parts[0];
    final masked = name.length > 1
        ? '${name[0]}${'*' * (name.length - 1)}'
        : name;
    return '$masked@${parts[1]}';
  }

  /// Mask phone: ******7890
  String get maskPhone {
    if (length < 4) return this;
    return '${'*' * (length - 4)}${substring(length - 4)}';
  }

  /// Extract initials: "John Doe" → "JD"
  String get initials {
    final words = trim().split(' ');
    if (words.isEmpty) return '';
    if (words.length == 1) return words[0][0].toUpperCase();
    return '${words[0][0]}${words.last[0]}'.toUpperCase();
  }
}
