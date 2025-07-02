import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qribar_cocina/data/data_sources/local/localization_local_datasource_contract.dart';
import 'package:qribar_cocina/features/app/cubit/language_cubit.dart';
import 'package:qribar_cocina/shared/utils/language_dropdown.dart';

import '../../../../helpers/pump_app.dart';

// Mock
class MockLocalizationDataSource extends Mock
    implements LocalizationLocalDataSourceContract {}

void main() {
  late MockLocalizationDataSource mockLocalization;
  late LanguageCubit languageCubit;

  setUp(() {
    mockLocalization = MockLocalizationDataSource();

    when(() => mockLocalization.getCachedLocalLanguageCode()).thenReturn('es');
    when(
      () => mockLocalization.cacheLocalLanguageCode(any()),
    ).thenAnswer((_) async {});

    languageCubit = LanguageCubit(mockLocalization);
  });

  testWidgets('LanguageDropdown muestra y cambia el idioma correctamente', (
    tester,
  ) async {
    await tester.pumpApp(
      const LanguageDropdown(),
      repositories: [
        RepositoryProvider<LocalizationLocalDataSourceContract>.value(
          value: mockLocalization,
        ),
      ],
      blocs: [BlocProvider<LanguageCubit>.value(value: languageCubit)],
    );

    // Verifica idioma predeterminado
    expect(find.text('Español'), findsOneWidget);

    clearInteractions(mockLocalization);

    // Cambia a inglés
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English').last);
    await tester.pumpAndSettle();

    verify(() => mockLocalization.cacheLocalLanguageCode('en')).called(2);
    expect(languageCubit.state.localeCode, 'en');
  });
}
