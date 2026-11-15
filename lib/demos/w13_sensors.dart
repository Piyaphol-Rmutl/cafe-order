import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// สาธิต sensors_plus: แสดงความเร่ง x, y, z และนับการเขย่า
/// Android Emulator: Extended controls → Virtual sensors หรือ
///   adb emu sensor set acceleration 0:15:9.8
/// iOS Simulator ไม่มีเซนเซอร์ความเร่ง (Stream ไม่ส่งค่า)
class SensorsDemo extends StatefulWidget {
  const SensorsDemo({super.key, this.events});

  /// ส่ง Stream ทดแทนได้ตอนทดสอบ
  final Stream<AccelerometerEvent>? events;

  @override
  State<SensorsDemo> createState() => _SensorsDemoState();
}

class _SensorsDemoState extends State<SensorsDemo> {
  StreamSubscription<AccelerometerEvent>? _sub;
  AccelerometerEvent? _last;
  int _shakes = 0;

  @override
  void initState() {
    super.initState();
    final events =
        widget.events ??
        accelerometerEventStream(samplingPeriod: SensorInterval.uiInterval);
    _sub = events.listen((e) {
      // ขนาดความเร่งเกิน ~2.5g ถือว่าเขย่า
      final g = math.sqrt(e.x * e.x + e.y * e.y + e.z * e.z) / 9.81;
      setState(() {
        _last = e;
        if (g > 2.5) _shakes++;
      });
    });
  }

  @override
  void dispose() {
    _sub?.cancel(); // หยุดฟังเซนเซอร์เมื่อออกจากหน้า (ประหยัดแบตเตอรี่)
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final e = _last;
    return Scaffold(
      appBar: AppBar(title: const Text('เซนเซอร์ความเร่ง')),
      body: Center(
        child: Text(
          e == null
              ? 'ยังไม่มีข้อมูลจากเซนเซอร์'
              : 'x=${e.x.toStringAsFixed(1)} y=${e.y.toStringAsFixed(1)} '
                    'z=${e.z.toStringAsFixed(1)}\nเขย่า $_shakes ครั้ง',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
