import 'dart:async';

import 'package:cafe_core/cafe_core.dart';
import 'package:cafe_order/data/repositories/branch_repository.dart';
import 'package:cafe_order/data/repositories/favorite_repository.dart';
import 'package:cafe_order/data/repositories/live_order_repository.dart';
import 'package:cafe_order/data/repositories/menu_repository.dart';
import 'package:cafe_order/data/repositories/order_repository.dart';
import 'package:cafe_order/data/services/api_exception.dart';
import 'package:cafe_order/data/services/auth_service.dart';
import 'package:cafe_order/data/services/location_service.dart';
import 'package:cafe_order/data/services/photo_service.dart';

/// Repository ปลอมสำหรับทดสอบ: ทำงานในหน่วยความจำ ไม่มีปลั๊กอิน ไม่มีหน่วงเวลา

class FakeMenuRepository implements MenuRepository {
  FakeMenuRepository({this.menu = sampleMenu, this.fail = false});

  final List<MenuItem> menu;
  bool fail; // true = จำลองโหลดไม่สำเร็จ
  int calls = 0;

  @override
  Future<List<MenuItem>> fetchMenu() async {
    calls++;
    if (fail) throw Exception('network down');
    return menu;
  }
}

class InMemoryOrderRepository implements OrderRepository {
  final List<Order> orders = [];
  bool fail = false;

  @override
  Future<Order> placeOrder(List<OrderItem> items) async {
    if (fail) throw Exception('server error');
    final order = Order(id: 'T${orders.length + 1}', items: items);
    orders.insert(0, order);
    return order;
  }

  @override
  Future<List<Order>> history() async => [...orders];

  @override
  Future<String?> receipt(String orderId) async =>
      orders.where((o) => o.id == orderId).map(formatReceipt).firstOrNull;
}

class InMemoryFavoriteRepository implements FavoriteRepository {
  final Set<String> ids = {};

  @override
  Future<Set<String>> load() async => {...ids};

  @override
  Future<void> setFavorite(String menuId, bool favorite) async =>
      favorite ? ids.add(menuId) : ids.remove(menuId);
}

class FakeBranchRepository implements BranchRepository {
  FakeBranchRepository({this.fail = false});

  bool fail;

  @override
  Future<List<Branch>> fetchBranches() async {
    if (fail) throw Exception('offline');
    return sampleBranches;
  }
}

/// AuthService ปลอม: เริ่มต้นเข้าสู่ระบบอยู่แล้ว (เทสต์เดิมจึงผ่าน AuthGate ได้)
class FakeAuthService implements AuthService {
  FakeAuthService([this._user = customer]);

  static const customer = AppUser(
    uid: 'u1',
    email: 'ton@student.test',
    name: 'ต้น',
  );
  static const barista = AppUser(
    uid: 'b1',
    email: 'ploy@barista.test',
    name: 'พลอย',
  );

  AppUser? _user;
  final _changes = StreamController<AppUser?>.broadcast();
  final Map<String, String> passwords = {'ton@student.test': 'secret123'};

  @override
  AppUser? get currentUser => _user;

  @override
  Stream<AppUser?> userChanges() => _changes.stream;

  void _set(AppUser? user) {
    _user = user;
    _changes.add(user);
  }

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    if (passwords[email] != password) {
      throw const ApiException('อีเมลหรือรหัสผ่านไม่ถูกต้อง');
    }
    final user = AppUser(
      uid: email,
      email: email,
      name: email.split('@').first,
    );
    _set(user);
    return user;
  }

  @override
  Future<AppUser> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    passwords[email] = password;
    final user = AppUser(uid: email, email: email, name: name);
    _set(user);
    return user;
  }

  @override
  Future<void> signOut() async => _set(null);
}

/// คำสั่งซื้อแบบเรียลไทม์ในหน่วยความจำ (ใช้แทน Firestore ในเทสต์วิดเจ็ต)
class InMemoryLiveOrders extends InMemoryOrderRepository
    implements LiveOrderRepository {
  final _changes = StreamController<void>.broadcast();

  Stream<T> _watch<T>(T Function() read) async* {
    yield read();
    await for (final _ in _changes.stream) {
      yield read();
    }
  }

  @override
  Future<Order> placeOrder(List<OrderItem> items) async {
    final order = await super.placeOrder(items);
    _changes.add(null);
    return order;
  }

  @override
  Stream<Order?> watchOrder(String id) =>
      _watch(() => orders.where((o) => o.id == id).firstOrNull);

  @override
  Stream<List<Order>> watchActive() => _watch(
    () => [
      for (final o in orders.reversed)
        if (o.status != OrderStatus.completed) o,
    ],
  );

  @override
  Future<void> updateStatus(String id, OrderStatus status) async {
    final i = orders.indexWhere((o) => o.id == id);
    orders[i] = orders[i].copyWith(status: status);
    _changes.add(null);
  }
}

/// ตำแหน่งปลอม: ค่าเริ่มต้นอยู่หน้าหอพัก หรือกำหนดให้ล้มเหลวได้
class FakeLocationService implements LocationService {
  FakeLocationService({this.here = (lat: 18.8030, lng: 98.9510), this.failure});

  ({double lat, double lng}) here;
  LocationFailure? failure;
  int settingsOpened = 0;

  @override
  Future<({double lat, double lng})> current() async {
    if (failure != null) throw LocationException(failure!);
    return here;
  }

  @override
  Future<bool> openSettings() async {
    settingsOpened++;
    return true;
  }
}

class FakePhotoService implements PhotoService {
  FakePhotoService([this.path]);

  String? path; // null = ผู้ใช้ยกเลิก

  @override
  Future<String?> pick({required bool fromCamera}) async => path;
}
