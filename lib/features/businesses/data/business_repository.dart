/// Local-first access to the user's businesses.
library;

import 'dart:async';

import '../../../app/model/business.dart';
import '../../../core/db/app_database.dart';
import '../../../core/sync/outbox_dao.dart';
import '../../../core/sync/sync_op.dart';
import '../../auth/data/profile_local_datasource.dart';
import 'business_api.dart';
import 'business_local_datasource.dart';
import 'business_remote_datasource.dart';

/// Reads come from SQLite; edits are written locally and queued.
///
/// Creation is the deliberate exception. A business has to exist on the server
/// before an entry, a health score or an alert can reference it, and every one
/// of those relationships is keyed by the BIGINT the backend assigns. Allowing
/// an offline create would mean inventing a temporary id and rewriting it
/// across four tables later — so the setup wizard requires a connection, and
/// everything downstream can assume a real server id exists.
class BusinessRepository {
  BusinessRepository({
    required BusinessLocalDataSource local,
    required BusinessRemoteDataSource remote,
    required OutboxDao outbox,
    ProfileLocalDataSource? profileLocal,
  }) : _local = local,
       _remote = remote,
       _outbox = outbox,
       _profileLocal = profileLocal;

  final BusinessLocalDataSource _local;
  final BusinessRemoteDataSource _remote;
  final OutboxDao _outbox;

  /// Used to scope reads (and now creates) to the signed-in account so that
  /// switching users on the same device never leaks the previous user's
  /// businesses onto Home. Nullable for tests that pump the repository
  /// without a full profile stack.
  final ProfileLocalDataSource? _profileLocal;

  /// Live list for the business switcher, scoped to the active account.
  ///
  /// Re-emits when the active user changes so a fresh sign-in never shows
  /// the previous user's cached businesses while the pull is in flight.
  Stream<List<LocalBusinessRecord>> watchAll() {
    final ProfileLocalDataSource? profile = _profileLocal;
    if (profile == null) return _local.watchAll();
    return profile.watchActiveUser().asyncExpand((LocalUser? user) {
      return _local.watchAll(ownerUserId: user?.serverId);
    });
  }

  /// Emits when the server's business list was last pulled onto this device,
  /// and null until it ever has been. An empty [watchAll] only means "this
  /// account has no businesses" once this has a value.
  Stream<DateTime?> watchServerPullTime() => _local.watchServerPullTime();

  /// Cached list. Never hits the network, so the switcher works offline.
  Future<List<RemoteBusiness>> list() async {
    final records = await _local.all();
    return records
        .where((r) => r.serverId != null)
        .map(
          (r) => RemoteBusiness(
            id: r.serverId!,
            name: r.business.name,
            segment: BusinessApiMapper.segment(r.business.segment),
            sector: BusinessApiMapper.sector(r.business.sector),
            tenure: BusinessApiMapper.tenure(r.business.tenure),
            staffCount: r.business.staffCount,
            isNewBusiness: r.business.tenure == BusinessTenure.underOneYear,
            yearsInOperation: 0,
            savingsInr: r.business.savingsInr,
            loanInr: r.business.loanInr,
            officerId: r.business.officerId,
            latestSnapshot: r.business.monthly,
          ),
        )
        .toList(growable: false);
  }

  /// Creates a business on the server, then caches it. Requires a connection.
  Future<RemoteBusiness> create(Business business, {int? ownerUserId}) async {
    final RemoteBusiness created = await _remote.create(business);
    // Fall back to the active user so watchAll's owner filter never hides a
    // freshly-created business from Home just because the caller did not
    // pass an id — the setup flow calls create() without one.
    final int? resolvedOwner =
        ownerUserId ?? (await _profileLocal?.activeUser())?.serverId;
    // The cached row is what Home reads back seconds later, so it carries the
    // opening savings the user typed on the wizard whenever the server's reply
    // does not mention money at all.
    await _local.insertCreated(
      created,
      ownerUserId: resolvedOwner,
      savingsInr: created.carriesMoney ? null : business.savingsInr,
      loanInr: created.carriesMoney ? null : business.loanInr,
    );
    return created;
  }

  /// Applies an edit locally and queues the PATCH.
  Future<void> update(
    String clientId, {
    String? name,
    int? staffCount,
    String? tenure,
    int? savingsInr,
    int? loanInr,
  }) async {
    await _local.updateLocal(
      clientId: clientId,
      name: name,
      staffCount: staffCount,
      tenureWire: tenure,
      savingsInr: savingsInr,
      loanInr: loanInr,
    );

    final LocalBusiness? row = await _local.byClientId(clientId);
    if (row == null) return;

    await _outbox.enqueue(
      entity: SyncEntity.business,
      op: SyncOpKind.update,
      localRowId: clientId,
      serverId: row.serverId,
      businessServerId: row.serverId,
      payload: <String, dynamic>{
        'name': ?name,
        'staff_count': ?staffCount,
        'tenure': ?tenure,
        'savings_inr': ?savingsInr,
        'loan_inr': ?loanInr,
      },
    );
  }

  /// Resolves the local client id for a backend business id.
  ///
  /// Screens hold the server id (that is what `AppSession` tracks), but every
  /// local write is addressed by client id.
  Future<String?> clientIdFor(int serverId) async {
    final LocalBusiness? row = await _local.byServerId(serverId);
    return row?.clientId;
  }

  Future<void> softDelete(int businessId) => _remote.softDelete(businessId);
}
