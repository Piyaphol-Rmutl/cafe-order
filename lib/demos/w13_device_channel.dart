import 'package:flutter/material.dart';

import '../data/services/device_channel.dart';

/// สาธิต MethodChannel: เรียก Kotlin/Swift ที่เขียนเองใน MainActivity/AppDelegate
class DeviceChannelDemo extends StatefulWidget {
  const DeviceChannelDemo({super.key});

  @override
  State<DeviceChannelDemo> createState() => _DeviceChannelDemoState();
}

class _DeviceChannelDemoState extends State<DeviceChannelDemo> {
  final _device = const CafeDeviceChannel();
  String _result = '-';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MethodChannel')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_result, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () async {
                final level = await _device.batteryLevel();
                setState(
                  () => _result = level == null
                      ? 'อ่านแบตเตอรี่ไม่ได้'
                      : 'แบตเตอรี่ $level%',
                );
              },
              child: const Text('อ่านระดับแบตเตอรี่'),
            ),
            OutlinedButton(
              onPressed: () async {
                final ok = await _device.vibrate();
                setState(() => _result = ok ? 'สั่นแล้ว' : 'สั่นไม่ได้');
              },
              child: const Text('สั่น'),
            ),
          ],
        ),
      ),
    );
  }
}
