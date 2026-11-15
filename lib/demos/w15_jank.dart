import 'package:cafe_core/cafe_core.dart';
import 'package:flutter/material.dart';

/// สาธิตประสิทธิภาพ: รายการ 300 แถว แบบ "ช้า" เทียบ "ปรับแล้ว"
/// รันด้วย flutter run --profile บนเครื่องจริง แล้วเปิด DevTools → Performance
/// หรือเปิด Performance Overlay (ปุ่มบนแถบ) ดูกราฟ UI/Raster
class JankDemo extends StatefulWidget {
  const JankDemo({super.key});

  @override
  State<JankDemo> createState() => _JankDemoState();
}

class _JankDemoState extends State<JankDemo> {
  bool _optimized = false;
  bool _overlay = false;

  @override
  Widget build(BuildContext context) {
    final list = ListView.builder(
      itemCount: 300,
      itemBuilder: (context, i) {
        final item = sampleMenu[i % sampleMenu.length];
        return _optimized ? FastRow(item: item) : SlowRow(item: item);
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(_optimized ? 'ปรับแล้ว' : 'ช้า (jank)'),
        actions: [
          IconButton(
            tooltip: 'Performance Overlay',
            icon: const Icon(Icons.speed),
            onPressed: () => setState(() => _overlay = !_overlay),
          ),
          Switch(
            value: _optimized,
            onChanged: (v) => setState(() => _optimized = v),
          ),
        ],
      ),
      body: Stack(
        children: [list, if (_overlay) PerformanceOverlay.allEnabled()],
      ),
    );
  }
}

/// แบบช้า: ถอดรหัสภาพเต็ม 800×800 ทุกแถว + คำนวณหนักใน build + Opacity
class SlowRow extends StatelessWidget {
  const SlowRow({super.key, required this.item});
  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    // งานหนักใน build: ทำซ้ำทุกเฟรมที่แถวนี้ถูกสร้าง
    // (มากพอให้เห็นแท่งเกินงบเฟรมบนเครื่องจำลองในโหมด profile)
    var checksum = 0;
    for (var i = 0; i < 3000000; i++) {
      checksum = (checksum + i * item.price) % 9973;
    }
    return Opacity(
      opacity: 0.9, // Opacity ทั้งแถวทำให้ต้องวาดลงเลเยอร์แยก
      child: ListTile(
        leading: Image.asset('assets/menu/${item.id}.png', width: 56),
        title: Text(item.name),
        subtitle: Text('checksum $checksum'),
      ),
    );
  }
}

/// แบบปรับแล้ว: cacheWidth, ไม่คำนวณใน build, ใช้สีโปร่งแทน Opacity
class FastRow extends StatelessWidget {
  const FastRow({super.key, required this.item});
  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    final px = (56 * MediaQuery.devicePixelRatioOf(context)).round();
    return ListTile(
      leading: Image.asset(
        'assets/menu/${item.id}.png',
        width: 56,
        cacheWidth: px,
      ),
      title: Text(item.name),
      subtitle: Text('${item.price} บาท'),
    );
  }
}
