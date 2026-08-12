import '../../../app/model/business.dart';
import '../../../core/network/api_client.dart';
import 'business_api.dart';

/// Talks to `/api/v1/businesses`. Read-through cache is deliberately
/// omitted for v1 — the list is short and re-fetching on Home/Hub is cheap;
/// we can layer Hive on top later if measurements demand it.
class BusinessRepository {
  BusinessRepository(this._api);
  final ApiClient _api;

  Future<RemoteBusiness> create(Business business) async {
    final json = await _api.postJson(
      '/api/v1/businesses',
      body: businessCreateBody(business),
    );
    return RemoteBusiness.fromJson(json);
  }

  Future<List<RemoteBusiness>> list() async {
    final items = await _api.getList('/api/v1/businesses');
    return items
        .cast<Map<String, dynamic>>()
        .map(RemoteBusiness.fromJson)
        .toList(growable: false);
  }

  Future<void> softDelete(int businessId) async {
    await _api.delete('/api/v1/businesses/$businessId');
  }

  /// PATCH a subset of editable fields. Only name / staff_count / tenure
  /// are editable in the UI today (segment + sector affect ML scoring so
  /// they stay locked).
  Future<RemoteBusiness> update(
    int businessId, {
    String? name,
    int? staffCount,
    String? tenure,
  }) async {
    final body = <String, dynamic>{
      'name': ?name,
      'staff_count': ?staffCount,
      'tenure': ?tenure,
    };
    final json = await _api.patchJson('/api/v1/businesses/$businessId', body: body);
    return RemoteBusiness.fromJson(json);
  }
}
