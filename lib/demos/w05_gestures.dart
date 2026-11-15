import 'package:flutter/material.dart';

/// สาธิต GestureDetector: แตะ แตะสองครั้ง กดค้าง และปัด บนแก้วกาแฟ
class GestureDemo extends StatefulWidget {
  const GestureDemo({super.key});

  @override
  State<GestureDemo> createState() => _GestureDemoState();
}

class _GestureDemoState extends State<GestureDemo> {
  String _last = 'ลองแตะ แตะสองครั้ง กดค้าง หรือปัดซ้าย/ขวาที่แก้ว';
  bool _favorite = false;
  int _shots = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ท่าทาง (Gesture)')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => setState(() => _last = 'แตะ (onTap)'),
              onDoubleTap: () => setState(() {
                _favorite = !_favorite;
                _last = 'แตะสองครั้ง: ${_favorite ? 'ถูกใจ' : 'เลิกถูกใจ'}';
              }),
              onLongPress: () => setState(() => _last = 'กดค้าง (onLongPress)'),
              // ปัดแนวนอน: ดูความเร็วตอนปล่อยนิ้วว่าไปทางซ้ายหรือขวา
              onHorizontalDragEnd: (details) => setState(() {
                final v = details.primaryVelocity ?? 0;
                if (v > 0) _shots++;
                if (v < 0 && _shots > 1) _shots--;
                _last = 'ปัด${v > 0 ? 'ขวา' : 'ซ้าย'}: $_shots ช็อต';
              }),
              child: Icon(
                Icons.coffee,
                key: const Key('cup'),
                size: 160,
                color: _favorite ? Colors.red : Colors.brown,
              ),
            ),
            const SizedBox(height: 24),
            Text(_last, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
