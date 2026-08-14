/// HTTP access to `/api/v1/businesses`.
library;

import '../../../app/model/business.dart';
import '../../../core/network/api_client.dart';
import 'business_api.dart';

/// Thin wrapper over the business endpoints.
///
/// Creation stays online-only by design, so there is no offline path here —
/// a new business needs a server id before anything else can reference it.
class BusinessRemoteDataSource {
  BusinessRemoteDataSource(this._api);

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

  /// PATCHes the editable subset. Segment and sector stay locked after setup
  /// because changing either invalidates every stamped health score.
  Future<RemoteBusiness> update(
    int businessId, {
    String? name,
    int? staffCount,
    String? tenure,
    int? savingsInr,
    int? loanInr,
  }) async {
    final json = await _api.patchJson(
      '/api/v1/businesses/$businessId',
      body: <String, dynamic>{
        'name': ?name,
        'staff_count': ?staffCount,
        'tenure': ?tenure,
        'savings_inr': ?savingsInr,
        'loan_inr': ?loanInr,
      },
    );
    return RemoteBusiness.fromJson(json);
  }

  Future<void> softDelete(int businessId) async {
    await _api.delete('/api/v1/businesses/$businessId');
  }
}
