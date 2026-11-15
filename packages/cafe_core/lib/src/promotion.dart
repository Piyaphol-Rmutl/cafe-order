import 'order.dart';

/// โปรโมชันแบบนามธรรม: คลาสลูกต้องกำหนดวิธีคิดส่วนลดเอง
abstract class Promotion {
  const Promotion(this.title);
  final String title;

  int discountFor(Order order);

  /// ยอดสุทธิไม่ติดลบ
  int applyTo(Order order) =>
      (order.total - discountFor(order)).clamp(0, order.total);
}

/// ลดเป็นเปอร์เซ็นต์ (สืบทอดจาก Promotion)
class PercentOff extends Promotion {
  const PercentOff(this.percent) : super('ลด $percent%');
  final int percent;

  @override
  int discountFor(Order order) => order.total * percent ~/ 100;
}

/// ซื้อครบ N แก้ว ลดตามจำนวนเงินที่กำหนด
class CupsDiscount extends Promotion {
  const CupsDiscount({required this.minCups, required this.amount})
      : super('ครบ $minCups แก้ว ลด $amount บาท');
  final int minCups;
  final int amount;

  @override
  int discountFor(Order order) =>
      order.summary.cups >= minCups ? amount : 0;
}
