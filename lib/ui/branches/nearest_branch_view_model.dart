import 'package:cafe_core/cafe_core.dart';
import 'package:flutter/foundation.dart';

import '../../data/repositories/branch_repository.dart';
import '../../data/services/location_service.dart';

/// หาสาขาที่ใกล้ที่สุด: อ่านตำแหน่ง (geolocator) + สาขา (REST) แล้วเรียงตามระยะ
class NearestBranchViewModel extends ChangeNotifier {
  NearestBranchViewModel(this._location, this._branches);

  final LocationService _location;
  final BranchRepository _branches;

  bool loading = false;
  LocationException? locationError;
  Object? error;
  List<(Branch, double)> results = [];

  Future<void> load() async {
    loading = true;
    locationError = null;
    error = null;
    notifyListeners();
    try {
      final here = await _location.current(); // ขอสิทธิ์ + อ่านพิกัด
      final branches = await _branches.fetchBranches(); // สาขาจาก REST
      results = nearestBranches(here.lat, here.lng, branches);
    } on LocationException catch (e) {
      locationError = e; // แยกไว้ เพื่อแสดงปุ่ม "เปิดการตั้งค่า" ได้
    } catch (e) {
      error = e;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> openSettings() => _location.openSettings();
}
