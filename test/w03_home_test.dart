import 'package:cafe_order/ui/shop/info_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  testWidgets('หน้าแรกมีโลโก้ ชื่อร้าน InfoRow และเมนูแนะนำ', (tester) async {
    // สัปดาห์ 6 ย้ายหน้าร้านไปอยู่แท็บ /shop
    await tester.pumpWidget(cafeApp(initialLocation: '/shop'));

    final logo = find.byWidgetPredicate(
      (w) =>
          w is Image &&
          w.image is AssetImage &&
          (w.image as AssetImage).assetName == 'assets/images/logo.png',
    );
    expect(logo, findsOneWidget);

    expect(find.text('ร้านกาแฟคณะวิศวกรรมศาสตร์'), findsOneWidget);
    expect(find.byType(InfoRow), findsNWidgets(3));
    expect(find.byIcon(Icons.schedule), findsOneWidget);
    expect(find.text('เมนูแนะนำ: ลาเต้'), findsOneWidget);
    // แท็บร้านมีแถบหัวเดียว (SliverAppBar.large) ไม่ซ้อนกับแถบหัวของเชลล์
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Café Order'), findsNothing);
  });
}
