import 'package:cafe_core/cafe_core.dart';
import 'package:cafe_order/data/services/api_service.dart';
import 'package:cafe_order/data/services/recommender.dart';
import 'package:cafe_order/ui/customize/customize_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';
import 'helpers.dart';
import 'server.dart';

/// Service ที่ล้มเหลวเสมอ (เช่น เซิร์ฟเวอร์ AI ล่ม)
class BrokenRecommender implements MenuRecommender {
  @override
  Future<Recommendation> recommend(
    List<MenuItem> menu,
    RecommendationRequest r,
  ) => Future.error(Exception('AI unavailable'));
}

/// แนะนำเมนูที่ไม่มีในร้าน (เช่น โมเดลแต่งขึ้น) ราคาก็ไม่ตรง
class UnknownMenuRecommender implements MenuRecommender {
  @override
  Future<Recommendation> recommend(
    List<MenuItem> menu,
    RecommendationRequest r,
  ) async => Recommendation(
    const MenuItem(
      id: 'unicorn-latte',
      name: 'ยูนิคอร์นลาเต้',
      category: MenuCategory.coffee,
      price: 1,
    ),
    'ใหม่ล่าสุด',
  );
}

void main() {
  test('FakeRecommender ใช้กฎ: สั่งบ่อยมาก่อน', () async {
    const fake = FakeRecommender(delay: Duration.zero);
    final rec = await fake.recommend(
      sampleMenu,
      const RecommendationRequest(hour: 9, orderCounts: {'thai_tea': 4}),
    );
    expect(rec.item.id, 'thai_tea');
    expect(rec.reason, contains('บ่อย'));
  });

  test(
    'ApiRecommender: แอปเรียกเซิร์ฟเวอร์ของเรา (คีย์ AI อยู่ฝั่งเซิร์ฟเวอร์)',
    () async {
      final rec = await ApiRecommender(
        ApiService(baseUrl: baseUrl, client: fakeServer()),
      ).recommend(sampleMenu, const RecommendationRequest(hour: 14));
      expect(rec.item.id, 'lemon_soda');
    },
  );

  test('prompt จำกัดให้เลือกจากเมนูที่มีและตอบเป็น JSON', () {
    final prompt = buildRecommendationPrompt(
      sampleMenu,
      const RecommendationRequest(hour: 9, favorites: {'latte'}),
    );
    expect(prompt, contains('เลือกจากเมนูต่อไปนี้เท่านั้น'));
    expect(prompt, contains('- latte: ลาเต้ 55 บาท'));
    expect(prompt, contains('JSON'));
    expect(prompt, isNot(contains('@'))); // ไม่ส่งอีเมล/ข้อมูลส่วนตัว
  });

  testWidgets('การ์ดแนะนำใช้ประวัติการสั่ง แล้วกด "ลองเลย" เปิดหน้าปรับแต่ง', (
    tester,
  ) async {
    final orders = InMemoryOrderRepository();
    await orders.placeOrder([
      OrderItem(item: sampleMenu[2], quantity: 2),
    ]); // มอคค่า
    await tester.pumpWidget(await cafeApp(orders: orders));
    await tester.pumpAndSettle();
    expect(find.text('แนะนำสำหรับคุณ: มอคค่า'), findsOneWidget);
    expect(find.textContaining('AI (จำลอง)'), findsOneWidget);
    await tester.tap(find.text('ลองเลย'));
    await tester.pumpAndSettle();
    expect(find.byType(CustomizePage), findsOneWidget);
  });

  testWidgets('แนะนำเมนูที่ไม่มีในร้าน → ไม่แสดงการ์ด', (tester) async {
    await tester.pumpWidget(
      await cafeApp(recommender: UnknownMenuRecommender()),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('ยูนิคอร์นลาเต้'), findsNothing);
    expect(find.textContaining('แนะนำสำหรับคุณ'), findsNothing);
  });

  testWidgets('AI ล้มเหลว → ซ่อนการ์ด แอปยังใช้ได้', (tester) async {
    await tester.pumpWidget(await cafeApp(recommender: BrokenRecommender()));
    await tester.pumpAndSettle();
    expect(
      find
          .byType(Card)
          .evaluate()
          .where(
            (e) => find
                .descendant(
                  of: find.byWidget(e.widget),
                  matching: find.text('ลองเลย'),
                )
                .evaluate()
                .isNotEmpty,
          ),
      isEmpty,
    );
    expect(find.textContaining('แนะนำสำหรับคุณ'), findsNothing);
    expect(find.text('ลาเต้'), findsOneWidget); // เมนูยังแสดงตามปกติ
  });
}
