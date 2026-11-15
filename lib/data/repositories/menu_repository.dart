import 'package:cafe_core/cafe_core.dart';

import '../services/api_service.dart';

/// Repository ของเมนู: UI ขอข้อมูลผ่านอินเทอร์เฟซนี้ ไม่รู้ว่ามาจากไหน
abstract interface class MenuRepository {
  Future<List<MenuItem>> fetchMenu();
}

/// สัปดาห์ 10: เมนูอยู่ในแอป (สัปดาห์ 11 เปลี่ยนเป็นดึงจากเซิร์ฟเวอร์)
class LocalMenuRepository implements MenuRepository {
  LocalMenuRepository({this.delay = const Duration(milliseconds: 300)});

  final Duration delay;

  @override
  Future<List<MenuItem>> fetchMenu() async {
    await Future<void>.delayed(delay);
    return sampleMenu;
  }
}

/// สัปดาห์ 11: ดึงเมนูจากเซิร์ฟเวอร์ของร้าน (GET /menu)
class ApiMenuRepository implements MenuRepository {
  ApiMenuRepository(this._api);

  final ApiService _api;

  @override
  Future<List<MenuItem>> fetchMenu() async {
    final json = await _api.getJson('/menu');
    return parseOrThrow(
      () => [
        for (final e in json as List<dynamic>)
          MenuItem.fromJson(e as Map<String, dynamic>),
      ],
    );
  }
}
