import 'dart:developer';

import 'package:qribar_cocina/app/core/bootstrap.dart';
import 'package:qribar_cocina/features/app/providers/providers.dart';

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
