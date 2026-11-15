// ตรวจ firestore.rules กับ Firestore Emulator ผ่าน REST API
// ใช้งาน: firebase emulators:exec --project demo-cafe-order "dart run tool/rules_check.dart"
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

const project = 'demo-cafe-order';
const authUrl = 'http://127.0.0.1:9199';
const dbUrl = 'http://127.0.0.1:8180';
const root = 'projects/$project/databases/(default)/documents';

/// สมัครผู้ใช้ใน Auth Emulator คืน (uid, idToken)
Future<(String, String)> signUp(String email) async {
  final res = await http.post(
    Uri.parse(
      '$authUrl/identitytoolkit.googleapis.com/v1/accounts:signUp?key=demo',
    ),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'password': 'secret123',
      'returnSecureToken': true,
    }),
  );
  final body = jsonDecode(res.body) as Map<String, dynamic>;
  return (body['localId'] as String, body['idToken'] as String);
}

Map<String, Object> value(Object v) => switch (v) {
  int() => {'integerValue': '$v'},
  List() => {
    'arrayValue': {
      'values': [for (final e in v) value(e)],
    },
  },
  Map() => {
    'mapValue': {
      'fields': {
        for (final e in v.entries) e.key as String: value(e.value as Object),
      },
    },
  },
  _ => {'stringValue': '$v'},
};

Future<bool> commit(String? token, Map<String, Object> write) async {
  final res = await http.post(
    Uri.parse('$dbUrl/v1/$root:commit'),
    headers: {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'writes': [write],
    }),
  );
  return res.statusCode == 200;
}

Map<String, Object> createDoc(String id, Map<String, Object> fields) => {
  'update': {
    'name': '$root/orders/$id',
    'fields': {for (final e in fields.entries) e.key: value(e.value)},
  },
  'currentDocument': {'exists': false},
};

Map<String, Object> patchStatus(String id, String status) => {
  'update': {
    'name': '$root/orders/$id',
    'fields': {'status': value(status)},
  },
  'updateMask': {
    'fieldPaths': ['status'],
  },
};

Future<bool> read(String? token, String id) async {
  final res = await http.get(
    Uri.parse('$dbUrl/v1/$root/orders/$id'),
    headers: {if (token != null) 'Authorization': 'Bearer $token'},
  );
  return res.statusCode == 200;
}

Future<void> main() async {
  final run = DateTime.now().millisecondsSinceEpoch;
  final (aUid, a) = await signUp('ton$run@student.test');
  final (_, b) = await signUp('mai$run@student.test');
  final (_, barista) = await signUp('ploy$run@barista.test');
  Map<String, Object> order(
    String uid, {
    String status = 'received',
    int total = 65,
  }) => {
    'uid': uid,
    'customer': 'ต้น',
    'status': status,
    'total': total,
    'createdAt': run,
    'items': [
      {'quantity': 1},
    ],
  };
  final id = 'R$run';

  // [คำอธิบาย, คาดว่าอนุญาต?, การกระทำ]
  final cases = <(String, bool, Future<bool> Function())>[
    (
      'ไม่ล็อกอิน สร้างคำสั่งซื้อ',
      false,
      () => commit(null, createDoc('x$run', order(aUid))),
    ),
    (
      'ลูกค้า A สร้างในนามคนอื่น',
      false,
      () => commit(a, createDoc('y$run', order('other'))),
    ),
    (
      'ลูกค้า A สร้างโดยสถานะ ready',
      false,
      () => commit(a, createDoc('z$run', order(aUid, status: 'ready'))),
    ),
    (
      'ลูกค้า A ส่งราคารวม 0 บาท',
      false,
      () => commit(a, createDoc('t$run', order(aUid, total: 0))),
    ),
    (
      'ลูกค้า A สร้างคำสั่งซื้อของตน',
      true,
      () => commit(a, createDoc(id, order(aUid))),
    ),
    ('ลูกค้า A อ่านของตน', true, () => read(a, id)),
    ('ลูกค้า B อ่านของ A', false, () => read(b, id)),
    ('บาริสต้าอ่านของ A', true, () => read(barista, id)),
    (
      'ลูกค้า A เปลี่ยนสถานะเอง',
      false,
      () => commit(a, patchStatus(id, 'ready')),
    ),
    (
      'บาริสต้าเปลี่ยนสถานะเป็น preparing',
      true,
      () => commit(barista, patchStatus(id, 'preparing')),
    ),
    (
      'บาริสต้าเปลี่ยนเป็นสถานะที่ไม่มี',
      false,
      () => commit(barista, patchStatus(id, 'lost')),
    ),
  ];

  var failed = 0;
  for (final (name, expected, action) in cases) {
    final allowed = await action();
    final ok = allowed == expected;
    if (!ok) failed++;
    stdout.writeln(
      '${ok ? 'ผ่าน' : 'ไม่ผ่าน'}  $name → ${allowed ? 'อนุญาต' : 'ปฏิเสธ'}',
    );
  }
  stdout.writeln(
    failed == 0
        ? 'กฎทั้งหมดถูกต้อง (${cases.length} กรณี)'
        : 'ผิด $failed กรณี',
  );
  exit(failed == 0 ? 0 : 1);
}
