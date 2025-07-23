import 'dart:developer';

import 'package:qribar_cocina/app/core/bootstrap.dart';
import 'package:qribar_cocina/app/types/result.dart';
import 'package:qribar_cocina/features/app/providers/providers.dart';

/// The entry point of the application.
///
/// This function is responsible for bootstrapping the Flutter application,
/// which includes initializing dependencies, setting up error handling,
/// and running the main application widget.
void main() async {
  // Call the bootstrap function to initialize and run the app.
  // It returns a Result object indicating success or failure.
  final result = await bootstrap(() => const AppProviders());

  // Handle the result of the bootstrap process.
  result.when(
    success: (_) {
      log('Application started successfully.');
    },
    failure: (error) {
      log('Application failed to start: $error');
    },
  );
}
