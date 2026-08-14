/// HTTP access to `/api/v1/me`.
library;

import '../../../core/network/api_client.dart';

/// Thin wrapper over the profile endpoints.
class ProfileRemoteDataSource {
  ProfileRemoteDataSource(this._api);

  final ApiClient _api;

  /// The signed-in user's profile.
  Future<Map<String, dynamic>> me() => _api.getJson('/api/v1/me');

  /// Partial profile update. Omitted fields are left untouched by the backend.
  Future<Map<String, dynamic>> patchMe({
    String? name,
    String? language,
    String? state,
    String? district,
    String? village,
    bool? notificationsEnabled,
  }) {
    return _api.patchJson(
      '/api/v1/me',
      body: <String, dynamic>{
        'name': ?name,
        'language': ?language,
        'state': ?state,
        'district': ?district,
        'village': ?village,
        'notifications_enabled': ?notificationsEnabled,
      },
    );
  }

  /// Savings and loan live on their own endpoint, and it requires both values
  /// rather than accepting a partial.
  Future<Map<String, dynamic>> patchSavingsLoan({
    required int savingsInr,
    required int loanInr,
  }) {
    return _api.patchJson(
      '/api/v1/me/savings-loan',
      body: <String, dynamic>{
        'savings_inr': savingsInr,
        'loan_inr': loanInr,
      },
    );
  }
}
