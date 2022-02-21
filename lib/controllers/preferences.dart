import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static SharedPreferences? _preference;
  set preference(SharedPreferences? pref) {
    _preference = pref ?? _preference;
  }

  SharedPreferences? get preference => _preference;
}
