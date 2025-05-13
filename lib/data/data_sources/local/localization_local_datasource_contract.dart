/// The abstract class representing a localization repository.
/// This repository is responsible for caching and retrieving the local language code.
abstract class LocalizationLocalDataSourceContract {
  /// Caches the provided [localeCode] as the local language code.
  /// Returns a [Future] that completes when the caching is done.
  Future<void> cacheLocalLanguageCode(String localeCode);

  /// Retrieves the cached local language code.
  /// Returns the cached local language code as a [String].
  String getCachedLocalLanguageCode();
}
