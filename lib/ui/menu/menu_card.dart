import 'package:cafe_core/cafe_core.dart';
import 'package:flutter/material.dart';

import '../l10n_ext.dart';
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
    // Semantics: โปรแกรมอ่านจออ่านเป็นปุ่มเดียว "ลาเต้ ราคา 55 บาท"
    // แทนการอ่านข้อความย่อยทีละชิ้น
    return Semantics(
      button: true,
      label: context.l10n.menuSemantics(item.nameFor(context), item.price),
      excludeSemantics: true,
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        clipBehavior: Clip.antiAlias,
        // InkWell ตอบสนองการแตะพร้อมเอฟเฟกต์ระลอกน้ำ (ripple)
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Row(
            children: [
              MenuImage(item: item, size: 72, hero: true),
              const SizedBox(width: 12),
              // Expanded ให้ข้อความใช้พื้นที่ที่เหลือ ข้อความยาวจึงไม่ล้น (Overflow)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.nameFor(context), style: textTheme.titleMedium),
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
                child: Text(
                  context.l10n.price(item.price),
                  style: textTheme.titleSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// การ์ดเมนูสำหรับมุมมองกริด (GridView) ใช้ Stack วางป้ายหมวดทับรูป
class MenuGridCard extends StatelessWidget {
  const MenuGridCard({super.key, required this.item, this.onTap});

  final MenuItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MenuImage(item: item, hero: true),
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
                        item.category.labelFor(context),
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
                    child: Text(
                      item.nameFor(context),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text('${item.price}.-'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
