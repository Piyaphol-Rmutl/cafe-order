import 'package:cafe_core/cafe_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../customize/customize_page.dart';
import '../l10n_ext.dart';
import 'menu_list.dart';

/// แท็บเมนู: TabBar แยกตามหมวด + เลย์เอาต์ที่ปรับตามความกว้าง
class MenuPage extends StatelessWidget {
  const MenuPage({super.key, required this.onAdd});

  final ValueChanged<OrderItem> onAdd;

  /// จอแคบ: เปิดหน้าปรับแต่ง แล้วรอผลลัพธ์ที่ส่งกลับมาด้วย pop
  Future<void> _open(BuildContext context, MenuItem item) async {
    final result = await context.push<OrderItem>('/menu/${item.id}');
    if (result == null || !context.mounted) return; // กดย้อนกลับ = ไม่สั่ง
    _added(context, result);
  }

  void _added(BuildContext context, OrderItem result) {
    onAdd(result);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.addedToCart(result.item.nameFor(context))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [null, ...MenuCategory.values]; // null = ทั้งหมด
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabs: [
              for (final c in tabs)
                Tab(text: c?.labelFor(context) ?? context.l10n.allCategories),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                for (final c in tabs)
                  _MenuBody(
                    menu: c == null
                        ? sampleMenu
                        : sampleMenu.where((m) => m.category == c).toList(),
                    onOpen: (item) => _open(context, item),
                    onAdded: (item) => _added(context, item),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// เลือกเลย์เอาต์จากพื้นที่ที่ได้รับจริง (LayoutBuilder)
/// < 600: รายการ, 600–899: กริด, ≥ 900: กริด + บานปรับแต่งด้านขวา (สองบาน)
class _MenuBody extends StatefulWidget {
  const _MenuBody({
    required this.menu,
    required this.onOpen,
    required this.onAdded,
  });

  final List<MenuItem> menu;
  final ValueChanged<MenuItem> onOpen;
  final ValueChanged<OrderItem> onAdded;

  @override
  State<_MenuBody> createState() => _MenuBodyState();
}

class _MenuBodyState extends State<_MenuBody> {
  MenuItem? _selected; // เมนูที่เลือกในโหมดสองบาน

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        if (width < 600) {
          return MenuList(
            menu: widget.menu,
            onSelect: widget.onOpen,
            onLongPress: (item) => _showInfo(context, item),
          );
        }
        if (width < 900) {
          return MenuGrid(menu: widget.menu, onSelect: widget.onOpen);
        }
        final selected = _selected ?? widget.menu.first;
        return Row(
          children: [
            Expanded(
              child: MenuGrid(
                menu: widget.menu,
                onSelect: (item) => setState(() => _selected = item),
              ),
            ),
            const VerticalDivider(width: 1),
            SizedBox(
              width: 420,
              child: CustomizePage(
                key: ValueKey(selected.id), // เปลี่ยนเมนู = ฟอร์มใหม่
                item: selected,
                onSubmit: widget.onAdded,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showInfo(BuildContext context, MenuItem item) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => ListTile(
        contentPadding: const EdgeInsets.all(24),
        title: Text(item.nameFor(context)),
        subtitle: Text(item.description),
      ),
    );
  }
}
