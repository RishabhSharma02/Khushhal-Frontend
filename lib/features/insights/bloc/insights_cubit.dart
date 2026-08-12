import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/insights_api.dart';
import '../data/insights_repository.dart';

enum InsightsStatus { idle, loading, loaded, error }

class InsightsState extends Equatable {
  const InsightsState({
    this.status = InsightsStatus.idle,
    this.businessId,
    this.health,
    this.forecast,
    this.alerts = const [],
    this.error,
  });

  final InsightsStatus status;
  final int? businessId;
  final RemoteHealth? health;
  final RemoteForecast? forecast;
  final List<RemoteAlert> alerts;
  final String? error;

  InsightsState copyWith({
    InsightsStatus? status,
    int? businessId,
    RemoteHealth? health,
    RemoteForecast? forecast,
    List<RemoteAlert>? alerts,
    String? error,
    bool clearError = false,
  }) {
    return InsightsState(
      status: status ?? this.status,
      businessId: businessId ?? this.businessId,
      health: health ?? this.health,
      forecast: forecast ?? this.forecast,
      alerts: alerts ?? this.alerts,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [status, businessId, health?.id, forecast?.asOn, alerts.length, error];
}

class InsightsCubit extends Cubit<InsightsState> {
  InsightsCubit(this._repo) : super(const InsightsState());
  final InsightsRepository _repo;

  Future<void> load(
    int businessId, {
    bool refreshFirst = false,
    bool autoRefreshIfMissing = true,
  }) async {
    // A different business must not inherit the previous one's insights.
    // `copyWith` can't clear a field, so switching starts from a bare state
    // — otherwise a business with no stamp yet shows its predecessor's
    // score, forecast and alerts.
    emit(state.businessId == businessId
        ? state.copyWith(status: InsightsStatus.loading, clearError: true)
        : InsightsState(status: InsightsStatus.loading, businessId: businessId));
    try {
      if (refreshFirst) {
        try { await _repo.refresh(businessId); } catch (_) {}
      }
      var bundle = await _repo.fetchAll(businessId);
      // Freshly-created businesses have no stamped score yet (health/forecast
      // return 404, alerts is []). In dev, kick the /insights/refresh
      // endpoint so the ML pipeline runs immediately and we can show real
      // data on Home the first time. Silent no-op if the endpoint 403s
      // (prod) or the pipeline can't load (no libomp).
      if (autoRefreshIfMissing && bundle.health == null) {
        try {
          await _repo.refresh(businessId);
          bundle = await _repo.fetchAll(businessId);
        } catch (_) {}
      }
      emit(InsightsState(
        status: InsightsStatus.loaded,
        businessId: businessId,
        health: bundle.health,
        forecast: bundle.forecast,
        alerts: bundle.alerts,
      ));
    } catch (e) {
      emit(state.copyWith(status: InsightsStatus.error, error: e.toString()));
    }
  }

  Future<void> togglePlanAction({
    required int businessId,
    required int alertId,
    required int actionId,
    required bool done,
  }) async {
    try {
      await _repo.togglePlanAction(
        businessId: businessId,
        alertId: alertId,
        actionId: actionId,
        done: done,
      );
      // Refresh alerts so the toggled state is reflected.
      final alerts = await _repo.getAlerts(businessId);
      emit(state.copyWith(alerts: alerts));
    } catch (_) {
      // Swallow — the UI already flipped its local state optimistically.
    }
  }
}
