import 'package:cafe_core/cafe_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'router.dart';

// จุดเริ่มต้นของแอป: runApp() รับวิดเจ็ตราก
void main() {
  runApp(const CafeOrderApp());
}

/// วิดเจ็ตรากของแอป Café Order (แอปสั่งเครื่องดื่มร้านกาแฟของคณะ)
/// เก็บตะกร้าไว้ที่ราก (ยกสถานะขึ้น) แล้วส่งลงไปให้หน้าที่ต้องใช้ผ่าน router
class CafeOrderApp extends StatefulWidget {
  const CafeOrderApp({super.key, this.initialLocation = '/menu'});

  final String initialLocation;

  @override
  State<CafeOrderApp> createState() => _CafeOrderAppState();
}

class _CafeOrderAppState extends State<CafeOrderApp> {
  final List<OrderItem> _cart = [];
  late final GoRouter _router = createRouter(
    cart: _cart,
    initialLocation: widget.initialLocation,
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Café Order',
      debugShowCheckedModeBanner: false, // ไม่แสดงป้าย DEBUG
      theme: ThemeData(colorSchemeSeed: const Color(0xFF8D5A2B)),
      routerConfig: _router,
    );
  }
}
