import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qribar_cocina/data/data_sources/local/localization_local_datasource_contract.dart';
import 'package:qribar_cocina/features/app/cubit/language_cubit.dart';
import 'package:qribar_cocina/features/login/presentation/widgets/language_dropdown.dart';

// Mock
class MockLocalizationDataSource extends Mock implements LocalizationLocalDataSourceContract {}

void main() {
  late MockLocalizationDataSource mockLocalization;
  late LanguageCubit languageCubit;

  setUp(() {
    mockLocalization = MockLocalizationDataSource();

    // El idioma por defecto es 'es'
    when(() => mockLocalization.getCachedLocalLanguageCode()).thenReturn('es');

    // Usa any() sin tipo genérico para String
    when(() => mockLocalization.cacheLocalLanguageCode(any())).thenAnswer((_) async {});

    languageCubit = LanguageCubit(mockLocalization);
  });

  testWidgets('LanguageDropdown muestra y cambia el idioma correctamente', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RepositoryProvider<LocalizationLocalDataSourceContract>.value(
          value: mockLocalization,
          child: BlocProvider<LanguageCubit>.value(
            value: languageCubit,
            child: const Scaffold(
              body: LanguageDropdown(),
            ),
          ),
        ),
      ),
    );

    // Verifica que aparezca el idioma predeterminado
    expect(find.text('Español'), findsOneWidget);

    clearInteractions(mockLocalization);

    // Simula cambiar a inglés
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English').last);
    await tester.pumpAndSettle();

    // Verifica que cacheLocalLanguageCode haya sido llamado una vez con 'en'
    verify(() => mockLocalization.cacheLocalLanguageCode('en')).called(2);
    expect(languageCubit.state.localeCode, 'en');
  });
}
