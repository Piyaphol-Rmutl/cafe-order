import 'dart:convert';

import 'package:cafe_core/cafe_core.dart';
import 'package:intl/intl.dart';

import '../services/database_service.dart';
import '../services/file_service.dart';

/// Repository ของคำสั่งซื้อ: แหล่งข้อมูลจริงเพียงแหล่งเดียว (Single Source of Truth)
abstract interface class OrderRepository {
  Future<Order> placeOrder(List<OrderItem> items);
  Future<List<Order>> history();
  Future<String?> receipt(String orderId);
}

/// สัปดาห์ 10: บันทึกคำสั่งซื้อลง SQLite และเขียนใบเสร็จเป็นไฟล์ข้อความ
class LocalOrderRepository implements OrderRepository {
  LocalOrderRepository(this._db, this._files);

  final DatabaseService _db;
  final FileService _files;

  @override
  Future<Order> placeOrder(List<OrderItem> items) async {
    final number = await _db.maxOrderNumber() + 1;
    final order = Order(
      id: 'A${number.toString().padLeft(3, '0')}',
      items: items,
    );
    // เขียนใบเสร็จก่อนบันทึกแถว ถ้าเขียนไฟล์ไม่สำเร็จจะไม่มีคำสั่งซื้อที่ไม่มีใบเสร็จค้างในประวัติ
    await _files.writeText('receipts/${order.id}.txt', formatReceipt(order));
    await _db.insertOrder(toRow(order));
    return order;
  }

  @override
  Future<List<Order>> history() async => [
    for (final row in await _db.queryOrders()) fromRow(row),
  ];

  @override
  Future<String?> receipt(String orderId) =>
      _files.readText('receipts/$orderId.txt');

  /// แปลง Order ↔ แถวของตาราง orders
  static Map<String, Object?> toRow(Order order) => {
    'id': order.id,
    'created_at': order.createdAt.millisecondsSinceEpoch,
    'status': order.status.name,
    'total': order.total,
    'items': jsonEncode([for (final i in order.items) i.toJson()]),
  };

  static Order fromRow(Map<String, Object?> row) => Order(
    id: row['id'] as String,
    createdAt: DateTime.fromMillisecondsSinceEpoch(row['created_at'] as int),
    status: OrderStatus.values.byName(row['status'] as String),
    items: [
      for (final i in jsonDecode(row['items'] as String) as List<dynamic>)
        OrderItem.fromJson(i as Map<String, dynamic>),
    ],
  );
}

/// ข้อความใบเสร็จ
String formatReceipt(Order order) {
  final lines = [
    'Café Order — ใบเสร็จ ${order.id}',
    DateFormat('d/M/yyyy HH:mm').format(order.createdAt),
    for (final i in order.items)
      '${i.item.name} ${i.summary} ×${i.quantity} = ${i.total}',
    'รวม ${order.total} บาท',
  ];
  return lines.join('\n');
}
