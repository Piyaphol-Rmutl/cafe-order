import 'package:cafe_core/cafe_core.dart';
import 'package:flutter/material.dart';

/// สาธิตการนำทางแบบสแตก (ก่อนใช้ go_router):
/// ส่งข้อมูลไปทางคอนสตรักเตอร์ และรับผลลัพธ์กลับด้วย await push / pop(result)
class NavigatorDemo extends StatefulWidget {
  const NavigatorDemo({super.key});

  @override
  State<NavigatorDemo> createState() => _NavigatorDemoState();
}

class _NavigatorDemoState extends State<NavigatorDemo> {
  CupSize? _size;

  Future<void> _chooseSize() async {
    // push คืน Future ที่เสร็จเมื่อหน้าใหม่ถูก pop
    final size = await Navigator.of(context).push<CupSize>(
      MaterialPageRoute(
        builder: (_) => SizePickerPage(drink: sampleMenu.first.name),
      ),
    );
    if (size != null) setState(() => _size = size); // null = กดย้อนกลับ
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigator แบบสแตก')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _size == null
                  ? 'ยังไม่ได้เลือกขนาด'
                  : 'เลือกขนาด ${_size!.label}',
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _chooseSize,
              child: const Text('เลือกขนาดแก้ว'),
            ),
          ],
        ),
      ),
    );
  }
}

/// หน้าที่สอง: รับชื่อเครื่องดื่มเข้ามา แล้ว pop พร้อมขนาดที่เลือก
class SizePickerPage extends StatelessWidget {
  const SizePickerPage({super.key, required this.drink});

  final String drink;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ขนาดของ$drink')),
      body: ListView(
        children: [
          for (final size in CupSize.values)
            ListTile(
              title: Text('ขนาด ${size.label}'),
              trailing: Text('+${size.extra} บาท'),
              onTap: () => Navigator.of(context).pop(size),
            ),
        ],
      ),
    );
  }
}
