/// ขนาดแก้วและราคาที่บวกเพิ่ม
enum CupSize {
  small('S', 0),
  medium('M', 10),
  large('L', 20);

  const CupSize(this.label, this.extra);
  final String label;
  final int extra;
}

/// ระดับความหวาน (เปอร์เซ็นต์)
enum Sweetness {
  none(0),
  less(50),
  normal(100),
  extra(120);

  const Sweetness(this.percent);
  final int percent;

  String get label => '$percent%';
}

/// ท็อปปิง (เพิ่มได้หลายอย่าง จึงเก็บเป็น Set ใน OrderItem)
class Topping {
  const Topping(this.id, this.name, this.price);
  final String id;
  final String name;
  final int price;

  @override
  bool operator ==(Object other) => other is Topping && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

const List<Topping> allToppings = [
  Topping('shot', 'เพิ่มช็อต', 15),
  Topping('whip', 'วิปครีม', 10),
  Topping('pearl', 'ไข่มุก', 10),
  Topping('oat', 'นมโอ๊ต', 20),
];
