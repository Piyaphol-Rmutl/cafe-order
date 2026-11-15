import 'package:cafe_order/app_dependencies.dart';
import 'package:cafe_order/data/repositories/settings_repository.dart';
import 'package:cafe_order/data/services/prefs_service.dart';
import 'package:cafe_order/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fakes.dart';

/// MaterialApp สำหรับทดสอบวิดเจ็ตเดี่ยว (มี delegates ของภาษา เพราะวิดเจ็ตใช้ context.l10n)
Widget testApp(Widget home, {Locale locale = const Locale('th')}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: home,
  );
}

/// แอปทั้งแอปกับ Repository ปลอม (สัปดาห์ 10) ส่งตัวปลอมเข้ามาเพื่อตรวจผลได้
Future<Widget> cafeApp({
  String initialLocation = '/menu',
  FakeMenuRepository? menu,
  InMemoryOrderRepository? orders,
  InMemoryFavoriteRepository? favorites,
  FakeBranchRepository? branches,
  FakeAuthService? auth,
  InMemoryLiveOrders? live,
  Map<String, Object> prefs = const {},
}) async {
  SharedPreferences.setMockInitialValues(prefs);
  final prefsService = PrefsService(await SharedPreferences.getInstance());
  return buildApp(
    AppDependencies(
      menu: menu ?? FakeMenuRepository(),
      orders: live ?? orders ?? InMemoryOrderRepository(),
      live: live,
      auth: auth ?? FakeAuthService(),
      favorites: favorites ?? InMemoryFavoriteRepository(),
      settings: SettingsRepository(prefsService),
      branches: branches ?? FakeBranchRepository(),
    ),
    initialLocation: initialLocation,
  );
}
