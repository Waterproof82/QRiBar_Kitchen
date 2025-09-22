/// A typedef that represents a language option with a `code` and `label`.
typedef LanguageOption = ({String code, String label});

/// Enum that defines all supported application languages.
/// Add as many as you need.
enum AppLanguage {
  es(code: 'es', label: 'Español'),
  en(code: 'en', label: 'English');

  final String code;
  final String label;

  const AppLanguage({required this.code, required this.label});

  /// Converts the enum into a [LanguageOption].
  LanguageOption toOption() => (code: code, label: label);
}
