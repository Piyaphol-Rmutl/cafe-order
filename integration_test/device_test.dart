// ทดสอบฮาร์ดแวร์บนเครื่องจำลองจริง (สัปดาห์ 13)
// 1) dart run tool/mock_server.dart
// 2) iOS:     xcrun simctl location <udid> set 18.8030,98.9510
//             xcrun simctl privacy <udid> grant location th.ac.rmutl.engce307.cafeOrder
//    Android: adb emu geo fix 98.9510 18.8030   (ลองจิจูดก่อน)
// 3) flutter test integration_test/device_test.dart -d <เครื่องจำลอง>
import 'package:cafe_core/cafe_core.dart';
import 'package:cafe_order/config.dart';
import 'package:cafe_order/data/repositories/branch_repository.dart';
import 'package:cafe_order/data/services/api_service.dart';
import 'package:cafe_order/data/services/device_channel.dart';
import 'package:cafe_order/data/services/location_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('ตำแหน่งจำลอง + สาขาจากเซิร์ฟเวอร์ → สาขาหอพักใกล้สุด', (
    tester,
  ) async {
    final here = await const GeolocatorLocationService().current();
    final branches = await ApiBranchRepository(ApiService(baseUrl: apiBaseUrl))
        .fetchBranches();
    final sorted = nearestBranches(here.lat, here.lng, branches);
    // ignore: avoid_print
    print(
      'ตำแหน่ง $here → ${sorted.first.$1.name} ${sorted.first.$2.round()} ม.',
    );
    expect(sorted.first.$1.id, 'dorm');
  });

  testWidgets('MethodChannel เรียกโค้ดเนทีฟได้จริง', (tester) async {
    const device = CafeDeviceChannel();
    expect(await device.vibrate(), isTrue);
    final level = await device.batteryLevel();
    // ignore: avoid_print
    print('แบตเตอรี่: $level'); // iOS Simulator = null
  });
}
