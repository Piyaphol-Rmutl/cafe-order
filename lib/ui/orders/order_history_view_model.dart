import 'package:cafe_core/cafe_core.dart';
import 'package:flutter/foundation.dart';

import '../../data/repositories/order_repository.dart';

/// ViewModel ของหน้าประวัติคำสั่งซื้อ
class OrderHistoryViewModel extends ChangeNotifier {
  OrderHistoryViewModel(this._orders);

  final OrderRepository _orders;
  List<Order> _history = [];
  bool _loading = false;
  Object? _error;

  List<Order> get history => _history;
  bool get loading => _loading;

  /// ข้อผิดพลาดล่าสุดจากการโหลด (null = ไม่มี)
  Object? get error => _error;

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _history = await _orders.history();
    } catch (e) {
      _error = e; // อ่านฐานข้อมูลไม่สำเร็จ: ไม่ค้างที่สถานะกำลังโหลด
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<String?> receipt(String id) => _orders.receipt(id);
}
