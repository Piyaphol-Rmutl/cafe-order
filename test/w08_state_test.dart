import 'package:cafe_core/cafe_core.dart';
import 'package:cafe_order/demos/w08_inherited.dart';
import 'package:cafe_order/demos/w08_listenable_builder.dart';
import 'package:cafe_order/state/cart_model.dart';
import 'package:cafe_order/state/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  final latte = sampleMenu.first;

  group('CartModel', () {
    test('add/setQuantity/removeAt แจ้งผู้ฟังทุกครั้ง', () {
      final cart = CartModel();
      var notified = 0;
      cart.addListener(() => notified++);

      cart.add(OrderItem(item: latte)); // 65
      cart.add(OrderItem(item: latte, quantity: 2)); // 130
      expect(cart.count, 3);
      expect(cart.total, 195);

      cart.setQuantity(0, 3);
      expect(cart.count, 5);
      cart.setQuantity(1, 0); // เหลือ 0 = ลบ
      expect(cart.items, hasLength(1));
      cart.removeAt(0);
      expect(cart.isEmpty, isTrue);
      expect(notified, 5);
    });

    test('items แก้จากภายนอกไม่ได้', () {
      final cart = CartModel()..add(OrderItem(item: latte));
      expect(() => cart.items.clear(), throwsUnsupportedError);
    });

    test('checkout คืน Order และล้างตะกร้า', () {
      final cart = CartModel()..add(OrderItem(item: latte, quantity: 2));
      final order = cart.checkout();
      expect(order.total, 130);
      expect(cart.isEmpty, isTrue);
    });
  });

  test('SettingsModel ไม่แจ้งเมื่อค่าเดิม', () {
    final settings = SettingsModel();
    var notified = 0;
    settings.addListener(() => notified++);
    settings.locale = const Locale('th');
    settings.themeMode = ThemeMode.dark;
    expect(notified, 1);
  });

  testWidgets('badge บนแท็บตะกร้าอัปเดตเมื่อโมเดลเปลี่ยน', (tester) async {
    final cart = CartModel();
    await tester.pumpWidget(cafeApp(cart: cart));
    expect(find.byType(Badge), findsOneWidget);
    expect(find.text('2'), findsNothing);

    cart.add(OrderItem(item: latte, quantity: 2));
    await tester.pump();
    expect(
      find.descendant(of: find.byType(Badge), matching: find.text('2')),
      findsOneWidget,
    );
  });

  testWidgets('ลดจำนวนในหน้าตะกร้า → badge ลดตาม (หน้าอื่นรู้ด้วย)', (
    tester,
  ) async {
    final cart = CartModel()..add(OrderItem(item: latte, quantity: 2));
    await tester.pumpWidget(cafeApp(cart: cart, initialLocation: '/cart'));
    await tester.tap(find.byTooltip('ลบ ลาเต้'));
    await tester.pump();
    expect(cart.count, 1);
    expect(find.text('ลาเต้ ×1'), findsOneWidget);
    expect(
      find.descendant(of: find.byType(Badge), matching: find.text('1')),
      findsOneWidget,
    );
  });

  testWidgets('ปัดซ้ายเพื่อลบ (Dismissible)', (tester) async {
    final cart = CartModel()..add(OrderItem(item: latte));
    await tester.pumpWidget(cafeApp(cart: cart, initialLocation: '/cart'));
    await tester.drag(find.text('ลาเต้ ×1'), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(cart.isEmpty, isTrue);
    expect(find.text('ตะกร้ายังว่าง'), findsOneWidget);
  });

  testWidgets('สาธิต ListenableBuilder: สองกิ่งเห็นข้อมูลตรงกัน', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(const ListenableDemo()));
    await tester.tap(find.byTooltip('เพิ่มลาเต้'));
    await tester.tap(find.byTooltip('เพิ่มลาเต้'));
    await tester.pump();
    expect(find.text('2 แก้ว'), findsOneWidget);
    expect(find.text('ลาเต้'), findsNWidgets(2));
  });

  testWidgets('สาธิต InheritedWidget: ลูกหลานเห็นค่าใหม่', (tester) async {
    await tester.pumpWidget(testApp(const InheritedDemo()));
    expect(find.text('ร้าน: สาขาวิศวะ'), findsOneWidget);
    await tester.tap(find.text('สลับสาขา'));
    await tester.pump();
    expect(find.text('ร้าน: สาขาหอพัก'), findsOneWidget);
  });
}
