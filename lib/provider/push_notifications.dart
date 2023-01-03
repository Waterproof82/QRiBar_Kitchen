import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'package:qribar/main.dart';
import 'package:qribar/provider/products_provider.dart';

class PushNotificationProvider {
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static String? token;
  String idBar = ProductsService().idBar;
  //static StreamController<String> _messagestream = new StreamController.broadcast();

  // static Stream<String> get messagestream => _messagestream.stream;

  initNotifications() async {
    /*    await Firebase.initializeApp(
         options: DefaultFirebaseOptions.currentPlatform,
        ); */

    _firebaseMessaging.getInitialMessage().then((data) => null);

    _firebaseMessaging.subscribeToTopic(idBar);
//Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        showNotification(0, message.notification!.body, false, false, false);
/*          flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );  */
      }
    });

    //Background
/*     FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data['router'];

      print(routeFromMessage);
    }); */

/*     NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    ); */
    // token = await _firebaseMessaging.getToken(
    //   vapidKey: "AAAA4rS8uVc:APA91bFXJmA0Mj9lCA3etssvfNvgmhayATJApk38n2tt13Ulj3Kh6hvhs81RsfGVna7DLy-7dmQJBWnIwjufRpuwh71bphGnKlVO9UE6iMOJ4xoBbhZZHFrtGHcLQ5zZWoeU_NtY24lx",
/*     _firebaseMessaging.getToken().then((token) {
      print('FCM=======Token');
      print(token);
    }); */
    //  );
    // print('FCM=======Token');
    //  print(token);
    //Nuevo pedido
/*     FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        showNotification(0, message.notification!.body, false, false, false);
        // _messagestream.sink.add(message.notification!.body!);
      },
    ); */

    // FirebaseMessaging.onBackgroundMessage((RemoteMessage message) => showNotification(0, message.notification!.body, false, false, false));
  }
}
