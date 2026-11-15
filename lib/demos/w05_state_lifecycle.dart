import 'package:flutter/material.dart';

/// สาธิตวงจรชีวิตของ State: กดปุ่มแล้วดูลำดับเมธอดที่ถูกเรียก
/// (บันทึกลง debugPrint และแสดงในหน้าจอ)
class StateLifecycleDemo extends StatefulWidget {
  const StateLifecycleDemo({super.key});

  @override
  State<StateLifecycleDemo> createState() => _StateLifecycleDemoState();
}

class _StateLifecycleDemoState extends State<StateLifecycleDemo> {
  final List<String> log = [];
  bool _showCup = true;
  int _shots = 1;

  void _add(String line) {
    debugPrint(line);
    log.add(line);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('วงจรชีวิตของ State')),
      body: Column(
        children: [
          Wrap(
            spacing: 8,
            children: [
              // เปลี่ยนค่าที่ส่งให้ลูก → ลูกได้ didUpdateWidget
              OutlinedButton(
                onPressed: () => setState(() => _shots++),
                child: const Text('เพิ่มช็อต (ส่งค่าใหม่ให้ลูก)'),
              ),
              // ถอดลูกออกจากต้นไม้ → deactivate + dispose
              OutlinedButton(
                onPressed: () => setState(() => _showCup = !_showCup),
                child: Text(_showCup ? 'ถอดแก้วออก' : 'ใส่แก้วกลับ'),
              ),
            ],
          ),
          if (_showCup) CupWidget(shots: _shots, log: _add),
          const Divider(),
          Expanded(
            child: ListView(
              children: [for (final line in log.reversed) Text(line)],
            ),
          ),
        ],
      ),
    );
  }
}

/// ลูกที่บันทึกทุกเมธอดในวงจรชีวิต
class CupWidget extends StatefulWidget {
  const CupWidget({super.key, required this.shots, required this.log});

  final int shots;
  final void Function(String) log;

  // ปกติห้ามใส่ตรรกะใน createState ที่นี่บันทึกเพื่อการสาธิตเท่านั้น
  @override
  // ignore: no_logic_in_create_state
  State<CupWidget> createState() {
    log('1 createState');
    return _CupWidgetState();
  }
}

class _CupWidgetState extends State<CupWidget> {
  int _sips = 0;

  @override
  void initState() {
    super.initState();
    widget.log('2 initState'); // ครั้งเดียว: เตรียม controller, subscription
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.log('3 didChangeDependencies'); // Theme/MediaQuery ที่ใช้เปลี่ยน
  }

  @override
  void didUpdateWidget(CupWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.log('didUpdateWidget: ${oldWidget.shots} → ${widget.shots} ช็อต');
  }

  @override
  void deactivate() {
    widget.log('deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    widget.log('dispose'); // คืนทรัพยากร
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.log('4 build (จิบไป $_sips)');
    return ListTile(
      leading: const Icon(Icons.coffee),
      title: Text('${widget.shots} ช็อต · จิบไป $_sips ครั้ง'),
      trailing: TextButton(
        // setState → build ใหม่เฉพาะวิดเจ็ตนี้
        onPressed: () => setState(() => _sips++),
        child: const Text('จิบ (setState)'),
      ),
    );
  }
}
