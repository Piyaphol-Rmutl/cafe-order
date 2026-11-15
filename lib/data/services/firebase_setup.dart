import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// รหัสโปรเจกต์ที่ขึ้นต้นด้วย demo- ใช้ได้กับ Emulator เท่านั้น
/// ไม่ต้องสร้างโปรเจกต์บนคลาวด์ ไม่ต้องล็อกอิน และไม่มีค่าใช้จ่าย
const demoProjectId = 'demo-cafe-order';

/// พอร์ตตรงกับ firebase.json (ไม่ชนกับเซิร์ฟเวอร์จำลอง REST ที่ 8080)
const authPort = 9199;
const firestorePort = 8180;

/// เครื่องที่รัน Emulator (กำหนดเองได้ด้วย --dart-define=EMULATOR_HOST=...)
String emulatorHost() {
  const host = String.fromEnvironment('EMULATOR_HOST');
  if (host.isNotEmpty) return host;
  // Android Emulator มองเครื่องโฮสต์ที่ 10.0.2.2
  return defaultTargetPlatform == TargetPlatform.android
      ? '10.0.2.2'
      : '127.0.0.1';
}

/// เริ่ม Firebase แล้วเชื่อมต่อ Firebase Local Emulator Suite
Future<(FirebaseAuth, FirebaseFirestore)> initFirebase() async {
  await Firebase.initializeApp(
    // ปลั๊กอิน Firestore ต้องมีแอปชื่อ [DEFAULT] จึงระบุชื่อเอง
    name: defaultFirebaseAppName,
    demoProjectId: demoProjectId,
  );
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final host = emulatorHost();
  await auth.useAuthEmulator(host, authPort);
  db.useFirestoreEmulator(host, firestorePort);
  return (auth, db);
}
