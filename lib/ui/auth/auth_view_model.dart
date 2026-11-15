import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/services/auth_service.dart';

/// ViewModel ของการเข้าสู่ระบบ: ฟังสถานะจาก AuthService
/// go_router ใช้เป็น refreshListenable เพื่อ redirect เมื่อเข้า/ออกจากระบบ
class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._auth) : _user = _auth.currentUser {
    _sub = _auth.userChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  final AuthService _auth;
  late final StreamSubscription<AppUser?> _sub;
  AppUser? _user;
  bool _busy = false;
  String? _error;

  AppUser? get user => _user;
  bool get isSignedIn => _user != null;
  bool get isBarista => _user?.isBarista ?? false;
  bool get busy => _busy;
  String? get error => _error;

  Future<void> signIn(String email, String password) =>
      _run(() => _auth.signIn(email: email, password: password));

  Future<void> signUp(String email, String password, String name) =>
      _run(() => _auth.signUp(email: email, password: password, name: name));

  Future<void> signOut() => _auth.signOut();

  Future<void> _run(Future<AppUser> Function() action) async {
    _busy = true;
    _error = null;
    notifyListeners();
    try {
      _user = await action();
    } catch (e) {
      _error = '$e';
    } finally {
      _busy = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
