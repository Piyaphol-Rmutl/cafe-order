import 'package:flutter/material.dart';

/// สีหลักของร้าน (seed) ใช้สร้าง ColorScheme ทั้งชุดตามหลัก Material 3
const Color brandSeed = Color(0xFF8D5A2B);

/// ThemeData ของโหมดสว่าง/มืดจาก seed เดียวกัน
ThemeData buildTheme(Brightness brightness) {
  final scheme = ColorScheme.fromSeed(
    seedColor: brandSeed,
    brightness: brightness,
  );
  return ThemeData(
    colorScheme: scheme,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.primaryContainer,
      foregroundColor: scheme.onPrimaryContainer, // คู่สีที่คมชัดพอ
    ),
    cardTheme: CardThemeData(
      color: scheme.surfaceContainerLow,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),
  );
}

final ThemeData lightTheme = buildTheme(Brightness.light);
final ThemeData darkTheme = buildTheme(Brightness.dark);
