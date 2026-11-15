import 'package:cafe_core/cafe_core.dart';
import 'package:flutter/material.dart';

/// รูปของเมนูจากแอสเซต `assets/menu/{id}.png`
/// [hero] = true ห่อด้วย Hero ให้รูปบินไปหน้าปรับแต่ง (tag ต้องไม่ซ้ำในหน้าเดียวกัน)
class MenuImage extends StatelessWidget {
  const MenuImage({
    super.key,
    required this.item,
    this.size,
    this.hero = false,
  });

  final MenuItem item;
  final double? size;
  final bool hero;

  @override
  Widget build(BuildContext context) {
    // สัปดาห์ 15: ถอดรหัสภาพเท่าขนาดที่แสดงจริง (ภาพต้นฉบับ 800×800)
    // ภาพ 72 จุดบนจอ 3x ใช้ 216 พิกเซลแทน 800 → ใช้หน่วยความจำน้อยลงราว 14 เท่า
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final image = Image.asset(
      'assets/menu/${item.id}.png',
      width: size,
      height: size,
      cacheWidth: size == null ? null : (size! * dpr).round(),
      fit: BoxFit.cover,
      excludeFromSemantics: true, // รูปประกอบ ไม่ต้องให้โปรแกรมอ่านจอพูด
    );
    return hero ? Hero(tag: 'menu-${item.id}', child: image) : image;
  }
}
