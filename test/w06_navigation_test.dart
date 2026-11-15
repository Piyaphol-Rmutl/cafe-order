import 'package:cafe_order/demos/w06_navigator.dart';
import 'package:cafe_order/main.dart';
import 'package:cafe_order/router.dart';
import 'package:cafe_order/ui/customize/customize_page.dart';
import 'package:cafe_order/ui/menu/menu_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

/// เปิดเมนู กรอกชื่อ แล้วใส่ตะกร้า (ใช้ซ้ำหลายเทสต์)
Future<void> addToCart(WidgetTester tester, String menuName) async {
  await tester.tap(find.text(menuName).first);
  await tester.pumpAndSettle();
  final name = find.byType(TextFormField).first;
  await tester.ensureVisible(name);
  await tester.enterText(name, 'ต้น');
  await tester.tap(find.byType(FilledButton));
  await tester.pumpAndSettle();
}

void setSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('เมนู → ปรับแต่ง → pop ผลลัพธ์ → ตะกร้า → สั่งซื้อ', (
    tester,
  ) async {
    await tester.pumpWidget(const CafeOrderApp());
    await addToCart(tester, 'ลาเต้');
    expect(find.text('เพิ่ม ลาเต้ ลงตะกร้าแล้ว'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5)); // รอ SnackBar หายไป
    await tester.pumpAndSettle();

    await tester.tap(find.text('ตะกร้า'));
    await tester.pumpAndSettle();
    expect(find.text('ลาเต้ ×1'), findsOneWidget);
    expect(find.text('สั่งซื้อ · 65 บาท'), findsOneWidget);

    await tester.tap(find.text('สั่งซื้อ · 65 บาท'));
    await tester.pumpAndSettle();
    expect(find.textContaining('รวม 65 บาท'), findsOneWidget);
    await tester.tap(find.text('ตกลง'));
    await tester.pumpAndSettle();
    expect(find.byType(MenuTile), findsWidgets); // กลับมาหน้าเมนู
  });

  testWidgets('ลบรายการในตะกร้า', (tester) async {
    await tester.pumpWidget(const CafeOrderApp());
    await addToCart(tester, 'ลาเต้');
    await tester.tap(find.text('ตะกร้า'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('ลบ ลาเต้'));
    await tester.pump();
    expect(find.text('ตะกร้ายังว่าง'), findsOneWidget);
  });

  testWidgets('TabBar กรองตามหมวด', (tester) async {
    await tester.pumpWidget(const CafeOrderApp());
    final tab = find.widgetWithText(Tab, 'เบเกอรี่');
    await tester.ensureVisible(tab); // TabBar เลื่อนได้ แท็บท้ายอาจอยู่นอกจอ
    await tester.pumpAndSettle();
    await tester.tap(tab);
    await tester.pumpAndSettle();
    expect(find.text('ครัวซองต์เนยสด'), findsOneWidget);
    expect(find.text('ลาเต้'), findsNothing);
  });

  testWidgets('เส้นทางที่ไม่มีเมนู → หน้าไม่พบ', (tester) async {
    await tester.pumpWidget(const CafeOrderApp(initialLocation: '/menu/xyz'));
    await tester.pumpAndSettle();
    expect(find.byType(NotFoundPage), findsOneWidget);
  });

  testWidgets('จอแคบ: NavigationBar + รายการ', (tester) async {
    setSize(tester, const Size(400, 800));
    await tester.pumpWidget(const CafeOrderApp());
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(MenuTile), findsWidgets);
  });

  testWidgets('จอกว้าง: NavigationRail + กริด + บานปรับแต่ง (สองบาน)', (
    tester,
  ) async {
    setSize(tester, const Size(1280, 800));
    await tester.pumpWidget(const CafeOrderApp());
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(MenuGridCard), findsWidgets);
    expect(find.byType(CustomizePage), findsOneWidget);

    await tester.tap(find.text('อเมริกาโน'));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byType(CustomizePage),
        matching: find.text('อเมริกาโน'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Drawer เปิดได้', (tester) async {
    await tester.pumpWidget(const CafeOrderApp());
    await tester.tap(
      find.byIcon(Icons.menu),
    ); // tooltip เป็นภาษาไทยตั้งแต่สัปดาห์ 7
    await tester.pumpAndSettle();
    expect(find.byType(Drawer), findsOneWidget);
  });

  testWidgets('สาธิต Navigator: push แล้วรับผลจาก pop', (tester) async {
    await tester.pumpWidget(testApp(NavigatorDemo()));
    await tester.tap(find.text('เลือกขนาดแก้ว'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ขนาด L'));
    await tester.pumpAndSettle();
    expect(find.text('เลือกขนาด L'), findsOneWidget);
  });
}
