import 'package:cafe_core/cafe_core.dart';

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
