import 'dart:convert';

import 'package:cafe_core/cafe_core.dart';
import 'package:test/test.dart';

void main() {
  final latte = sampleMenu.firstWhere((m) => m.id == 'latte');
  final croissant = sampleMenu.firstWhere((m) => m.id == 'croissant');

  group('MenuItem', () {
    test('fromJson/toJson ไปกลับได้ค่าเดิม', () {
      final copy = MenuItem.fromJson(latte.toJson());
      expect(copy, latte);
      expect(copy.nameEn, 'Latte');
      expect(copy.category, MenuCategory.coffee);
    });

    test('ไม่มีชื่ออังกฤษ ใช้ชื่อไทยแทน', () {
      expect(croissant.nameEn, isNull);
      expect(croissant.displayNameEn, 'ครัวซองต์เนยสด');
    });

    test('groupByCategory แยกหมวดครบ', () {
      final groups = groupByCategory(sampleMenu);
      expect(groups.keys, containsAll(MenuCategory.values));
      expect(groups[MenuCategory.bakery], [croissant]);
    });
  });

  group('OrderItem', () {
    test('ราคาต่อแก้ว = เมนู + ขนาด + ท็อปปิง', () {
      final item = OrderItem(
        item: latte,
        size: CupSize.large,
        toppings: {allToppings[0], allToppings[1]},
        quantity: 2,
      );
      expect(item.unitPrice, 55 + 20 + 15 + 10);
      expect(item.total, 200);
      expect(item.priceText, '200 บาท');
    });

    test('เบเกอรี่ไม่บวกราคาขนาดแก้ว', () {
      final item = OrderItem(item: croissant, size: CupSize.large);
      expect(item.unitPrice, 35);
      expect(item.summary, '');
    });

    test('ท็อปปิงซ้ำนับครั้งเดียว (Set)', () {
      final item = OrderItem(
        item: latte,
        toppings: {allToppings[0], const Topping('shot', 'เพิ่มช็อต', 15)},
      );
      expect(item.toppings.length, 1);
    });
  });

  group('Order และ Promotion', () {
    final order = Order(id: 'A1', items: [
      OrderItem(item: latte, quantity: 2), // (55+10)*2 = 130
      OrderItem(item: croissant), // 35
    ]);

    test('summary คืน Record จำนวนชิ้นและยอดรวม', () {
      expect(order.summary, (cups: 3, total: 165));
    });

    test('PercentOff และ CupsDiscount', () {
      expect(const PercentOff(10).applyTo(order), 165 - 16);
      expect(const CupsDiscount(minCups: 3, amount: 20).applyTo(order), 145);
      expect(const CupsDiscount(minCups: 5, amount: 20).applyTo(order), 165);
    });

    test('สถานะถัดไปเรียงตามลำดับ', () {
      expect(OrderStatus.received.next, OrderStatus.preparing);
      expect(OrderStatus.completed.next, isNull);
      expect(order.copyWith(status: OrderStatus.ready).status,
          OrderStatus.ready);
    });
  });

  group('อะซิงโครนัส', () {
    test('loadMenu อ่าน JSON แบบ Future', () async {
      final text = jsonEncode([for (final m in sampleMenu) m.toJson()]);
      final menu = await loadMenu(text, delay: Duration.zero);
      expect(menu, hasLength(sampleMenu.length));
    });

    test('simulateOrderProgress ส่งสถานะครบตามลำดับ', () {
      expect(
        simulateOrderProgress(step: Duration.zero),
        emitsInOrder([...OrderStatus.values, emitsDone]),
      );
    });
  });
}
