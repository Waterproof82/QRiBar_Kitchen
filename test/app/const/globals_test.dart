import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qribar_cocina/app/const/globals.dart';

void main() {
  test('Globals.rootScaffoldMessengerKey should not be null', () {
    expect(Globals.navigatorKey, isNotNull);
  });

  test('Globals.rootScaffoldMessengerKey should be a GlobalKey of ScaffoldMessengerState', () {
    expect(Globals.navigatorKey, isA<GlobalKey<ScaffoldMessengerState>>());
  });

  testWidgets('Snackbar shows using Globals.rootScaffoldMessengerKey', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: Globals.navigatorKey,
        home: Scaffold(
          body: Center(
            child: Builder(
              builder: (context) => TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Snackbar from Globals')),
                  );
                },
                child: const Text('Show Snackbar'),
              ),
            ),
          ),
        ),
      ),
    );

    // Tap to trigger snackbar
    await tester.tap(find.text('Show Snackbar'));
    await tester.pump(); // Start animation
    await tester.pump(const Duration(seconds: 1)); // Let snackbar fully show

    expect(find.text('Snackbar from Globals'), findsOneWidget);
  });
}
