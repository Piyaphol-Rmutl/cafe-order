import 'package:flutter/material.dart';

/// ค่าตั้งของแอป (โหมดธีม ภาษา) ที่ MaterialApp และหน้าตั้งค่าใช้ร่วมกัน
class SettingsModel extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('th');

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  set themeMode(ThemeMode mode) {
    if (mode == _themeMode) return;
    _themeMode = mode;
    notifyListeners();
  }

  set locale(Locale value) {
    if (value == _locale) return;
    _locale = value;
    notifyListeners();
  }
}
