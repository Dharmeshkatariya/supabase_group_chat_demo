import 'export.dart';

class LocalStorageKeys {
  static const String keyLoggedIn = 'isLoggedIn';
  static const String token = 'token';
}

class AppPreference {
  AppPreference._();

  static Future<void> setBool(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static Future<void> setString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> removeKey(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

//:::::::::::::::::::::::::::::::::::::::  GET USER TOKEN  :::::::::::::::::::::::::::::::::::::::::::*/

  static Future<String?> getUserToken() async {
    return getString(LocalStorageKeys.token);
  }

//:::::::::::::::::::::::::::::::::::::::  SET USER TOKEN  :::::::::::::::::::::::::::::::::::::::::::*/

  static Future<void> setUserToken(String token) async {
    return setString(LocalStorageKeys.token, token);
  }
}
