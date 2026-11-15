import 'package:cafe_core/cafe_core.dart';
import 'package:flutter/material.dart';

/// โมเดลตะกร้าแบบย่อสำหรับสาธิต: ChangeNotifier ล้วน
class DemoCart extends ChangeNotifier {
  final List<OrderItem> _items = [];

  List<OrderItem> get items => List.unmodifiable(_items);
  int get count => _items.fold(0, (sum, i) => sum + i.quantity);

  void add(OrderItem item) {
    _items.add(item);
    notifyListeners(); // แจ้งทุกผู้ฟัง
  }
}

/// สาธิต ChangeNotifier + ListenableBuilder (ยังไม่ใช้แพ็กเกจ provider)
/// วิดเจ็ตสองตัวที่อยู่คนละกิ่งฟังโมเดลเดียวกัน จึงเห็นข้อมูลตรงกันเสมอ
class ListenableDemo extends StatefulWidget {
  const ListenableDemo({super.key});

  @override
  State<ListenableDemo> createState() => _ListenableDemoState();
}

class _ListenableDemoState extends State<ListenableDemo> {
  final DemoCart _cart = DemoCart(); // โมเดลของหน้านี้เท่านั้น

  @override
  void dispose() {
    _cart.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ListenableBuilder'),
        actions: [
          // กิ่งที่ 1: badge จำนวนแก้ว build ใหม่เฉพาะส่วนนี้
          ListenableBuilder(
            listenable: _cart,
            builder: (context, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text('${_cart.count} แก้ว', key: const Key('badge')),
            ),
          ),
        ],
      ),
      // กิ่งที่ 2: รายการในตะกร้า
      body: ListenableBuilder(
        listenable: _cart,
        builder: (context, _) => ListView(
          children: [
            for (final line in _cart.items)
              ListTile(title: Text(line.item.name)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'เพิ่มลาเต้',
        onPressed: () => _cart.add(OrderItem(item: sampleMenu.first)),
        child: const Icon(Icons.add),
      ),
    );
  }
}
