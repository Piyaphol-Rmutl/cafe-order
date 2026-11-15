import 'package:flutter/material.dart';

/// แอนิเมชันแบบ Explicit: ไอน้ำเหนือแก้วกาแฟลอยขึ้นลงวนซ้ำ
/// ต้องมี AnimationController เอง (เริ่ม หยุด ย้อนกลับได้) และต้อง dispose
class BrewingIndicator extends StatefulWidget {
  const BrewingIndicator({super.key, this.size = 64, this.controller});

  final double size;

  /// ส่ง controller จากภายนอกได้ (หน้าสาธิตใช้ควบคุมเล่น/หยุด)
  final AnimationController? controller;

  @override
  State<BrewingIndicator> createState() => _BrewingIndicatorState();
}

class _BrewingIndicatorState extends State<BrewingIndicator>
    with SingleTickerProviderStateMixin {
  // vsync: this = ใช้ Ticker ของ State นี้ หยุดเองเมื่อมองไม่เห็น
  late final AnimationController _own = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  AnimationController get _controller => widget.controller ?? _own;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) _own.repeat(reverse: true);
  }

  @override
  void dispose() {
    _own.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    // Tween แปลงค่า 0..1 ของ controller เป็นระยะเลื่อนและความทึบ
    final rise = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.3),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    return Semantics(
      label: 'กำลังชง',
      child: SizedBox(
        width: widget.size,
        height: widget.size * 1.4,
        child: Column(
          children: [
            SlideTransition(
              position: rise,
              child: FadeTransition(
                opacity: ReverseAnimation(_controller),
                child: Icon(Icons.air, size: widget.size * 0.4, color: color),
              ),
            ),
            Icon(Icons.coffee, size: widget.size, color: color),
          ],
        ),
      ),
    );
  }
}
