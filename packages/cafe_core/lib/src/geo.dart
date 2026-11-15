import 'dart:math' as math;

import 'branch.dart';

/// ระยะทางบนผิวโลกระหว่างสองพิกัด (เมตร) ด้วยสูตร Haversine
double distanceMeters(double lat1, double lng1, double lat2, double lng2) {
  const earthRadius = 6371000.0;
  double rad(double d) => d * math.pi / 180;
  final dLat = rad(lat2 - lat1);
  final dLng = rad(lng2 - lng1);
  final a =
      math.pow(math.sin(dLat / 2), 2) +
      math.cos(rad(lat1)) *
          math.cos(rad(lat2)) *
          math.pow(math.sin(dLng / 2), 2);
  return 2 * earthRadius * math.asin(math.sqrt(a));
}

/// เรียงสาขาจากใกล้ไปไกล คืนคู่ (สาขา, ระยะทางเมตร) เป็น Record
List<(Branch, double)> nearestBranches(
  double lat,
  double lng,
  List<Branch> branches,
) {
  final result = [
    for (final b in branches)
      (b, distanceMeters(lat, lng, b.latitude, b.longitude)),
  ];
  result.sort((a, b) => a.$2.compareTo(b.$2));
  return result;
}
