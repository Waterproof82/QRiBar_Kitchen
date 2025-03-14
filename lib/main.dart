import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:qribar_cocina/providers/providers.dart';
import 'package:qribar_cocina/routes/app_routes.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();
  await Firebase.initializeApp();
  await initializeDateFormatting('es_ES');
  runApp(Providers());
}

class Providers extends StatelessWidget {
  const Providers({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: App(),
    );
  }
}

class App extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);

    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.green[700], scaffoldBackgroundColor: Colors.blueGrey),
      debugShowCheckedModeBanner: false,
      title: 'QRiBar Cocina',
      initialRoute: AppRoutes.splash,
      navigatorKey: navigatorKey,
      routes: AppRoutes.routes,
    );
  }
}
