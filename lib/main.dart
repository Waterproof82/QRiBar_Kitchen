import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

//import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:qribar/screens/screens.dart';

import 'package:wakelock/wakelock.dart';

//import 'package:qribar/services/services.dart';
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(" --- background message received ---");
  if (message.notification!.title == 'camarero') showNotification(0, message.notification!.body, true, false, true);
  if (message.notification!.title == 'cobrar') showNotification(0, message.notification!.body, false, true, true);
  if (message.notification!.title == 'nuevoPedido') showNotification(0, message.notification!.body, false, false, true);

  //showNotification(0, message.notification!.body, false, false);
}

final pushProvider = PushNotificationProvider();
//GetIt getIt = GetIt.instance;

//final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
/* class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

String? selectedNotificationPayload; */
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

/*   MessagingManager manager = MessagingManager();
  getIt.registerSingleton<MessagingManager>(manager);
  await manager.setupFirebase(firebaseMessagingBackgroundHandler); */

  //await pushProvider.initNotifications();

  await initializeDateFormatting('es_ES');

  // await Preferences.init(); //Almacenamiento de datos

  runApp(AppState());

  // await Firebase.initializeApp();
  //FirebaseMessaging.instance.subscribeToTopic("OnlineUsers");
  /*  await Firebase.initializeApp(

      /*     options: const FirebaseOptions(
      apiKey: 'ccccccc',
      appId: '1:385965509282:android:a1594526a9d1ab76a4e5fb',
      messagingSenderId: '448618578101',
      projectId: 'qribar-notifications',
      authDomain: 'qribar-notifications-default-rtdb.europe-west1.firebasedatabase.app',
      //iosClientId: '448618578101-m53gtqfnqipj12pts10590l37npccd2r.apps.googleusercontent.com',
    ), */
      ); */
}

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*  var dateTime = new DateTime.now();
    print(dateTime); */
    return MultiProvider(
      providers: [
        //ChangeNotifierProvider(create: (_) => AuthService()),
        //ChangeNotifierProvider(create: (_) => ReadData()),
        ChangeNotifierProvider(create: (_) => ProductsService()),
        //ChangeNotifierProvider(create: (_) => PedidosService()),
        ChangeNotifierProvider(create: (_) => NavegacionModel()),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  //final GlobalKey<ScaffoldMessengerState> messengerKey = new GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

/*     FirebaseMessaging.instance.subscribeToTopic("OnlineUsers");
    //Notificaciones con APP abierta
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        showNotification(0, message.notification!.body, false, false, false);
      },
    ); */
    //TODO:Activar y probar notificaciones
    // final nav = Provider.of<NavegacionModel>(context, listen: false);
    //final salasMesa = Provider.of<ProductsService>(context, listen: false).salasMesa;

/*     PushNotificationService.messagestream.listen((message) {
      
      // print('My App $message');
      //navigatorKey.currentState?.pushNamed('salas', arguments: message);
      //nav.categoriaSelected = 'Cuenta';
      //showNotification(nav.numPedido, salasMesa.mesa, salasMesa[i].callCamarero!, false);
      //final snackBar = SnackBar(content: Text(message));

      //NotificationService.showSnackbar('$message', '');
      //NotificationService.messengerKey.currentState?.showSnackBar(snackBar);
    }); */
    // _sendMessage();
  }

/*   Future _sendMessage() async {
    var func = FirebaseFunctions.instance.httpsCallable("notifySubscribers");
    var res = await func.call(<String, dynamic>{
      "targetDevices": [PushNotificationService.token],
      "messageTitle": "Test title",
      "messageBody": 'Hola sjsui iasias'
    });
  } */

  @override
  Widget build(BuildContext context) {
    //final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);

    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.green[700], backgroundColor: Colors.blueGrey),
      debugShowCheckedModeBanner: false,
      title: 'QRiBar',
      initialRoute: 'splash',
      scaffoldMessengerKey: NotificationService.messengerKey,
      navigatorKey: navigatorKey,
      routes: {
        LoginScreen.routeName: (_) => LoginScreen(),
        //RegisterScreen.routeName: (_) => RegisterScreen(),
        // CheckAuthScreen.routeName: (_) => CheckAuthScreen(),
        //AlertDialogs.routeName: (_) => AlertDialogs(),
        Splash.routeName: (_) => Splash(),
        PrinterestScreen.routeName: (_) => PrinterestScreen(),
        //ProductScreen.routeName: (_) => ProductScreen(),
        //IconScreen.routeName: (_) => IconScreen(),
        /*        PedidosScreen.routeName: (_) => PedidosScreen(
              numUltPed: '0',
            ), */
        //PedidoRealizadoScreen.routeName: (_) => PedidoRealizadoScreen(),
        //PagoScreen.routeName: (_) => PagoScreen(),
        //CamareroScreen.routeName: (_) => CamareroScreen(),
        CuentaCocinaScreen.routeName: (_) => CuentaCocinaScreen(),
        //CuentaMesasScreen.routeName: (_) => CuentaMesasScreen(),
        //CuentaMesasGeneralScreen.routeName: (_) => CuentaMesasGeneralScreen(),
        CuentaCocinaGeneralScreen.routeName: (_) => CuentaCocinaGeneralScreen(),
        //CuentaBarraGeneralScreen.routeName: (_) => CuentaBarraGeneralScreen(),
        //CuentaScreen.routeName: (_) => CuentaScreen(),
        //SalasMenuPage.routeName: (_) => SalasMenuPage(),
        //SalaPage.routeName: (_) => SalaPage(),
        //IconosLista.routeName: (_) => IconosLista(),
        //MapaScreen.routeName: (_) => MapaScreen(),
        //LongPressDrag.routeName: (_) => LongPressDrag(),
        // PushNotificationService.routeName: (_) => PushNotificationService()
        //ListenFirebase.routeName: (_) => ListenFirebase()
        //VideoApp.routeName: (_) => VideoApp(),
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
  if (avisoPago == true && camarero == false)
    await flutterLocalNotificationsPlugin.show(notificationId, 'Aviso de Cobro en Mesa ${int.parse(mesaSnap!)}', '', platformChannelSpecifics);
  else if (camarero == true && avisoPago == false)
    await flutterLocalNotificationsPlugin.show(notificationId, 'Aviso de Camarero en Mesa ${int.parse(mesaSnap!)}', '', platformChannelSpecifics);
}
