/// Wire model + mapping for `/api/v1/officers/{id}`.
library;

import '../../../app/model/assigned_officer.dart';

/// Backend representation of an Officer row.
class RemoteOfficer {
  const RemoteOfficer({
    required this.id,
    required this.employeeId,
    required this.fullName,
    this.email,
    this.mobileE164,
  });

  /// Backend BIGINT id — the value carried on `Business.officer_id`.
  final int id;

  /// Department/employee code shown to the owner (e.g. "UP-SIT-0482").
  final String employeeId;

  final String fullName;

  /// Optional on the backend since 2026-08-15 (0009_officer_mobile_optional).
  final String? email;
  final String? mobileE164;

  factory RemoteOfficer.fromJson(Map<String, dynamic> json) {
    return RemoteOfficer(
      id: (json['id'] as num).toInt(),
      employeeId: json['employee_id'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String?,
      mobileE164: json['mobile_e164'] as String?,
    );
  }

  AssignedOfficer toDomain() {
    return AssignedOfficer(
      officerId: employeeId,
      name: fullName,
      email: email ?? '',
      mobile: mobileE164 ?? '',
    );
  }
}
