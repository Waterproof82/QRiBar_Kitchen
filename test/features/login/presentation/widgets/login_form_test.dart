import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qribar_cocina/app/const/globals.dart';
import 'package:qribar_cocina/app/extensions/repository_error_extension.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_bloc.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_event.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_state.dart';
import 'package:qribar_cocina/features/login/presentation/widgets/login_form.dart';

class MockLoginFormBloc extends Mock implements LoginFormBloc {}

class FakeLoginFormEvent extends Fake implements LoginFormEvent {}

void main() {
  late MockLoginFormBloc mockBloc;
  late StreamController<LoginFormState> controller;

  setUpAll(() {
    registerFallbackValue(FakeLoginFormEvent());
  });

  setUp(() {
    mockBloc = MockLoginFormBloc();

    final initialState = const LoginFormState();

    controller = StreamController<LoginFormState>();
    controller.add(initialState);

    whenListen(mockBloc, controller.stream, initialState: initialState);
    when(() => mockBloc.state).thenReturn(initialState);
    when(() => mockBloc.add(any())).thenReturn(null);
  });

  tearDown(() async {
    await controller.close();
  });

  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      scaffoldMessengerKey: Globals.rootScaffoldMessengerKey,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('es')],
      home: Scaffold(
        body: BlocProvider<LoginFormBloc>.value(
          value: mockBloc,
          child: child,
        ),
      ),
    );
  }

  testWidgets('LoginForm renders with 2 TextFormFields and a MaterialButton', (tester) async {
    await tester.pumpWidget(buildTestableWidget(LoginForm()));
    await tester.pumpAndSettle();

    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byType(MaterialButton), findsOneWidget);
  });

  testWidgets('calls PasswordChanged when password field is modified', (tester) async {
    await tester.pumpWidget(buildTestableWidget(LoginForm()));
    await tester.pumpAndSettle();

    final passwordField = find.byType(TextFormField).at(1);

    await tester.enterText(passwordField, '123456');
    verify(() => mockBloc.add(PasswordChanged('123456'))).called(1);
  });

  testWidgets('calls EmailChanged when email field is modified', (tester) async {
    await tester.pumpWidget(buildTestableWidget(LoginForm()));
    await tester.pumpAndSettle();

    final emailField = find.byType(TextFormField).at(0);
    await tester.enterText(emailField, 'test@example.com');

    verify(() => mockBloc.add(EmailChanged('test@example.com'))).called(1);
  });

  testWidgets('validator returns null if email format is valid', (tester) async {
    await tester.pumpWidget(buildTestableWidget(LoginForm()));
    await tester.pumpAndSettle();

    final emailField = find.byType(TextFormField).at(0);

    await tester.enterText(emailField, 'test@example.com');
    await tester.tap(find.byType(MaterialButton));
    await tester.pump();

    expect(find.text('Introduce un correo válido'), findsNothing);
  });

  testWidgets('shows SnackBar when failure is present', (tester) async {
    final failure = const RepositoryError.userNotFound();
    final failureState = const LoginFormState().copyWith(failure: failure);

    await tester.pumpWidget(buildTestableWidget(LoginForm()));

    // Captura el context del LoginForm
    final context = tester.element(find.byType(LoginForm));

    // Emitimos el estado con error
    controller.add(failureState);

    // Pump dos veces para garantizar postFrameCallback
    await tester.pump();
    await tester.pump(const Duration(seconds: 1)); // garantiza visibilidad

    final translatedError = failure.translateError(context);

    // Verificaciones
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(translatedError), findsOneWidget);
  });

  testWidgets('dispatches LoginSubmitted when form is valid and button tapped', (tester) async {
    await tester.pumpWidget(buildTestableWidget(LoginForm()));
    await tester.pumpAndSettle();

    // Encuentra los campos de texto
    final emailField = find.byType(TextFormField).at(0);
    final passwordField = find.byType(TextFormField).at(1);
    final submitButton = find.byType(MaterialButton);

    // Ingresa datos válidos para que la validación pase
    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passwordField, '12345678');

    // Dispara la pulsación del botón
    await tester.tap(submitButton);

    // Ejecuta la validación y el listener del botón
    await tester.pump();

    // Verifica que se haya enviado LoginSubmitted al bloc
    verify(() => mockBloc.add(const LoginSubmitted())).called(1);
  });
}
