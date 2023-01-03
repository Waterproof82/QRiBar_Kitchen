import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:qribar/provider/products_provider.dart';
import 'package:qribar/provider/push_notifications.dart';
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

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final pushProvider = PushNotificationProvider();

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

Future<void> showNotification(int? numPedido, String? mesaSnap, bool? camarero, bool? avisoPago, bool? pedidoBackground) async {
  final notificationId = UniqueKey().hashCode;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'notificationId',
    'notificationId',
    channelDescription: 'Canal Notificación',
    importance: Importance.max,
    priority: Priority.high,
    icon: 'logo_cut',
    sound: RawResourceAndroidNotificationSound('chimes'),
    largeIcon: DrawableResourceAndroidBitmap('logo_cut') /* ticker: 'ticker' */,
    playSound: true,
    enableLights: true,
    color: Color.fromARGB(255, 255, 255, 255),
    ledColor: Color.fromARGB(255, 255, 255, 255),
    ledOnMs: 1000,
    ledOffMs: 500,
  );
  const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

  if (numPedido != 0 && camarero == false && avisoPago == false && pedidoBackground == false)
    await flutterLocalNotificationsPlugin.show(notificationId, 'Mesa ${int.parse(mesaSnap!)}', 'Nuevo Pedido nº $numPedido', platformChannelSpecifics, payload: 'item x');
  if (camarero == false && avisoPago == false && numPedido == 0 && pedidoBackground == true)
    await flutterLocalNotificationsPlugin.show(notificationId, 'Nuevo Pedido en Mesa ${int.parse(mesaSnap!)}', '', platformChannelSpecifics);
}
