import 'package:flutter/material.dart';

import '../../data/repositories/settings_repository.dart';

/// ViewModel ของค่าตั้ง: อ่านค่าเริ่มต้นจาก repository และบันทึกทุกครั้งที่เปลี่ยน
class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel(this._repository)
    : _themeMode = _repository.themeMode,
      _locale = _repository.locale;

  final SettingsRepository _repository;
  ThemeMode _themeMode;
  Locale _locale;

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  set themeMode(ThemeMode mode) {
    if (mode == _themeMode) return;
    _themeMode = mode;
    notifyListeners(); // UI เปลี่ยนทันที
    _repository.saveThemeMode(mode); // แล้วจึงบันทึก
  }

  set locale(Locale value) {
    if (value == _locale) return;
    _locale = value;
    notifyListeners();
    _repository.saveLocale(value);
  }
}
