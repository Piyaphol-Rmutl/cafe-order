import 'package:flutter/services.dart';

/// เรียกโค้ดเฉพาะแพลตฟอร์ม (Kotlin/Swift) ผ่าน MethodChannel
/// ชื่อช่องต้องตรงกับ MainActivity.kt และ AppDelegate.swift ทุกตัวอักษร
class CafeDeviceChannel {
  const CafeDeviceChannel([this._channel = channel]);

  static const channel = MethodChannel('th.ac.rmutl.engce307/cafe_device');

  final MethodChannel _channel;

  /// สั่นเครื่องหนึ่งครั้ง คืน false ถ้าแพลตฟอร์มไม่รองรับ
  Future<bool> vibrate() async {
    try {
      return await _channel.invokeMethod<bool>('vibrate') ?? false;
    } on MissingPluginException {
      return false; // เช่น ตอนรันเทสต์ หรือแพลตฟอร์มที่ยังไม่มีโค้ดเนทีฟ
    } on PlatformException {
      return false;
    }
  }

  /// ระดับแบตเตอรี่ 0–100 หรือ null ถ้าอ่านไม่ได้ (เช่น iOS Simulator)
  Future<int?> batteryLevel() async {
    try {
      final level = await _channel.invokeMethod<int>('batteryLevel');
      return level == null || level < 0 ? null : level;
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }
}
