import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:qribar/provider/products_provider.dart';
import 'package:qribar/screens/cuenta_cocina_general.dart';
import 'package:qribar/screens/cuenta_cocina_screen.dart';
import 'package:qribar/provider/navegacion_model.dart';
import 'package:qribar/services/notifications_service.dart';
import 'package:qribar/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qribar/screens/screens.dart';
import 'package:wakelock/wakelock.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();
  await Firebase.initializeApp();
  await initializeDateFormatting('es_ES');
  runApp(AppState());
}

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ProductsService()),
      ChangeNotifierProvider(create: (_) => NavegacionModel()),
    ], child: MyApp());
  }
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);

    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.green[700], backgroundColor: Colors.blueGrey),
      debugShowCheckedModeBanner: false,
      title: 'QRiBar Cocina',
      initialRoute: 'splash',
      scaffoldMessengerKey: NotificationService.messengerKey,
      navigatorKey: navigatorKey,
      routes: {
        LoginScreen.routeName: (_) => LoginScreen(),
        Splash.routeName: (_) => Splash(),
        PrinterestScreen.routeName: (_) => PrinterestScreen(),
        CuentaCocinaScreen.routeName: (_) => CuentaCocinaScreen(),
        CuentaCocinaGeneralScreen.routeName: (_) => CuentaCocinaGeneralScreen(),
      },
    );
  }
}
