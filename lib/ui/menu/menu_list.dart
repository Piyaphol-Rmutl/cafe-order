import 'package:cafe_core/cafe_core.dart';
import 'package:flutter/material.dart';

import 'menu_card.dart';

/// รายการเมนู: ListView.builder สร้างเฉพาะแถวที่มองเห็น
class MenuList extends StatelessWidget {
  const MenuList({
    super.key,
    required this.menu,
    this.header,
    this.onSelect,
    this.onLongPress,
  });

  final List<MenuItem> menu;
  final Widget? header; // แถวแรก (ไม่บังคับ)
  final ValueChanged<MenuItem>? onSelect;
  final ValueChanged<MenuItem>? onLongPress;

  @override
  Widget build(BuildContext context) {
    final offset = header == null ? 0 : 1;
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: menu.length + offset,
      itemBuilder: (context, index) {
        if (index < offset) return header!;
        final item = menu[index - offset];
        return MenuTile(
          item: item,
          onTap: onSelect == null ? null : () => onSelect!(item),
          onLongPress: onLongPress == null ? null : () => onLongPress!(item),
        );
      },
    );
  }
}

/// กริดเมนู: กำหนดความกว้างสูงสุดของช่อง จำนวนคอลัมน์จึงปรับตามจอ
class MenuGrid extends StatelessWidget {
  const MenuGrid({super.key, required this.menu, this.onSelect});

  final List<MenuItem> menu;
  final ValueChanged<MenuItem>? onSelect;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 0.8,
      ),
      itemCount: menu.length,
      itemBuilder: (context, index) => MenuGridCard(
        item: menu[index],
        onTap: onSelect == null ? null : () => onSelect!(menu[index]),
      ),
    );
  }
}
