/// ตัวตรวจสอบข้อมูลของฟอร์ม (ฟังก์ชันล้วน จึงเขียน Unit Test ได้ง่าย)
/// คืน null = ผ่าน, คืนข้อความ = ข้อผิดพลาดที่จะแสดงใต้ช่อง
String? validateCupName(String? value) {
  final name = value?.trim() ?? '';
  if (name.isEmpty) return 'กรุณากรอกชื่อบนแก้ว';
  if (name.length > 20) return 'ชื่อยาวได้ไม่เกิน 20 ตัวอักษร';
  return null;
}

String? validateNote(String? value) {
  if ((value ?? '').length > 50) return 'หมายเหตุยาวได้ไม่เกิน 50 ตัวอักษร';
  return null;
}
