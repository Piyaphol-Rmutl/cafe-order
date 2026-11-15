import 'package:cafe_core/cafe_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/branch_repository.dart';
import '../../data/repositories/loyalty_repository.dart';
import '../l10n_ext.dart';
import 'info_row.dart';

/// แท็บ "ร้าน": CustomScrollView รวม Sliver หลายชนิดให้เลื่อนเป็นผืนเดียว
/// สัปดาห์ 11: รายชื่อสาขามาจากเซิร์ฟเวอร์ แสดงด้วย FutureBuilder
class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  static const _hours = {
    'จันทร์–ศุกร์': '07:30–17:00',
    'เสาร์': '09:00–15:00',
    'อาทิตย์': 'ปิด',
  };

  // สร้าง Future ครั้งเดียวใน initState (ถ้าสร้างใน build จะยิงคำร้องขอใหม่ทุกครั้งที่ build)
  late Future<List<Branch>> _branches;

  @override
  void initState() {
    super.initState();
    _branches = _load();
  }

  Future<List<Branch>> _load() {
    final future = context.read<BranchRepository>().fetchBranches();
    // FutureBuilder อยู่ใน SliverList ซึ่งสร้างเมื่อเลื่อนถึง ถ้า Future ล้มเหลวก่อน
    // จะเป็น "ข้อผิดพลาดที่ไม่มีใครจัดการ" ignore() บอกว่าเรารู้แล้ว
    // (FutureBuilder ยังได้รับข้อผิดพลาดตามปกติเมื่อถูกสร้าง)
    future.ignore();
    return future;
  }

  // ใช้ { } ไม่ใช่ => : ลูกศรจะคืน Future ออกจาก setState ซึ่ง Flutter ไม่อนุญาต
  void _retry() => setState(() {
    _branches = _load();
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // แถบหัวขนาดใหญ่ที่หดลงเมื่อเลื่อน
        const SliverAppBar.large(title: Text('ร้านของเรา')),
        const SliverToBoxAdapter(child: ShopHeader()),
        SliverList.list(
          children: [
            for (final e in _hours.entries)
              ListTile(title: Text(e.key), trailing: Text(e.value)),
            const Divider(),
            const PointsTile(), // สัปดาห์ 15: API ที่ต้องแนบโทเค็น
            // สัปดาห์ 13: หาสาขาใกล้ที่สุดด้วยตำแหน่งของเครื่อง
            ListTile(
              leading: const Icon(Icons.near_me),
              title: Text(context.l10n.nearestBranch),
              onTap: () => context.push('/branches'),
            ),
            // FutureBuilder: แสดงตามสถานะของ Future (กำลังโหลด / ข้อมูล / ผิดพลาด)
            FutureBuilder<List<Branch>>(
              future: _branches,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return ListTile(
                    leading: const Icon(Icons.cloud_off),
                    title: Text('โหลดสาขาไม่สำเร็จ: ${snapshot.error}'),
                    trailing: TextButton(
                      onPressed: _retry,
                      child: Text(context.l10n.retry),
                    ),
                  );
                }
                return Column(
                  children: [
                    for (final b in snapshot.data!)
                      ListTile(
                        leading: const Icon(Icons.storefront),
                        title: Text(b.name),
                        subtitle: Text(b.hours),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

/// ส่วนหัวร้าน: ต้นไม้ Column → [Image, Text, Text, InfoRow × 3, Card]
class ShopHeader extends StatelessWidget {
  const ShopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final special = sampleMenu.first; // เมนูแนะนำจากแพ็กเกจ cafe_core

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Image.asset('assets/images/logo.png', height: 160),
          const SizedBox(height: 16),
          Text('ร้านกาแฟคณะวิศวกรรมศาสตร์', style: textTheme.headlineSmall),
          Text('สั่งล่วงหน้า ไม่ต้องรอคิว', style: textTheme.bodyLarge),
          const SizedBox(height: 16),
          const InfoRow(
            icon: Icons.schedule,
            text: 'เปิด 07:30–17:00 จันทร์–ศุกร์',
          ),
          const InfoRow(
            icon: Icons.place,
            text: 'ชั้น 1 อาคารวิศวกรรมคอมพิวเตอร์',
          ),
          const InfoRow(icon: Icons.phone, text: '053-000-000'),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.local_cafe, color: Colors.brown),
              title: Text('เมนูแนะนำ: ${special.name}'),
              subtitle: Text(special.description),
              trailing: Text('${special.price} บาท'),
            ),
          ),
        ],
      ),
    );
  }
}

/// แต้มสะสม: ApiService แนบโทเค็นจาก secure storage ให้เอง
class PointsTile extends StatefulWidget {
  const PointsTile({super.key});

  @override
  State<PointsTile> createState() => _PointsTileState();
}

class _PointsTileState extends State<PointsTile> {
  late final Future<int> _points =
      context.read<LoyaltyRepository>().fetchPoints()..ignore();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _points,
      builder: (context, snapshot) => ListTile(
        leading: const Icon(Icons.loyalty),
        title: Text(
          snapshot.hasData ? context.l10n.points(snapshot.data!) : '…',
        ),
      ),
    );
  }
}
