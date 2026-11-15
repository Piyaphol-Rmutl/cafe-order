import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;

import 'api_exception.dart';

/// Service คุยกับ REST API ของร้านผ่านแพ็กเกจ http
/// รับ http.Client จากภายนอก ชุดทดสอบจึงส่ง MockClient เข้ามาแทนได้
class ApiService {
  ApiService({
    required this.baseUrl,
    http.Client? client,
    this.timeout = const Duration(seconds: 5),
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final Duration timeout;
  final http.Client _client;

  /// GET แล้วคืน JSON ที่ถอดรหัสแล้ว (คาดรหัส 200)
  Future<Object?> getJson(String path) async {
    final res = await _send(
      () => _client.get(
        Uri.parse('$baseUrl$path'),
        headers: {'Accept': 'application/json'},
      ),
    );
    return _decode(res, expected: 200);
  }

  /// POST ส่ง JSON แล้วคืน JSON ที่ได้ (คาดรหัส 201 Created)
  Future<Object?> postJson(String path, Object body) async {
    final res = await _send(
      () => _client.post(
        Uri.parse('$baseUrl$path'),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode(body),
      ),
    );
    return _decode(res, expected: 201);
  }

  /// กำหนดเวลา และแปลงข้อผิดพลาดของเครือข่ายเป็น ApiException
  Future<http.Response> _send(Future<http.Response> Function() request) async {
    final watch = Stopwatch()..start();
    try {
      final res = await request().timeout(timeout);
      // สัปดาห์ 14: บันทึกทุกคำร้องขอ (ดูใน DevTools → Logging และ Network)
      developer.log(
        '${res.request?.method} ${res.request?.url} → ${res.statusCode} '
        '(${watch.elapsedMilliseconds} ms)',
        name: 'cafe.api',
      );
      return res;
    } on TimeoutException {
      throw const ApiException('เซิร์ฟเวอร์ไม่ตอบภายในเวลาที่กำหนด');
    } on http.ClientException {
      throw const ApiException('เชื่อมต่อเซิร์ฟเวอร์ไม่ได้');
    }
  }

  /// ตรวจรหัสสถานะ แล้วถอดรหัส UTF-8 เอง (ภาษาไทยจึงไม่เพี้ยน)
  Object? _decode(http.Response res, {required int expected}) {
    Object? body;
    try {
      body = jsonDecode(utf8.decode(res.bodyBytes));
    } on FormatException {
      body = null;
    }
    if (res.statusCode != expected) {
      final message = body is Map && body['error'] is String
          ? body['error'] as String
          : 'เซิร์ฟเวอร์ตอบรหัส ${res.statusCode}';
      throw ApiException(message, statusCode: res.statusCode);
    }
    if (body == null) {
      throw const ApiException('ข้อมูลจากเซิร์ฟเวอร์ผิดรูปแบบ');
    }
    return body;
  }

  void close() => _client.close();
}

/// แปลง JSON เป็นโมเดล ถ้าชนิดไม่ตรงให้เป็น ApiException
T parseOrThrow<T>(T Function() convert) {
  try {
    return convert();
  } on TypeError {
    throw const ApiException('ข้อมูลจากเซิร์ฟเวอร์ผิดรูปแบบ');
  }
}
