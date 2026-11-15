import 'package:flutter/material.dart';

/// สาธิต InheritedWidget: กลไกที่ provider ใช้อยู่เบื้องหลัง
/// ส่งข้อมูลลงไปให้ลูกหลานทุกชั้นโดยไม่ต้องส่งผ่านคอนสตรักเตอร์ทีละชั้น
class ShopScope extends InheritedWidget {
  const ShopScope({super.key, required this.shopName, required super.child});

  final String shopName;

  /// ลูกหลานเรียก ShopScope.of(context) แล้วจะถูก build ใหม่เมื่อค่าเปลี่ยน
  static ShopScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ShopScope>()!;

  @override
  bool updateShouldNotify(ShopScope oldWidget) =>
      oldWidget.shopName != shopName;
}

class InheritedDemo extends StatefulWidget {
  const InheritedDemo({super.key});

  @override
  State<InheritedDemo> createState() => _InheritedDemoState();
}

class _InheritedDemoState extends State<InheritedDemo> {
  bool _branch2 = false;

  @override
  Widget build(BuildContext context) {
    return ShopScope(
      shopName: _branch2 ? 'สาขาหอพัก' : 'สาขาวิศวะ',
      child: Scaffold(
        appBar: AppBar(title: const Text('InheritedWidget')),
        // _Level1 → _Level2 → _ShopLabel: ไม่มีชั้นไหนรับ shopName ทางคอนสตรักเตอร์
        body: const _Level1(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => setState(() => _branch2 = !_branch2),
          label: const Text('สลับสาขา'),
        ),
      ),
    );
  }
}

class _Level1 extends StatelessWidget {
  const _Level1();
  @override
  Widget build(BuildContext context) => const Center(child: _Level2());
}

class _Level2 extends StatelessWidget {
  const _Level2();
  @override
  Widget build(BuildContext context) => const Card(child: _ShopLabel());
}

class _ShopLabel extends StatelessWidget {
  const _ShopLabel();
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: Text('ร้าน: ${ShopScope.of(context).shopName}'),
  );
}
