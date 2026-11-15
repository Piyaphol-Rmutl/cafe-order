import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'app_dependencies.dart';
import 'config.dart';
import 'data/repositories/branch_repository.dart';
import 'data/repositories/favorite_repository.dart';
import 'data/repositories/firestore_order_repository.dart';
import 'data/repositories/menu_repository.dart';
import 'data/repositories/order_repository.dart';
import 'data/repositories/review_repository.dart';
import 'data/repositories/settings_repository.dart';
import 'data/services/api_service.dart';
import 'data/services/auth_service.dart';
import 'data/services/database_service.dart';
import 'data/services/file_service.dart';
import 'data/services/firebase_setup.dart';
import 'data/services/location_service.dart';
import 'data/services/photo_service.dart';
import 'data/services/prefs_service.dart';
import 'l10n/app_localizations.dart';
import 'router.dart';
import 'theme.dart';
import 'ui/auth/auth_view_model.dart';
import 'ui/settings/settings_view_model.dart';

/// จุดประกอบ (composition root): สร้าง Service → Repository ที่นี่ที่เดียว
/// แล้วส่งต่อให้ ViewModel ผ่านคอนสตรักเตอร์ (constructor injection)
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ต้องมีก่อนเรียกปลั๊กอิน
  final db = await DatabaseService.open();
  final prefs = await PrefsService.create();
  final files = FileService();
  final api = ApiService(baseUrl: apiBaseUrl); // สัปดาห์ 11
  final (firebaseAuth, firestore) = await initFirebase(); // สัปดาห์ 12
  final auth = FirebaseAuthService(firebaseAuth);
  final orders = FirestoreOrderRepository(
    firestore,
    auth,
    LocalOrderRepository(db, files),
  );

  runApp(
    buildApp(
      AppDependencies(
        // สลับ implementation ที่นี่ที่เดียว UI ไม่ต้องแก้
        menu: ApiMenuRepository(api),
        orders: orders, // สัปดาห์ 11 ใช้ ApiOrderRepository
        live: orders,
        auth: auth,
        location: const GeolocatorLocationService(), // สัปดาห์ 13
        photos: ImagePickerPhotoService(),
        reviews: ReviewRepository(files),
        branches: ApiBranchRepository(api),
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
    auth: context.read<AuthViewModel>(), // สัปดาห์ 12: AuthGate
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
