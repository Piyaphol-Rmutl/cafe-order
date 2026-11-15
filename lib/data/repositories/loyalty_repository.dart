import '../services/api_service.dart';

/// แต้มสะสมของลูกค้า (API ที่ต้องแนบโทเค็น สัปดาห์ 15)
abstract interface class LoyaltyRepository {
  Future<int> fetchPoints();
}

class ApiLoyaltyRepository implements LoyaltyRepository {
  ApiLoyaltyRepository(this._api);

  final ApiService _api;

  @override
  Future<int> fetchPoints() async {
    final json = await _api.getJsonAuthorized('/me/points');
    return parseOrThrow(() => (json as Map)['points'] as int);
  }
}
