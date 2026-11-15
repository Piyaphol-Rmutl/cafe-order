import 'menu_item.dart';

/// ผลการแนะนำเมนูพร้อมเหตุผล (อธิบายได้ว่าทำไมจึงแนะนำ)
class Recommendation {
  const Recommendation(this.item, this.reason);

  final MenuItem item;
  final String reason;

  Map<String, dynamic> toJson() => {'item': item.toJson(), 'reason': reason};

  factory Recommendation.fromJson(Map<String, dynamic> json) => Recommendation(
    MenuItem.fromJson(json['item'] as Map<String, dynamic>),
    json['reason'] as String,
  );
}

/// ตัวแนะนำแบบกฎ (ใช้แทนโมเดล AI ในการสาธิตและทดสอบ ผลคาดเดาได้)
Recommendation recommendByRules({
  required List<MenuItem> menu,
  required int hour,
  Map<String, int> orderCounts = const {},
  Set<String> favorites = const {},
}) {
  MenuItem? find(String id) => menu.where((m) => m.id == id).firstOrNull;

  // 1) เมนูที่สั่งบ่อยที่สุด (อย่างน้อย 2 ครั้ง)
  final often = orderCounts.entries.where((e) => e.value >= 2).toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  if (often.isNotEmpty) {
    final item = find(often.first.key);
    if (item != null) {
      return Recommendation(item, 'คุณสั่ง${item.name}บ่อยที่สุด');
    }
  }
  // 2) รายการโปรด
  for (final id in favorites) {
    if (find(id) case final item?) {
      return Recommendation(item, '${item.name}อยู่ในรายการโปรดของคุณ');
    }
  }
  // 3) ตามช่วงเวลา
  final (category, reason) = switch (hour) {
    < 11 => (MenuCategory.coffee, 'ช่วงเช้า กาแฟช่วยให้ตื่นตัว'),
    < 16 => (MenuCategory.soda, 'ช่วงบ่ายอากาศร้อน ลองเครื่องดื่มเย็นซ่า'),
    _ => (MenuCategory.tea, 'ช่วงเย็น เลือกเครื่องดื่มที่ไม่มีกาแฟ'),
  };
  final pick = menu.where((m) => m.category == category).firstOrNull;
  return pick == null
      ? Recommendation(menu.first, 'เมนูขายดีของร้าน')
      : Recommendation(pick, reason);
}
