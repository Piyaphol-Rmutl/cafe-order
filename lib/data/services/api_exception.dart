/// ข้อผิดพลาดจากการเรียก API ทุกชนิดถูกแปลงเป็นคลาสนี้ UI จึงจัดการแบบเดียว
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message; // ข้อความสำหรับแสดงผู้ใช้
  final int? statusCode; // null = ไม่ได้รับคำตอบเลย (เครือข่าย/หมดเวลา)

  @override
  String toString() => message;
}
