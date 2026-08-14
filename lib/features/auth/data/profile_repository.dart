/// Local-first access to the signed-in user's profile.
library;

import '../../../core/db/app_database.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/sync/outbox_dao.dart';
import '../../../core/sync/sync_op.dart';
import 'profile_local_datasource.dart';
import 'profile_remote_datasource.dart';
import 'session_user.dart';

/// Reads the cached profile; writes locally and queues the PATCH.
class ProfileRepository {
  ProfileRepository({
    required ProfileLocalDataSource local,
    required ProfileRemoteDataSource remote,
    required OutboxDao outbox,
  }) : _local = local,
       _remote = remote,
       _outbox = outbox;

  final ProfileLocalDataSource _local;
  final ProfileRemoteDataSource _remote;
  final OutboxDao _outbox;

  /// The cached profile, or null before the first successful sign-in.
  Future<LocalUser?> current() => _local.activeUser();

  /// Live view for screens that show the name, location or money tiles.
  Stream<LocalUser?> watch() => _local.watchActiveUser();

  /// Whether this device has a completed profile on disk.
  Future<bool> hasLocalProfile() => _local.hasOnboardedUser();

  /// The cached profile shaped like a `/auth/session` response.
  ///
  /// This is what lets a returning user open the app on a train. Startup used
  /// to hard-depend on `POST /auth/session`, so no connection meant no user
  /// object and the whole session was treated as signed out — despite every
  /// row they cared about already sitting in SQLite.
  ///
  /// Only rows that carry a server id qualify: without one there is nothing to
  /// PATCH against later, which means the user never completed onboarding and
  /// genuinely does need the network.
  Future<SessionUser?> cachedSessionUser() async {
    final LocalUser? row = await _local.activeUser();
    if (row == null) return null;
    final int? serverId = row.serverId;
    if (serverId == null) return null;
    return SessionUser(
      id: serverId,
      phoneE164: row.phoneE164 ?? '',
      name: row.name,
      language: row.language,
      savingsInr: row.savingsInr,
      loanInr: row.loanInr,
      notificationsEnabled: row.notificationsEnabled,
      state: row.state,
      district: row.district,
      village: row.village,
    );
  }

  /// Mirrors `/me` into SQLite. Called after sign-in and by the pull cycle.
  Future<LocalUser?> refreshFromServer({String? firebaseUid}) async {
    try {
      final Map<String, dynamic> me = await _remote.me();
      await _local.upsertFromServer(
        me,
        firebaseUid: firebaseUid,
        preserveLocalEdits: true,
      );
    } on ApiException {
      // Offline: the cached row is the answer.
    }
    return _local.activeUser();
  }

  /// Seeds SQLite from the `/auth/session` response so subsequent local
  /// writes (name capture, savings toggle, …) have an active row to update.
  ///
  /// Without this, a brand-new sign-in has no local user until the sync
  /// engine's next pull cycle — meaning `setName` from `NameCaptureScreen`
  /// silently drops on the floor (updateLocalProfile returns null → no
  /// outbox op → server never learns the name → next sign-in prompts
  /// for the name again).
  Future<void> captureSession(SessionUser me, {String? firebaseUid}) async {
    await _local.upsertFromServer(
      <String, dynamic>{
        'id': me.id,
        'phone_e164': me.phoneE164,
        'name': me.name,
        'language': me.language,
        'state': me.state,
        'district': me.district,
        'village': me.village,
        'savings_inr': me.savingsInr,
        'loan_inr': me.loanInr,
        'notifications_enabled': me.notificationsEnabled,
      },
      firebaseUid: firebaseUid,
      preserveLocalEdits: true,
    );
  }

  /// Saves the user's name.
  ///
  /// Local-first like everything else, so the name-capture screen can no longer
  /// strand a user on a bad connection — previously it made a bare PATCH and
  /// left them on the form when it failed.
  Future<void> setName(String name) async {
    await _patchProfile(<String, dynamic>{'name': name}, name: name);
  }

  /// Saves the chosen language.
  Future<void> setLanguage(String language) async {
    await _patchProfile(<String, dynamic>{
      'language': language,
    }, language: language);
  }

  /// Saves the notification toggle.
  Future<void> setNotificationsEnabled(bool enabled) async {
    await _patchProfile(<String, dynamic>{
      'notifications_enabled': enabled,
    }, notificationsEnabled: enabled);
  }

  Future<void> _patchProfile(
    Map<String, dynamic> payload, {
    String? name,
    String? language,
    bool? notificationsEnabled,
  }) async {
    final String? clientId = await _local.updateLocalProfile(
      name: name,
      language: language,
      notificationsEnabled: notificationsEnabled,
    );
    if (clientId == null) return;

    await _outbox.enqueue(
      entity: SyncEntity.userProfile,
      op: SyncOpKind.update,
      localRowId: clientId,
      payload: payload,
    );
  }

  // Savings and loan are per business, not per user: they live on the business
  // row and are written through `BusinessRepository.update`. The
  // `SyncEntity.savingsLoan` push handler stays behind only to drain ops an
  // earlier build may already have queued against `PATCH /me/savings-loan`.
}
