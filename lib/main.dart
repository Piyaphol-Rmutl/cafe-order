import 'package:flutter/material.dart';

import 'demos/demo_menu.dart';

// จุดเริ่มต้นของแอป: runApp() รับวิดเจ็ตราก
void main() {
  runApp(const CafeOrderApp());
}

/// วิดเจ็ตรากของแอป Café Order (แอปสั่งเครื่องดื่มร้านกาแฟของคณะ)
class CafeOrderApp extends StatelessWidget {
  const CafeOrderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Café Order',
      debugShowCheckedModeBanner: false, // ไม่แสดงป้าย DEBUG
      theme: ThemeData(colorSchemeSeed: const Color(0xFF8D5A2B)),
      home: const HomePage(),
    );
  }
}

/// หน้าแรก (สัปดาห์ 1 ยังเป็นหน้าว่าง) ลองแก้ข้อความแล้วกด Hot Reload
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Café Order'),
        actions: const [DemoMenuButton()],
      ),
      body: const Center(
        child: Text('ร้านกาแฟคณะวิศวกรรมศาสตร์ — เร็ว ๆ นี้'),
      ),
    );
  }
}
