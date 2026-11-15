import 'package:firebase_auth/firebase_auth.dart';

import 'api_exception.dart';

/// ผู้ใช้ของแอป (ไม่ผูกกับชนิดของ Firebase)
class AppUser {
  const AppUser({required this.uid, required this.email, required this.name});

  final String uid;
  final String email;
  final String name;

  /// บาริสต้า = อีเมล @barista.test (ตรงกับ firestore.rules)
  bool get isBarista => email.endsWith('@barista.test');
}

/// สัญญาที่ ViewModel รู้จัก (ไม่รู้ว่าเบื้องหลังเป็น Firebase)
abstract interface class AuthService {
  AppUser? get currentUser;

  /// ส่งผู้ใช้ปัจจุบัน (หรือ null) ทุกครั้งที่สถานะการเข้าสู่ระบบเปลี่ยน
  Stream<AppUser?> userChanges();

  Future<AppUser> signIn({required String email, required String password});

  Future<AppUser> signUp({
    required String email,
    required String password,
    required String name,
  });

  Future<void> signOut();
}

/// การยืนยันตัวตนด้วยอีเมลและรหัสผ่านผ่าน Firebase Authentication
class FirebaseAuthService implements AuthService {
  FirebaseAuthService(this._auth);

  final FirebaseAuth _auth;

  @override
  AppUser? get currentUser => _toAppUser(_auth.currentUser);

  @override
  Stream<AppUser?> userChanges() => _auth.userChanges().map(_toAppUser);

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return _toAppUser(cred.user)!;
    } on FirebaseAuthException catch (e) {
      throw ApiException(authMessage(e.code));
    }
  }

  @override
  Future<AppUser> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await cred.user!.updateDisplayName(name.trim());
      return AppUser(
        uid: cred.user!.uid,
        email: email.trim(),
        name: name.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw ApiException(authMessage(e.code));
    }
  }

  @override
  Future<void> signOut() => _auth.signOut();

  static AppUser? _toAppUser(User? u) {
    if (u == null) return null;
    final email = u.email ?? '';
    return AppUser(
      uid: u.uid,
      email: email,
      name: u.displayName ?? email.split('@').first,
    );
  }

  /// แปลงรหัสข้อผิดพลาดของ Firebase เป็นข้อความที่ผู้ใช้เข้าใจ
  static String authMessage(String code) => switch (code) {
    'invalid-email' => 'รูปแบบอีเมลไม่ถูกต้อง',
    'weak-password' => 'รหัสผ่านต้องยาวอย่างน้อย 6 ตัวอักษร',
    'email-already-in-use' => 'อีเมลนี้ถูกใช้สมัครแล้ว',
    'invalid-credential' ||
    'user-not-found' ||
    'wrong-password' => 'อีเมลหรือรหัสผ่านไม่ถูกต้อง',
    'network-request-failed' => 'เชื่อมต่อเซิร์ฟเวอร์ไม่ได้',
    _ => 'ยืนยันตัวตนไม่สำเร็จ ($code)',
  };
}
