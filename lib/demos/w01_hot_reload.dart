import 'package:flutter/material.dart';

/// สาธิต Hot Reload: กดเพิ่มตัวเลข แล้วแก้ข้อความ/สีในโค้ดและกด Hot Reload
/// ตัวเลขยังอยู่ (สถานะไม่หาย) แต่ถ้า Hot Restart ตัวเลขกลับเป็น 0
class HotReloadDemo extends StatefulWidget {
  const HotReloadDemo({super.key});

  @override
  State<HotReloadDemo> createState() => _HotReloadDemoState();
}

class _HotReloadDemoState extends State<HotReloadDemo> {
  int _cups = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hot Reload')),
      body: Center(
        child: Text(
          'ชงไปแล้ว $_cups แก้ว', // ลองแก้ข้อความนี้แล้ว Hot Reload
          style: const TextStyle(fontSize: 28, color: Colors.brown),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _cups++),
        child: const Icon(Icons.add),
      ),
    );
  }
}
