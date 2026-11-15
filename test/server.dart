// ตัวช่วย: ต่อ MockClient เข้ากับ Handler ของเซิร์ฟเวอร์จำลอง
// ทดสอบทั้งเส้นทาง แอป → http → เซิร์ฟเวอร์ ได้โดยไม่เปิดพอร์ตจริง
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shelf/shelf.dart' as shelf;

import '../tool/mock_server.dart';

const baseUrl = 'http://test.local';

/// ฟังก์ชันตอบคำร้องขอด้วย Handler ของ tool/mock_server.dart
MockClientHandler serverHandler({bool fail = false}) {
  final handler = createHandler(fail: fail);
  return (req) async {
    final res = await handler(
      shelf.Request(
        req.method,
        req.url,
        headers: req.headers,
        body: req.bodyBytes,
      ),
    );
    return http.Response.bytes(
      await res.read().expand((b) => b).toList(),
      res.statusCode,
      headers: res.headers,
    );
  };
}

MockClient fakeServer({bool fail = false}) =>
    MockClient(serverHandler(fail: fail));
