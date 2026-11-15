import 'package:cafe_core/cafe_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/live_order_repository.dart';
import '../../data/services/device_channel.dart';
import '../l10n_ext.dart';
import '../widgets/brewing_indicator.dart';

/// ลูกค้าติดตามสถานะคำสั่งซื้อแบบเรียลไทม์ด้วย StreamBuilder
/// บาริสต้าเปลี่ยนสถานะบนเครื่องอื่น หน้านี้เปลี่ยนตามทันทีโดยไม่ต้องรีเฟรช
class OrderStatusPage extends StatefulWidget {
  const OrderStatusPage({super.key, required this.orderId});

  final String orderId;

  @override
  State<OrderStatusPage> createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends State<OrderStatusPage> {
  // สร้าง Stream ครั้งเดียว ไม่สร้างใหม่ทุกครั้งที่ build
  // สัปดาห์ 13: สั่นเครื่องเมื่อสถานะเปลี่ยนเป็น "พร้อมรับ" (MethodChannel)
  OrderStatus? _previous;
  late final Stream<Order?> _order = context
      .read<LiveOrderRepository?>()!
      .watchOrder(widget.orderId)
      .map((order) {
        if (order?.status == OrderStatus.ready &&
            _previous != null &&
            _previous != OrderStatus.ready) {
          const CafeDeviceChannel().vibrate();
        }
        _previous = order?.status;
        return order;
      });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text('${l10n.orderStatus} ${widget.orderId}')),
      body: StreamBuilder<Order?>(
        stream: _order,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // ไม่แสดงข้อความดิบของระบบให้ผู้ใช้ (ดูรายละเอียดใน log)
            return Center(child: Text(l10n.orderStatusError));
          }
          if (!snapshot.hasData) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : Center(child: Text(l10n.orderNotFound));
          }
          final order = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              if (order.status == OrderStatus.preparing)
                const Center(child: BrewingIndicator(size: 80)),
              for (final s in OrderStatus.values)
                ListTile(
                  leading: Icon(
                    s.index <= order.status.index
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: s == order.status
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  title: Text(s.label),
                  selected: s == order.status,
                ),
              const Divider(),
              for (final i in order.items)
                Text('${i.item.nameFor(context)} ×${i.quantity}'),
              Text(l10n.price(order.total)),
            ],
          );
        },
      ),
    );
  }
}
