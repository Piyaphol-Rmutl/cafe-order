import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// ที่เก็บโทเค็นลับ (สัปดาห์ 15): ห้ามเก็บใน shared_preferences หรือฝังในโค้ด
abstract interface class TokenStore {
  Future<String?> read();
  Future<void> write(String token);
  Future<void> delete();
}

/// เก็บใน Keychain (iOS) / เข้ารหัสด้วยกุญแจใน Android Keystore (Android)
class SecureTokenStore implements TokenStore {
  SecureTokenStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  static const _key = 'device_token';

  @override
  Future<String?> read() => _storage.read(key: _key);

  @override
  Future<void> write(String token) => _storage.write(key: _key, value: token);

  @override
  Future<void> delete() => _storage.delete(key: _key);
}

/// เก็บในหน่วยความจำ (ทดสอบ หรือแพลตฟอร์มที่ไม่มีที่เก็บปลอดภัย)
class MemoryTokenStore implements TokenStore {
  String? token;

  @override
  Future<String?> read() async => token;

  @override
  Future<void> write(String value) async => token = value;

  @override
  Future<void> delete() async => token = null;
}
