import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Service ชั้นล่างสุด: คุยกับ SQLite ผ่าน sqflite
/// รับ/คืนข้อมูลดิบเป็น Map ไม่รู้จักคลาส Order และไม่มีตรรกะทางธุรกิจ
class DatabaseService {
  DatabaseService._(this._db);

  final Database _db;

  /// เปิด (หรือสร้าง) ไฟล์ cafe.db
  /// [factory] และ [path] ใช้สลับเป็นฐานข้อมูลในหน่วยความจำตอนทดสอบ
  static Future<DatabaseService> open({
    DatabaseFactory? factory,
    String? path,
  }) async {
    final f = factory ?? databaseFactory;
    final dbPath = path ?? join(await f.getDatabasesPath(), 'cafe.db');
    final db = await f.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(version: 1, onCreate: _onCreate),
    );
    return DatabaseService._(db);
  }

  static Future<void> _onCreate(Database db, int version) async {
    // ตารางประวัติคำสั่งซื้อ: รายการเก็บเป็นข้อความ JSON ในคอลัมน์ items
    await db.execute('''
      CREATE TABLE orders(
        id TEXT PRIMARY KEY,
        created_at INTEGER NOT NULL,
        status TEXT NOT NULL,
        total INTEGER NOT NULL,
        items TEXT NOT NULL
      )''');
    // ตารางรายการโปรด: มีแค่รหัสเมนู
    await db.execute('CREATE TABLE favorites(menu_id TEXT PRIMARY KEY)');
  }

  // ---------- orders ----------
  Future<void> insertOrder(Map<String, Object?> row) =>
      _db.insert('orders', row, conflictAlgorithm: ConflictAlgorithm.replace);

  Future<List<Map<String, Object?>>> queryOrders() =>
      _db.query('orders', orderBy: 'created_at DESC');

  /// เลขลำดับสูงสุดของรหัสคำสั่งซื้อในเครื่อง (A001 → 1, ยังไม่มี → 0)
  /// ใช้ค่าสูงสุดแทนการนับแถว รหัสถัดไปจึงไม่ซ้ำแม้จะลบคำสั่งซื้อบางรายการ
  Future<int> maxOrderNumber() async =>
      Sqflite.firstIntValue(
        await _db.rawQuery(
          "SELECT MAX(CAST(SUBSTR(id, 2) AS INTEGER)) FROM orders "
          "WHERE id LIKE 'A%'",
        ),
      ) ??
      0;

  // ---------- favorites ----------
  Future<List<String>> queryFavorites() async {
    final rows = await _db.query('favorites');
    return [for (final r in rows) r['menu_id'] as String];
  }

  Future<void> insertFavorite(String menuId) => _db.insert('favorites', {
    'menu_id': menuId,
  }, conflictAlgorithm: ConflictAlgorithm.ignore);

  Future<void> deleteFavorite(String menuId) =>
      _db.delete('favorites', where: 'menu_id = ?', whereArgs: [menuId]);

  Future<void> close() => _db.close();
}
