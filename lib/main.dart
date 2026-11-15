import 'package:cafe_core/cafe_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'l10n/app_localizations.dart';
import 'router.dart';
import 'theme.dart';

// จุดเริ่มต้นของแอป: runApp() รับวิดเจ็ตราก
void main() {
  runApp(const CafeOrderApp());
}

/// วิดเจ็ตรากของแอป Café Order (แอปสั่งเครื่องดื่มร้านกาแฟของคณะ)
/// เก็บตะกร้า โหมดธีม และภาษาไว้ที่ราก (ยกสถานะขึ้น)
class CafeOrderApp extends StatefulWidget {
  const CafeOrderApp({
    super.key,
    this.initialLocation = '/menu',
    this.initialLocale = const Locale('th'),
  });

  final String initialLocation;
  final Locale initialLocale;

  @override
  State<CafeOrderApp> createState() => _CafeOrderAppState();
}

class _CafeOrderAppState extends State<CafeOrderApp> {
  final List<OrderItem> _cart = [];
  ThemeMode _themeMode = ThemeMode.system;
  late Locale _locale = widget.initialLocale;

  late final GoRouter _router = createRouter(
    cart: _cart,
    initialLocation: widget.initialLocation,
    onThemeModeChanged: (mode) => setState(() => _themeMode = mode),
    onLocaleChanged: (locale) => setState(() => _locale = locale),
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false, // ไม่แสดงป้าย DEBUG
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router,
    );
  }
}
