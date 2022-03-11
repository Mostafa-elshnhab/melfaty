import 'package:shared_preferences/shared_preferences.dart';

class CashHelper {
  static SharedPreferences? prefs;
  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static dynamic getData(String key) async {
    return prefs!.getString(key);
  }

  static dynamic getBoarding(String key) {
    return prefs!.getBool(key);
  }

  static dynamic getuId(String key) {
    return prefs!.getString(key);
  }

  static dynamic getList(String key) {
    return prefs!.getStringList(key);
  }

  static Future<bool> saveData(
      {required String key, required dynamic value,bool? isList}) async {
    if (value is String) return await prefs!.setString(key, value);
    if (value is int) return await prefs!.setInt(key, value);
    if (value is bool) return await prefs!.setBool(key, value);
    if(isList!) return await prefs!.setStringList(key, value);
    return await prefs!.setDouble(key, value);
  }

  static Future<bool> removeData({
    required String key,
  }) async {
    return await prefs!.remove(key);
  }

}
