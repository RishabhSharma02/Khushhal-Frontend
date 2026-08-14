import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

/// Thin wrapper around OpenStreetMap Nominatim geocoding.
///
/// Free, no API key, ~1 req/sec per client — plenty for a "user picked a
/// district" callback. We ask for one hit and the highest-confidence match
/// so map + marker centre on the district town rather than the state.
class Geocoder {
  Geocoder({Dio? dio})
      : _dio = dio ??
            (Dio(BaseOptions(
              baseUrl: 'https://nominatim.openstreetmap.org',
              connectTimeout: const Duration(seconds: 6),
              receiveTimeout: const Duration(seconds: 6),
              headers: {
                // Nominatim requires an identifying User-Agent.
                'User-Agent': 'Khushhal-App/1.0 (contact: dev@khushhal.local)',
                'Accept': 'application/json',
              },
            )));

  final Dio _dio;

  Future<LatLng?> forDistrict({required String state, required String? district}) async {
    final q = [district, state, 'India'].where((s) => s != null && s.isNotEmpty).join(', ');
    try {
      final resp = await _dio.get<List<dynamic>>('/search', queryParameters: {
        'q': q, 'format': 'json', 'limit': 1, 'addressdetails': 0,
      });
      final rows = resp.data;
      if (rows == null || rows.isEmpty) return null;
      final row = rows.first as Map<String, dynamic>;
      final lat = double.tryParse(row['lat'] as String? ?? '');
      final lon = double.tryParse(row['lon'] as String? ?? '');
      if (lat == null || lon == null) return null;
      return LatLng(lat, lon);
    } catch (_) {
      return null;
    }
  }

  /// Reverse-geocode a device GPS fix into `{state, district, village}`.
  /// Any field can come back null when Nominatim doesn't know that level
  /// for the given coordinate.
  Future<ReverseResult?> reverse(LatLng at) async {
    try {
      final resp = await _dio.get<Map<String, dynamic>>('/reverse', queryParameters: {
        'lat': at.latitude, 'lon': at.longitude,
        'format': 'json', 'addressdetails': 1, 'zoom': 12,
      });
      final data = resp.data;
      if (data == null) return null;
      final addr = (data['address'] as Map?)?.cast<String, dynamic>() ?? const {};
      return ReverseResult(
        state: addr['state'] as String?,
        district: (addr['state_district'] as String?)
            ?? (addr['county'] as String?)
            ?? (addr['city_district'] as String?),
        village: (addr['village'] as String?)
            ?? (addr['town'] as String?)
            ?? (addr['hamlet'] as String?)
            ?? (addr['suburb'] as String?)
            ?? (addr['city'] as String?),
      );
    } catch (_) {
      return null;
    }
  }
}

class ReverseResult {
  const ReverseResult({this.state, this.district, this.village});
  final String? state;
  final String? district;
  final String? village;
}
