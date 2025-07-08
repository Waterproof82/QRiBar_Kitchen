import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qribar_cocina/features/login/login_screen.dart';
import 'package:qribar_cocina/features/login/presentation/ui/auth_background.dart';
import 'package:qribar_cocina/features/login/presentation/ui/login_container.dart';
import 'package:qribar_cocina/shared/utils/language_dropdown.dart';
import 'package:qribar_cocina/features/login/presentation/widgets/login_form.dart';

class Gap {
  static const Widget h248 = SizedBox(height: 248.0);
  static const Widget h10 = SizedBox(height: 10.0);
  static const Widget h24 = SizedBox(height: 24.0);
  static const Widget h48 = SizedBox(height: 48.0);
}

void main() {
  group('LoginScreen Widget Tests', () {
    testWidgets('LoginScreen renders all expected child widgets', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );

      expect(find.byType(AuthBackground), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      // This finds the Column that is the direct child of SingleChildScrollView.
      final Finder outerColumnFinder = find.descendant(
        of: find.byType(SingleChildScrollView),
        matching: find.byWidgetPredicate((widget) => widget is Column && widget.key == const Key('loginScreenOuterColumn')), // Add a Key to this Column in LoginScreen
      );
      expect(outerColumnFinder, findsOneWidget);

      // Verify the Row with LanguageDropdown inside the OUTER Column
      expect(find.descendant(of: outerColumnFinder, matching: find.byType(Row)), findsOneWidget);
      expect(find.byType(LanguageDropdown), findsOneWidget);

      // Verify LoginContainer inside the OUTER Column
      expect(find.descendant(of: outerColumnFinder, matching: find.byType(LoginContainer)), findsOneWidget);

      // This finds the Column that is the direct child of LoginContainer.
      final Finder innerColumnFinder = find.descendant(
        of: find.byType(LoginContainer),
        matching: find.byWidgetPredicate((widget) => widget is Column && widget.key == const Key('loginContainerInnerColumn')),
      );
      expect(innerColumnFinder, findsOneWidget);

      // Verify the "Login" Text widget inside the INNER Column
      expect(
          find.descendant(
            of: innerColumnFinder,
            matching: find.text('Login'),
          ),
          findsOneWidget);

      // Verify LoginForm inside the INNER Column
      expect(
          find.descendant(
            of: innerColumnFinder,
            matching: find.byType(LoginForm),
          ),
          findsOneWidget);

      await tester.pumpAndSettle();
    });
  });
}
