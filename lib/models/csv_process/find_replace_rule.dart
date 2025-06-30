enum ReplacementType { normal, parameterizedRegex, patternGeneration }

class FindReplaceRule {
  final String findText;
  final String replaceText;
  final bool isRegex;
  final bool isCaseSensitive;
  final ReplacementType type;

  // For Parameterized Regex:
  final List<String>? parameterizedReplacements; // e.g., ["$1...", "$2..."]

  // For Pattern Generation:
  final int? startNumber;
  final int? padding; // Number of zeros for padding
  final String? prefix;
  final String? suffix;
  final String? separator;
  final String? customSeparatorRegex; // For custom regex separators

  FindReplaceRule({
    required this.findText,
    required this.replaceText,
    this.isRegex = false,
    this.isCaseSensitive = false,
    this.type = ReplacementType.normal,
    this.parameterizedReplacements,
    this.startNumber,
    this.padding,
    this.prefix,
    this.suffix,
    this.separator,
    this.customSeparatorRegex,
  });
}
