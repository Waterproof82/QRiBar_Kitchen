/// Enum representing the types of preferences in the application.
enum PreferencesType {
  /// Represents the locale code preference.
  localeCode('localeCode');

  /// The type of the preference.
  final String type;

  /// Constructs a [PreferencesType] with the given [type].
  const PreferencesType(this.type);
}
