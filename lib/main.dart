// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/auth_controller.dart';
import 'controllers/dashboard_controller.dart';
import 'controllers/pref_controller.dart';
import 'firebase.dart';
import 'firebase_options.dart';
import 'routers/auth_router.dart';
import 'routers/routes.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  await prefs.setStringList(
      DateTime.now().toIso8601String().substring(0, 19) + ".000000", [message.notification!.body.toString(), message.notification!.title.toString()]);
}

AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.max,
    playSound: true,
    sound: const RawResourceAndroidNotificationSound('notification'),
    vibrationPattern: Int64List.fromList([0, 1000, 1500, 1000]));

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
const initializationSettings = InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher'));

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // FirebaseAuth.instance.useAuthEmulator('172.20.10.13', 9099);
  // FirebaseFunctions.instance.useFunctionsEmulator('172.20.10.13', 5001);
  // FirebaseFirestore.instance.settings = const Settings(
  //   host: '172.20.10.13:8080',
  //   sslEnabled: false,
  //   persistenceEnabled: false,
  // );

  // SharedPreferences.setMockInitialValues({'key': "Value"});
  var preferences = await prefs;

  Get.put(PreferencesController(preferences));

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await firebaseMessaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  Get.put(AuthController());
  Get.put(Dashboard());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        iconTheme: const IconThemeData(color: Color(0xFFEF4C43)),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
          const Color(0xFFEF4C43),
        ))),
        primarySwatch: Colors.red,
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.white),
          bodyText1: TextStyle(fontSize: 14.0, color: Color(0xFFEF4C43)),
        ),
        tabBarTheme: const TabBarTheme(labelColor: Colors.white),
        appBarTheme: const AppBarTheme(color: Colors.redAccent),
      ),
      getPages: Routes.routes,

      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const AuthRouter(),
    );
  }
}
