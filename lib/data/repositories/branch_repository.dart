import 'package:cafe_core/cafe_core.dart';

import '../services/api_service.dart';

abstract interface class BranchRepository {
  Future<List<Branch>> fetchBranches();
}

/// GET /branches
class ApiBranchRepository implements BranchRepository {
  ApiBranchRepository(this._api);

  final ApiService _api;

  @override
  Future<List<Branch>> fetchBranches() async {
    final json = await _api.getJson('/branches');
    return parseOrThrow(
      () => [
        for (final e in json as List<dynamic>)
          Branch.fromJson(e as Map<String, dynamic>),
      ],
    );
  }
}
