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
/// [cart] คือสถานะตะกร้าที่ยกขึ้นไปเก็บไว้ที่ราก แล้วส่งลงมาให้หน้าที่ใช้
GoRouter createRouter({
  required List<OrderItem> cart,
  required ValueChanged<ThemeMode> onThemeModeChanged,
  required ValueChanged<Locale> onLocaleChanged,
  String initialLocation = '/menu',
}) {
  final rootKey = GlobalKey<NavigatorState>();
  return GoRouter(
    navigatorKey: rootKey,
    initialLocation: initialLocation,
    routes: [
      GoRoute(path: '/', redirect: (_, _) => '/menu'),
      GoRoute(
        path: '/settings',
        builder: (context, state) => SettingsPage(
          onThemeModeChanged: onThemeModeChanged,
          onLocaleChanged: onLocaleChanged,
        ),
      ),
      // ShellRoute: หน้าลูกแสดงภายในโครงที่มีแถบนำทาง
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: '/menu',
            builder: (context, state) => MenuPage(onAdd: cart.add),
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
          GoRoute(
            path: '/cart',
            builder: (context, state) => CartPage(items: cart),
          ),
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
