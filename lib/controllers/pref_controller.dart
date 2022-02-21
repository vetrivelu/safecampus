import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesController extends GetxController {
  final SharedPreferences preferences;
  static PreferencesController instance = Get.find();
  PreferencesController(this.preferences);
}
