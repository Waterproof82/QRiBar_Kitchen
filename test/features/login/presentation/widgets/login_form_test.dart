import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qribar_cocina/app/extensions/repository_error_extension.dart';
import 'package:qribar_cocina/app/l10n/app_localizations.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_event.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_state.dart';
import 'package:qribar_cocina/features/login/presentation/widgets/login_form.dart';

/// Mock del Bloc
class MockLoginFormBloc extends MockBloc<LoginFormEvent, LoginFormState> {}

void main() {
  late MockLoginFormBloc mockBloc;
  late StreamController<LoginFormState> controller;

  setUpAll(() {
    registerFallbackValue(const EmailChanged(''));
    registerFallbackValue(const LoginSubmitted(email: '', password: ''));
    registerFallbackValue(const LoginFormState.initial());
  });

  setUp(() {
    mockBloc = MockLoginFormBloc();
    const initialState = LoginFormState.initial();

    controller = StreamController<LoginFormState>();
    controller.add(initialState);

    whenListen(mockBloc, controller.stream, initialState: initialState);
    when(() => mockBloc.state).thenReturn(initialState);
    when(() => mockBloc.add(any())).thenReturn(null);
  });

  tearDown(() async {
    await controller.close();
  });

  /// Helper para envolver LoginForm con MaterialApp y BlocProvider
  Future<void> _pumpLoginForm(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<Bloc<LoginFormEvent, LoginFormState>>.value(
          value: mockBloc,
          child: const Scaffold(body: LoginForm()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.pumpAndSettle();
  }

  testWidgets('renders 2 TextFormFields and 1 MaterialButton', (tester) async {
    await _pumpLoginForm(tester);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byType(MaterialButton), findsOneWidget);
  });

  testWidgets('dispatches EmailChanged when email is typed', (tester) async {
    await _pumpLoginForm(tester);
    final emailField = find.byType(TextFormField).at(0);
    await tester.enterText(emailField, 'test@example.com');
    verify(
      () => mockBloc.add(const EmailChanged('test@example.com')),
    ).called(1);
  });

  testWidgets('valid email does not show error', (tester) async {
    await _pumpLoginForm(tester);
    final emailField = find.byType(TextFormField).at(0);
    await tester.enterText(emailField, 'test@example.com');
    await tester.tap(find.byType(MaterialButton));
    await tester.pump();
    expect(find.text('Introduce un correo válido'), findsNothing);
  });

  testWidgets('shows SnackBar when LoginFormState.error is emitted', (
    tester,
  ) async {
    await _pumpLoginForm(tester);
    const failure = RepositoryError.userNotFound();
    const errorState = LoginFormState.error(
      error: failure,
      email: 'test@example.com',
    );

    controller.add(errorState);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    final context = tester.element(find.byType(LoginForm));
    final translatedError = failure.translateError(context);

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(translatedError), findsOneWidget);
  });

  testWidgets('dispatches LoginSubmitted when button tapped and form valid', (
    tester,
  ) async {
    await _pumpLoginForm(tester);
    final emailField = find.byType(TextFormField).at(0);
    final passwordField = find.byType(TextFormField).at(1);
    final submitButton = find.byType(MaterialButton);

    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passwordField, '12345678');
    await tester.tap(submitButton);
    await tester.pump();

    verify(
      () => mockBloc.add(
        const LoginSubmitted(email: 'test@example.com', password: '12345678'),
      ),
    ).called(1);
  });
}
