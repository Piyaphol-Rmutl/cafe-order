import 'package:flutter/material.dart';

import 'ui/home/home_page.dart';

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
