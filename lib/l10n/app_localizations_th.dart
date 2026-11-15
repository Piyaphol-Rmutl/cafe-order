// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'Café Order';

  @override
  String get tabMenu => 'เมนู';

  @override
  String get tabCart => 'ตะกร้า';

  @override
  String get tabShop => 'ร้าน';

  @override
  String get settings => 'ตั้งค่า';

  @override
  String get darkMode => 'โหมดมืด';

  @override
  String get language => 'ภาษา';

  @override
  String get allCategories => 'ทั้งหมด';

  @override
  String price(int price) {
    return '$price บาท';
  }

  @override
  String get cupSize => 'ขนาดแก้ว';

  @override
  String get sweetness => 'ความหวาน';

  @override
  String get toppings => 'ท็อปปิง';

  @override
  String get quantity => 'จำนวน';

  @override
  String get cupName => 'ชื่อบนแก้ว *';

  @override
  String get note => 'หมายเหตุถึงบาริสต้า';

  @override
  String get lessSugarHint => 'หวานน้อย ดีต่อสุขภาพ';

  @override
  String addToCart(int price) {
    return 'ใส่ตะกร้า · $price บาท';
  }

  @override
  String addedToCart(String name) {
    return 'เพิ่ม $name ลงตะกร้าแล้ว';
  }

  @override
  String get cartEmpty => 'ตะกร้ายังว่าง';

  @override
  String removeItem(String name) {
    return 'ลบ $name';
  }

  @override
  String checkout(int price) {
    return 'สั่งซื้อ · $price บาท';
  }

  @override
  String orderPlaced(String id) {
    return 'สั่งซื้อ $id แล้ว';
  }

  @override
  String orderSummary(int cups, int price) {
    String _temp0 = intl.Intl.pluralLogic(
      cups,
      locale: localeName,
      other: '$cups รายการ',
    );
    return '$_temp0 รวม $price บาท';
  }

  @override
  String get ok => 'ตกลง';

  @override
  String menuSemantics(String name, int price) {
    return '$name ราคา $price บาท';
  }

  @override
  String get orderHistory => 'ประวัติคำสั่งซื้อ';

  @override
  String get noOrders => 'ยังไม่มีคำสั่งซื้อ';

  @override
  String get historyError => 'โหลดประวัติคำสั่งซื้อไม่สำเร็จ';

  @override
  String get receipt => 'ใบเสร็จ';

  @override
  String get favorite => 'รายการโปรด';

  @override
  String get loadError => 'โหลดเมนูไม่สำเร็จ';

  @override
  String get retry => 'ลองอีกครั้ง';

  @override
  String get orderFailed => 'สั่งซื้อไม่สำเร็จ กรุณาลองใหม่';

  @override
  String get signIn => 'เข้าสู่ระบบ';

  @override
  String get signUp => 'สมัครสมาชิก';

  @override
  String get email => 'อีเมล';

  @override
  String get password => 'รหัสผ่าน';

  @override
  String get displayName => 'ชื่อที่แสดง';

  @override
  String get signOut => 'ออกจากระบบ';

  @override
  String get noAccount => 'ยังไม่มีบัญชี? สมัครสมาชิก';

  @override
  String get haveAccount => 'มีบัญชีแล้ว? เข้าสู่ระบบ';

  @override
  String get barista => 'บาริสต้า';

  @override
  String get orderStatus => 'สถานะคำสั่งซื้อ';

  @override
  String get trackOrder => 'ติดตามสถานะ';

  @override
  String get noActiveOrders => 'ไม่มีคำสั่งซื้อที่รอทำ';

  @override
  String get orderNotFound => 'ไม่พบคำสั่งซื้อ';

  @override
  String get orderStatusError => 'โหลดสถานะคำสั่งซื้อไม่สำเร็จ';

  @override
  String get nearestBranch => 'หาสาขาใกล้ฉัน';

  @override
  String get findingLocation => 'กำลังหาตำแหน่ง…';

  @override
  String get openSettings => 'เปิดการตั้งค่า';

  @override
  String distanceKm(String km) {
    return '$km กม.';
  }

  @override
  String get review => 'รีวิว';

  @override
  String get takePhoto => 'ถ่ายภาพ';

  @override
  String get pickPhoto => 'เลือกจากคลังภาพ';

  @override
  String get photoError =>
      'เปิดกล้องหรือคลังภาพไม่ได้ ตรวจสอบสิทธิ์ในการตั้งค่า';

  @override
  String get comment => 'ความเห็น';

  @override
  String get saveReview => 'บันทึกรีวิว';

  @override
  String get reviewSaved => 'บันทึกรีวิวแล้ว';

  @override
  String points(int points) {
    return 'แต้มสะสม $points แต้ม';
  }

  @override
  String get forYou => 'แนะนำสำหรับคุณ';

  @override
  String get aiSimulated => 'AI (จำลอง)';

  @override
  String get tryIt => 'ลองเลย';
}
