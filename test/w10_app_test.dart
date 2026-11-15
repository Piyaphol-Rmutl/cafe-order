import 'package:cafe_core/cafe_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';
import 'helpers.dart';
import 'w06_navigation_test.dart' show addToCart;

void main() {
  testWidgets('สั่งซื้อแล้วเห็นในหน้าประวัติ และเปิดใบเสร็จได้', (
    tester,
  ) async {
    final orders = InMemoryOrderRepository();
    await tester.pumpWidget(await cafeApp(orders: orders));
    await tester.pumpAndSettle();
    await addToCart(tester, 'ลาเต้');
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ตะกร้า'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('สั่งซื้อ · 65 บาท'));
    await tester.pumpAndSettle();
    expect(find.text('สั่งซื้อ T1 แล้ว'), findsOneWidget);
    await tester.tap(find.text('ตกลง'));
    await tester.pumpAndSettle();
    expect(orders.orders, hasLength(1));

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ประวัติคำสั่งซื้อ'));
    await tester.pumpAndSettle();
    expect(find.text('T1 · 65 บาท'), findsOneWidget);
    await tester.tap(find.text('T1 · 65 บาท'));
    await tester.pumpAndSettle();
    expect(find.textContaining('ใบเสร็จ T1'), findsOneWidget);
  });

  testWidgets('สั่งไม่สำเร็จ → SnackBar และตะกร้ายังอยู่', (tester) async {
    final orders = InMemoryOrderRepository()..fail = true;
    await tester.pumpWidget(await cafeApp(orders: orders));
    await tester.pumpAndSettle();
    await addToCart(tester, 'ลาเต้');
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ตะกร้า'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('สั่งซื้อ · 65 บาท'));
    await tester.pumpAndSettle();
    expect(find.text('สั่งซื้อไม่สำเร็จ กรุณาลองใหม่'), findsOneWidget);
    expect(find.text('ลาเต้ ×1'), findsOneWidget);
  });

  testWidgets('โหลดเมนูไม่สำเร็จ → ปุ่มลองอีกครั้ง', (tester) async {
    final menu = FakeMenuRepository(fail: true);
    await tester.pumpWidget(await cafeApp(menu: menu));
    await tester.pumpAndSettle();
    expect(find.text('โหลดเมนูไม่สำเร็จ'), findsOneWidget);
    menu.fail = false;
    await tester.tap(find.text('ลองอีกครั้ง'));
    await tester.pumpAndSettle();
    expect(find.text('ลาเต้'), findsOneWidget);
    expect(menu.calls, 2);
  });

  testWidgets('กดหัวใจในหน้าปรับแต่ง → แท็บรายการโปรด', (tester) async {
    final favorites = InMemoryFavoriteRepository();
    await tester.pumpWidget(await cafeApp(favorites: favorites));
    await tester.pumpAndSettle();
    await tester.tap(find.text('มอคค่า'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('รายการโปรด'));
    await tester.pump();
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(favorites.ids, {'mocha'});
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(Tab, 'รายการโปรด'));
    await tester.pumpAndSettle();
    expect(find.text('มอคค่า'), findsOneWidget);
    expect(find.text('ลาเต้'), findsNothing);
  });

  testWidgets('ค่าตั้งที่บันทึกไว้ถูกใช้ตอนเปิดแอป', (tester) async {
    await tester.pumpWidget(
      await cafeApp(prefs: {'theme_mode': 'dark', 'locale': 'en'}),
    );
    await tester.pumpAndSettle();
    expect(find.text('Latte'), findsOneWidget);
    final context = tester.element(find.text('Latte'));
    expect(Theme.of(context).brightness, Brightness.dark);
    expect(sampleMenu, isNotEmpty);
  });
}
