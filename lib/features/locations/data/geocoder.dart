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
}
