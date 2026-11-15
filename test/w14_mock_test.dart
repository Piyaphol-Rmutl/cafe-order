import 'package:cafe_core/cafe_core.dart';
import 'package:cafe_order/data/repositories/favorite_repository.dart';
import 'package:cafe_order/data/repositories/menu_repository.dart';
import 'package:cafe_order/data/repositories/order_repository.dart';
import 'package:cafe_order/data/services/api_exception.dart';
import 'package:cafe_order/demos/w14_debugging.dart';
import 'package:cafe_order/ui/cart/cart_view_model.dart';
import 'package:cafe_order/ui/menu/menu_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers.dart';
import 'w06_navigation_test.dart' show addToCart;

// Mock: กำหนดคำตอบด้วย when() และตรวจการเรียกด้วย verify()
class MockMenuRepository extends Mock implements MenuRepository {}

class MockFavoriteRepository extends Mock implements FavoriteRepository {}

class MockOrderRepository extends Mock implements OrderRepository {}

void main() {
  final latte = sampleMenu.first;

  setUpAll(() {
    registerFallbackValue(<OrderItem>[]); // ใช้กับ any() ของ List<OrderItem>
  });

  group('MenuViewModel กับ Mock', () {
    late MockMenuRepository menu;
    late MockFavoriteRepository favorites;
    late MenuViewModel vm;

    setUp(() {
      menu = MockMenuRepository();
      favorites = MockFavoriteRepository();
      when(() => favorites.load()).thenAnswer((_) async => {'latte'});
      vm = MenuViewModel(menu, favorites);
    });

    test('โหลดสำเร็จ: เรียก repository ครั้งเดียว', () async {
      when(() => menu.fetchMenu()).thenAnswer((_) async => sampleMenu);
      await vm.load();
      expect(vm.items, sampleMenu);
      expect(vm.isFavorite('latte'), isTrue);
      verify(() => menu.fetchMenu()).called(1);
    });

    test('บันทึกรายการโปรดไม่สำเร็จ → ย้อนกลับ (rollback)', () async {
      when(() => menu.fetchMenu()).thenAnswer((_) async => sampleMenu);
      when(() => favorites.setFavorite(any(), any()))
          .thenThrow(const ApiException('disk full'));
      await vm.load();
      await vm.toggleFavorite('mocha');
      expect(vm.isFavorite('mocha'), isFalse);
      verify(() => favorites.setFavorite('mocha', true)).called(1);
    });
  });

  group('CartViewModel กับ Mock', () {
    test('กดสั่งซ้ำระหว่างกำลังส่ง → ส่งครั้งเดียว', () async {
      final orders = MockOrderRepository();
      when(() => orders.placeOrder(any())).thenAnswer((inv) async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        return Order(
          id: 'M1',
          items: inv.positionalArguments.first as List<OrderItem>,
        );
      });
      final cart = CartViewModel(orders)..add(OrderItem(item: latte));
      final results = await Future.wait([cart.checkout(), cart.checkout()]);
      expect(results.whereType<Order>(), hasLength(1));
      verify(() => orders.placeOrder(any())).called(1);
    });

    test('ข้อผิดพลาดจาก repository ไม่หลุดออกมาเป็น exception', () async {
      final orders = MockOrderRepository();
      when(() => orders.placeOrder(any()))
          .thenThrow(const ApiException('เซิร์ฟเวอร์ขัดข้อง', statusCode: 500));
      final cart = CartViewModel(orders)..add(OrderItem(item: latte));
      expect(await cart.checkout(), isNull);
      expect(cart.error, isA<ApiException>());
    });
  });

  group('บั๊กที่ฝังไว้ในหน้าฝึกดีบัก (เทสต์จับได้)', () {
    test('total ลืมคูณจำนวน', () {
      final cart = BuggyCart()..items.add(OrderItem(item: latte, quantity: 2));
      final correct = cart.items.fold(0, (s, i) => s + i.total);
      expect(cart.total, isNot(correct)); // 65 แทนที่จะเป็น 130
    });

    test('removeMenu ลบไม่ครบเมื่อรายการซ้ำติดกัน', () {
      final cart = BuggyCart()
        ..items.addAll([OrderItem(item: latte), OrderItem(item: latte)]);
      cart.removeMenu('latte');
      expect(cart.items, hasLength(1)); // ควรเป็น 0
    });
  });

  testWidgets('เปลี่ยนแท็บแล้ว SnackBar หายทันที (ไม่บังปุ่มสั่งซื้อ)', (
    tester,
  ) async {
    await tester.pumpWidget(await cafeApp());
    await tester.pumpAndSettle();
    await addToCart(tester, 'ลาเต้');
    expect(find.byType(SnackBar), findsOneWidget);
    await tester.tap(find.text('ตะกร้า'));
    await tester.pumpAndSettle(); // ไม่ต้องรอ 4 วินาที
    expect(find.byType(SnackBar), findsNothing);
    await tester.tap(find.text('สั่งซื้อ · 65 บาท'));
    await tester.pumpAndSettle();
    expect(find.text('ตกลง'), findsOneWidget);
  });

  testWidgets('หน้าฝึกดีบัก: สวิตช์ debugPaintSizeEnabled ไม่ทำให้เกิด error', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(const DebuggingDemo()));
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle(); // reassemble หลังจบเฟรม
    expect(debugPaintSizeEnabled, isTrue);
    expect(tester.takeException(), isNull);
    debugPaintSizeEnabled = false; // คืนค่าให้เทสต์อื่น
  });
}
