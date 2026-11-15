import 'package:cafe_core/cafe_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../cart/cart_view_model.dart';
import '../widgets/brewing_indicator.dart';
import '../customize/customize_page.dart';
import '../l10n_ext.dart';
import 'menu_list.dart';
import 'menu_view_model.dart';

/// แท็บเมนู: TabBar แยกตามหมวด + เลย์เอาต์ที่ปรับตามความกว้าง
class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  /// จอแคบ: เปิดหน้าปรับแต่ง แล้วรอผลลัพธ์ที่ส่งกลับมาด้วย pop
  Future<void> _open(BuildContext context, MenuItem item) async {
    final result = await context.push<OrderItem>('/menu/${item.id}');
    if (result == null || !context.mounted) return; // กดย้อนกลับ = ไม่สั่ง
    _added(context, result);
  }

  void _added(BuildContext context, OrderItem result) {
    context.read<CartViewModel>().add(result); // ทุกหน้าที่ฟังอยู่อัปเดตเอง
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.addedToCart(result.item.nameFor(context))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MenuViewModel>();
    final l10n = context.l10n;
    // View แสดงตามสถานะของ ViewModel: กำลังโหลด / ผิดพลาด / ข้อมูล
    if (vm.loading && vm.items.isEmpty) {
      return const Center(child: BrewingIndicator());
    }
    if (vm.error != null && vm.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.loadError),
            const SizedBox(height: 8),
            FilledButton(onPressed: vm.load, child: Text(l10n.retry)),
          ],
        ),
      );
    }
    // แท็บ: ทั้งหมด, รายการโปรด (สัปดาห์ 10), แล้วตามหมวด
    final tabs = <(String, List<MenuItem>)>[
      (l10n.allCategories, vm.items),
      (l10n.favorite, vm.favorites),
      for (final c in MenuCategory.values)
        (c.labelFor(context), vm.byCategory(c)),
    ];
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabs: [for (final (label, _) in tabs) Tab(text: label)],
          ),
          Expanded(
            child: TabBarView(
              children: [
                for (final (_, menu) in tabs)
                  _MenuBody(
                    menu: menu,
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
        if (widget.menu.isEmpty) return const SizedBox.shrink();
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
