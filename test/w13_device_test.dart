import 'dart:async';
import 'dart:io';

import 'package:cafe_core/cafe_core.dart';
import 'package:cafe_order/data/repositories/review_repository.dart';
import 'package:cafe_order/data/services/device_channel.dart';
import 'package:cafe_order/data/services/file_service.dart';
import 'package:cafe_order/data/services/location_service.dart';
import 'package:cafe_order/demos/w13_sensors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'fakes.dart';
import 'helpers.dart';

void main() {
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  group('MethodChannel (จำลองฝั่งเนทีฟด้วย setMockMethodCallHandler)', () {
    final calls = <String>[];

    setUp(() {
      calls.clear();
      messenger.setMockMethodCallHandler(CafeDeviceChannel.channel, (
        call,
      ) async {
        calls.add(call.method);
        return switch (call.method) {
          'vibrate' => true,
          'batteryLevel' => 87,
          _ => throw MissingPluginException(),
        };
      });
    });
    tearDown(
      () => messenger.setMockMethodCallHandler(CafeDeviceChannel.channel, null),
    );

    test('vibrate และ batteryLevel', () async {
      const device = CafeDeviceChannel();
      expect(await device.vibrate(), isTrue);
      expect(await device.batteryLevel(), 87);
      expect(calls, ['vibrate', 'batteryLevel']);
    });

    test('ค่า -1 (Simulator) แปลงเป็น null', () async {
      messenger.setMockMethodCallHandler(
        CafeDeviceChannel.channel,
        (call) async => -1,
      );
      expect(await const CafeDeviceChannel().batteryLevel(), isNull);
    });

    testWidgets('สถานะเป็น "พร้อมรับ" → สั่นหนึ่งครั้ง', (tester) async {
      final live = InMemoryLiveOrders();
      final order = await live.placeOrder([OrderItem(item: sampleMenu.first)]);
      await tester.pumpWidget(
        await cafeApp(initialLocation: '/status/${order.id}', live: live),
      );
      await tester.pumpAndSettle();
      expect(calls, isEmpty);
      await live.updateStatus(order.id, OrderStatus.preparing);
      await tester.pump();
      await live.updateStatus(order.id, OrderStatus.ready);
      await tester.pump();
      expect(calls, ['vibrate']);
      await tester.pumpWidget(const SizedBox()); // หยุด BrewingIndicator
    });
  });

  test('ไม่มีโค้ดเนทีฟ (MissingPluginException) → ไม่ล้ม', () async {
    expect(await const CafeDeviceChannel().vibrate(), isFalse);
    expect(await const CafeDeviceChannel().batteryLevel(), isNull);
  });

  group('หาสาขาใกล้ฉัน', () {
    testWidgets('เรียงสาขาตามระยะ ใกล้สุดอยู่บน', (tester) async {
      await tester.pumpWidget(await cafeApp(initialLocation: '/branches'));
      await tester.pumpAndSettle();
      final tiles = tester.widgetList<ListTile>(find.byType(ListTile)).toList();
      expect((tiles.first.title as Text).data, 'สาขาหอพักนักศึกษา');
      expect(find.byIcon(Icons.near_me), findsOneWidget);
    });

    testWidgets('ปฏิเสธสิทธิ์ถาวร → ปุ่มเปิดการตั้งค่า', (tester) async {
      final location = FakeLocationService(
        failure: LocationFailure.deniedForever,
      );
      await tester.pumpWidget(
        await cafeApp(initialLocation: '/branches', location: location),
      );
      await tester.pumpAndSettle();
      expect(
        find.text('ถูกปฏิเสธสิทธิ์ถาวร เปิดได้ที่การตั้งค่าของแอป'),
        findsOneWidget,
      );
      await tester.tap(find.text('เปิดการตั้งค่า'));
      expect(location.settingsOpened, 1);
    });

    testWidgets('ไม่อนุญาตครั้งเดียว → ลองอีกครั้งสำเร็จ', (tester) async {
      final location = FakeLocationService(failure: LocationFailure.denied);
      await tester.pumpWidget(
        await cafeApp(initialLocation: '/branches', location: location),
      );
      await tester.pumpAndSettle();
      location.failure = null;
      await tester.tap(find.text('ลองอีกครั้ง'));
      await tester.pumpAndSettle();
      expect(find.text('สาขาหอพักนักศึกษา'), findsOneWidget);
    });
  });

  group('รีวิวพร้อมภาพ', () {
    late Directory tmp;
    setUp(() => tmp = Directory.systemTemp.createTempSync('cafe_review'));
    tearDown(() => tmp.deleteSync(recursive: true));

    test('ReviewRepository คัดลอกภาพมาเก็บและอ่านกลับได้', () async {
      final photo = File('${tmp.path}/picked.jpg')..writeAsBytesSync([1, 2, 3]);
      final repo = ReviewRepository(FileService(directory: () async => tmp));
      await repo.save(
        'A001',
        Review(rating: 4, comment: 'อร่อย', photoPath: photo.path),
      );
      final review = await repo.load('A001');
      expect(review!.rating, 4);
      expect(review.photoPath, endsWith('reviews/A001.jpg'));
      expect(File(review.photoPath!).readAsBytesSync(), [1, 2, 3]);
      // JSON เก็บเพียงชื่อไฟล์ ไม่ผูกกับพาธของโฟลเดอร์ซึ่งเปลี่ยนได้บน iOS
      final json = File('${tmp.path}/reviews/A001.json').readAsStringSync();
      expect(json, contains('"photoPath":"reviews/A001.jpg"'));
      expect(await repo.load('A999'), isNull);
    });

    testWidgets('เลือกภาพแล้วบันทึกรีวิว', (tester) async {
      final repo = ReviewRepository(FileService(directory: () async => tmp));
      final photo = File('${tmp.path}/picked.jpg')..writeAsBytesSync([1]);
      await tester.pumpWidget(
        await cafeApp(
          initialLocation: '/review/A001',
          photos: FakePhotoService(photo.path),
          reviews: repo,
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('3'));
      await tester.tap(find.text('เลือกจากคลังภาพ'));
      await tester.pump();
      expect(find.byType(Image), findsWidgets);
      await tester.runAsync(() async {
        await tester.tap(find.text('บันทึกรีวิว'));
        await Future<void>.delayed(const Duration(milliseconds: 200));
      });
      await tester.pumpAndSettle();
      final saved = await tester.runAsync(() => repo.load('A001'));
      expect(saved!.rating, 3);
    });

    testWidgets('ปฏิเสธสิทธิ์กล้อง → แจ้งผู้ใช้ ไม่พัง', (tester) async {
      await tester.pumpWidget(
        await cafeApp(
          initialLocation: '/review/A001',
          photos: _DeniedPhotoService(),
          reviews: ReviewRepository(FileService(directory: () async => tmp)),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('ถ่ายภาพ'));
      await tester.pump();
      expect(
        find.text('เปิดกล้องหรือคลังภาพไม่ได้ ตรวจสอบสิทธิ์ในการตั้งค่า'),
        findsOneWidget,
      );
    });
  });

  testWidgets('สาธิตเซนเซอร์: เขย่าแรง → นับ', (tester) async {
    final events = StreamController<AccelerometerEvent>();
    await tester.pumpWidget(testApp(SensorsDemo(events: events.stream)));
    events.add(AccelerometerEvent(0, 0, 9.8, DateTime.now()));
    await tester.pump();
    expect(find.textContaining('เขย่า 0 ครั้ง'), findsOneWidget);
    events.add(AccelerometerEvent(30, 0, 9.8, DateTime.now()));
    await tester.pump(); // ส่งเหตุการณ์ไปยังผู้ฟัง
    await tester.pump(); // build ใหม่หลัง setState
    expect(find.textContaining('เขย่า 1 ครั้ง'), findsOneWidget);
    await events.close();
  });
}

/// image_picker โยน PlatformException เมื่อผู้ใช้ปฏิเสธสิทธิ์กล้องบน iOS
class _DeniedPhotoService extends FakePhotoService {
  @override
  Future<String?> pick({required bool fromCamera}) async =>
      throw PlatformException(code: 'camera_access_denied');
}
