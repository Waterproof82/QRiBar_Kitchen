import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qribar_cocina/data/data_sources/local/localization_local_datasource_contract.dart';
import 'package:qribar_cocina/features/app/cubit/language_cubit.dart';
import 'package:qribar_cocina/features/app/cubit/language_cubit_impl.dart';

class MockLocalizationLocalDataSource extends Mock
    implements LocalizationLocalDataSourceContract {}

void main() {
  late MockLocalizationLocalDataSource mockLocalization;
  late LanguageCubitImpl cubit;

  setUp(() {
    mockLocalization = MockLocalizationLocalDataSource();
  });

  test('initial state uses cached locale code', () {
    when(() => mockLocalization.getCachedLocalLanguageCode()).thenReturn('en');
    cubit = LanguageCubitImpl(mockLocalization);

    expect(cubit.state.localeCode, 'en');
  });

  test('fetchLanguage emits new state if locale changed', () {
    when(() => mockLocalization.getCachedLocalLanguageCode()).thenReturn('es');
    cubit = LanguageCubitImpl(mockLocalization);

    cubit.emit(const LanguageChangedState(localeCode: 'en'));

    cubit.fetchLanguage();

    expect(cubit.state.localeCode, 'es');
  });

  test('fetchLanguage does not emit if locale is same', () {
    when(() => mockLocalization.getCachedLocalLanguageCode()).thenReturn('en');
    cubit = LanguageCubitImpl(mockLocalization);

    cubit.emit(const LanguageChangedState(localeCode: 'en'));

    cubit.fetchLanguage();

    expect(cubit.state.localeCode, 'en');
  });

  test(
    'changeLanguage updates cache and emits new state if locale changed',
    () async {
      when(
        () => mockLocalization.getCachedLocalLanguageCode(),
      ).thenReturn('en');
      when(
        () => mockLocalization.cacheLocalLanguageCode('de'),
      ).thenAnswer((_) async {});

      cubit = LanguageCubitImpl(mockLocalization);

      cubit.emit(const LanguageChangedState(localeCode: 'en'));

      await cubit.changeLanguage('de');

      verify(() => mockLocalization.cacheLocalLanguageCode('de')).called(1);
      expect(cubit.state.localeCode, 'de');
    },
  );

  test('changeLanguage does nothing if localeCode is same', () async {
    when(() => mockLocalization.getCachedLocalLanguageCode()).thenReturn('en');

    cubit = LanguageCubitImpl(mockLocalization);

    cubit.emit(const LanguageChangedState(localeCode: 'en'));

    await cubit.changeLanguage('en');

    verifyNever(() => mockLocalization.cacheLocalLanguageCode(any()));
    expect(cubit.state.localeCode, 'en');
  });

  test('getter locale devuelve un Locale con el código correcto', () {
    when(() => mockLocalization.getCachedLocalLanguageCode()).thenReturn('es');
    cubit = LanguageCubitImpl(mockLocalization);

    expect(cubit.locale, isA<Locale>());
    expect(cubit.locale.languageCode, 'es');
  });

  test(
    'changeLanguage llama cacheLocalLanguageCode y emite nuevo estado',
    () async {
      when(
        () => mockLocalization.getCachedLocalLanguageCode(),
      ).thenReturn('en');
      when(
        () => mockLocalization.cacheLocalLanguageCode('fr'),
      ).thenAnswer((_) async {});

      cubit = LanguageCubitImpl(mockLocalization);

      await cubit.changeLanguage('fr');

      verify(() => mockLocalization.cacheLocalLanguageCode('fr')).called(1);
      expect(cubit.state.localeCode, 'fr');
    },
  );

  test('changeLanguage emite correctamente varios cambios de idioma', () async {
    when(() => mockLocalization.getCachedLocalLanguageCode()).thenReturn('en');
    when(
      () => mockLocalization.cacheLocalLanguageCode(any()),
    ).thenAnswer((_) async {});

    cubit = LanguageCubitImpl(mockLocalization);

    await cubit.changeLanguage('es');
    expect(cubit.state.localeCode, 'es');
    await cubit.changeLanguage('de');
    expect(cubit.state.localeCode, 'de');
    verify(() => mockLocalization.cacheLocalLanguageCode('es')).called(1);
    verify(() => mockLocalization.cacheLocalLanguageCode('de')).called(1);
  });

  test('fetchLanguage actualiza el estado aunque el idioma sea el mismo', () {
    when(() => mockLocalization.getCachedLocalLanguageCode()).thenReturn('en');
    cubit = LanguageCubitImpl(mockLocalization);

    cubit.fetchLanguage();

    expect(cubit.state.localeCode, 'en');
  });

  test(
    'LanguageCubitImpl emite el estado correcto al inicializar con diferentes idiomas',
    () {
      when(
        () => mockLocalization.getCachedLocalLanguageCode(),
      ).thenReturn('it');
      cubit = LanguageCubitImpl(mockLocalization);
      expect(cubit.state.localeCode, 'it');

      when(
        () => mockLocalization.getCachedLocalLanguageCode(),
      ).thenReturn('pt');
      cubit = LanguageCubitImpl(mockLocalization);
      expect(cubit.state.localeCode, 'pt');
    },
  );

  test(
    'changeLanguage maneja correctamente llamadas rápidas consecutivas',
    () async {
      when(
        () => mockLocalization.getCachedLocalLanguageCode(),
      ).thenReturn('pt');
      when(
        () => mockLocalization.cacheLocalLanguageCode(any()),
      ).thenAnswer((_) async {});

      cubit = LanguageCubitImpl(mockLocalization);

      await Future.wait([
        cubit.changeLanguage('es'),
        cubit.changeLanguage('de'),
        cubit.changeLanguage('en'),
      ]);

      // El estado final debe ser uno de esos
      expect(['es', 'de', 'en'], contains(cubit.state.localeCode));

      verify(() => mockLocalization.cacheLocalLanguageCode('es')).called(1);
      verify(() => mockLocalization.cacheLocalLanguageCode('de')).called(1);
      verify(() => mockLocalization.cacheLocalLanguageCode('en')).called(1);
    },
  );
}
