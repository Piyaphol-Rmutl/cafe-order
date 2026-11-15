import 'package:cafe_core/cafe_core.dart';
import 'package:flutter/material.dart';

import 'menu_image.dart';

/// แถวเมนูสำหรับมุมมองรายการ (ListView)
/// Row: [รูป 72×72] [Expanded(ชื่อ + คำอธิบาย)] [ราคา]
class MenuTile extends StatelessWidget {
  const MenuTile({super.key, required this.item, this.onTap, this.onLongPress});

  final MenuItem item;
  final VoidCallback? onTap; // แตะ: เปิดหน้าปรับแต่ง
  final VoidCallback? onLongPress; // กดค้าง: ดูคำอธิบาย

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      // InkWell ตอบสนองการแตะพร้อมเอฟเฟกต์ระลอกน้ำ (ripple)
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Row(
          children: [
            MenuImage(item: item, size: 72),
            const SizedBox(width: 12),
            // Expanded ให้ข้อความใช้พื้นที่ที่เหลือ ข้อความยาวจึงไม่ล้น (Overflow)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: textTheme.titleMedium),
                  Text(
                    item.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text('${item.price} บาท', style: textTheme.titleSmall),
            ),
          ],
        ),
      ),
    );
  }
}

/// การ์ดเมนูสำหรับมุมมองกริด (GridView) ใช้ Stack วางป้ายหมวดทับรูป
class MenuGridCard extends StatelessWidget {
  const MenuGridCard({super.key, required this.item});

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                MenuImage(item: item),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.category.label,
                      style: TextStyle(color: scheme.onPrimary, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: Text(item.name, overflow: TextOverflow.ellipsis),
                ),
                Text('${item.price}.-'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
