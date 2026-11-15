import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// ค่าตั้งต้นของทุกเทสต์: จอขนาดโทรศัพท์ 390×844 (ค่าเริ่มต้น 800×600 เป็นจอกว้าง)
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    final view = binding.platformDispatcher.implicitView!;
    view.physicalSize = const Size(1170, 2532);
    view.devicePixelRatio = 3;
  });
  await testMain();
}
