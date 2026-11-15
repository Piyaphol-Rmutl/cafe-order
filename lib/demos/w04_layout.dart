import 'package:cafe_core/cafe_core.dart';
import 'package:flutter/material.dart';

import '../ui/menu/menu_image.dart';
import '../ui/menu/menu_list.dart';

/// สาธิตสัปดาห์ 4: กริดเมนู, Overflow และ Constraints
class LayoutDemo extends StatelessWidget {
  const LayoutDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เลย์เอาต์')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('1) Overflow: Row ที่ไม่มี Expanded (แถบเหลือง-ดำ)'),
          BrokenMenuRow(item: sampleMenu.first),
          const Text('แก้แล้ว: ห่อข้อความด้วย Expanded'),
          FixedMenuRow(item: sampleMenu.first),
          const Divider(),
          const Text('2) Constraints: Container ขอ 300×80 แต่พ่อบังคับเต็มความกว้าง'),
          Container(width: 300, height: 80, color: Colors.amber),
          const Text('ห่อด้วย Center: พ่อให้ขนาดหลวม ลูกจึงได้ 300×80 ตามขอ'),
          Center(
            child: Container(width: 300, height: 80, color: Colors.amber),
          ),
          const Divider(),
          const Text('3) กริดเมนู (GridView ภายในกล่องสูง 420)'),
          const SizedBox(height: 420, child: MenuGrid(menu: sampleMenu)),
        ],
      ),
    );
  }
}

const _longText = 'คำอธิบายยาวมากเพื่อทดลองว่าข้อความจะล้นออกนอกแถวหรือไม่';

/// แบบผิด: ข้อความในแถวได้ความกว้างไม่จำกัด จึงล้นขอบ
class BrokenMenuRow extends StatelessWidget {
  const BrokenMenuRow({super.key, required this.item});
  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MenuImage(item: item, size: 48),
        const Text(_longText),
      ],
    );
  }
}

/// แบบถูก: Expanded บังคับความกว้างเท่าพื้นที่ที่เหลือ ข้อความจึงตัดบรรทัด
class FixedMenuRow extends StatelessWidget {
  const FixedMenuRow({super.key, required this.item});
  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MenuImage(item: item, size: 48),
        const Expanded(child: Text(_longText)),
      ],
    );
  }
}
