import 'package:flutter/foundation.dart';

/// ที่อยู่ของ API: กำหนดตอน build ได้ด้วย
///   flutter run --dart-define=API_BASE_URL=http://192.168.1.10:8080
/// ถ้าไม่กำหนด: Android Emulator ใช้ 10.0.2.2 (= localhost ของเครื่องคอมพิวเตอร์)
/// ส่วน iOS Simulator ใช้ localhost ได้ตรง ๆ
String get apiBaseUrl {
  const fromDefine = String.fromEnvironment('API_BASE_URL');
  if (fromDefine.isNotEmpty) return fromDefine;
  return defaultTargetPlatform == TargetPlatform.android
      ? 'http://10.0.2.2:8080'
      : 'http://localhost:8080';
}
