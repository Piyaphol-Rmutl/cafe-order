import '../services/database_service.dart';

abstract interface class FavoriteRepository {
  Future<Set<String>> load();
  Future<void> setFavorite(String menuId, bool favorite);
}

/// รายการโปรดเก็บในตาราง favorites ของ SQLite
class SqliteFavoriteRepository implements FavoriteRepository {
  SqliteFavoriteRepository(this._db);

  final DatabaseService _db;

  @override
  Future<Set<String>> load() async => (await _db.queryFavorites()).toSet();

  @override
  Future<void> setFavorite(String menuId, bool favorite) =>
      favorite ? _db.insertFavorite(menuId) : _db.deleteFavorite(menuId);
}
