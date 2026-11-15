// ทดสอบกับ Firebase Local Emulator Suite จริงบนเครื่องจำลอง (สัปดาห์ 12)
// 1) firebase emulators:start --project demo-cafe-order
// 2) flutter test integration_test/emulator_test.dart -d <เครื่องจำลอง>
import 'dart:io';

import 'package:cafe_core/cafe_core.dart';
import 'package:cafe_order/data/repositories/firestore_order_repository.dart';
import 'package:cafe_order/data/repositories/order_repository.dart';
import 'package:cafe_order/data/services/auth_service.dart';
import 'package:cafe_order/data/services/database_service.dart';
import 'package:cafe_order/data/services/file_service.dart';
import 'package:cafe_order/data/services/firebase_setup.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('ลูกค้าสั่ง → บาริสต้าเปลี่ยนสถานะ → ลูกค้าเห็นสถานะใหม่', (
    tester,
  ) async {
    final (firebaseAuth, firestore) = await initFirebase();
    final auth = FirebaseAuthService(firebaseAuth);
    final db = await DatabaseService.open(path: 'cafe_it.db');
    final tmp = await Directory.systemTemp.createTemp('cafe_it');
    final repo = FirestoreOrderRepository(
      firestore,
      auth,
      LocalOrderRepository(db, FileService(directory: () async => tmp)),
    );
    final run = DateTime.now().millisecondsSinceEpoch;

    // ลูกค้าสมัครและสั่ง
    await auth.signUp(
      email: 'ton$run@student.test',
      password: 'secret123',
      name: 'ต้น',
    );
    final order = await repo.placeOrder([
      OrderItem(item: sampleMenu.first, cupName: 'ต้น'),
    ]);
    expect(
      (await repo.watchOrder(order.id).first)!.status,
      OrderStatus.received,
    );

    // ลูกค้าเปลี่ยนสถานะเองไม่ได้ (Security Rules)
    await expectLater(
      repo.updateStatus(order.id, OrderStatus.ready),
      throwsA(anything),
    );

    // บาริสต้าเห็นในรายการที่รอทำ และเปลี่ยนสถานะ
    await auth.signOut();
    await auth.signUp(
      email: 'ploy$run@barista.test',
      password: 'secret123',
      name: 'พลอย',
    );
    final active = await repo.watchActive().first;
    expect(active.map((o) => o.id), contains(order.id));
    await repo.updateStatus(order.id, OrderStatus.ready);

    // ลูกค้ากลับมาเห็นสถานะใหม่
    await auth.signOut();
    await auth.signIn(email: 'ton$run@student.test', password: 'secret123');
    final latest = await repo
        .watchOrder(order.id)
        .firstWhere((o) => o?.status == OrderStatus.ready);
    expect(latest!.status, OrderStatus.ready);

    await db.close();
  });
}
