import 'package:cafe_core/cafe_core.dart';
import 'package:cafe_order/data/repositories/favorite_repository.dart';
import 'package:cafe_order/data/repositories/menu_repository.dart';
import 'package:cafe_order/data/repositories/order_repository.dart';

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
