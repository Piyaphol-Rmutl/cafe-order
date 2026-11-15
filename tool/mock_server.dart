// เซิร์ฟเวอร์ REST API จำลองของร้าน Café Order (Dart ล้วน ใช้แพ็กเกจ shelf)
// รัน: dart run tool/mock_server.dart [--port=8080] [--delay=0] [--fail]
//   --delay=มิลลิวินาที  หน่วงทุกคำตอบ (ทดลอง Timeout)
//   --fail              ตอบ 500 ทุกคำร้องขอ (ทดลองข้อผิดพลาด)
//
//   GET  /menu          รายการเมนู
//   GET  /branches      รายการสาขา
//   POST /orders        สร้างคำสั่งซื้อ  body: {"items": [OrderItem.toJson()...]}
//   GET  /orders/{id}   คำสั่งซื้อตามรหัส
//   POST /devices       ลงทะเบียนเครื่อง ได้โทเค็น (สัปดาห์ 15)
//   GET  /me/points     แต้มสะสม ต้องแนบ Authorization: Bearer <โทเค็น>
import 'dart:convert';
import 'dart:io';

import 'package:cafe_core/cafe_core.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

Response _json(int status, Object? body) => Response(
  status,
  body: jsonEncode(body),
  headers: {'content-type': 'application/json; charset=utf-8'},
);

/// สร้าง Handler (ชุดทดสอบเรียกใช้ตรง ๆ ได้โดยไม่เปิดพอร์ต)
Handler createHandler({Duration delay = Duration.zero, bool fail = false}) {
  final orders = <String, Order>{};
  final devices = <String, int>{}; // โทเค็น → แต้มสะสม

  Future<Response> handle(Request req) async {
    if (delay > Duration.zero) await Future<void>.delayed(delay);
    if (fail) return _json(500, {'error': 'เซิร์ฟเวอร์ขัดข้อง'});

    final seg = req.url.pathSegments;
    final route = '${req.method} /${seg.isEmpty ? '' : seg.first}';
    switch (route) {
      case 'GET /menu':
        return _json(200, [for (final m in sampleMenu) m.toJson()]);
      case 'GET /branches':
        return _json(200, [for (final b in sampleBranches) b.toJson()]);
      case 'GET /orders' when seg.length == 2:
        final order = orders[seg[1]];
        return order == null
            ? _json(404, {'error': 'ไม่พบคำสั่งซื้อ ${seg[1]}'})
            : _json(200, order.toJson());
      case 'POST /orders':
        final List<OrderItem> items;
        try {
          final body = jsonDecode(await req.readAsString()) as Map;
          items = [
            for (final i in body['items'] as List)
              OrderItem.fromJson(i as Map<String, dynamic>),
          ];
        } catch (_) {
          return _json(400, {'error': 'ข้อมูลคำสั่งซื้อไม่ถูกต้อง'});
        }
        if (items.isEmpty) return _json(400, {'error': 'ไม่มีรายการ'});
        // เซิร์ฟเวอร์กำหนดรหัสและคำนวณราคาเอง (ไม่เชื่อราคาจากแอป)
        final id = 'S${(orders.length + 1).toString().padLeft(3, '0')}';
        final order = Order(id: id, items: items);
        orders[id] = order;
        return _json(201, order.toJson());
      case 'POST /devices':
        final token = 'dev-${DateTime.now().microsecondsSinceEpoch}';
        devices[token] = 120; // แต้มตั้งต้นสำหรับสาธิต
        return _json(201, {'token': token});
      case 'GET /me' when seg.length == 2 && seg[1] == 'points':
        final auth = req.headers['authorization'] ?? '';
        final token = auth.startsWith('Bearer ') ? auth.substring(7) : '';
        final points = devices[token];
        return points == null
            ? _json(401, {'error': 'ต้องยืนยันตัวตน'})
            : _json(200, {'points': points});
      default:
        return _json(404, {'error': 'ไม่พบเส้นทาง $route'});
    }
  }

  return handle;
}

Future<void> main(List<String> args) async {
  String? opt(String name) => args
      .where((a) => a.startsWith('--$name='))
      .map((a) => a.split('=').last)
      .firstOrNull;
  final port = int.parse(opt('port') ?? '8080');
  final delay = Duration(milliseconds: int.parse(opt('delay') ?? '0'));

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(createHandler(delay: delay, fail: args.contains('--fail')));
  final server = await io.serve(handler, InternetAddress.anyIPv6, port);
  stdout.writeln('API จำลองพร้อมที่ http://localhost:${server.port}');
}
