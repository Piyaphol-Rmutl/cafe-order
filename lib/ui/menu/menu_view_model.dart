import 'package:cafe_core/cafe_core.dart';
import 'package:flutter/foundation.dart';

import '../../data/repositories/favorite_repository.dart';
import '../../data/repositories/menu_repository.dart';

/// ViewModel ของเมนู: เก็บสถานะ กำลังโหลด / ข้อมูล / ข้อผิดพลาด และรายการโปรด
class MenuViewModel extends ChangeNotifier {
  MenuViewModel(this._menu, this._favoriteRepo);

  final MenuRepository _menu;
  final FavoriteRepository _favoriteRepo;

  List<MenuItem> _items = [];
  Set<String> _favorites = {};
  bool _loading = false;
  Object? _error;

  List<MenuItem> get items => _items;
  bool get loading => _loading;
  Object? get error => _error;

  bool isFavorite(String id) => _favorites.contains(id);

  List<MenuItem> get favorites =>
      _items.where((m) => _favorites.contains(m.id)).toList();

  List<MenuItem> byCategory(MenuCategory? category) => category == null
      ? _items
      : _items.where((m) => m.category == category).toList();

  MenuItem? findById(String id) => _items.where((m) => m.id == id).firstOrNull;

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _items = await _menu.fetchMenu();
      _favorites = await _favoriteRepo.load();
    } catch (e) {
      _error = e;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String id) async {
    final favorite = !_favorites.contains(id);
    // อัปเดต UI ก่อน (optimistic) แล้วบันทึก ถ้าบันทึกพลาดให้ย้อนกลับ
    favorite ? _favorites.add(id) : _favorites.remove(id);
    notifyListeners();
    try {
      await _favoriteRepo.setFavorite(id, favorite);
    } catch (_) {
      favorite ? _favorites.remove(id) : _favorites.add(id);
      notifyListeners();
    }
  }
}
