import '../../../core/network/api_client.dart';

class RemoteState {
  const RemoteState({required this.code, required this.nameEn, required this.nameHi});
  final String code;
  final String nameEn;
  final String nameHi;

  factory RemoteState.fromJson(Map<String, dynamic> json) => RemoteState(
        code: json['code'] as String,
        nameEn: json['name_en'] as String,
        nameHi: json['name_hi'] as String,
      );
}

class LocationRepository {
  LocationRepository(this._api);
  final ApiClient _api;

  Future<List<RemoteState>> listStates() async {
    final rows = await _api.getList('/api/v1/locations/states');
    return rows.cast<Map<String, dynamic>>().map(RemoteState.fromJson).toList(growable: false);
  }

  Future<List<String>> listDistricts(String stateCode) async {
    final rows = await _api.getList('/api/v1/locations/states/$stateCode/districts');
    return rows.cast<Map<String, dynamic>>().map((r) => r['name_en'] as String).toList(growable: false);
  }

  /// PATCH the current user's saved location so subsequent scoring picks up
  /// the (state, district, village) tuple.
  Future<void> saveOnUser({
    required String? state,
    required String? district,
    required String? village,
  }) async {
    await _api.patchJson('/api/v1/me', body: {
      'state': ?state,
      'district': ?district,
      'village': ?village,
    });
  }
}
