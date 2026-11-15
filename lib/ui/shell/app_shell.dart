import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../demos/demo_menu.dart';

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
    return Scaffold(
      // แท็บร้านมี SliverAppBar.large ของตัวเอง จึงไม่แสดงแถบหัวของเชลล์ซ้ำ
      appBar: _index == 2
          ? null
          : AppBar(
              title: const Text('Café Order'),
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
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.local_cafe),
                      label: Text('เมนู'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.shopping_cart),
                      label: Text('ตะกร้า'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.storefront),
                      label: Text('ร้าน'),
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
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.local_cafe),
                  label: 'เมนู',
                ),
                NavigationDestination(
                  icon: Icon(Icons.shopping_cart),
                  label: 'ตะกร้า',
                ),
                NavigationDestination(
                  icon: Icon(Icons.storefront),
                  label: 'ร้าน',
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
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Image.asset('assets/images/logo.png')),
          ListTile(
            leading: const Icon(Icons.local_cafe),
            title: const Text('เมนู'),
            onTap: () {
              Navigator.of(context).pop(); // ปิด Drawer ก่อน
              context.go('/menu');
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
