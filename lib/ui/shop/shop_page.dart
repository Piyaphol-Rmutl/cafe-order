import 'package:cafe_core/cafe_core.dart';
import 'package:flutter/material.dart';

import 'info_row.dart';

/// แท็บ "ร้าน": CustomScrollView รวม Sliver หลายชนิดให้เลื่อนเป็นผืนเดียว
class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  static const _hours = {
    'จันทร์–ศุกร์': '07:30–17:00',
    'เสาร์': '09:00–15:00',
    'อาทิตย์': 'ปิด',
  };

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
