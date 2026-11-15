import 'dart:io';

import 'package:cafe_core/cafe_core.dart';
import 'package:cafe_order/data/repositories/favorite_repository.dart';
import 'package:cafe_order/data/repositories/order_repository.dart';
import 'package:cafe_order/data/repositories/settings_repository.dart';
import 'package:cafe_order/data/services/database_service.dart';
import 'package:cafe_order/data/services/file_service.dart';
import 'package:cafe_order/data/services/prefs_service.dart';
import 'package:cafe_order/ui/cart/cart_view_model.dart';
import 'package:cafe_order/ui/menu/menu_view_model.dart';
import 'package:cafe_order/ui/orders/order_history_view_model.dart';
import 'package:cafe_order/ui/settings/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'fakes.dart';

// ชั้นข้อมูลทดสอบกับ SQLite จริงบนคอมพิวเตอร์ (sqflite_common_ffi)
// และไฟล์จริงในโฟลเดอร์ชั่วคราว ไม่ต้องเปิดเครื่องจำลอง
void main() {
  sqfliteFfiInit();
  final latte = sampleMenu.first;

  group('SQLite + ไฟล์', () {
    late DatabaseService db;
    late Directory tmp;
    late LocalOrderRepository orders;

    setUp(() async {
      db = await DatabaseService.open(
        factory: databaseFactoryFfi,
        path: inMemoryDatabasePath,
      );
      tmp = await Directory.systemTemp.createTemp('cafe_test');
      orders = LocalOrderRepository(
        db,
        FileService(directory: () async => tmp),
      );
    });

    tearDown(() async {
      await db.close();
      await tmp.delete(recursive: true);
    });

    test('placeOrder บันทึกลงตาราง orders ได้รหัสเรียงกัน', () async {
      final a = await orders.placeOrder([OrderItem(item: latte)]);
      final b = await orders.placeOrder([OrderItem(item: latte, quantity: 2)]);
      expect(a.id, 'A001');
      expect(b.id, 'A002');

      final history = await orders.history();
      expect(history.map((o) => o.total), containsAll([65, 130]));
      expect(history.first.items.single.item, latte);
    });

    test('รหัสถัดไปมาจากเลขสูงสุด ไม่ซ้ำแม้มีการลบบางรายการ', () async {
      // จำลองประวัติที่เหลือเพียง A005 (สมมติว่าลบ A001–A004 ไปแล้ว)
      await db.insertOrder(
        LocalOrderRepository.toRow(
          Order(
            id: 'A005',
            items: [OrderItem(item: latte)],
          ),
        ),
      );
      final next = await orders.placeOrder([OrderItem(item: latte)]);
      expect(next.id, 'A006'); // ถ้านับแถวจะได้ A002
    });

    test('ใบเสร็จถูกเขียนเป็นไฟล์และอ่านกลับได้', () async {
      final order = await orders.placeOrder([OrderItem(item: latte)]);
      final file = File('${tmp.path}/receipts/${order.id}.txt');
      expect(file.existsSync(), isTrue);
      final text = await orders.receipt(order.id);
      expect(text, contains('รวม 65 บาท'));
      // วันเวลาแบบอ่านง่าย ไม่มีวินาทีและไมโครวินาที
      expect(
        text,
        matches(
          RegExp(r'^\d{1,2}/\d{1,2}/\d{4} \d{2}:\d{2}$', multiLine: true),
        ),
      );
      expect(await orders.receipt('X999'), isNull);
    });

    test('toRow/fromRow ไปกลับได้ค่าเดิม', () {
      final order = Order(
        id: 'A9',
        items: [OrderItem(item: latte)],
      );
      final copy = LocalOrderRepository.fromRow(
        LocalOrderRepository.toRow(order),
      );
      expect(copy.id, 'A9');
      expect(copy.total, order.total);
    });

    test('รายการโปรดเพิ่ม/ลบในตาราง favorites', () async {
      final repo = SqliteFavoriteRepository(db);
      await repo.setFavorite('latte', true);
      await repo.setFavorite('latte', true); // ซ้ำไม่ error
      await repo.setFavorite('mocha', true);
      await repo.setFavorite('mocha', false);
      expect(await repo.load(), {'latte'});
    });
  });

  group('shared_preferences', () {
    test('SettingsViewModel บันทึกค่า เปิดใหม่ได้ค่าเดิม', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = PrefsService(await SharedPreferences.getInstance());
      final vm = SettingsViewModel(SettingsRepository(prefs));
      expect(vm.themeMode, ThemeMode.system);
      vm.themeMode = ThemeMode.dark;
      vm.locale = const Locale('en');

      // จำลองการเปิดแอปใหม่: สร้าง ViewModel ใหม่จาก prefs เดิม
      final reopened = SettingsViewModel(SettingsRepository(prefs));
      expect(reopened.themeMode, ThemeMode.dark);
      expect(reopened.locale, const Locale('en'));
    });
  });

  group('ViewModel', () {
    test('MenuViewModel: ล้มเหลวเก็บ error แล้วลองใหม่สำเร็จ', () async {
      final repo = FakeMenuRepository(fail: true);
      final vm = MenuViewModel(repo, InMemoryFavoriteRepository());
      final states = <bool>[];
      vm.addListener(() => states.add(vm.loading));

      await vm.load();
      expect(vm.error, isNotNull);
      expect(vm.items, isEmpty);

      repo.fail = false;
      await vm.load();
      expect(vm.error, isNull);
      expect(vm.items, sampleMenu);
      expect(states, [true, false, true, false]); // loading เปิด-ปิดทุกครั้ง
    });

    test('MenuViewModel: toggleFavorite บันทึกผ่าน repository', () async {
      final favs = InMemoryFavoriteRepository();
      final vm = MenuViewModel(FakeMenuRepository(), favs);
      await vm.load();
      await vm.toggleFavorite('latte');
      expect(vm.isFavorite('latte'), isTrue);
      expect(vm.favorites, [latte]);
      expect(favs.ids, {'latte'});
    });

    test('CartViewModel: สั่งไม่สำเร็จ ตะกร้ายังอยู่และมี error', () async {
      final orders = InMemoryOrderRepository()..fail = true;
      final cart = CartViewModel(orders)..add(OrderItem(item: latte));
      expect(await cart.checkout(), isNull);
      expect(cart.error, isNotNull);
      expect(cart.count, 1);
      expect(cart.placing, isFalse);
    });

    test('OrderHistoryViewModel: อ่านประวัติไม่สำเร็จ เก็บ error ไม่ค้างที่กำลังโหลด', () async {
      final vm = OrderHistoryViewModel(_BrokenHistoryRepository());
      await vm.load();
      expect(vm.loading, isFalse);
      expect(vm.error, isNotNull);
      expect(vm.history, isEmpty);
    });
  });
}

/// Repository ที่อ่านประวัติไม่สำเร็จ (เช่น ไฟล์ฐานข้อมูลเสีย)
class _BrokenHistoryRepository extends InMemoryOrderRepository {
  @override
  Future<List<Order>> history() async => throw Exception('database error');
}
