import 'menu_item.dart';

/// เมนูตัวอย่างของร้าน (ใช้ก่อนมีเซิร์ฟเวอร์ในสัปดาห์ 11)
const List<MenuItem> sampleMenu = [
  MenuItem(
    id: 'latte',
    name: 'ลาเต้',
    nameEn: 'Latte',
    category: MenuCategory.coffee,
    price: 55,
    description: 'เอสเปรสโซกับนมสดสตีม ฟองนมนุ่ม',
  ),
  MenuItem(
    id: 'americano',
    name: 'อเมริกาโน',
    nameEn: 'Americano',
    category: MenuCategory.coffee,
    price: 45,
    description: 'เอสเปรสโซเติมน้ำ รสเข้ม',
  ),
  MenuItem(
    id: 'mocha',
    name: 'มอคค่า',
    nameEn: 'Mocha',
    category: MenuCategory.coffee,
    price: 60,
    description: 'กาแฟผสมช็อกโกแลตและนม',
  ),
  MenuItem(
    id: 'thai_tea',
    name: 'ชาไทย',
    nameEn: 'Thai tea',
    category: MenuCategory.tea,
    price: 45,
    description: 'ชาไทยสูตรเข้มข้น หอมนม',
  ),
  MenuItem(
    id: 'matcha',
    name: 'มัทฉะลาเต้',
    nameEn: 'Matcha latte',
    category: MenuCategory.tea,
    price: 60,
    description: 'ชาเขียวมัทฉะกับนมสด',
  ),
  MenuItem(
    id: 'cocoa',
    name: 'โกโก้',
    nameEn: 'Cocoa',
    category: MenuCategory.tea,
    price: 50,
    description: 'โกโก้เข้มข้น',
  ),
  MenuItem(
    id: 'lemon_soda',
    name: 'เลมอนโซดา',
    nameEn: 'Lemon soda',
    category: MenuCategory.soda,
    price: 40,
    description: 'เลมอนสดกับโซดาซ่า',
  ),
  MenuItem(
    id: 'croissant',
    name: 'ครัวซองต์เนยสด',
    category: MenuCategory.bakery, // ไม่มีชื่ออังกฤษ (nameEn เป็น null)
    price: 35,
    description: 'อบใหม่ทุกเช้า',
  ),
];
