import 'package:cafe_core/cafe_core.dart';

// รันด้วย: dart run example/cafe_core_example.dart
Future<void> main() async {
  // 1) คอลเลกชัน: จัดกลุ่มเมนูตามหมวด
  final groups = groupByCategory(sampleMenu);
  groups.forEach((category, items) {
    final names = items.map((m) => m.name).join(', ');
    print('${category.label}: $names');
  });

  // 2) คลาสและพารามิเตอร์แบบระบุชื่อ
  final latte = sampleMenu.firstWhere((m) => m.id == 'latte');
  final order = Order(id: 'A001', items: [
    OrderItem(item: latte, size: CupSize.large, toppings: {allToppings[0]}),
    OrderItem(item: sampleMenu.last, quantity: 2),
  ]);
  final (:cups, :total) = order.summary; // แยก Record ออกเป็นตัวแปร
  print('คำสั่งซื้อ ${order.id}: $cups ชิ้น รวม ${order.priceText}');

  // 3) การสืบทอด: โปรโมชันหลายแบบใช้ผ่านชนิดแม่ Promotion
  const promotions = <Promotion>[
    PercentOff(10),
    CupsDiscount(minCups: 3, amount: 20),
  ];
  for (final p in promotions) {
    print('${p.title}: จ่าย ${p.applyTo(order)} บาท (จาก $total)');
  }

  // 4) Stream: ติดตามสถานะคำสั่งซื้อ
  await for (final status in simulateOrderProgress(
    step: const Duration(milliseconds: 500),
  )) {
    print('สถานะ: ${status.label}');
  }
}
