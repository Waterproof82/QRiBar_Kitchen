import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:qribar_cocina/data/data_sources/local/preferences_local_data_source.dart';
import 'package:qribar_cocina/data/data_sources/local/preferences_local_datasource_contract.dart';
import 'package:qribar_cocina/shared/utils/svg_preloader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

// This directive indicates that part of this file's content is defined in 'modules/preferences_module.dart'.
part 'modules/preferences_module.dart';

/// Global instance of GetIt, the service locator for dependency injection.
/// It's initialized here and used throughout the application to retrieve registered dependencies.
GetIt getIt = GetIt.instance;

/// Initializes all core dependencies and services required for the application to run.
///
/// This asynchronous function performs several critical setup tasks in parallel
/// to speed up the application's startup time. It includes:
/// - Initializing Firebase.
/// - Setting up date formatting for a specific locale.
/// - Enabling Wakelock to keep the screen on.
/// - Restricting device orientation.
/// - Preloading SVG assets.
/// - Initializing and registering local preferences with GetIt.
/// - Configuring system UI overlays.
Future<void> initDi() async {
  // Obtain an instance of SharedPreferences, which is used for local data persistence.
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  // Use Future.wait to execute multiple asynchronous initialization tasks concurrently.
  // This improves startup performance by not waiting for each task sequentially.
  await Future.wait([
    // Initialize Firebase, essential for many app features like authentication and database.
    Firebase.initializeApp(),
    // Initialize date formatting data for 'es_ES' locale, used for internationalization.
    initializeDateFormatting('es_ES'),
    // Enable Wakelock to prevent the screen from turning off automatically,
    WakelockPlus.enable(),
    // Set preferred device orientations to portrait mode only, ensuring consistent UI.
    SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]),
    // Preload SVG assets to ensure they are ready for use, preventing rendering delays.
    precacheSVGs(),
  ]);

  // Call the private module function to register preferences-related dependencies with GetIt.
  // This modularizes the DI setup for preferences.
  _preferencesModule(sharedPreferences);

  // Configure the system UI mode, specifically enabling only the bottom overlay (e.g., navigation bar).
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: const [SystemUiOverlay.bottom],
  );
}
