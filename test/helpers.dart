import 'package:cafe_order/l10n/app_localizations.dart';
import 'package:cafe_order/main.dart';
import 'package:cafe_order/state/cart_model.dart';
import 'package:cafe_order/state/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// MaterialApp สำหรับทดสอบวิดเจ็ตเดี่ยว (มี delegates ของภาษา เพราะวิดเจ็ตใช้ context.l10n)
Widget testApp(Widget home, {Locale locale = const Locale('th')}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: home,
  );
}

/// แอปทั้งแอปพร้อม Provider (สัปดาห์ 8) ส่ง [cart] เข้ามาเพื่อตรวจสถานะได้
Widget cafeApp({String initialLocation = '/menu', CartModel? cart}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => cart ?? CartModel()),
      ChangeNotifierProvider(create: (_) => SettingsModel()),
    ],
    child: CafeOrderApp(initialLocation: initialLocation),
  );
}
