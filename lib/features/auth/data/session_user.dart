/// The user record returned by `GET /me` / `POST /auth/session`.
class SessionUser {
  const SessionUser({
    required this.id,
    required this.phoneE164,
    required this.name,
    required this.language,
    required this.savingsInr,
    required this.loanInr,
    required this.notificationsEnabled,
    this.state,
    this.district,
    this.village,
  });

  final int id;
  final String phoneE164;
  final String? name;
  final String language; // 'hi' | 'en'
  final int savingsInr;
  final int loanInr;
  final bool notificationsEnabled;
  final String? state;
  final String? district;
  final String? village;

  factory SessionUser.fromJson(Map<String, dynamic> json) {
    return SessionUser(
      id: json['id'] as int,
      phoneE164: json['phone_e164'] as String,
      name: json['name'] as String?,
      language: json['language'] as String,
      savingsInr: json['savings_inr'] as int,
      loanInr: json['loan_inr'] as int,
      notificationsEnabled: json['notifications_enabled'] as bool,
      state: json['state'] as String?,
      district: json['district'] as String?,
      village: json['village'] as String?,
    );
  }
}
