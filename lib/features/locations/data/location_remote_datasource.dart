/// HTTP access to `/api/v1/locations`.
library;

import '../../../core/network/api_client.dart';

/// A state as the backend serves it.
class RemoteState {
  const RemoteState({
    required this.code,
    required this.nameEn,
    required this.nameHi,
  });

  final String code;
  final String nameEn;
  final String nameHi;

  factory RemoteState.fromJson(Map<String, dynamic> json) => RemoteState(
    code: json['code'] as String,
    nameEn: json['name_en'] as String,
    nameHi: (json['name_hi'] as String?) ?? json['name_en'] as String,
  );
}

/// Thin wrapper over the location endpoints.
class LocationRemoteDataSource {
  LocationRemoteDataSource(this._api);

  final ApiClient _api;

  Future<List<RemoteState>> listStates() async {
    final rows = await _api.getList('/api/v1/locations/states');
    return rows
        .cast<Map<String, dynamic>>()
        .map(RemoteState.fromJson)
        .toList(growable: false);
  }

  Future<List<String>> listDistricts(String stateCode) async {
    final rows = await _api.getList(
      '/api/v1/locations/states/$stateCode/districts',
    );
    return rows
        .cast<Map<String, dynamic>>()
        .map((r) => r['name_en'] as String)
        .toList(growable: false);
  }
}
