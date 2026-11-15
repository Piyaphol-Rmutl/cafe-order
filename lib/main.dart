import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'router.dart';
import 'state/cart_model.dart';
import 'state/settings_model.dart';
import 'theme.dart';

// จุดเริ่มต้นของแอป: วาง ChangeNotifierProvider ไว้เหนือ MaterialApp
// ทุกหน้าจึงเข้าถึงตะกร้าและค่าตั้งได้ด้วย context.watch / context.read
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartModel()),
        ChangeNotifierProvider(create: (_) => SettingsModel()),
      ],
      child: const CafeOrderApp(),
    ),
  );
}

/// วิดเจ็ตรากของแอป Café Order (แอปสั่งเครื่องดื่มร้านกาแฟของคณะ)
class CafeOrderApp extends StatefulWidget {
  const CafeOrderApp({super.key, this.initialLocation = '/menu'});

  final String initialLocation;

  @override
  State<CafeOrderApp> createState() => _CafeOrderAppState();
}

class _CafeOrderAppState extends State<CafeOrderApp> {
  // router สร้างครั้งเดียว ไม่ต้องรับสถานะใด ๆ แล้ว
  late final GoRouter _router = createRouter(
    initialLocation: widget.initialLocation,
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsModel>(); // เปลี่ยนแล้ว build ใหม่
    return MaterialApp.router(
      debugShowCheckedModeBanner: false, // ไม่แสดงป้าย DEBUG
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: settings.themeMode,
      locale: settings.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router,
    );
  }
}
