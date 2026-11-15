import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'data/repositories/branch_repository.dart';
import 'data/repositories/favorite_repository.dart';
import 'data/repositories/live_order_repository.dart';
import 'data/repositories/menu_repository.dart';
import 'data/repositories/order_repository.dart';
import 'data/repositories/review_repository.dart';
import 'data/repositories/settings_repository.dart';
import 'data/services/auth_service.dart';
import 'data/services/location_service.dart';
import 'data/services/photo_service.dart';
import 'main.dart';
import 'ui/auth/auth_view_model.dart';
import 'ui/cart/cart_view_model.dart';
import 'ui/menu/menu_view_model.dart';
import 'ui/settings/settings_view_model.dart';

/// Repository ทุกตัวที่แอปต้องใช้ (main.dart สร้างตัวจริง เทสต์ส่งตัวปลอมแทนได้)
class AppDependencies {
  const AppDependencies({
    required this.menu,
    required this.orders,
    required this.favorites,
    required this.settings,
    required this.branches,
    required this.auth,
    required this.location,
    required this.photos,
    required this.reviews,
    this.live,
  });

  final MenuRepository menu;
  final OrderRepository orders;
  final FavoriteRepository favorites;
  final SettingsRepository settings;
  final BranchRepository branches;
  final AuthService auth;
  final LocationService location; // สัปดาห์ 13
  final PhotoService photos;
  final ReviewRepository reviews;
  final LiveOrderRepository? live; // null = ไม่มีสถานะเรียลไทม์
}

/// ประกอบแอป: วาง Repository และ ViewModel ระดับแอปไว้เหนือ CafeOrderApp
Widget buildApp(AppDependencies deps, {String initialLocation = '/menu'}) {
  return MultiProvider(
    providers: [
      // ชั้นข้อมูล: Provider ธรรมดา (ไม่เปลี่ยนค่า)
      Provider<MenuRepository>.value(value: deps.menu),
      Provider<OrderRepository>.value(value: deps.orders),
      Provider<BranchRepository>.value(value: deps.branches),
      Provider<LiveOrderRepository?>.value(value: deps.live),
      Provider<LocationService>.value(value: deps.location),
      Provider<PhotoService>.value(value: deps.photos),
      Provider<ReviewRepository>.value(value: deps.reviews),
      ChangeNotifierProvider(create: (_) => AuthViewModel(deps.auth)),
      // ชั้น ViewModel ระดับแอป
      ChangeNotifierProvider(
        create: (_) => MenuViewModel(deps.menu, deps.favorites)..load(),
      ),
      ChangeNotifierProvider(create: (_) => CartViewModel(deps.orders)),
      ChangeNotifierProvider(create: (_) => SettingsViewModel(deps.settings)),
    ],
    child: CafeOrderApp(initialLocation: initialLocation),
  );
}
