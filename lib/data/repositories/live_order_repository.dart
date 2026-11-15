import 'package:cafe_core/cafe_core.dart';

/// คำสั่งซื้อแบบเรียลไทม์ (สัปดาห์ 12): ลูกค้าติดตามสถานะ บาริสต้าเปลี่ยนสถานะ
abstract interface class LiveOrderRepository {
  /// ส่งค่าใหม่ทุกครั้งที่เอกสารเปลี่ยน (null = ไม่พบ/ไม่มีสิทธิ์อ่าน)
  Stream<Order?> watchOrder(String id);

  /// คำสั่งซื้อที่ยังไม่เสร็จ เรียงจากเก่าไปใหม่ (หน้าบาริสต้า)
  Stream<List<Order>> watchActive();

  Future<void> updateStatus(String id, OrderStatus status);
}
