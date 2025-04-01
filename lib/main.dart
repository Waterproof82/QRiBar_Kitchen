import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:qribar_cocina/providers/providers.dart';
import 'package:qribar_cocina/routes/app_routes.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('es_ES');

  WakelockPlus.enable();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Ocultar la barra superior
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.green[700],
          scaffoldBackgroundColor: Colors.blueGrey,
        ),
        debugShowCheckedModeBanner: false,
        title: 'QRiBar Cocina',
        initialRoute: AppRoutes.splash,
        navigatorKey: GlobalKey<NavigatorState>(),
        routes: AppRoutes.routes,
      ),
    );
  }
}
