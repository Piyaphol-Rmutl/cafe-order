import 'package:flutter/material.dart';

import '../ui/widgets/brewing_indicator.dart';

/// สาธิตแอนิเมชันแบบ Explicit: ควบคุม AnimationController เอง
class AnimationDemo extends StatefulWidget {
  const AnimationDemo({super.key});

  @override
  State<AnimationDemo> createState() => _AnimationDemoState();
}

class _AnimationDemoState extends State<AnimationDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AnimationController')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BrewingIndicator(size: 96, controller: _controller),
            // AnimatedBuilder สร้างใหม่ทุกเฟรมที่ค่าเปลี่ยน
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) =>
                  Text('value = ${_controller.value.toStringAsFixed(2)}'),
            ),
            Wrap(
              spacing: 8,
              children: [
                FilledButton(
                  onPressed: () => _controller.repeat(reverse: true),
                  child: const Text('เล่นวน'),
                ),
                OutlinedButton(
                  onPressed: _controller.stop,
                  child: const Text('หยุด'),
                ),
                OutlinedButton(
                  onPressed: _controller.reverse,
                  child: const Text('ย้อนกลับ'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
