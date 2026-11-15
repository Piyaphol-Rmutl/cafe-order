import 'package:shared_preferences/shared_preferences.dart';

/// Service ห่อ shared_preferences: เก็บค่าตั้งแบบคีย์-ค่า (ข้อมูลเล็ก ไม่ลับ)
class PrefsService {
  PrefsService(this._prefs);

  final SharedPreferences _prefs;

  static Future<PrefsService> create() async =>
      PrefsService(await SharedPreferences.getInstance());

  String? getString(String key) => _prefs.getString(key);

  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);
}
