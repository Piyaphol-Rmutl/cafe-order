import 'package:cafe_order/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('หน้าแรกแสดงชื่อแอป', (tester) async {
    await tester.pumpWidget(const CafeOrderApp());
    expect(find.text('Café Order'), findsOneWidget);
  });

  testWidgets('เมนูผู้พัฒนา → สาธิตวงจรชีวิตบันทึกสถานะ', (tester) async {
    await tester.pumpWidget(const CafeOrderApp());
    await tester.tap(find.byTooltip('เมนูผู้พัฒนา'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('วงจรชีวิตของแอป'));
    await tester.pumpAndSettle();

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();
    expect(find.text('paused'), findsOneWidget);
    expect(find.text('inactive'), findsOneWidget);
  });

  testWidgets('สาธิต Hot Reload: กดปุ่มแล้วตัวเลขเพิ่ม', (tester) async {
    await tester.pumpWidget(const CafeOrderApp());
    await tester.tap(find.byTooltip('เมนูผู้พัฒนา'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hot Reload กับสถานะ'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    expect(find.text('ชงไปแล้ว 1 แก้ว'), findsOneWidget);
  });
}
