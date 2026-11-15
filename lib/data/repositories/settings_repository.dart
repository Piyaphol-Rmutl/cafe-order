import 'package:flutter/material.dart';

import '../services/prefs_service.dart';

/// ค่าตั้งของแอป: แปลงชนิดของ Flutter ↔ ข้อความใน shared_preferences
class SettingsRepository {
  SettingsRepository(this._prefs);

  final PrefsService _prefs;

  static const _themeKey = 'theme_mode';
  static const _localeKey = 'locale';

  ThemeMode get themeMode =>
      ThemeMode.values.asNameMap()[_prefs.getString(_themeKey)] ??
      ThemeMode.system;

  Locale get locale => Locale(_prefs.getString(_localeKey) ?? 'th');

  Future<void> saveThemeMode(ThemeMode mode) =>
      _prefs.setString(_themeKey, mode.name);

  Future<void> saveLocale(Locale locale) =>
      _prefs.setString(_localeKey, locale.languageCode);
}
