import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'data/repositories/branch_repository.dart';
import 'data/repositories/order_repository.dart';
import 'data/services/location_service.dart';
import 'ui/auth/auth_view_model.dart';
import 'ui/auth/login_page.dart';
import 'ui/barista/barista_page.dart';
import 'ui/branches/nearest_branch_page.dart';
import 'ui/branches/nearest_branch_view_model.dart';
import 'ui/cart/cart_page.dart';
import 'ui/customize/customize_page.dart';
import 'ui/menu/menu_page.dart';
import 'ui/menu/menu_view_model.dart';
import 'ui/orders/order_history_page.dart';
import 'ui/orders/order_history_view_model.dart';
import 'ui/orders/order_status_page.dart';
import 'ui/review/review_page.dart';
import 'ui/settings/settings_page.dart';
import 'ui/shell/app_shell.dart';
import 'ui/shop/shop_page.dart';

/// สร้างตัวจัดเส้นทาง (ฟังก์ชัน จึงสร้างใหม่ได้ในแต่ละ Widget Test)
/// สัปดาห์ 8: สถานะอยู่ใน Provider แล้ว router จึงไม่ต้องส่งต่อสถานะใด ๆ
/// สัปดาห์ 12: AuthGate ที่ราก — ยังไม่เข้าสู่ระบบถูกส่งไป /login เสมอ
GoRouter createRouter({
  required AuthViewModel auth,
  String initialLocation = '/menu',
}) {
  final rootKey = GlobalKey<NavigatorState>();
  return GoRouter(
    navigatorKey: rootKey,
    initialLocation: initialLocation,
    refreshListenable: auth, // เข้า/ออกจากระบบ → ประเมิน redirect ใหม่
    redirect: (context, state) {
      final atLogin = state.matchedLocation == '/login';
      if (!auth.isSignedIn) return atLogin ? null : '/login';
      if (atLogin) return '/menu';
      if (state.matchedLocation == '/barista' && !auth.isBarista) {
        return '/menu';
      }
      return null; // ไม่เปลี่ยนเส้นทาง
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/status/:id',
        builder: (context, state) =>
            OrderStatusPage(orderId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/branches',
        builder: (context, state) => ChangeNotifierProvider(
          create: (context) => NearestBranchViewModel(
            context.read<LocationService>(),
            context.read<BranchRepository>(),
          )..load(),
          child: const NearestBranchPage(),
        ),
      ),
      GoRoute(
        path: '/review/:id',
        builder: (context, state) =>
            ReviewPage(orderId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/barista',
        builder: (context, state) => const BaristaPage(),
      ),
      GoRoute(path: '/', redirect: (_, _) => '/menu'),
      GoRoute(
        path: '/orders',
        // ViewModel ของหน้านี้สร้างเมื่อเปิดหน้า และถูก dispose เมื่อปิดหน้า
        builder: (context, state) => ChangeNotifierProvider(
          create: (context) =>
              OrderHistoryViewModel(context.read<OrderRepository>())..load(),
          child: const OrderHistoryPage(),
        ),
      ),
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
                  final menu = context.watch<MenuViewModel>();
                  if (menu.loading) return const _LoadingPage();
                  final item = menu.findById(id);
                  if (item == null) return const NotFoundPage();
                  return CustomizePage(
                    item: item,
                    isFavorite: menu.isFavorite(id),
                    onToggleFavorite: () => menu.toggleFavorite(id),
                  );
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

class _LoadingPage extends StatelessWidget {
  const _LoadingPage();

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}
