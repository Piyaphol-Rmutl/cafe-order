import 'dart:io';

import 'package:cafe_core/cafe_core.dart';
import 'package:cafe_order/data/repositories/firestore_order_repository.dart';
import 'package:cafe_order/data/repositories/order_repository.dart';
import 'package:cafe_order/data/services/auth_service.dart';
import 'package:cafe_order/data/services/database_service.dart';
import 'package:cafe_order/data/services/file_service.dart';
import 'package:cafe_order/ui/auth/login_page.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'fakes.dart';
import 'helpers.dart';
import 'w06_navigation_test.dart' show addToCart;

void main() {
  sqfliteFfiInit();
  final latte = sampleMenu.first;

  group('FirestoreOrderRepository (fake_cloud_firestore)', () {
    late FakeFirebaseFirestore firestore;
    late FirestoreOrderRepository repo;
    late DatabaseService db;
    late Directory tmp;

    setUp(() async {
      firestore = FakeFirebaseFirestore();
      db = await DatabaseService.open(
        factory: databaseFactoryFfi,
        path: inMemoryDatabasePath,
      );
      tmp = await Directory.systemTemp.createTemp('cafe_fs');
      repo = FirestoreOrderRepository(
        firestore,
        FakeAuthService(),
        LocalOrderRepository(db, FileService(directory: () async => tmp)),
      );
    });

    tearDown(() async {
      await db.close();
      await tmp.delete(recursive: true);
    });

    test('placeOrder เขียนเอกสารพร้อม uid และสถานะ received', () async {
      final order = await repo.placeOrder([OrderItem(item: latte)]);
      expect(order.id, matches(RegExp(r'^C[0-9A-Z]{8,}$'))); // เวลาเต็มฐาน 36
      final doc = await firestore.collection('orders').doc(order.id).get();
      expect(doc.data()!['uid'], 'u1');
      expect(doc.data()!['status'], 'received');
      expect(doc.data()!['total'], 65);
      expect(doc.data()!.keys, isNot(contains('id')));
      expect((await repo.history()).single.id, order.id); // สำเนาในเครื่อง
    });

    test('watchOrder ส่งสถานะใหม่เมื่อบาริสต้าเปลี่ยน', () async {
      final order = await repo.placeOrder([OrderItem(item: latte)]);
      final statuses = repo.watchOrder(order.id).map((o) => o?.status);
      final expectation = expectLater(
        statuses,
        emitsThrough(OrderStatus.preparing),
      );
      await repo.updateStatus(order.id, OrderStatus.preparing);
      await expectation;
    });

    test('watchActive ไม่รวมคำสั่งซื้อที่เสร็จแล้ว', () async {
      final a = await repo.placeOrder([OrderItem(item: latte)]);
      await Future<void>.delayed(const Duration(milliseconds: 2));
      final b = await repo.placeOrder([OrderItem(item: latte, quantity: 2)]);
      await repo.updateStatus(a.id, OrderStatus.completed);
      final active = await repo.watchActive().first;
      expect(active.map((o) => o.id), [b.id]);
    });
  });

  test('ข้อความข้อผิดพลาดของ Firebase Auth', () {
    expect(
      FirebaseAuthService.authMessage('weak-password'),
      'รหัสผ่านต้องยาวอย่างน้อย 6 ตัวอักษร',
    );
    expect(
      FirebaseAuthService.authMessage('invalid-credential'),
      'อีเมลหรือรหัสผ่านไม่ถูกต้อง',
    );
    expect(
      const AppUser(uid: 'x', email: 'a@barista.test', name: 'a').isBarista,
      isTrue,
    );
  });

  group('AuthGate (redirect ของ go_router)', () {
    testWidgets('ยังไม่เข้าสู่ระบบ → /login, เข้าสู่ระบบแล้ว → เมนู', (
      tester,
    ) async {
      await tester.pumpWidget(await cafeApp(auth: FakeAuthService(null)));
      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'ton@student.test');
      await tester.enterText(fields.at(1), 'wrong-password');
      await tester.tap(find.widgetWithText(FilledButton, 'เข้าสู่ระบบ'));
      await tester.pumpAndSettle();
      expect(find.text('อีเมลหรือรหัสผ่านไม่ถูกต้อง'), findsOneWidget);

      await tester.enterText(fields.at(1), 'secret123');
      await tester.tap(find.widgetWithText(FilledButton, 'เข้าสู่ระบบ'));
      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsNothing);
      expect(find.text('ลาเต้'), findsOneWidget);
    });

    testWidgets('ออกจากระบบจาก Drawer → กลับไป /login', (tester) async {
      await tester.pumpWidget(await cafeApp());
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ออกจากระบบ'));
      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('ลูกค้าเข้า /barista ไม่ได้', (tester) async {
      await tester.pumpWidget(
        await cafeApp(initialLocation: '/barista', live: InMemoryLiveOrders()),
      );
      await tester.pumpAndSettle();
      expect(find.text('บาริสต้า'), findsNothing);
      expect(find.text('ลาเต้'), findsOneWidget);
    });
  });

  testWidgets('สั่งซื้อ → หน้าสถานะ; บาริสต้าเปลี่ยนสถานะ → ลูกค้าเห็นทันที', (
    tester,
  ) async {
    final live = InMemoryLiveOrders();
    await tester.pumpWidget(await cafeApp(live: live));
    await tester.pumpAndSettle();
    await addToCart(tester, 'ลาเต้');
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ตะกร้า'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('สั่งซื้อ · 65 บาท'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ตกลง'));
    await tester.pumpAndSettle();
    expect(find.text('สถานะคำสั่งซื้อ T1'), findsOneWidget);
    final selected = find.byWidgetPredicate((w) => w is ListTile && w.selected);
    expect(
      find.descendant(of: selected, matching: find.text('รับคำสั่งซื้อแล้ว')),
      findsOneWidget,
    );

    // บาริสต้า (อีกเครื่องหนึ่ง) เปลี่ยนสถานะ
    await live.updateStatus('T1', OrderStatus.ready);
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: selected, matching: find.text('พร้อมรับ')),
      findsOneWidget,
    );

    // หน้าสถานะเปิดด้วย push จึงย้อนกลับไปหน้าตะกร้าได้
    await tester.tap(
      find.byType(BackButton),
    ); // tooltip เป็นภาษาไทย ใช้ pageBack ไม่ได้
    await tester.pumpAndSettle();
    expect(find.text('สถานะคำสั่งซื้อ T1'), findsNothing);
    expect(find.text('ตะกร้า'), findsWidgets);
  });

  testWidgets('หน้าสถานะ: อ่านไม่สำเร็จ แสดงข้อความที่อ่านเข้าใจ', (
    tester,
  ) async {
    await tester.pumpWidget(
      await cafeApp(live: _BrokenLiveOrders(), initialLocation: '/status/C1'),
    );
    await tester.pumpAndSettle();
    expect(find.text('โหลดสถานะคำสั่งซื้อไม่สำเร็จ'), findsOneWidget);
    expect(find.textContaining('FormatException'), findsNothing);
  });

  testWidgets('หน้าบาริสต้า: กดปุ่มสถานะถัดไป', (tester) async {
    final live = InMemoryLiveOrders();
    await live.placeOrder([OrderItem(item: latte, cupName: 'ต้น')]);
    await tester.pumpWidget(
      await cafeApp(
        initialLocation: '/barista',
        live: live,
        auth: FakeAuthService(FakeAuthService.barista),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('T1 · รับคำสั่งซื้อแล้ว'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'กำลังชง'));
    await tester.pumpAndSettle();
    expect(find.text('T1 · กำลังชง'), findsOneWidget);
    expect(live.orders.single.status, OrderStatus.preparing);
  });
}

/// สตรีมสถานะล้มเหลว (เช่น ข้อมูลสถานะในเอกสารไม่ถูกต้อง)
class _BrokenLiveOrders extends InMemoryLiveOrders {
  @override
  Stream<Order?> watchOrder(String id) =>
      Stream.error(const FormatException('unknown status'));
}
