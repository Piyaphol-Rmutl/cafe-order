import 'package:cafe_core/cafe_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'
    hide Order; // Order ชื่อซ้ำกับของ cafe_core

import '../services/auth_service.dart';
import 'live_order_repository.dart';
import 'order_repository.dart';

/// สัปดาห์ 12: คำสั่งซื้ออยู่ในคอลเลกชัน orders ของ Cloud Firestore
/// และยังเก็บสำเนาลงประวัติในเครื่อง (SQLite + ใบเสร็จ) เหมือนเดิม
class FirestoreOrderRepository implements OrderRepository, LiveOrderRepository {
  FirestoreOrderRepository(
    this._db,
    this._auth,
    this._local, {
    this.writeTimeout = const Duration(seconds: 10),
  });

  final Duration writeTimeout;

  final FirebaseFirestore _db;
  final AuthService _auth;
  final LocalOrderRepository _local;

  CollectionReference<Map<String, dynamic>> get _orders =>
      _db.collection('orders');

  static Order _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      Order.fromJson({...doc.data()!, 'id': doc.id});

  @override
  Future<Order> placeOrder(List<OrderItem> items) async {
    final user = _auth.currentUser!;
    // รหัสจากเวลาเต็มเป็นเลขฐาน 36 (ตัวอย่าง: CMI4K2Q1V) ไม่วนซ้ำเหมือนการตัดเศษ
    // ถ้าบังเอิญซ้ำในมิลลิวินาทีเดียวกัน set จะกลายเป็นการแก้เอกสารเดิม ซึ่งกฎไม่อนุญาต
    final id =
        'C${DateTime.now().millisecondsSinceEpoch.toRadixString(36).toUpperCase()}';
    final order = Order(id: id, items: items);
    // CREATE: เขียนเอกสารใหม่ (ฟิลด์ต้องตรงกับที่ firestore.rules อนุญาต)
    // set รอให้เซิร์ฟเวอร์ยืนยัน ถ้าเครือข่าย/บัญชีมีปัญหาอาจรอไม่สิ้นสุด
    // จึงกำหนดเวลา เกินแล้วถือว่าไม่สำเร็จ (CartViewModel แสดงข้อผิดพลาด)
    await _orders
        .doc(id)
        .set({
          ...order.toJson()..remove('id'),
          'uid': user.uid,
          'customer': user.name,
        })
        .timeout(writeTimeout);
    await _local.save(order);
    return order;
  }

  // READ แบบเรียลไทม์: snapshots() คืน Stream ที่ส่งค่าใหม่ทุกครั้งที่ข้อมูลเปลี่ยน
  @override
  Stream<Order?> watchOrder(String id) => _orders
      .doc(id)
      .snapshots()
      .map((doc) => doc.exists ? _fromDoc(doc) : null);

  @override
  Stream<List<Order>> watchActive() => _orders
      .where('status', whereIn: ['received', 'preparing', 'ready'])
      .snapshots()
      .map(
        (snap) =>
            [for (final d in snap.docs) _fromDoc(d)]
              ..sort((a, b) => a.createdAt.compareTo(b.createdAt)),
      );

  // UPDATE: เปลี่ยนเฉพาะฟิลด์ status
  @override
  Future<void> updateStatus(String id, OrderStatus status) =>
      _orders.doc(id).update({'status': status.name});

  @override
  Future<List<Order>> history() => _local.history();

  @override
  Future<String?> receipt(String orderId) => _local.receipt(orderId);
}
