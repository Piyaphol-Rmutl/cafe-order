/// หมวดของเมนู: enum ที่มีฟิลด์ของตนเอง
enum MenuCategory {
  coffee('กาแฟ'),
  tea('ชาและนม'),
  soda('โซดา'),
  bakery('เบเกอรี่');

  const MenuCategory(this.label);
  final String label;
}

/// รายการเมนูหนึ่งรายการ (ราคาเก็บเป็นจำนวนเต็มหน่วยบาท เลี่ยงปัญหาทศนิยม)
class MenuItem {
  const MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.nameEn, // ไม่บังคับ จึงเป็นชนิด String? (อาจเป็น null)
    this.description = '',
  });

  final String id;
  final String name;
  final String? nameEn;
  final MenuCategory category;
  final int price;
  final String description;

  /// เครื่องดื่มปรับขนาด/ความหวานได้ ส่วนเบเกอรี่ไม่ได้
  bool get isDrink => category != MenuCategory.bakery;

  /// ชื่อภาษาอังกฤษ ถ้าไม่มีให้ใช้ชื่อไทยแทน (ตัวดำเนินการ ??)
  String get displayNameEn => nameEn ?? name;

  /// สร้างจาก JSON (Map) ด้วยคอนสตรักเตอร์แบบ factory
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as String,
      name: json['name'] as String,
      nameEn: json['nameEn'] as String?,
      category: MenuCategory.values.byName(json['category'] as String),
      price: json['price'] as int,
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (nameEn != null) 'nameEn': nameEn,
        'category': category.name,
        'price': price,
        'description': description,
      };

  // เทียบด้วย id เพื่อใช้เป็นสมาชิกของ Set หรือคีย์ของ Map ได้
  @override
  bool operator ==(Object other) => other is MenuItem && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'MenuItem($id, $price บาท)';
}

/// จัดกลุ่มเมนูตามหมวด: คืนค่าเป็น Map<หมวด, List<เมนู>>
Map<MenuCategory, List<MenuItem>> groupByCategory(List<MenuItem> menu) {
  final groups = <MenuCategory, List<MenuItem>>{};
  for (final item in menu) {
    groups.putIfAbsent(item.category, () => []).add(item);
  }
  return groups;
}
