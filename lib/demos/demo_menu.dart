import 'package:flutter/material.dart';

import 'w01_hot_reload.dart';
import 'w01_lifecycle.dart';
import 'w04_layout.dart';
import 'w05_gestures.dart';
import 'w05_state_lifecycle.dart';
import 'w06_navigator.dart';
import 'w07_animation.dart';
import 'w07_cupertino.dart';

/// รายการจุดสาธิตที่ไม่ได้เป็นส่วนของแอปจริง (เปิดจากเมนูผู้พัฒนา)
final List<({String week, String title, WidgetBuilder builder})> demos = [
  (
    week: 'w01',
    title: 'Hot Reload กับสถานะ',
    builder: (_) => const HotReloadDemo(),
  ),
  (
    week: 'w01',
    title: 'วงจรชีวิตของแอป',
    builder: (_) => const LifecycleDemo(),
  ),
  (
    week: 'w04',
    title: 'เลย์เอาต์: Overflow, Constraints, Grid',
    builder: (_) => const LayoutDemo(),
  ),
  (
    week: 'w05',
    title: 'วงจรชีวิตของ State',
    builder: (_) => const StateLifecycleDemo(),
  ),
  (
    week: 'w05',
    title: 'ท่าทาง: แตะ กดค้าง ปัด',
    builder: (_) => const GestureDemo(),
  ),
  (
    week: 'w06',
    title: 'Navigator push/pop รับผลลัพธ์',
    builder: (_) => const NavigatorDemo(),
  ),
  (
    week: 'w07',
    title: 'AnimationController (Explicit)',
    builder: (_) => const AnimationDemo(),
  ),
  (
    week: 'w07',
    title: 'วิดเจ็ต Cupertino',
    builder: (_) => const CupertinoDemo(),
  ),
];

/// ปุ่มบนแถบด้านบนสำหรับเปิดเมนูผู้พัฒนา
class DemoMenuButton extends StatelessWidget {
  const DemoMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'เมนูผู้พัฒนา',
      icon: const Icon(Icons.developer_mode),
      onPressed: () => Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (_) => const DemoMenuPage())),
    );
  }
}

class DemoMenuPage extends StatelessWidget {
  const DemoMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เมนูผู้พัฒนา')),
      body: ListView(
        children: [
          for (final d in demos)
            ListTile(
              leading: CircleAvatar(child: Text(d.week.substring(1))),
              title: Text(d.title),
              onTap: () =>
                  Navigator.of(context)
                      .push(MaterialPageRoute<void>(builder: d.builder)),
            ),
        ],
      ),
    );
  }
}
