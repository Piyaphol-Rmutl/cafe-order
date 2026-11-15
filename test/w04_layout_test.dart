import 'package:cafe_core/cafe_core.dart';
import 'package:cafe_order/demos/w04_layout.dart';
import 'package:cafe_order/main.dart';
import 'package:cafe_order/ui/menu/menu_card.dart';
import 'package:cafe_order/ui/menu/menu_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ListView.builder สร้างแถวเมนูเมื่อเลื่อนถึง', (tester) async {
    await tester.pumpWidget(const CafeOrderApp());
    final list = find
        .descendant(
          of: find.byType(MenuList),
          matching: find.byType(Scrollable),
        )
        .first;
    await tester.scrollUntilVisible(
      find.text('ครัวซองต์เนยสด'),
      300,
      scrollable: list,
    );
    expect(find.text('ครัวซองต์เนยสด'), findsOneWidget);
    expect(find.text('35 บาท'), findsOneWidget);
  });

  testWidgets('MenuTile ข้อความยาวไม่ล้นในจอแคบ', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: MenuTile(item: sampleMenu.first)),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('BrokenMenuRow ล้น แต่ FixedMenuRow ไม่ล้น', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: BrokenMenuRow(item: sampleMenu.first)),
      ),
    );
    expect(tester.takeException(), isFlutterError);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: FixedMenuRow(item: sampleMenu.first)),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('MenuGrid แสดงการ์ดพร้อมป้ายหมวด (Stack)', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: MenuGrid(menu: sampleMenu)),
      ),
    );
    expect(find.byType(MenuGridCard), findsWidgets);
    expect(find.text('กาแฟ'), findsWidgets);
  });
}
