import 'package:cafe_core/cafe_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n_ext.dart';

/// แท็บตะกร้า (สัปดาห์ 6): รับรายการผ่านคอนสตรักเตอร์จากรากของแอป
/// ข้อจำกัด: ลบในหน้านี้แล้ว หน้าอื่นไม่รู้ (แก้ด้วย ChangeNotifier ในสัปดาห์ 8)
class CartPage extends StatefulWidget {
  const CartPage({super.key, required this.items});

  final List<OrderItem> items;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<OrderItem> get _items => widget.items;

  Future<void> _checkout() async {
    final order = Order(
      id: 'A${DateTime.now().millisecondsSinceEpoch % 10000}',
      items: [..._items],
    );
    setState(_items.clear);
    final l10n = context.l10n;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.orderPlaced(order.id)),
        content: Text(l10n.orderSummary(order.summary.cups, order.total)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
    if (mounted) context.go('/menu');
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return Center(child: Text(context.l10n.cartEmpty));
    }
    final total = _items.fold(0, (sum, i) => sum + i.total);
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _items.length,
            itemBuilder: (context, index) {
              final line = _items[index];
              return ListTile(
                title: Text('${line.item.nameFor(context)} ×${line.quantity}'),
                subtitle: Text(
                  [
                    line.summary,
                    line.cupName ?? '',
                  ].where((s) => s.isNotEmpty).join(' · '),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(context.l10n.price(line.total)),
                    IconButton(
                      tooltip: context.l10n.removeItem(
                        line.item.nameFor(context),
                      ),
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => setState(() => _items.removeAt(index)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: _checkout,
            child: Text(context.l10n.checkout(total)),
          ),
        ),
      ],
    );
  }
}
