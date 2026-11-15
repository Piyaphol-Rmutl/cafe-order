import 'package:flutter/material.dart';

/// สาธิตวงจรชีวิตของแอป: กด Home/สลับแอปแล้วกลับมา จะเห็นลำดับสถานะ
/// resumed → inactive → hidden → paused → … → resumed
class LifecycleDemo extends StatefulWidget {
  const LifecycleDemo({super.key});

  @override
  State<LifecycleDemo> createState() => _LifecycleDemoState();
}

class _LifecycleDemoState extends State<LifecycleDemo> {
  late final AppLifecycleListener _listener;
  final List<String> _log = [];

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onStateChange: (state) {
        debugPrint('lifecycle: ${state.name}'); // ดูใน Debug Console
        setState(() => _log.add(state.name));
      },
    );
  }

  @override
  void dispose() {
    _listener.dispose(); // เลิกฟังเมื่อออกจากหน้า
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('วงจรชีวิตของแอป')),
      body: ListView(
        children: [
          for (final (i, name) in _log.indexed)
            ListTile(leading: Text('${i + 1}'), title: Text(name)),
        ],
      ),
    );
  }
}
