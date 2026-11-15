import 'package:cafe_core/cafe_core.dart';
import 'package:cafe_order/demos/w07_animation.dart';
import 'package:cafe_order/demos/w07_cupertino.dart';
import 'package:cafe_order/main.dart';
import 'package:cafe_order/ui/customize/customize_page.dart';
import 'package:cafe_order/ui/menu/menu_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

Future<void> openSettings(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.menu));
  await tester.pumpAndSettle();
  await tester.tap(find.byIcon(Icons.settings));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('สลับโหมดมืดจากหน้าตั้งค่า', (tester) async {
    await tester.pumpWidget(const CafeOrderApp());
    await openSettings(tester);
    BuildContext ctx() => tester.element(find.byType(SwitchListTile));
    expect(Theme.of(ctx()).brightness, Brightness.light);
    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();
    expect(Theme.of(ctx()).brightness, Brightness.dark);
  });

  testWidgets('เปลี่ยนภาษาเป็นอังกฤษ ข้อความและชื่อเมนูเปลี่ยน', (
    tester,
  ) async {
    await tester.pumpWidget(const CafeOrderApp());
    await openSettings(tester);
    await tester.tap(find.text('EN'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Latte'), findsOneWidget);
    expect(find.text('฿55'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
  });

  testWidgets('Semantics ของการ์ดเมนูอ่านเป็นปุ่มเดียว', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      testApp(
        Scaffold(
          body: MenuTile(item: sampleMenu.first, onTap: () {}),
        ),
      ),
    );
    expect(
      tester.getSemantics(find.byType(MenuTile)),
      matchesSemantics(
        label: 'ลาเต้ ราคา 55 บาท',
        isButton: true,
        hasTapAction: true,
      ),
    );
    handle.dispose();
  });

  testWidgets('ตัวอักษรขนาด 2 เท่า การ์ดเมนูไม่ล้น', (tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: testApp(Scaffold(body: MenuTile(item: sampleMenu.first))),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Hero: รูปเมนูมี tag เดียวกันในรายการและหน้าปรับแต่ง', (
    tester,
  ) async {
    await tester.pumpWidget(const CafeOrderApp());
    expect(
      find.byWidgetPredicate((w) => w is Hero && w.tag == 'menu-latte'),
      findsOneWidget,
    );
    await tester.tap(find.text('ลาเต้'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100)); // กลางเที่ยวบิน
    await tester.pumpAndSettle();
    final hero = find.descendant(
      of: find.byType(CustomizePage),
      matching: find.byWidgetPredicate(
        (w) => w is Hero && w.tag == 'menu-latte',
      ),
    );
    expect(hero, findsOneWidget);
  });

  testWidgets('AnimatedContainer ของแก้วสูงขึ้นเมื่อเลือกขนาด L', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(CustomizePage(item: sampleMenu.first)));
    double cupHeight() => tester
        .getSize(
          find.descendant(
            of: find.byType(CupPreview),
            matching: find.byType(AnimatedContainer),
          ),
        )
        .height;
    final before = cupHeight();
    await tester.tap(find.text('L +20'));
    await tester.pump(); // เฟรมแรก: เริ่มแอนิเมชัน
    await tester.pump(const Duration(milliseconds: 100));
    final middle = cupHeight();
    await tester.pumpAndSettle();
    expect(middle, greaterThan(before));
    expect(cupHeight(), 60 + 2 * 25);
  });

  testWidgets('AnimatedOpacity แสดงคำแนะนำเมื่อหวานน้อย', (tester) async {
    await tester.pumpWidget(testApp(CustomizePage(item: sampleMenu.first)));
    AnimatedOpacity hint() => tester.widget<AnimatedOpacity>(
      find.ancestor(
        of: find.text('หวานน้อย ดีต่อสุขภาพ'),
        matching: find.byType(AnimatedOpacity),
      ),
    );
    expect(hint().opacity, 0);
    await tester.tap(find.text('50%'));
    await tester.pumpAndSettle();
    expect(hint().opacity, 1);
  });

  testWidgets('สาธิต AnimationController: หยุดแล้วค่าไม่เปลี่ยน', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(const AnimationDemo()));
    await tester.tap(find.text('เล่นวน'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text('หยุด'));
    await tester.pump();
    final text = find.textContaining('value =');
    final v1 = tester.widget<Text>(text).data;
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.widget<Text>(text).data, v1);
    expect(v1, isNot('value = 0.00'));
  });

  testWidgets('สาธิต Cupertino', (tester) async {
    await tester.pumpWidget(testApp(const CupertinoDemo()));
    // ข้อความใน segmented control ต้องได้สไตล์ปกติ ไม่ใช่สไตล์เตือนของ WidgetsApp
    // (ตัวแดงขีดเส้นใต้เหลือง เมื่อไม่มี DefaultTextStyle)
    final style = DefaultTextStyle.of(tester.element(find.text('S'))).style;
    expect(style.decoration, isNot(TextDecoration.underline));
    await tester.tap(find.text('L'));
    await tester.pumpAndSettle();
    expect(find.text('สั่ง L เย็น'), findsOneWidget);
  });
}
