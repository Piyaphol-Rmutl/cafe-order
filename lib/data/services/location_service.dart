import 'dart:async';

import 'package:geolocator/geolocator.dart';

/// สาเหตุที่อ่านตำแหน่งไม่ได้ (แยกเพื่อแสดงข้อความและทางแก้ที่ต่างกัน)
enum LocationFailure { serviceDisabled, denied, deniedForever, timeout }

class LocationException implements Exception {
  const LocationException(this.reason);

  final LocationFailure reason;

  String get message => switch (reason) {
    LocationFailure.serviceDisabled => 'บริการตำแหน่งที่ตั้งปิดอยู่',
    LocationFailure.denied => 'ไม่ได้รับอนุญาตให้ใช้ตำแหน่ง',
    LocationFailure.deniedForever =>
      'ถูกปฏิเสธสิทธิ์ถาวร เปิดได้ที่การตั้งค่าของแอป',
    LocationFailure.timeout => 'หาตำแหน่งไม่สำเร็จภายในเวลาที่กำหนด',
  };

  @override
  String toString() => message;
}

/// สิ่งที่แอปต้องการจากตำแหน่งที่ตั้ง (ทดสอบด้วยของปลอมได้)
abstract interface class LocationService {
  Future<({double lat, double lng})> current();
  Future<bool> openSettings();
}

/// ห่อแพ็กเกจ geolocator: ตรวจบริการ → ตรวจ/ขอสิทธิ์ → อ่านตำแหน่ง
class GeolocatorLocationService implements LocationService {
  const GeolocatorLocationService({
    this.timeLimit = const Duration(seconds: 15),
  });

  final Duration timeLimit;

  @override
  Future<({double lat, double lng})> current() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationException(LocationFailure.serviceDisabled);
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission(); // ระบบแสดงกล่องถาม
    }
    if (permission == LocationPermission.denied) {
      throw const LocationException(LocationFailure.denied);
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LocationException(LocationFailure.deniedForever);
    }
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: timeLimit,
        ),
      );
      return (lat: pos.latitude, lng: pos.longitude);
    } on TimeoutException {
      throw const LocationException(LocationFailure.timeout);
    }
  }

  @override
  Future<bool> openSettings() => Geolocator.openAppSettings();
}
