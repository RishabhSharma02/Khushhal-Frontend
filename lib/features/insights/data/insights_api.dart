import '../../../app/model/insights.dart';

/// Backend contracts — decoded straight from the FastAPI JSON.

class RemoteHealth {
  const RemoteHealth({
    required this.id,
    required this.businessId,
    required this.asOn,
    required this.nextUpdate,
    required this.score,
    required this.risk,
    required this.delta,
    required this.daysWritten,
    required this.daysInMonth,
    required this.band,
    required this.pGreen,
    required this.pAmber,
    required this.pRed,
    required this.modelVersion,
  });

  final int id;
  final int businessId;
  final DateTime asOn;
  final DateTime nextUpdate;
  final int score;
  final String risk; // low|medium|high
  final int? delta;
  final int daysWritten;
  final int daysInMonth;
  final String band; // green|amber|red
  final double pGreen;
  final double pAmber;
  final double pRed;
  final String modelVersion;

  factory RemoteHealth.fromJson(Map<String, dynamic> json) => RemoteHealth(
        id: json['id'] as int,
        businessId: json['business_id'] as int,
        asOn: DateTime.parse(json['as_on'] as String),
        nextUpdate: DateTime.parse(json['next_update'] as String),
        score: json['score'] as int,
        risk: json['risk'] as String,
        delta: json['delta'] as int?,
        daysWritten: json['days_written'] as int,
        daysInMonth: json['days_in_month'] as int,
        band: json['band'] as String,
        pGreen: (json['p_green'] as num).toDouble(),
        pAmber: (json['p_amber'] as num).toDouble(),
        pRed: (json['p_red'] as num).toDouble(),
        modelVersion: json['model_version'] as String,
      );

  HealthSnapshot toDomain() => HealthSnapshot(
        score: score,
        asOn: asOn,
        nextUpdate: nextUpdate,
        risk: switch (risk) {
          'low' => RiskLevel.low,
          'medium' => RiskLevel.medium,
          _ => RiskLevel.high,
        },
        daysWritten: daysWritten,
        daysInMonth: daysInMonth,
        delta: delta,
      );
}

class RemoteForecastMonth {
  const RemoteForecastMonth({
    required this.horizon,
    required this.cfPred,
    required this.inLevel,
    required this.outLevel,
    required this.isRiskMonth,
  });

  final int horizon;
  final double cfPred;
  final double inLevel;
  final double outLevel;
  final bool isRiskMonth;

  factory RemoteForecastMonth.fromJson(Map<String, dynamic> json) => RemoteForecastMonth(
        horizon: json['horizon'] as int,
        cfPred: (json['cf_pred'] as num).toDouble(),
        inLevel: (json['in_level'] as num).toDouble(),
        outLevel: (json['out_level'] as num).toDouble(),
        isRiskMonth: json['is_risk_month'] as bool,
      );
}

class RemoteForecast {
  const RemoteForecast({required this.businessId, required this.asOn, required this.months});
  final int businessId;
  final DateTime asOn;
  final List<RemoteForecastMonth> months;

  factory RemoteForecast.fromJson(Map<String, dynamic> json) => RemoteForecast(
        businessId: json['business_id'] as int,
        asOn: DateTime.parse(json['as_on'] as String),
        months: (json['months'] as List<dynamic>)
            .cast<Map<String, dynamic>>()
            .map(RemoteForecastMonth.fromJson)
            .toList(),
      );

  List<ForecastMonth> toDomain() {
    final base = DateTime(asOn.year, asOn.month, 1);
    return months.map((m) {
      final month = DateTime(base.year, base.month + m.horizon, 1);
      return ForecastMonth(
        month: month,
        cfPred: m.cfPred,
        inLevel: m.inLevel,
        outLevel: m.outLevel,
        isRiskMonth: m.isRiskMonth,
      );
    }).toList(growable: false);
  }
}

class RemotePlanAction {
  const RemotePlanAction({
    required this.id,
    required this.role,
    required this.ordinal,
    required this.labelEn,
    required this.labelHi,
    required this.done,
  });

  final int id;
  final String role; // owner | field_officer
  final int ordinal;
  final String labelEn;
  final String? labelHi;
  final bool done;

  factory RemotePlanAction.fromJson(Map<String, dynamic> json) => RemotePlanAction(
        id: json['id'] as int,
        role: json['role'] as String,
        ordinal: json['ordinal'] as int,
        labelEn: json['label_en'] as String,
        labelHi: json['label_hi'] as String?,
        done: json['done'] as bool,
      );
}

class RemoteAlert {
  const RemoteAlert({
    required this.id,
    required this.businessId,
    required this.asOn,
    required this.kind,
    required this.severity,
    required this.driver,
    required this.hasPlan,
    required this.raisedOn,
    this.planActions = const [],
  });

  final int id;
  final int businessId;
  final DateTime asOn;
  final String kind; // savings_low | liquidity_debt_stress | climate_deficit | climate_excess | market_stress | new_business
  final String severity; // urgent | info
  final String driver;
  final bool hasPlan;
  final DateTime raisedOn;
  final List<RemotePlanAction> planActions;

  factory RemoteAlert.fromJson(Map<String, dynamic> json) {
    final raw = json['plan_actions'] as List<dynamic>?;
    return RemoteAlert(
      id: json['id'] as int,
      businessId: json['business_id'] as int,
      asOn: DateTime.parse(json['as_on'] as String),
      kind: json['kind'] as String,
      severity: json['severity'] as String,
      driver: json['driver'] as String,
      hasPlan: json['has_plan'] as bool,
      raisedOn: DateTime.parse(json['raised_on'] as String),
      planActions: raw == null
          ? const []
          : raw.cast<Map<String, dynamic>>().map(RemotePlanAction.fromJson).toList(),
    );
  }

  /// Collapse the six backend kinds into the three currently rendered by
  /// AlertsScreen. Copy is Phase-3 work; for now the label is close enough.
  AlertKind toDomainKind() => switch (kind) {
        'savings_low' => AlertKind.savingsRunningLow,
        'liquidity_debt_stress' => AlertKind.savingsRunningLow,
        'new_business' => AlertKind.savingsRunningLow,
        'market_stress' => AlertKind.fodderPriceUp,
        'climate_deficit' => AlertKind.heavyRain,
        'climate_excess' => AlertKind.heavyRain,
        _ => AlertKind.savingsRunningLow,
      };

  AlertSeverity toDomainSeverity() =>
      severity == 'urgent' ? AlertSeverity.urgent : AlertSeverity.info;

  RiskAlert toDomain() => RiskAlert(
        kind: toDomainKind(),
        severity: toDomainSeverity(),
        raisedOn: raisedOn,
        hasPlan: hasPlan,
        backendId: id,
      );
}
