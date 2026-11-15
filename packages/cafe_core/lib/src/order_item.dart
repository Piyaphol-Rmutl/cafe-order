import 'menu_item.dart';
import 'options.dart';
import 'priced.dart';

/// รายการในตะกร้า: เมนู + ตัวเลือกที่ลูกค้าปรับแต่ง
class OrderItem with Priced {
  OrderItem({
    required this.item,
    this.size = CupSize.medium,
    this.sweetness = Sweetness.normal,
    Set<Topping>? toppings,
    this.quantity = 1,
    this.note,
    this.cupName,
  }) : toppings = toppings ?? {},
       assert(quantity > 0, 'จำนวนต้องมากกว่า 0');

  final MenuItem item;
  final CupSize size;
  final Sweetness sweetness;
  final Set<Topping> toppings;
  final int quantity;
  final String? note;
  final String? cupName; // ชื่อที่เขียนบนแก้ว

  /// ราคาต่อแก้ว = ราคาเมนู + ขนาด + ท็อปปิงทั้งหมด (ใช้ fold รวมค่า)
  int get unitPrice {
    final sizeExtra = item.isDrink ? size.extra : 0;
    final toppingSum = toppings.fold(0, (sum, t) => sum + t.price);
    return item.price + sizeExtra + toppingSum;
  }

  @override
  int get total => unitPrice * quantity;

  /// คำอธิบายสั้น เช่น "L · หวาน 50% · เพิ่มช็อต"
  String get summary => [
    if (item.isDrink) size.label,
    if (item.isDrink) 'หวาน ${sweetness.label}',
    ...toppings.map((t) => t.name),
  ].join(' · ');

  OrderItem copyWith({int? quantity}) => OrderItem(
    item: item,
    size: size,
    sweetness: sweetness,
    toppings: toppings,
    quantity: quantity ?? this.quantity,
    note: note,
    cupName: cupName,
  );

  Map<String, dynamic> toJson() => {
    'menuId': item.id,
    'name': item.name,
    'size': size.name,
    'sweetness': sweetness.name,
    'toppings': [for (final t in toppings) t.id],
    'quantity': quantity,
    'note': note,
    'cupName': cupName,
    'unitPrice': unitPrice,
  };
}
