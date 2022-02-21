import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:safecampus/constants/themeconstants.dart';

class NotificationHelper {
  // ignore: unused_element
  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    preferencesController.preferences.setStringList(DateTime.now().toIso8601String().substring(0, 19) + ".000000",
        [message.notification!.body.toString(), message.notification!.title.toString()]);
    // sharedPreferenbcece
  }
}
