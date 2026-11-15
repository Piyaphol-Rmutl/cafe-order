import 'package:cafe_core/cafe_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/order_repository.dart';
import '../../data/services/recommender.dart';
import '../l10n_ext.dart';
import '../menu/menu_image.dart';

/// การ์ด "แนะนำสำหรับคุณ" บนหน้าเมนู (สัปดาห์ 16)
/// รวมข้อมูลจากหลายชั้น: เมนู (REST) + รายการโปรด (SQLite) + ประวัติ (SQLite) → AI
class RecommendationCard extends StatefulWidget {
  const RecommendationCard({
    super.key,
    required this.menu,
    required this.favorites,
    required this.onOpen,
    this.now,
  });

  final List<MenuItem> menu;
  final Set<String> favorites;
  final ValueChanged<MenuItem> onOpen;
  final DateTime? now; // กำหนดเวลาได้ตอนทดสอบ

  @override
  State<RecommendationCard> createState() => _RecommendationCardState();
}

class _RecommendationCardState extends State<RecommendationCard> {
  late final Future<Recommendation> _future = _load()..ignore();

  Future<Recommendation> _load() async {
    final history = await context.read<OrderRepository>().history();
    final counts = <String, int>{};
    for (final order in history) {
      for (final line in order.items) {
        counts.update(
          line.item.id,
          (n) => n + line.quantity,
          ifAbsent: () => line.quantity,
        );
      }
    }
    if (!mounted) throw StateError('disposed');
    final rec = await context.read<MenuRecommender>().recommend(
      widget.menu,
      RecommendationRequest(
        hour: (widget.now ?? DateTime.now()).hour,
        orderCounts: counts,
        favorites: widget.favorites,
      ),
    );
    // ไม่เชื่อข้อมูลเมนูจาก AI/เซิร์ฟเวอร์ทั้งก้อน: ใช้เมนูจริงของร้านตามรหัส
    // ถ้าไม่มีในเมนู (เช่น โมเดลแต่งชื่อขึ้นมา) ถือว่าแนะนำไม่ได้ การ์ดจะถูกซ่อน
    final item = widget.menu.where((m) => m.id == rec.item.id).firstOrNull;
    if (item == null) throw StateError('ไม่พบเมนู ${rec.item.id}');
    return Recommendation(item, rec.reason);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return FutureBuilder<Recommendation>(
      future: _future,
      builder: (context, snapshot) {
        // แนะนำไม่ได้ ไม่ต้องรบกวนผู้ใช้ ซ่อนการ์ดไปเลย
        if (snapshot.hasError) return const SizedBox.shrink();
        final rec = snapshot.data;
        return Card(
          child: ListTile(
            leading: rec == null
                ? const SizedBox.square(
                    dimension: 48,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: MenuImage(item: rec.item, size: 48),
                  ),
            title: Text(
              rec == null
                  ? l10n.forYou
                  : '${l10n.forYou}: ${rec.item.nameFor(context)}',
            ),
            // บอกผู้ใช้ตรง ๆ ว่าเป็นผลจาก AI และเหตุผลที่แนะนำ (โปร่งใส อธิบายได้)
            subtitle: Text(
              rec == null
                  ? l10n.aiSimulated
                  : '${rec.reason} · ${l10n.aiSimulated}',
            ),
            trailing: rec == null
                ? null
                : TextButton(
                    onPressed: () => widget.onOpen(rec.item),
                    child: Text(l10n.tryIt),
                  ),
          ),
        );
      },
    );
  }
}
