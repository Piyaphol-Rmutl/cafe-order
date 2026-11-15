// Integration Test ทั้งแอปบนเครื่องจำลอง ใช้ Repository ปลอม (ไม่ต้องมีเซิร์ฟเวอร์/Firebase)
// รัน: flutter test integration_test/app_test.dart -d <เครื่องจำลอง>
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/fakes.dart';
import '../test/helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('ล็อกอิน → เลือกเมนู → ใส่ตะกร้า → สั่งซื้อ → ติดตามสถานะ', (
    tester,
  ) async {
    final live = InMemoryLiveOrders();
    await tester.pumpWidget(
      await cafeApp(auth: FakeAuthService(null), live: live),
    );
    await tester.pumpAndSettle();

    // 1) ล็อกอิน
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'ton@student.test');
    await tester.enterText(fields.at(1), 'secret123');
    await tester.tap(find.widgetWithText(FilledButton, 'เข้าสู่ระบบ'));
    await tester.pumpAndSettle();

    // 2) ปรับแต่งลาเต้ ขนาด L
    await tester.tap(find.text('ลาเต้'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('L +20'));
    final name = find.byType(TextFormField).first;
    await tester.ensureVisible(name);
    await tester.enterText(name, 'ต้น');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    // 3) ตะกร้า → สั่งซื้อ
    await tester.tap(find.text('ตะกร้า'));
    await tester.pumpAndSettle();
    expect(find.text('ลาเต้ ×1'), findsOneWidget);
    await tester.tap(find.text('สั่งซื้อ · 75 บาท'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ตกลง'));
    await tester.pumpAndSettle();

    // 4) หน้าสถานะ: บาริสต้าเปลี่ยนเป็นพร้อมรับ
    expect(find.text('สถานะคำสั่งซื้อ T1'), findsOneWidget);
    await live.updateStatus('T1', live.orders.single.status.next!.next!);
    await tester.pumpAndSettle();
    final selected = find.byWidgetPredicate((w) => w is ListTile && w.selected);
    expect(
      find.descendant(of: selected, matching: find.text('พร้อมรับ')),
      findsOneWidget,
    );
  });
}
