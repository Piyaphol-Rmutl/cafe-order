import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../demos/demo_menu.dart';
import '../auth/auth_view_model.dart';
import '../cart/cart_view_model.dart';
import '../l10n_ext.dart';

/// โครงของแอป: แถบนำทาง 3 แท็บ (เมนู ตะกร้า ร้าน) + Drawer
/// จอกว้าง ≥ 840 ใช้ NavigationRail ด้านซ้าย จอแคบใช้ NavigationBar ด้านล่าง
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  static const _paths = ['/menu', '/cart', '/shop'];

  int get _index {
    final i = _paths.indexWhere(location.startsWith);
    return i < 0 ? 0 : i;
  }

  void _go(BuildContext context, int i) => context.go(_paths[i]);

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 840;
    final l10n = context.l10n;
    // select: build ใหม่เฉพาะเมื่อ "จำนวน" เปลี่ยน ไม่ใช่ทุกครั้งที่ตะกร้าเปลี่ยน
    final count = context.select<CartViewModel, int>((cart) => cart.count);
    final cartIcon = Badge.count(
      count: count,
      isLabelVisible: count > 0,
      child: const Icon(Icons.shopping_cart),
    );
    return Scaffold(
      // แท็บร้านมี SliverAppBar.large ของตัวเอง จึงไม่แสดงแถบหัวของเชลล์ซ้ำ
      appBar: _index == 2
          ? null
          : AppBar(
              title: Text(l10n.appTitle),
              actions: const [DemoMenuButton()],
            ),
      drawer: const _AppDrawer(),
      body: wide
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: _index,
                  onDestinationSelected: (i) => _go(context, i),
                  labelType: NavigationRailLabelType.all,
                  destinations: [
                    NavigationRailDestination(
                      icon: const Icon(Icons.local_cafe),
                      label: Text(l10n.tabMenu),
                    ),
                    NavigationRailDestination(
                      icon: cartIcon,
                      label: Text(l10n.tabCart),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.storefront),
                      label: Text(l10n.tabShop),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: child),
              ],
            )
          : child,
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (i) => _go(context, i),
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.local_cafe),
                  label: l10n.tabMenu,
                ),
                NavigationDestination(icon: cartIcon, label: l10n.tabCart),
                NavigationDestination(
                  icon: const Icon(Icons.storefront),
                  label: l10n.tabShop,
                ),
              ],
            ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Image.asset('assets/images/logo.png')),
          ListTile(
            leading: const Icon(Icons.local_cafe),
            title: Text(context.l10n.tabMenu),
            onTap: () {
              Navigator.of(context).pop(); // ปิด Drawer ก่อน
              context.go('/menu');
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: Text(context.l10n.orderHistory),
            onTap: () {
              Navigator.of(context).pop();
              context.push('/orders');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(context.l10n.settings),
            onTap: () {
              Navigator.of(context).pop();
              context.push('/settings');
            },
          ),
          // สัปดาห์ 12: เมนูบาริสต้าเห็นเฉพาะบัญชีบาริสต้า
          if (auth.isBarista)
            ListTile(
              leading: const Icon(Icons.coffee_maker),
              title: Text(context.l10n.barista),
              onTap: () {
                Navigator.of(context).pop();
                context.push('/barista');
              },
            ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(context.l10n.signOut),
            subtitle: Text(auth.user?.email ?? ''),
            onTap: () {
              Navigator.of(context).pop();
              auth.signOut(); // router จะ redirect ไป /login เอง
            },
          ),
          ListTile(
            leading: const Icon(Icons.developer_mode),
            title: const Text('เมนูผู้พัฒนา'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const DemoMenuPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
