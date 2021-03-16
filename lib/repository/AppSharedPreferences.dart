import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  AppSharedPreferences._privateConstructor();

  static final AppSharedPreferences instance =
  AppSharedPreferences._privateConstructor();

  setBooleanValue(String key, bool value) async {
    SharedPreferences appPrefs = await SharedPreferences.getInstance();
    appPrefs.setBool(key, value);
  }

  Future<bool> getBooleanValue(String key) async {
    SharedPreferences appPrefs = await SharedPreferences.getInstance();
    return appPrefs.getBool(key);
    //TODO: add other data-types
  }

}