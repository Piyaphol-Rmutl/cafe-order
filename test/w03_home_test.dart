import 'package:cafe_order/main.dart';
import 'package:cafe_order/ui/home/info_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('หน้าแรกมีโลโก้ ชื่อร้าน InfoRow และเมนูแนะนำ', (tester) async {
    await tester.pumpWidget(const CafeOrderApp());

    final logo = find.byType(Image);
    expect(logo, findsOneWidget);
    final image = tester.widget<Image>(logo).image as AssetImage;
    expect(image.assetName, 'assets/images/logo.png');

    expect(find.text('ร้านกาแฟคณะวิศวกรรมศาสตร์'), findsOneWidget);
    expect(find.byType(InfoRow), findsNWidgets(3));
    expect(find.byIcon(Icons.schedule), findsOneWidget);
    expect(find.text('เมนูแนะนำ: ลาเต้'), findsOneWidget);
    expect(find.text('55 บาท'), findsOneWidget);
  });
}
