import 'package:cafe_core/cafe_core.dart';
import 'package:cafe_order/data/repositories/loyalty_repository.dart';
import 'package:cafe_order/data/services/api_service.dart';
import 'package:cafe_order/data/services/token_store.dart';
import 'package:cafe_order/demos/w15_jank.dart';
import 'package:cafe_order/ui/menu/menu_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';

import 'helpers.dart';
import 'server.dart';

void main() {
  group('โทเค็นใน secure storage', () {
    test('ครั้งแรกลงทะเบียนเครื่อง แล้วใช้โทเค็นเดิมต่อ', () async {
      final requests = <String>[];
      final server = serverHandler();
      final client = MockClient((req) {
        requests.add('${req.method} ${req.url.path}');
        return server(req);
      });
      final tokens = MemoryTokenStore();
      final repo = ApiLoyaltyRepository(
        ApiService(baseUrl: baseUrl, client: client, tokens: tokens),
      );
      expect(await repo.fetchPoints(), 120);
      expect(await repo.fetchPoints(), 120);
      expect(tokens.token, startsWith('dev-'));
      expect(requests, ['POST /devices', 'GET /me/points', 'GET /me/points']);
    });

    test('โทเค็นใช้ไม่ได้ (401) → ลบแล้วลงทะเบียนใหม่หนึ่งครั้ง', () async {
      final tokens = MemoryTokenStore()..token = 'stolen-or-expired';
      final repo = ApiLoyaltyRepository(
        ApiService(baseUrl: baseUrl, client: fakeServer(), tokens: tokens),
      );
      expect(await repo.fetchPoints(), 120);
      expect(tokens.token, isNot('stolen-or-expired'));
    });

    test('ไม่มีโทเค็น → เซิร์ฟเวอร์ตอบ 401', () async {
      final res = await fakeServer().get(Uri.parse('$baseUrl/me/points'));
      expect(res.statusCode, 401);
    });

    test('SecureTokenStore ใช้ FlutterSecureStorage', () async {
      FlutterSecureStorage.setMockInitialValues({});
      final store = SecureTokenStore();
      await store.write('abc');
      expect(await store.read(), 'abc');
      await store.delete();
      expect(await store.read(), isNull);
    });
  });

  testWidgets('MenuImage ถอดรหัสภาพเท่าขนาดที่แสดง (cacheWidth)', (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp(MenuImage(item: sampleMenu.first, size: 72)),
    );
    final image = tester.widget<Image>(find.byType(Image));
    final provider = image.image as ResizeImage;
    expect(provider.width, 72 * 3); // จอทดสอบ devicePixelRatio = 3
  });

  testWidgets('หน้าร้านแสดงแต้มสะสม', (tester) async {
    await tester.pumpWidget(await cafeApp(initialLocation: '/shop'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('แต้มสะสม 120 แต้ม'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('แต้มสะสม 120 แต้ม'), findsOneWidget);
  });

  testWidgets('สาธิต jank: สลับเป็นแบบปรับแล้ว', (tester) async {
    await tester.pumpWidget(testApp(const JankDemo()));
    expect(find.byType(SlowRow), findsWidgets);
    await tester.tap(find.byType(Switch));
    await tester.pump();
    expect(find.byType(FastRow), findsWidgets);
    expect(find.byType(SlowRow), findsNothing);
  });
}
