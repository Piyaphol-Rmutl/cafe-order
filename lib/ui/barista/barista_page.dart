import 'package:cafe_core/cafe_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/live_order_repository.dart';
import '../l10n_ext.dart';

/// หน้าบาริสต้า: เห็นคำสั่งซื้อใหม่ทันที (StreamBuilder) และกดเปลี่ยนสถานะ
class BaristaPage extends StatefulWidget {
  const BaristaPage({super.key});

  @override
  State<BaristaPage> createState() => _BaristaPageState();
}

class _BaristaPageState extends State<BaristaPage> {
  late final LiveOrderRepository _repo = context.read<LiveOrderRepository?>()!;
  late final Stream<List<Order>> _active = _repo.watchActive();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.barista)),
      body: StreamBuilder<List<Order>>(
        stream: _active,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final orders = snapshot.data!;
          if (orders.isEmpty) return Center(child: Text(l10n.noActiveOrders));
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final next = order.status.next!;
              return Card(
                child: ListTile(
                  title: Text('${order.id} · ${order.status.label}'),
                  subtitle: Text(
                    order.items
                        .map(
                          (i) =>
                              '${i.item.name} ${i.summary} ×${i.quantity} (${i.cupName ?? '-'})',
                        )
                        .join('\n'),
                  ),
                  isThreeLine: order.items.length > 1,
                  trailing: FilledButton.tonal(
                    onPressed: () => _repo.updateStatus(order.id, next),
                    child: Text(next.label),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
