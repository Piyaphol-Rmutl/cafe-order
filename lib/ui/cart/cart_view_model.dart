import 'package:cafe_core/cafe_core.dart';
import 'package:flutter/foundation.dart';

import '../../data/repositories/order_repository.dart';

/// ViewModel ของตะกร้า (ย้ายมาจาก CartModel ของสัปดาห์ 8)
/// เพิ่ม: สั่งซื้อผ่าน OrderRepository และสถานะ "กำลังส่ง" / ข้อผิดพลาด
class CartViewModel extends ChangeNotifier {
  CartViewModel(this._orders);

  final OrderRepository _orders;
  final List<OrderItem> _items = [];
  bool _placing = false;
  Object? _error;

  List<OrderItem> get items => List.unmodifiable(_items);
  int get count => _items.fold(0, (sum, i) => sum + i.quantity);
  int get total => _items.fold(0, (sum, i) => sum + i.total);
  bool get isEmpty => _items.isEmpty;
  bool get placing => _placing;
  Object? get error => _error;

  void add(OrderItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeAt(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void setQuantity(int index, int quantity) {
    if (quantity <= 0) {
      _items.removeAt(index);
    } else {
      _items[index] = _items[index].copyWith(quantity: quantity);
    }
    notifyListeners();
  }

  /// ส่งคำสั่งซื้อ: สำเร็จคืน Order และล้างตะกร้า, ล้มเหลวคืน null และเก็บ error
  Future<Order?> checkout() async {
    if (_items.isEmpty || _placing) return null;
    _placing = true;
    _error = null;
    notifyListeners();
    try {
      final order = await _orders.placeOrder([..._items]);
      _items.clear();
      return order;
    } catch (e) {
      _error = e;
      return null;
    } finally {
      _placing = false;
      notifyListeners();
    }
  }
}
