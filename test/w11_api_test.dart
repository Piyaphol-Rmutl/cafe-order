import 'dart:io';

import 'package:cafe_core/cafe_core.dart';
import 'package:cafe_order/data/repositories/branch_repository.dart';
import 'package:cafe_order/data/repositories/menu_repository.dart';
import 'package:cafe_order/data/repositories/order_repository.dart';
import 'package:cafe_order/data/services/api_exception.dart';
import 'package:cafe_order/data/services/api_service.dart';
import 'package:cafe_order/data/services/database_service.dart';
import 'package:cafe_order/data/services/file_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'fakes.dart';
import 'helpers.dart';
import 'server.dart';

ApiService apiWith(http.Client client, {Duration? timeout}) => ApiService(
  baseUrl: baseUrl,
  client: client,
  timeout: timeout ?? const Duration(seconds: 5),
);

void main() {
  sqfliteFfiInit();

  group('ผ่านเซิร์ฟเวอร์จำลอง', () {
    final api = apiWith(fakeServer());

    test('GET /menu → List<MenuItem>', () async {
      final menu = await ApiMenuRepository(api).fetchMenu();
      expect(menu, sampleMenu);
      expect(menu.first.name, 'ลาเต้'); // UTF-8 ไม่เพี้ยน
    });

    test('GET /branches → List<Branch>', () async {
      final branches = await ApiBranchRepository(api).fetchBranches();
      expect(branches.map((b) => b.id), ['eng', 'library', 'dorm']);
    });

    test('POST /orders → 201 เซิร์ฟเวอร์กำหนดรหัส แล้วเก็บลง SQLite', () async {
      final db = await DatabaseService.open(
        factory: databaseFactoryFfi,
        path: inMemoryDatabasePath,
      );
      final tmp = await Directory.systemTemp.createTemp('cafe_api');
      addTearDown(() async {
        await db.close();
        await tmp.delete(recursive: true);
      });
      final repo = ApiOrderRepository(
        api,
        LocalOrderRepository(db, FileService(directory: () async => tmp)),
      );
      final order = await repo.placeOrder([
        OrderItem(item: sampleMenu.first, quantity: 2),
      ]);
      expect(order.id, 'S001');
      expect(order.total, 130);
      expect((await repo.history()).single.id, 'S001');
      expect(await repo.receipt('S001'), contains('130'));
    });

    test(
      'POST ข้อมูลผิด → 400 เป็น ApiException พร้อมข้อความจากเซิร์ฟเวอร์',
      () async {
        await expectLater(
          api.postJson('/orders', {'items': 'ไม่ใช่รายการ'}),
          throwsA(
            isA<ApiException>()
                .having((e) => e.statusCode, 'statusCode', 400)
                .having(
                  (e) => e.message,
                  'message',
                  'ข้อมูลคำสั่งซื้อไม่ถูกต้อง',
                ),
          ),
        );
      },
    );

    test('เส้นทางที่ไม่มี → 404', () async {
      await expectLater(
        api.getJson('/coupons'),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'code', 404)),
      );
    });
  });

  group('การจัดการข้อผิดพลาด', () {
    test('500 จากเซิร์ฟเวอร์', () async {
      final api = apiWith(fakeServer(fail: true));
      await expectLater(
        ApiMenuRepository(api).fetchMenu(),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'code', 500)),
      );
    });

    test('หมดเวลา (Timeout)', () async {
      final slow = MockClient((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 200));
        return http.Response('[]', 200);
      });
      final api = apiWith(slow, timeout: const Duration(milliseconds: 50));
      await expectLater(
        api.getJson('/menu'),
        throwsA(
          isA<ApiException>().having(
            (e) => e.message,
            'message',
            'เซิร์ฟเวอร์ไม่ตอบภายในเวลาที่กำหนด',
          ),
        ),
      );
    });

    test('เชื่อมต่อไม่ได้', () async {
      final down = MockClient(
        (_) async => throw http.ClientException('refused'),
      );
      await expectLater(
        apiWith(down).getJson('/menu'),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'code', isNull),
        ),
      );
    });

    test('JSON ผิดรูปแบบ / ชนิดไม่ตรง', () async {
      final broken = MockClient((_) async => http.Response('<html>', 200));
      await expectLater(
        apiWith(broken).getJson('/menu'),
        throwsA(isA<ApiException>()),
      );
      final wrong = MockClient((_) async => http.Response('{"a":1}', 200));
      await expectLater(
        ApiMenuRepository(apiWith(wrong)).fetchMenu(),
        throwsA(isA<ApiException>()),
      );
    });
  });

  group('FutureBuilder ในหน้าร้าน', () {
    testWidgets('กำลังโหลด → รายชื่อสาขา', (tester) async {
      await tester.pumpWidget(await cafeApp(initialLocation: '/shop'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('สาขาหอพักนักศึกษา'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('สาขาหอพักนักศึกษา'), findsOneWidget);
    });

    testWidgets('ผิดพลาด → ลองอีกครั้งแล้วสำเร็จ', (tester) async {
      final branches = FakeBranchRepository(fail: true);
      await tester.pumpWidget(
        await cafeApp(initialLocation: '/shop', branches: branches),
      );
      await tester.pumpAndSettle();
      final retry = find.widgetWithText(TextButton, 'ลองอีกครั้ง');
      await tester.scrollUntilVisible(
        retry,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.ensureVisible(retry);
      await tester.pumpAndSettle();
      branches.fail = false;
      await tester.tap(retry);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('สาขาหอสมุด'), 200,
          scrollable: find.byType(Scrollable).first);
      expect(find.text('สาขาหอสมุด'), findsOneWidget);
    });
  });
}
