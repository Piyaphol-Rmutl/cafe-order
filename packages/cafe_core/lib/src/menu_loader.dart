import 'dart:async';
import 'dart:convert';

import 'menu_item.dart';
import 'order.dart';

/// อ่านเมนูจากข้อความ JSON แบบอะซิงโครนัส (จำลองการอ่านไฟล์/เครือข่าย)
Future<List<MenuItem>> loadMenu(
  String jsonText, {
  Duration delay = const Duration(milliseconds: 300),
}) async {
  await Future<void>.delayed(delay); // จำลองว่าต้องรอ
  final list = jsonDecode(jsonText) as List<dynamic>;
  return [for (final e in list) MenuItem.fromJson(e as Map<String, dynamic>)];
}

/// จำลองความคืบหน้าของคำสั่งซื้อเป็น Stream (async* + yield)
Stream<OrderStatus> simulateOrderProgress({
  Duration step = const Duration(seconds: 2),
}) async* {
  for (final status in OrderStatus.values) {
    yield status;
    if (status.next != null) await Future<void>.delayed(step);
  }
}
