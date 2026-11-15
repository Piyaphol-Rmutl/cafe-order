import 'package:cafe_core/cafe_core.dart';
import 'package:cafe_order/demos/w05_gestures.dart';
import 'package:cafe_order/demos/w05_state_lifecycle.dart';
import 'package:cafe_order/main.dart';
import 'package:cafe_order/ui/customize/customize_page.dart';
import 'package:cafe_order/ui/customize/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

Widget _wrap(Widget child) => testApp(child);

/// เลื่อนรายการในฟอร์มจนเห็นแล้วจึงแตะ
Future<void> _tapInForm(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    100,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.tap(finder);
  await tester.pump();
}

void main() {
  final latte = sampleMenu.first;

  group('validators', () {
    test('ชื่อบนแก้ว', () {
      expect(validateCupName(''), 'กรุณากรอกชื่อบนแก้ว');
      expect(validateCupName('   '), 'กรุณากรอกชื่อบนแก้ว');
      expect(validateCupName('ก' * 21), isNotNull);
      expect(validateCupName('ต้น'), isNull);
    });

    test('หมายเหตุ', () {
      expect(validateNote(null), isNull);
      expect(validateNote('x' * 51), isNotNull);
    });
  });

  testWidgets('ราคาบนปุ่มเปลี่ยนตามขนาด ท็อปปิง และจำนวน', (tester) async {
    await tester.pumpWidget(_wrap(CustomizePage(item: latte)));
    expect(find.text('ใส่ตะกร้า · 65 บาท'), findsOneWidget); // 55 + M10

    await _tapInForm(tester, find.text('L +20'));
    expect(find.text('ใส่ตะกร้า · 75 บาท'), findsOneWidget);

    await _tapInForm(tester, find.text('เพิ่มช็อต'));
    await _tapInForm(tester, find.byTooltip('เพิ่มจำนวน'));
    expect(find.text('ใส่ตะกร้า · 180 บาท'), findsOneWidget); // (75+15)*2
  });

  testWidgets('ไม่กรอกชื่อ → แสดงข้อผิดพลาด, กรอกแล้ว → ส่ง OrderItem กลับ', (
    tester,
  ) async {
    OrderItem? result;
    await tester.pumpWidget(
      testApp(
        Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await Navigator.of(context).push<OrderItem>(
                MaterialPageRoute(builder: (_) => CustomizePage(item: latte)),
              );
            },
            child: const Text('เปิด'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('เปิด'));
    await tester.pumpAndSettle();

    final button = find.byType(FilledButton);
    await tester.tap(button);
    await tester.pumpAndSettle(); // รอเลื่อนไปที่ช่องชื่อ
    expect(find.text('กรุณากรอกชื่อบนแก้ว'), findsOneWidget);

    // ช่องชื่อได้โฟกัสและถูกเลื่อนขึ้นมาให้เห็นโดยไม่ต้องเลื่อนเอง
    final name = find.byType(TextFormField).first;
    final field = tester.widget<EditableText>(
      find.descendant(of: name, matching: find.byType(EditableText)),
    );
    expect(field.focusNode.hasFocus, isTrue);
    // ข้อความแจ้งอยู่ในจอ เหนือปุ่มด้านล่าง (ไม่ถูกบัง)
    expect(
      tester.getRect(find.text('กรุณากรอกชื่อบนแก้ว')).bottom,
      lessThanOrEqualTo(tester.getRect(button).top),
    );
    expect(
      tester.getRect(name).bottom,
      lessThan(tester.view.physicalSize.height / tester.view.devicePixelRatio),
    );
    await tester.enterText(name, 'ต้น');
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(find.byType(CustomizePage), findsNothing); // ปิดหน้าแล้ว
    expect(result?.cupName, 'ต้น');
    expect(result?.total, 65);
  });

  testWidgets('เบเกอรี่ไม่มีตัวเลือกขนาดแก้ว', (tester) async {
    await tester.pumpWidget(_wrap(CustomizePage(item: sampleMenu.last)));
    expect(find.text('ขนาดแก้ว'), findsNothing);
    expect(find.text('ใส่ตะกร้า · 35 บาท'), findsOneWidget);
  });

  testWidgets('แตะเมนู → หน้าปรับแต่ง, กดค้าง → คำอธิบาย', (tester) async {
    await tester.pumpWidget(const CafeOrderApp());
    final americano = find.text('อเมริกาโน');
    await tester.scrollUntilVisible(
      americano,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.longPress(americano);
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsOneWidget);
    // ปิดแผ่นด้านล่าง
    Navigator.of(tester.element(find.byType(BottomSheet))).pop();
    await tester.pumpAndSettle();

    await tester.tap(americano);
    await tester.pumpAndSettle();
    expect(find.byType(CustomizePage), findsOneWidget);
  });

  testWidgets('สาธิตวงจรชีวิต State เรียงลำดับถูกต้อง', (tester) async {
    await tester.pumpWidget(_wrap(const StateLifecycleDemo()));
    final state = tester.state(find.byType(StateLifecycleDemo)) as dynamic;
    final log = state.log as List<String>;
    expect(log.take(4).toList(), [
      '1 createState',
      '2 initState',
      '3 didChangeDependencies',
      '4 build (จิบไป 0)',
    ]);
    await tester.tap(find.text('เพิ่มช็อต (ส่งค่าใหม่ให้ลูก)'));
    await tester.pump();
    expect(log, contains('didUpdateWidget: 1 → 2 ช็อต'));
    await tester.tap(find.text('ถอดแก้วออก'));
    await tester.pump();
    expect(log.sublist(log.length - 2), ['deactivate', 'dispose']);
  });

  testWidgets('สาธิตท่าทาง: แตะสองครั้งและปัด', (tester) async {
    await tester.pumpWidget(_wrap(const GestureDemo()));
    final cup = find.byKey(const Key('cup'));
    await tester.tap(cup);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(cup);
    await tester.pumpAndSettle();
    expect(find.text('แตะสองครั้ง: ถูกใจ'), findsOneWidget);
    await tester.fling(cup, const Offset(200, 0), 1000);
    await tester.pumpAndSettle();
    expect(find.text('ปัดขวา: 2 ช็อต'), findsOneWidget);
  });
}
