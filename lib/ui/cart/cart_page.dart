import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'cart_view_model.dart';
import '../l10n_ext.dart';

/// แท็บตะกร้า: StatelessWidget ที่ฟัง CartViewModel
/// ลบหรือเปลี่ยนจำนวนที่นี่ badge บนแถบนำทางก็อัปเดตทันที
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  Future<void> _checkout(BuildContext context) async {
    final l10n = context.l10n;
    final order = await context.read<CartViewModel>().checkout();
    if (!context.mounted) return;
    if (order == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.orderFailed)));
      return;
    }
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
    if (context.mounted) context.go('/menu');
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartViewModel>(); // ฟังการเปลี่ยนแปลงทั้งหมด
    final l10n = context.l10n;
    if (cart.isEmpty) {
      return Center(child: Text(l10n.cartEmpty));
    }
    final items = cart.items;
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final line = items[index];
              final name = line.item.nameFor(context);
              // Dismissible: ปัดซ้ายเพื่อลบ
              return Dismissible(
                key: ObjectKey(line),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Theme.of(context).colorScheme.errorContainer,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  child: const Icon(Icons.delete),
                ),
                onDismissed: (_) => cart.removeAt(index),
                child: ListTile(
                  title: Text('$name ×${line.quantity}'),
                  subtitle: Text(
                    [
                      line.summary,
                      line.cupName ?? '',
                    ].where((s) => s.isNotEmpty).join(' · '),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(l10n.price(line.total)),
                      IconButton(
                        tooltip: l10n.removeItem(name),
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () =>
                            cart.setQuantity(index, line.quantity - 1),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            // ระหว่างส่ง ปิดปุ่ม (null) กันกดซ้ำ
            onPressed: cart.placing ? null : () => _checkout(context),
            child: cart.placing
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.checkout(cart.total)),
          ),
        ),
      ],
    );
  }
}
