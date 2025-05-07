import 'dart:developer';

import 'package:qribar_cocina/core/bootstrap.dart';
import 'package:qribar_cocina/providers/providers.dart';

/// The entry point of the application.
void main() async {
  final result = await bootstrap(() => const AppProviders());

  result.when(
    success: (_) {
      log('Application started successfully.');
    },
    failure: (error) {
      log('Application failed to start: $error');
    },
  );
}
