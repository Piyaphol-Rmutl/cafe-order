import 'package:cafe_core/cafe_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// ตะกร้าที่ "จงใจมีบั๊ก" สำหรับฝึกดีบัก (ไม่ได้ใช้ในแอปจริง)
/// บั๊ก 1: total ลืมคูณจำนวน  บั๊ก 2: ลบทุกแก้วของเมนูที่ระบุ แต่ลบไม่ครบ
class BuggyCart {
  final List<OrderItem> items = [];

  int get total {
    var sum = 0;
    for (final i in items) {
      sum += i
          .unitPrice; // ← ตั้ง Breakpoint ที่นี่ แล้วดู i.quantity ใน Variables
    }
    return sum;
  }

  void removeMenu(String menuId) {
    // วนด้วยดัชนีแล้วลบระหว่างวน: รายการถัดไปเลื่อนมาแทน จึงถูกข้าม
    for (var i = 0; i < items.length; i++) {
      if (items[i].item.id == menuId) items.removeAt(i);
    }
  }
}

/// หน้าสาธิตดีบัก: ปุ่มเพิ่ม/ลบ, ยอดรวมที่ผิด, และสวิตช์ debugPaintSizeEnabled
class DebuggingDemo extends StatefulWidget {
  const DebuggingDemo({super.key});

  @override
  State<DebuggingDemo> createState() => _DebuggingDemoState();
}

class _DebuggingDemoState extends State<DebuggingDemo> {
  final _cart = BuggyCart();

  @override
  Widget build(BuildContext context) {
    final latte = sampleMenu.first;
    final expected = _cart.items.fold(0, (s, i) => s + i.total);
    return Scaffold(
      appBar: AppBar(title: const Text('ฝึกดีบัก')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('จำนวนรายการ ${_cart.items.length}'),
          Text('ยอดที่แอปคำนวณ: ${_cart.total} บาท'),
          Text('ยอดที่ถูกต้อง: $expected บาท'),
          Wrap(
            spacing: 8,
            children: [
              FilledButton(
                onPressed: () => setState(
                  () => _cart.items.add(OrderItem(item: latte, quantity: 2)),
                ),
                child: const Text('เพิ่มลาเต้ ×2'),
              ),
              OutlinedButton(
                onPressed: () => setState(() => _cart.removeMenu('latte')),
                child: const Text('ลบลาเต้ทั้งหมด'),
              ),
            ],
          ),
          // เปิดเส้นขอบของทุก RenderBox (เหมือนปุ่ม Show guidelines ใน DevTools)
          SwitchListTile(
            title: const Text('debugPaintSizeEnabled'),
            value: debugPaintSizeEnabled,
            onChanged: (on) {
              debugPaintSizeEnabled = on;
              setState(() {});
              // วาดใหม่ทั้งแอปหลังจบเฟรมนี้ (เรียกระหว่างจัดการการแตะจะผิด assertion)
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => WidgetsBinding.instance.reassembleApplication(),
              );
            },
          ),
        ],
      ),
    );
  }
}
