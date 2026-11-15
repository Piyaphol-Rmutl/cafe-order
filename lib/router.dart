import 'package:cafe_core/cafe_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'ui/cart/cart_page.dart';
import 'ui/customize/customize_page.dart';
import 'ui/menu/menu_page.dart';
import 'ui/settings/settings_page.dart';
import 'ui/shell/app_shell.dart';
import 'ui/shop/shop_page.dart';

/// สร้างตัวจัดเส้นทาง (ฟังก์ชัน จึงสร้างใหม่ได้ในแต่ละ Widget Test)
/// สัปดาห์ 8: สถานะอยู่ใน Provider แล้ว router จึงไม่ต้องส่งต่อสถานะใด ๆ
GoRouter createRouter({String initialLocation = '/menu'}) {
  final rootKey = GlobalKey<NavigatorState>();
  return GoRouter(
    navigatorKey: rootKey,
    initialLocation: initialLocation,
    routes: [
      GoRoute(path: '/', redirect: (_, _) => '/menu'),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      // ShellRoute: หน้าลูกแสดงภายในโครงที่มีแถบนำทาง
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: '/menu',
            builder: (context, state) => const MenuPage(),
            routes: [
              // /menu/:id วางบน Navigator ราก จึงคลุมแถบนำทาง
              GoRoute(
                path: ':id',
                parentNavigatorKey: rootKey,
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  final item = sampleMenu.where((m) => m.id == id).firstOrNull;
                  if (item == null) return const NotFoundPage();
                  return CustomizePage(item: item);
                },
              ),
            ],
          ),
          GoRoute(path: '/cart', builder: (context, state) => const CartPage()),
          GoRoute(path: '/shop', builder: (context, state) => const ShopPage()),
        ],
      ),
    ],
  );
}

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(child: Text('ไม่พบเมนูนี้')),
    );
  }
}
