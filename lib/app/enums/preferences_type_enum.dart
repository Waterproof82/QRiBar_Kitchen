/// Enum representing the types of preferences in the application.
enum PreferencesTypeEnum {
  /// Represents the locale code preference.
  localeCode('localeCode'),
  firstTime('firstTime');

  /// The type of the preference.
  final String type;

  /// Constructs a [PreferencesTypeEnum] with the given [type].
  const PreferencesTypeEnum(this.type);
}
