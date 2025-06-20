import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qribar_cocina/features/login/login_screen.dart';
// Import the screen and its child widgets.
// Adjust these paths to match your project structure.

import 'package:qribar_cocina/features/login/presentation/ui/auth_background.dart';
import 'package:qribar_cocina/features/login/presentation/ui/login_container.dart';
import 'package:qribar_cocina/features/login/presentation/widgets/language_dropdown.dart';
import 'package:qribar_cocina/features/login/presentation/widgets/login_form.dart';

// Mock the Gap class if it's not a real widget or causes issues in tests.
// If Gap.h248 is a const SizedBox or similar, you might not need to mock it,
// but if it relies on context or complex logic, a mock or a simple stub is better.
// For this example, we'll assume Gap is a simple SizedBox for rendering purposes.
// If your `Gap` class is structured differently (e.g., uses a package like `gap`),
// you might need to mock or provide a simplified version.
class Gap {
  static const Widget h248 = SizedBox(height: 248.0);
  static const Widget h10 = SizedBox(height: 10.0);
  static const Widget h24 = SizedBox(height: 24.0);
  static const Widget h48 = SizedBox(height: 48.0);
}

// test/login_screen_test.dart

// ... (your existing imports and setUp) ...

void main() {
  group('LoginScreen Widget Tests', () {
    testWidgets('LoginScreen renders all expected child widgets', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(),
        ),
      );

      expect(find.byType(AuthBackground), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      // --- Corrected Finder for the OUTER Column ---
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

      // --- Corrected Finder for the INNER Column ---
      // This finds the Column that is the direct child of LoginContainer.
      final Finder innerColumnFinder = find.descendant(
        of: find.byType(LoginContainer),
        matching: find.byWidgetPredicate((widget) => widget is Column && widget.key == const Key('loginContainerInnerColumn')), // Add a Key to this Column in LoginContainer
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

      // ... (your Gap assertions) ...

      await tester.pumpAndSettle();
    });
  });
}
