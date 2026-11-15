import 'package:cafe_core/cafe_core.dart';
import 'package:flutter/cupertino.dart';

/// สาธิตวิดเจ็ต Cupertino (หน้าตาแบบ iOS) เทียบกับ Material ในแอป
class CupertinoDemo extends StatefulWidget {
  const CupertinoDemo({super.key});

  @override
  State<CupertinoDemo> createState() => _CupertinoDemoState();
}

class _CupertinoDemoState extends State<CupertinoDemo> {
  CupSize _size = CupSize.medium;
  bool _iced = true;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Cupertino')),
      // แอปนี้เป็น MaterialApp จึงไม่มีสไตล์ข้อความแบบ Cupertino ให้ลูก
      // ถ้าไม่กำหนด ข้อความใน segmented control จะเป็นตัวแดงขีดเส้นใต้เหลือง
      child: DefaultTextStyle(
        style: CupertinoTheme.of(context).textTheme.textStyle,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              CupertinoSlidingSegmentedControl<CupSize>(
                groupValue: _size,
                children: {for (final s in CupSize.values) s: Text(s.label)},
                onValueChanged: (s) => setState(() => _size = s!),
              ),
              const SizedBox(height: 16),
              CupertinoListTile(
                title: const Text('เย็น'),
                trailing: CupertinoSwitch(
                  value: _iced,
                  onChanged: (v) => setState(() => _iced = v),
                ),
              ),
              const SizedBox(height: 16),
              CupertinoButton.filled(
                onPressed: () {},
                child: Text('สั่ง ${_size.label} ${_iced ? 'เย็น' : 'ร้อน'}'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
