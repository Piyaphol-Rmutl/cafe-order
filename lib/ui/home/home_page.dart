import 'package:cafe_core/cafe_core.dart';
import 'package:flutter/material.dart';

import '../../demos/demo_menu.dart';
import 'info_row.dart';

/// หน้าแรกของร้าน: StatelessWidget ที่ประกอบจากวิดเจ็ตพื้นฐาน
/// ต้นไม้: Scaffold → AppBar + ListView → [Image, Text, Text, InfoRow × 3, Card]
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final special = sampleMenu.first; // เมนูแนะนำจากแพ็กเกจ cafe_core

    return Scaffold(
      appBar: AppBar(
        title: const Text('Café Order'),
        actions: const [DemoMenuButton()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Image.asset('assets/images/logo.png', height: 160),
          const SizedBox(height: 16),
          Text(
            'ร้านกาแฟคณะวิศวกรรมศาสตร์',
            style: textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          Text(
            'สั่งล่วงหน้า ไม่ต้องรอคิว',
            style: textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const InfoRow(icon: Icons.schedule, text: 'เปิด 07:30–17:00 จันทร์–ศุกร์'),
          const InfoRow(icon: Icons.place, text: 'ชั้น 1 อาคารวิศวกรรมคอมพิวเตอร์'),
          const InfoRow(icon: Icons.phone, text: '053-000-000'),
          const SizedBox(height: 16),
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
