import 'package:cafe_order/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// MaterialApp สำหรับทดสอบวิดเจ็ตเดี่ยว (มี delegates ของภาษา เพราะวิดเจ็ตใช้ context.l10n)
Widget testApp(Widget home, {Locale locale = const Locale('th')}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: home,
  );
}
