import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/presentation/splash/splash_screen.dart';
import 'package:qribar_cocina/presentation/cocina/cocina_general_screen.dart';
import 'package:qribar_cocina/presentation/cocina/cocina_pedidos_screen.dart';
import 'package:qribar_cocina/presentation/home/home_screen.dart';
import 'package:qribar_cocina/presentation/login/login_screen.dart';
import 'package:qribar_cocina/providers/listeners_provider.dart';
import 'package:qribar_cocina/presentation/login/provider/login_form_provider.dart';
import 'package:qribar_cocina/providers/navegacion_model.dart';
import 'package:qribar_cocina/providers/products_provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();
  await Firebase.initializeApp();
  await initializeDateFormatting('es_ES');
  runApp(AppState());
}

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => LoginFormProvider()),
      ChangeNotifierProvider(create: (_) => ProductsService()),
      ChangeNotifierProvider(create: (_) => NavegacionModel()),
      ChangeNotifierProvider(create: (_) => ListenersProvider()),
    ], child: App());
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
      initialRoute: 'splash',
      navigatorKey: navigatorKey,
      routes: {
        Splash.routeName: (_) => Splash(),
        LoginScreen.routeName: (_) => LoginScreen(),
        HomeScreen.routeName: (_) => HomeScreen(),
        CocinaPedidosScreen.routeName: (_) => CocinaPedidosScreen(),
        CocinaGeneralScreen.routeName: (_) => CocinaGeneralScreen(),
      },
    );
  }
}
