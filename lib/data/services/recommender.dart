import 'package:cafe_core/cafe_core.dart';

import 'api_service.dart';

/// ข้อมูลที่ใช้แนะนำเมนู (ส่งเฉพาะที่จำเป็น ไม่ส่งข้อมูลส่วนตัว เช่น ชื่อ อีเมล พิกัด)
class RecommendationRequest {
  const RecommendationRequest({
    required this.hour,
    this.orderCounts = const {},
    this.favorites = const {},
  });

  final int hour;
  final Map<String, int> orderCounts; // รหัสเมนู → จำนวนครั้งที่สั่ง
  final Set<String> favorites;

  Map<String, dynamic> toJson() => {
    'hour': hour,
    'orderCounts': orderCounts,
    'favorites': [...favorites],
  };
}

/// สัปดาห์ 16: ฟีเจอร์ AI เขียนเป็นอินเทอร์เฟซ ส่วนอื่นของแอปไม่รู้ว่าเบื้องหลังคืออะไร
/// (กฎ, โมเดลบนเครื่อง, หรือโมเดลภาษาขนาดใหญ่ผ่านเซิร์ฟเวอร์ของเรา)
abstract interface class MenuRecommender {
  Future<Recommendation> recommend(
    List<MenuItem> menu,
    RecommendationRequest request,
  );
}

/// Service ปลอม: ใช้กฎแทนโมเดล AI (ไม่ใช้เครือข่าย ไม่ใช้คีย์ API ผลคาดเดาได้)
class FakeRecommender implements MenuRecommender {
  const FakeRecommender({this.delay = const Duration(milliseconds: 400)});

  final Duration delay; // จำลองเวลาที่โมเดลใช้คิด

  @override
  Future<Recommendation> recommend(
    List<MenuItem> menu,
    RecommendationRequest request,
  ) async {
    await Future<void>.delayed(delay);
    return recommendByRules(
      menu: menu,
      hour: request.hour,
      orderCounts: request.orderCounts,
      favorites: request.favorites,
    );
  }
}

/// รูปแบบที่ถูกต้องเมื่อใช้ AI จริง: แอปเรียกเซิร์ฟเวอร์ของเรา (POST /recommend)
/// แล้วเซิร์ฟเวอร์จึงเรียกผู้ให้บริการ AI ด้วยคีย์ที่เก็บไว้ฝั่งเซิร์ฟเวอร์
/// ห้ามฝังคีย์ API ของผู้ให้บริการ AI ไว้ในแอป (ถอดรหัส APK/IPA แล้วอ่านได้)
class ApiRecommender implements MenuRecommender {
  ApiRecommender(this._api);

  final ApiService _api;

  @override
  Future<Recommendation> recommend(
    List<MenuItem> menu,
    RecommendationRequest request,
  ) async {
    final json = await _api.postJson(
      '/recommend',
      request.toJson(),
      expected: 200,
    );
    return parseOrThrow(
      () => Recommendation.fromJson(json as Map<String, dynamic>),
    );
  }
}

/// ข้อความสั่ง (prompt) ที่เซิร์ฟเวอร์จะส่งให้โมเดลภาษา — ใช้อธิบายในบทเรียน
/// กำหนดบทบาท ข้อมูลที่อนุญาต รูปแบบคำตอบ และข้อจำกัด (เลือกจากเมนูที่มีเท่านั้น)
String buildRecommendationPrompt(
  List<MenuItem> menu,
  RecommendationRequest request,
) {
  final items = menu
      .map((m) => '- ${m.id}: ${m.name} ${m.price} บาท')
      .join('\n');
  return '''
คุณเป็นบาริสต้าที่แนะนำเครื่องดื่มหนึ่งรายการ
เลือกจากเมนูต่อไปนี้เท่านั้น:
$items
ข้อมูลลูกค้า: เวลา ${request.hour}:00 น., สั่งบ่อย ${request.orderCounts}, รายการโปรด ${request.favorites.join(', ')}
ตอบเป็น JSON {"id": "<รหัสเมนู>", "reason": "<เหตุผลสั้น ๆ ภาษาไทย>"}''';
}
