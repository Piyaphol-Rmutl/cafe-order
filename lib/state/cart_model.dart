import 'package:cafe_core/cafe_core.dart';
import 'package:flutter/foundation.dart';

/// สถานะของแอป (App State): ตะกร้าที่หลายหน้าใช้ร่วมกัน
/// แก้ข้อมูลผ่านเมธอดเท่านั้น แล้วเรียก notifyListeners() ให้ผู้ฟังสร้าง UI ใหม่
class CartModel extends ChangeNotifier {
  final List<OrderItem> _items = [];

  /// ภายนอกอ่านได้อย่างเดียว (แก้ตรง ๆ ไม่ได้ จึงไม่ลืมแจ้งผู้ฟัง)
  List<OrderItem> get items => List.unmodifiable(_items);

  /// จำนวนแก้วทั้งหมด (ใช้แสดงบน badge)
  int get count => _items.fold(0, (sum, i) => sum + i.quantity);

  int get total => _items.fold(0, (sum, i) => sum + i.total);

  bool get isEmpty => _items.isEmpty;

  void add(OrderItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeAt(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  /// เปลี่ยนจำนวน ถ้าเหลือ 0 ให้ลบออก
  void setQuantity(int index, int quantity) {
    if (quantity <= 0) {
      _items.removeAt(index);
    } else {
      _items[index] = _items[index].copyWith(quantity: quantity);
    }
    notifyListeners();
  }

  /// ยืนยันคำสั่งซื้อ: สร้าง Order จากตะกร้าแล้วล้างตะกร้า
  Order checkout() {
    final order = Order(
      id: 'A${DateTime.now().millisecondsSinceEpoch % 10000}',
      items: [..._items],
    );
    _items.clear();
    notifyListeners();
    return order;
  }
}
