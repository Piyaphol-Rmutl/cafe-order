import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'app_dependencies.dart';
import 'data/repositories/favorite_repository.dart';
import 'data/repositories/menu_repository.dart';
import 'data/repositories/order_repository.dart';
import 'data/repositories/settings_repository.dart';
import 'data/services/database_service.dart';
import 'data/services/file_service.dart';
import 'data/services/prefs_service.dart';
import 'l10n/app_localizations.dart';
import 'router.dart';
import 'theme.dart';
import 'ui/settings/settings_view_model.dart';

/// จุดประกอบ (composition root): สร้าง Service → Repository ที่นี่ที่เดียว
/// แล้วส่งต่อให้ ViewModel ผ่านคอนสตรักเตอร์ (constructor injection)
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ต้องมีก่อนเรียกปลั๊กอิน
  final db = await DatabaseService.open();
  final prefs = await PrefsService.create();
  final files = FileService();

  runApp(
    buildApp(
      AppDependencies(
        menu: LocalMenuRepository(),
        orders: LocalOrderRepository(db, files),
        favorites: SqliteFavoriteRepository(db),
        settings: SettingsRepository(prefs),
      ),
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
    final settings = context.watch<SettingsViewModel>();
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
