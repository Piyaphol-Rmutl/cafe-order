import 'order_item.dart';
import 'priced.dart';

/// สถานะคำสั่งซื้อ (บาริสต้าเปลี่ยนตามลำดับ)
enum OrderStatus {
  received('รับคำสั่งซื้อแล้ว'),
  preparing('กำลังชง'),
  ready('พร้อมรับ'),
  completed('รับแล้ว');

  const OrderStatus(this.label);
  final String label;

  /// สถานะถัดไป (สถานะสุดท้ายคืน null)
  OrderStatus? get next => index + 1 < values.length ? values[index + 1] : null;
}

class Order with Priced {
  Order({
    required this.id,
    required this.items,
    this.status = OrderStatus.received,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String id;
  final List<OrderItem> items;
  final OrderStatus status;
  final DateTime createdAt;

  @override
  int get total => items.fold(0, (sum, i) => sum + i.total);

  /// คืนค่าสองค่าพร้อมกันด้วย Record
  ({int cups, int total}) get summary =>
      (cups: items.fold(0, (sum, i) => sum + i.quantity), total: total);

  Order copyWith({OrderStatus? status}) => Order(
    id: id,
    items: items,
    status: status ?? this.status,
    createdAt: createdAt,
  );
}
