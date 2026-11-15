import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;

import 'api_exception.dart';
import 'token_store.dart';

/// Service คุยกับ REST API ของร้านผ่านแพ็กเกจ http
/// รับ http.Client จากภายนอก ชุดทดสอบจึงส่ง MockClient เข้ามาแทนได้
class ApiService {
  ApiService({
    required this.baseUrl,
    http.Client? client,
    this.timeout = const Duration(seconds: 5),
    this.tokens,
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final Duration timeout;
  final http.Client _client;

  /// สัปดาห์ 15: โทเค็นของเครื่องสำหรับ API ที่ต้องยืนยันตัวตน
  final TokenStore? tokens;

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

  /// สัปดาห์ 15: GET ที่ต้องแนบโทเค็น (Authorization: Bearer ...)
  /// ยังไม่มีโทเค็น → ลงทะเบียนเครื่องก่อน, โทเค็นหมดอายุ (401) → ขอใหม่หนึ่งครั้ง
  Future<Object?> getJsonAuthorized(String path) async {
    for (var attempt = 0; attempt < 2; attempt++) {
      final token = await _deviceToken();
      final res = await _send(
        () => _client.get(
          Uri.parse('$baseUrl$path'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (res.statusCode == 401 && attempt == 0) {
        await tokens!.delete(); // โทเค็นเดิมใช้ไม่ได้แล้ว
        continue;
      }
      return _decode(res, expected: 200);
    }
    throw const ApiException('ยืนยันตัวตนไม่สำเร็จ', statusCode: 401);
  }

  Future<String> _deviceToken() async {
    final store = tokens;
    if (store == null) throw StateError('ApiService ไม่ได้รับ TokenStore');
    final saved = await store.read();
    if (saved != null) return saved;
    final json = await postJson('/devices', {'platform': 'flutter'});
    final token = (json as Map)['token'] as String;
    await store.write(token); // เก็บใน secure storage ไม่ใช่ shared_preferences
    return token;
  }

  /// POST ส่ง JSON แล้วคืน JSON ที่ได้ (ค่าตั้งต้นคาดรหัส 201 Created)
  Future<Object?> postJson(
    String path,
    Object body, {
    int expected = 201,
  }) async {
    final res = await _send(
      () => _client.post(
        Uri.parse('$baseUrl$path'),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode(body),
      ),
    );
    return _decode(res, expected: expected);
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
