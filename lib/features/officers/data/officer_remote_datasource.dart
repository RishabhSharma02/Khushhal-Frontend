/// HTTP access to `/api/v1/officers/{id}`.
library;

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import 'officer_api.dart';

class OfficerRemoteDataSource {
  OfficerRemoteDataSource(this._api);

  final ApiClient _api;

  /// Returns the officer, or null when the backend has none by that id.
  /// Any other failure bubbles out — a flaky connection is a caller concern.
  Future<RemoteOfficer?> get(int id) async {
    try {
      final json = await _api.getJson('/api/v1/officers/$id');
      return RemoteOfficer.fromJson(json);
    } on ApiException catch (e) {
      if (e.statusCode == 404) return null;
      rethrow;
    }
  }
}
