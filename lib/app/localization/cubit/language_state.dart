import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';

part 'language_state.freezed.dart';

/// A [sealed class] representing the state of the application's language.
///
/// It holds the current locale code and optionally an error if something went wrong.
@freezed
sealed class LanguageState with _$LanguageState {
  /// Represents the current language state with a default locale code of 'es'.
  ///
  /// This ensures that even before fetching or changing the language,
  /// the app has a safe default.
  const factory LanguageState({
    @Default('es') String localeCode, // Default to Spanish
  }) = _LanguageState;

  /// Represents an error state with an associated [RepositoryError].
  ///
  /// The locale code is still kept to ensure the app has a safe default language.
  const factory LanguageState.error({
    required RepositoryError error,
    @Default('es') String localeCode, // Safe default locale even on error
  }) = _Error;
}
