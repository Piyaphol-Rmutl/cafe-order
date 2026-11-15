import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n_ext.dart';
import 'order_history_view_model.dart';

/// View: แสดงผลจาก ViewModel อย่างเดียว ไม่รู้จักฐานข้อมูลหรือไฟล์
class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  Future<void> _showReceipt(BuildContext context, String id) async {
    final text = await context.read<OrderHistoryViewModel>().receipt(id);
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.receipt),
        content: Text(text ?? '-'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OrderHistoryViewModel>();
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.orderHistory)),
      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
          : vm.error != null
          ? Center(child: Text(l10n.historyError))
          : vm.history.isEmpty
          ? Center(child: Text(l10n.noOrders))
          : ListView.builder(
              itemCount: vm.history.length,
              itemBuilder: (context, index) {
                final order = vm.history[index];
                return ListTile(
                  leading: const Icon(Icons.receipt_long),
                  title: Text('${order.id} · ${l10n.price(order.total)}'),
                  subtitle: Text(
                    order.items
                        .map((i) => '${i.item.nameFor(context)} ×${i.quantity}')
                        .join(', '),
                  ),
                  trailing: Text(order.status.label),
                  onTap: () => _showReceipt(context, order.id),
                );
              },
            ),
    );
  }
}
