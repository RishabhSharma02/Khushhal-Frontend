// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LocalUsersTable extends LocalUsers
    with TableInfo<$LocalUsersTable, LocalUser> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalUsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RowSyncState, String> syncState =
      GeneratedColumn<String>(
        'sync_state',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(RowSyncState.synced.name),
      ).withConverter<RowSyncState>($LocalUsersTable.$convertersyncState);
  static const VerificationMeta _localUpdatedAtMeta = const VerificationMeta(
    'localUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> localUpdatedAt =
      GeneratedColumn<DateTime>(
        'local_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _firebaseUidMeta = const VerificationMeta(
    'firebaseUid',
  );
  @override
  late final GeneratedColumn<String> firebaseUid = GeneratedColumn<String>(
    'firebase_uid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneE164Meta = const VerificationMeta(
    'phoneE164',
  );
  @override
  late final GeneratedColumn<String> phoneE164 = GeneratedColumn<String>(
    'phone_e164',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('hi'),
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _districtMeta = const VerificationMeta(
    'district',
  );
  @override
  late final GeneratedColumn<String> district = GeneratedColumn<String>(
    'district',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _villageMeta = const VerificationMeta(
    'village',
  );
  @override
  late final GeneratedColumn<String> village = GeneratedColumn<String>(
    'village',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _savingsInrMeta = const VerificationMeta(
    'savingsInr',
  );
  @override
  late final GeneratedColumn<int> savingsInr = GeneratedColumn<int>(
    'savings_inr',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _loanInrMeta = const VerificationMeta(
    'loanInr',
  );
  @override
  late final GeneratedColumn<int> loanInr = GeneratedColumn<int>(
    'loan_inr',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _notificationsEnabledMeta =
      const VerificationMeta('notificationsEnabled');
  @override
  late final GeneratedColumn<bool> notificationsEnabled = GeneratedColumn<bool>(
    'notifications_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notifications_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    serverId,
    clientId,
    syncState,
    localUpdatedAt,
    firebaseUid,
    phoneE164,
    name,
    language,
    state,
    district,
    village,
    savingsInr,
    loanInr,
    notificationsEnabled,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_users';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalUser> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('local_updated_at')) {
      context.handle(
        _localUpdatedAtMeta,
        localUpdatedAt.isAcceptableOrUnknown(
          data['local_updated_at']!,
          _localUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('firebase_uid')) {
      context.handle(
        _firebaseUidMeta,
        firebaseUid.isAcceptableOrUnknown(
          data['firebase_uid']!,
          _firebaseUidMeta,
        ),
      );
    }
    if (data.containsKey('phone_e164')) {
      context.handle(
        _phoneE164Meta,
        phoneE164.isAcceptableOrUnknown(data['phone_e164']!, _phoneE164Meta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('district')) {
      context.handle(
        _districtMeta,
        district.isAcceptableOrUnknown(data['district']!, _districtMeta),
      );
    }
    if (data.containsKey('village')) {
      context.handle(
        _villageMeta,
        village.isAcceptableOrUnknown(data['village']!, _villageMeta),
      );
    }
    if (data.containsKey('savings_inr')) {
      context.handle(
        _savingsInrMeta,
        savingsInr.isAcceptableOrUnknown(data['savings_inr']!, _savingsInrMeta),
      );
    }
    if (data.containsKey('loan_inr')) {
      context.handle(
        _loanInrMeta,
        loanInr.isAcceptableOrUnknown(data['loan_inr']!, _loanInrMeta),
      );
    }
    if (data.containsKey('notifications_enabled')) {
      context.handle(
        _notificationsEnabledMeta,
        notificationsEnabled.isAcceptableOrUnknown(
          data['notifications_enabled']!,
          _notificationsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  LocalUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalUser(
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      syncState: $LocalUsersTable.$convertersyncState.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_state'],
        )!,
      ),
      localUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}local_updated_at'],
      )!,
      firebaseUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}firebase_uid'],
      ),
      phoneE164: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_e164'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      ),
      district: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}district'],
      ),
      village: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}village'],
      ),
      savingsInr: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}savings_inr'],
      )!,
      loanInr: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}loan_inr'],
      )!,
      notificationsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notifications_enabled'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $LocalUsersTable createAlias(String alias) {
    return $LocalUsersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RowSyncState, String, String> $convertersyncState =
      const EnumNameConverter<RowSyncState>(RowSyncState.values);
}

class LocalUser extends DataClass implements Insertable<LocalUser> {
  /// The backend BIGINT, once known. Null only for a create that has never
  /// reached the server.
  final int? serverId;

  /// Client-generated UUID. Stable for the lifetime of the row.
  final String clientId;

  /// Local sync state — see [RowSyncState].
  final RowSyncState syncState;

  /// When the device last touched this row. Used for ordering and for showing
  /// "saved at" on pending items.
  final DateTime localUpdatedAt;

  /// Firebase UID from the ID token. The join key for "is this the same person
  /// who was signed in last time?" when starting up offline.
  final String? firebaseUid;

  /// E.164 phone, e.g. `+919876543210`.
  final String? phoneE164;

  /// Display name. Captured once during online onboarding and then never
  /// asked for again — this column is what makes that promise keepable
  /// offline.
  final String? name;

  /// `hi` | `en`.
  final String language;
  final String? state;
  final String? district;
  final String? village;
  final int savingsInr;
  final int loanInr;
  final bool notificationsEnabled;

  /// True for the row representing the account currently signed in on this
  /// device. Exactly one row should carry this at a time.
  final bool isActive;
  const LocalUser({
    this.serverId,
    required this.clientId,
    required this.syncState,
    required this.localUpdatedAt,
    this.firebaseUid,
    this.phoneE164,
    this.name,
    required this.language,
    this.state,
    this.district,
    this.village,
    required this.savingsInr,
    required this.loanInr,
    required this.notificationsEnabled,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['client_id'] = Variable<String>(clientId);
    {
      map['sync_state'] = Variable<String>(
        $LocalUsersTable.$convertersyncState.toSql(syncState),
      );
    }
    map['local_updated_at'] = Variable<DateTime>(localUpdatedAt);
    if (!nullToAbsent || firebaseUid != null) {
      map['firebase_uid'] = Variable<String>(firebaseUid);
    }
    if (!nullToAbsent || phoneE164 != null) {
      map['phone_e164'] = Variable<String>(phoneE164);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['language'] = Variable<String>(language);
    if (!nullToAbsent || state != null) {
      map['state'] = Variable<String>(state);
    }
    if (!nullToAbsent || district != null) {
      map['district'] = Variable<String>(district);
    }
    if (!nullToAbsent || village != null) {
      map['village'] = Variable<String>(village);
    }
    map['savings_inr'] = Variable<int>(savingsInr);
    map['loan_inr'] = Variable<int>(loanInr);
    map['notifications_enabled'] = Variable<bool>(notificationsEnabled);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  LocalUsersCompanion toCompanion(bool nullToAbsent) {
    return LocalUsersCompanion(
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      clientId: Value(clientId),
      syncState: Value(syncState),
      localUpdatedAt: Value(localUpdatedAt),
      firebaseUid: firebaseUid == null && nullToAbsent
          ? const Value.absent()
          : Value(firebaseUid),
      phoneE164: phoneE164 == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneE164),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      language: Value(language),
      state: state == null && nullToAbsent
          ? const Value.absent()
          : Value(state),
      district: district == null && nullToAbsent
          ? const Value.absent()
          : Value(district),
      village: village == null && nullToAbsent
          ? const Value.absent()
          : Value(village),
      savingsInr: Value(savingsInr),
      loanInr: Value(loanInr),
      notificationsEnabled: Value(notificationsEnabled),
      isActive: Value(isActive),
    );
  }

  factory LocalUser.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalUser(
      serverId: serializer.fromJson<int?>(json['serverId']),
      clientId: serializer.fromJson<String>(json['clientId']),
      syncState: $LocalUsersTable.$convertersyncState.fromJson(
        serializer.fromJson<String>(json['syncState']),
      ),
      localUpdatedAt: serializer.fromJson<DateTime>(json['localUpdatedAt']),
      firebaseUid: serializer.fromJson<String?>(json['firebaseUid']),
      phoneE164: serializer.fromJson<String?>(json['phoneE164']),
      name: serializer.fromJson<String?>(json['name']),
      language: serializer.fromJson<String>(json['language']),
      state: serializer.fromJson<String?>(json['state']),
      district: serializer.fromJson<String?>(json['district']),
      village: serializer.fromJson<String?>(json['village']),
      savingsInr: serializer.fromJson<int>(json['savingsInr']),
      loanInr: serializer.fromJson<int>(json['loanInr']),
      notificationsEnabled: serializer.fromJson<bool>(
        json['notificationsEnabled'],
      ),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'serverId': serializer.toJson<int?>(serverId),
      'clientId': serializer.toJson<String>(clientId),
      'syncState': serializer.toJson<String>(
        $LocalUsersTable.$convertersyncState.toJson(syncState),
      ),
      'localUpdatedAt': serializer.toJson<DateTime>(localUpdatedAt),
      'firebaseUid': serializer.toJson<String?>(firebaseUid),
      'phoneE164': serializer.toJson<String?>(phoneE164),
      'name': serializer.toJson<String?>(name),
      'language': serializer.toJson<String>(language),
      'state': serializer.toJson<String?>(state),
      'district': serializer.toJson<String?>(district),
      'village': serializer.toJson<String?>(village),
      'savingsInr': serializer.toJson<int>(savingsInr),
      'loanInr': serializer.toJson<int>(loanInr),
      'notificationsEnabled': serializer.toJson<bool>(notificationsEnabled),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  LocalUser copyWith({
    Value<int?> serverId = const Value.absent(),
    String? clientId,
    RowSyncState? syncState,
    DateTime? localUpdatedAt,
    Value<String?> firebaseUid = const Value.absent(),
    Value<String?> phoneE164 = const Value.absent(),
    Value<String?> name = const Value.absent(),
    String? language,
    Value<String?> state = const Value.absent(),
    Value<String?> district = const Value.absent(),
    Value<String?> village = const Value.absent(),
    int? savingsInr,
    int? loanInr,
    bool? notificationsEnabled,
    bool? isActive,
  }) => LocalUser(
    serverId: serverId.present ? serverId.value : this.serverId,
    clientId: clientId ?? this.clientId,
    syncState: syncState ?? this.syncState,
    localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
    firebaseUid: firebaseUid.present ? firebaseUid.value : this.firebaseUid,
    phoneE164: phoneE164.present ? phoneE164.value : this.phoneE164,
    name: name.present ? name.value : this.name,
    language: language ?? this.language,
    state: state.present ? state.value : this.state,
    district: district.present ? district.value : this.district,
    village: village.present ? village.value : this.village,
    savingsInr: savingsInr ?? this.savingsInr,
    loanInr: loanInr ?? this.loanInr,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    isActive: isActive ?? this.isActive,
  );
  LocalUser copyWithCompanion(LocalUsersCompanion data) {
    return LocalUser(
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      localUpdatedAt: data.localUpdatedAt.present
          ? data.localUpdatedAt.value
          : this.localUpdatedAt,
      firebaseUid: data.firebaseUid.present
          ? data.firebaseUid.value
          : this.firebaseUid,
      phoneE164: data.phoneE164.present ? data.phoneE164.value : this.phoneE164,
      name: data.name.present ? data.name.value : this.name,
      language: data.language.present ? data.language.value : this.language,
      state: data.state.present ? data.state.value : this.state,
      district: data.district.present ? data.district.value : this.district,
      village: data.village.present ? data.village.value : this.village,
      savingsInr: data.savingsInr.present
          ? data.savingsInr.value
          : this.savingsInr,
      loanInr: data.loanInr.present ? data.loanInr.value : this.loanInr,
      notificationsEnabled: data.notificationsEnabled.present
          ? data.notificationsEnabled.value
          : this.notificationsEnabled,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalUser(')
          ..write('serverId: $serverId, ')
          ..write('clientId: $clientId, ')
          ..write('syncState: $syncState, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('firebaseUid: $firebaseUid, ')
          ..write('phoneE164: $phoneE164, ')
          ..write('name: $name, ')
          ..write('language: $language, ')
          ..write('state: $state, ')
          ..write('district: $district, ')
          ..write('village: $village, ')
          ..write('savingsInr: $savingsInr, ')
          ..write('loanInr: $loanInr, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    serverId,
    clientId,
    syncState,
    localUpdatedAt,
    firebaseUid,
    phoneE164,
    name,
    language,
    state,
    district,
    village,
    savingsInr,
    loanInr,
    notificationsEnabled,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalUser &&
          other.serverId == this.serverId &&
          other.clientId == this.clientId &&
          other.syncState == this.syncState &&
          other.localUpdatedAt == this.localUpdatedAt &&
          other.firebaseUid == this.firebaseUid &&
          other.phoneE164 == this.phoneE164 &&
          other.name == this.name &&
          other.language == this.language &&
          other.state == this.state &&
          other.district == this.district &&
          other.village == this.village &&
          other.savingsInr == this.savingsInr &&
          other.loanInr == this.loanInr &&
          other.notificationsEnabled == this.notificationsEnabled &&
          other.isActive == this.isActive);
}

class LocalUsersCompanion extends UpdateCompanion<LocalUser> {
  final Value<int?> serverId;
  final Value<String> clientId;
  final Value<RowSyncState> syncState;
  final Value<DateTime> localUpdatedAt;
  final Value<String?> firebaseUid;
  final Value<String?> phoneE164;
  final Value<String?> name;
  final Value<String> language;
  final Value<String?> state;
  final Value<String?> district;
  final Value<String?> village;
  final Value<int> savingsInr;
  final Value<int> loanInr;
  final Value<bool> notificationsEnabled;
  final Value<bool> isActive;
  final Value<int> rowid;
  const LocalUsersCompanion({
    this.serverId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.syncState = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.firebaseUid = const Value.absent(),
    this.phoneE164 = const Value.absent(),
    this.name = const Value.absent(),
    this.language = const Value.absent(),
    this.state = const Value.absent(),
    this.district = const Value.absent(),
    this.village = const Value.absent(),
    this.savingsInr = const Value.absent(),
    this.loanInr = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalUsersCompanion.insert({
    this.serverId = const Value.absent(),
    required String clientId,
    this.syncState = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.firebaseUid = const Value.absent(),
    this.phoneE164 = const Value.absent(),
    this.name = const Value.absent(),
    this.language = const Value.absent(),
    this.state = const Value.absent(),
    this.district = const Value.absent(),
    this.village = const Value.absent(),
    this.savingsInr = const Value.absent(),
    this.loanInr = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : clientId = Value(clientId);
  static Insertable<LocalUser> custom({
    Expression<int>? serverId,
    Expression<String>? clientId,
    Expression<String>? syncState,
    Expression<DateTime>? localUpdatedAt,
    Expression<String>? firebaseUid,
    Expression<String>? phoneE164,
    Expression<String>? name,
    Expression<String>? language,
    Expression<String>? state,
    Expression<String>? district,
    Expression<String>? village,
    Expression<int>? savingsInr,
    Expression<int>? loanInr,
    Expression<bool>? notificationsEnabled,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (serverId != null) 'server_id': serverId,
      if (clientId != null) 'client_id': clientId,
      if (syncState != null) 'sync_state': syncState,
      if (localUpdatedAt != null) 'local_updated_at': localUpdatedAt,
      if (firebaseUid != null) 'firebase_uid': firebaseUid,
      if (phoneE164 != null) 'phone_e164': phoneE164,
      if (name != null) 'name': name,
      if (language != null) 'language': language,
      if (state != null) 'state': state,
      if (district != null) 'district': district,
      if (village != null) 'village': village,
      if (savingsInr != null) 'savings_inr': savingsInr,
      if (loanInr != null) 'loan_inr': loanInr,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalUsersCompanion copyWith({
    Value<int?>? serverId,
    Value<String>? clientId,
    Value<RowSyncState>? syncState,
    Value<DateTime>? localUpdatedAt,
    Value<String?>? firebaseUid,
    Value<String?>? phoneE164,
    Value<String?>? name,
    Value<String>? language,
    Value<String?>? state,
    Value<String?>? district,
    Value<String?>? village,
    Value<int>? savingsInr,
    Value<int>? loanInr,
    Value<bool>? notificationsEnabled,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return LocalUsersCompanion(
      serverId: serverId ?? this.serverId,
      clientId: clientId ?? this.clientId,
      syncState: syncState ?? this.syncState,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      phoneE164: phoneE164 ?? this.phoneE164,
      name: name ?? this.name,
      language: language ?? this.language,
      state: state ?? this.state,
      district: district ?? this.district,
      village: village ?? this.village,
      savingsInr: savingsInr ?? this.savingsInr,
      loanInr: loanInr ?? this.loanInr,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(
        $LocalUsersTable.$convertersyncState.toSql(syncState.value),
      );
    }
    if (localUpdatedAt.present) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt.value);
    }
    if (firebaseUid.present) {
      map['firebase_uid'] = Variable<String>(firebaseUid.value);
    }
    if (phoneE164.present) {
      map['phone_e164'] = Variable<String>(phoneE164.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (district.present) {
      map['district'] = Variable<String>(district.value);
    }
    if (village.present) {
      map['village'] = Variable<String>(village.value);
    }
    if (savingsInr.present) {
      map['savings_inr'] = Variable<int>(savingsInr.value);
    }
    if (loanInr.present) {
      map['loan_inr'] = Variable<int>(loanInr.value);
    }
    if (notificationsEnabled.present) {
      map['notifications_enabled'] = Variable<bool>(notificationsEnabled.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalUsersCompanion(')
          ..write('serverId: $serverId, ')
          ..write('clientId: $clientId, ')
          ..write('syncState: $syncState, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('firebaseUid: $firebaseUid, ')
          ..write('phoneE164: $phoneE164, ')
          ..write('name: $name, ')
          ..write('language: $language, ')
          ..write('state: $state, ')
          ..write('district: $district, ')
          ..write('village: $village, ')
          ..write('savingsInr: $savingsInr, ')
          ..write('loanInr: $loanInr, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalBusinessesTable extends LocalBusinesses
    with TableInfo<$LocalBusinessesTable, LocalBusiness> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalBusinessesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RowSyncState, String> syncState =
      GeneratedColumn<String>(
        'sync_state',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(RowSyncState.synced.name),
      ).withConverter<RowSyncState>($LocalBusinessesTable.$convertersyncState);
  static const VerificationMeta _localUpdatedAtMeta = const VerificationMeta(
    'localUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> localUpdatedAt =
      GeneratedColumn<DateTime>(
        'local_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _ownerUserIdMeta = const VerificationMeta(
    'ownerUserId',
  );
  @override
  late final GeneratedColumn<int> ownerUserId = GeneratedColumn<int>(
    'owner_user_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _segmentMeta = const VerificationMeta(
    'segment',
  );
  @override
  late final GeneratedColumn<String> segment = GeneratedColumn<String>(
    'segment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sectorMeta = const VerificationMeta('sector');
  @override
  late final GeneratedColumn<String> sector = GeneratedColumn<String>(
    'sector',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tenureMeta = const VerificationMeta('tenure');
  @override
  late final GeneratedColumn<String> tenure = GeneratedColumn<String>(
    'tenure',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _staffCountMeta = const VerificationMeta(
    'staffCount',
  );
  @override
  late final GeneratedColumn<int> staffCount = GeneratedColumn<int>(
    'staff_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isNewBusinessMeta = const VerificationMeta(
    'isNewBusiness',
  );
  @override
  late final GeneratedColumn<bool> isNewBusiness = GeneratedColumn<bool>(
    'is_new_business',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_new_business" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _yearsInOperationMeta = const VerificationMeta(
    'yearsInOperation',
  );
  @override
  late final GeneratedColumn<int> yearsInOperation = GeneratedColumn<int>(
    'years_in_operation',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _savingsInrMeta = const VerificationMeta(
    'savingsInr',
  );
  @override
  late final GeneratedColumn<int> savingsInr = GeneratedColumn<int>(
    'savings_inr',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _loanInrMeta = const VerificationMeta(
    'loanInr',
  );
  @override
  late final GeneratedColumn<int> loanInr = GeneratedColumn<int>(
    'loan_inr',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    serverId,
    clientId,
    syncState,
    localUpdatedAt,
    ownerUserId,
    name,
    segment,
    sector,
    tenure,
    staffCount,
    isNewBusiness,
    yearsInOperation,
    savingsInr,
    loanInr,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_businesses';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalBusiness> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('local_updated_at')) {
      context.handle(
        _localUpdatedAtMeta,
        localUpdatedAt.isAcceptableOrUnknown(
          data['local_updated_at']!,
          _localUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('owner_user_id')) {
      context.handle(
        _ownerUserIdMeta,
        ownerUserId.isAcceptableOrUnknown(
          data['owner_user_id']!,
          _ownerUserIdMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('segment')) {
      context.handle(
        _segmentMeta,
        segment.isAcceptableOrUnknown(data['segment']!, _segmentMeta),
      );
    } else if (isInserting) {
      context.missing(_segmentMeta);
    }
    if (data.containsKey('sector')) {
      context.handle(
        _sectorMeta,
        sector.isAcceptableOrUnknown(data['sector']!, _sectorMeta),
      );
    } else if (isInserting) {
      context.missing(_sectorMeta);
    }
    if (data.containsKey('tenure')) {
      context.handle(
        _tenureMeta,
        tenure.isAcceptableOrUnknown(data['tenure']!, _tenureMeta),
      );
    } else if (isInserting) {
      context.missing(_tenureMeta);
    }
    if (data.containsKey('staff_count')) {
      context.handle(
        _staffCountMeta,
        staffCount.isAcceptableOrUnknown(data['staff_count']!, _staffCountMeta),
      );
    }
    if (data.containsKey('is_new_business')) {
      context.handle(
        _isNewBusinessMeta,
        isNewBusiness.isAcceptableOrUnknown(
          data['is_new_business']!,
          _isNewBusinessMeta,
        ),
      );
    }
    if (data.containsKey('years_in_operation')) {
      context.handle(
        _yearsInOperationMeta,
        yearsInOperation.isAcceptableOrUnknown(
          data['years_in_operation']!,
          _yearsInOperationMeta,
        ),
      );
    }
    if (data.containsKey('savings_inr')) {
      context.handle(
        _savingsInrMeta,
        savingsInr.isAcceptableOrUnknown(data['savings_inr']!, _savingsInrMeta),
      );
    }
    if (data.containsKey('loan_inr')) {
      context.handle(
        _loanInrMeta,
        loanInr.isAcceptableOrUnknown(data['loan_inr']!, _loanInrMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  LocalBusiness map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalBusiness(
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      syncState: $LocalBusinessesTable.$convertersyncState.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_state'],
        )!,
      ),
      localUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}local_updated_at'],
      )!,
      ownerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owner_user_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      segment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}segment'],
      )!,
      sector: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sector'],
      )!,
      tenure: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tenure'],
      )!,
      staffCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}staff_count'],
      )!,
      isNewBusiness: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_new_business'],
      )!,
      yearsInOperation: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}years_in_operation'],
      )!,
      savingsInr: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}savings_inr'],
      )!,
      loanInr: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}loan_inr'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $LocalBusinessesTable createAlias(String alias) {
    return $LocalBusinessesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RowSyncState, String, String> $convertersyncState =
      const EnumNameConverter<RowSyncState>(RowSyncState.values);
}

class LocalBusiness extends DataClass implements Insertable<LocalBusiness> {
  /// The backend BIGINT, once known. Null only for a create that has never
  /// reached the server.
  final int? serverId;

  /// Client-generated UUID. Stable for the lifetime of the row.
  final String clientId;

  /// Local sync state — see [RowSyncState].
  final RowSyncState syncState;

  /// When the device last touched this row. Used for ordering and for showing
  /// "saved at" on pending items.
  final DateTime localUpdatedAt;

  /// Owning user's backend id, so a second account on the device cannot read
  /// the first one's businesses.
  final int? ownerUserId;
  final String name;

  /// `shg` | `fpo` | `own`.
  final String segment;

  /// `dairy` | `poultry` | `food_processing` | `handicrafts` | `rural_retail` |
  /// `other`.
  final String sector;

  /// `under_1` | `1_to_3` | `3_to_10` | `10_plus`.
  final String tenure;
  final int staffCount;
  final bool isNewBusiness;
  final int yearsInOperation;

  /// Savings held and loan outstanding for this business. Both are per
  /// business on the backend too, and both are editable offline from the
  /// savings & loan screen, so they ride the same `pendingUpdate` path as a
  /// name change.
  final int savingsInr;
  final int loanInr;

  /// Preserves the server's list order so the business switcher pill does not
  /// reshuffle between a cached read and a fresh pull.
  final int sortOrder;
  const LocalBusiness({
    this.serverId,
    required this.clientId,
    required this.syncState,
    required this.localUpdatedAt,
    this.ownerUserId,
    required this.name,
    required this.segment,
    required this.sector,
    required this.tenure,
    required this.staffCount,
    required this.isNewBusiness,
    required this.yearsInOperation,
    required this.savingsInr,
    required this.loanInr,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['client_id'] = Variable<String>(clientId);
    {
      map['sync_state'] = Variable<String>(
        $LocalBusinessesTable.$convertersyncState.toSql(syncState),
      );
    }
    map['local_updated_at'] = Variable<DateTime>(localUpdatedAt);
    if (!nullToAbsent || ownerUserId != null) {
      map['owner_user_id'] = Variable<int>(ownerUserId);
    }
    map['name'] = Variable<String>(name);
    map['segment'] = Variable<String>(segment);
    map['sector'] = Variable<String>(sector);
    map['tenure'] = Variable<String>(tenure);
    map['staff_count'] = Variable<int>(staffCount);
    map['is_new_business'] = Variable<bool>(isNewBusiness);
    map['years_in_operation'] = Variable<int>(yearsInOperation);
    map['savings_inr'] = Variable<int>(savingsInr);
    map['loan_inr'] = Variable<int>(loanInr);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  LocalBusinessesCompanion toCompanion(bool nullToAbsent) {
    return LocalBusinessesCompanion(
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      clientId: Value(clientId),
      syncState: Value(syncState),
      localUpdatedAt: Value(localUpdatedAt),
      ownerUserId: ownerUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerUserId),
      name: Value(name),
      segment: Value(segment),
      sector: Value(sector),
      tenure: Value(tenure),
      staffCount: Value(staffCount),
      isNewBusiness: Value(isNewBusiness),
      yearsInOperation: Value(yearsInOperation),
      savingsInr: Value(savingsInr),
      loanInr: Value(loanInr),
      sortOrder: Value(sortOrder),
    );
  }

  factory LocalBusiness.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalBusiness(
      serverId: serializer.fromJson<int?>(json['serverId']),
      clientId: serializer.fromJson<String>(json['clientId']),
      syncState: $LocalBusinessesTable.$convertersyncState.fromJson(
        serializer.fromJson<String>(json['syncState']),
      ),
      localUpdatedAt: serializer.fromJson<DateTime>(json['localUpdatedAt']),
      ownerUserId: serializer.fromJson<int?>(json['ownerUserId']),
      name: serializer.fromJson<String>(json['name']),
      segment: serializer.fromJson<String>(json['segment']),
      sector: serializer.fromJson<String>(json['sector']),
      tenure: serializer.fromJson<String>(json['tenure']),
      staffCount: serializer.fromJson<int>(json['staffCount']),
      isNewBusiness: serializer.fromJson<bool>(json['isNewBusiness']),
      yearsInOperation: serializer.fromJson<int>(json['yearsInOperation']),
      savingsInr: serializer.fromJson<int>(json['savingsInr']),
      loanInr: serializer.fromJson<int>(json['loanInr']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'serverId': serializer.toJson<int?>(serverId),
      'clientId': serializer.toJson<String>(clientId),
      'syncState': serializer.toJson<String>(
        $LocalBusinessesTable.$convertersyncState.toJson(syncState),
      ),
      'localUpdatedAt': serializer.toJson<DateTime>(localUpdatedAt),
      'ownerUserId': serializer.toJson<int?>(ownerUserId),
      'name': serializer.toJson<String>(name),
      'segment': serializer.toJson<String>(segment),
      'sector': serializer.toJson<String>(sector),
      'tenure': serializer.toJson<String>(tenure),
      'staffCount': serializer.toJson<int>(staffCount),
      'isNewBusiness': serializer.toJson<bool>(isNewBusiness),
      'yearsInOperation': serializer.toJson<int>(yearsInOperation),
      'savingsInr': serializer.toJson<int>(savingsInr),
      'loanInr': serializer.toJson<int>(loanInr),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  LocalBusiness copyWith({
    Value<int?> serverId = const Value.absent(),
    String? clientId,
    RowSyncState? syncState,
    DateTime? localUpdatedAt,
    Value<int?> ownerUserId = const Value.absent(),
    String? name,
    String? segment,
    String? sector,
    String? tenure,
    int? staffCount,
    bool? isNewBusiness,
    int? yearsInOperation,
    int? savingsInr,
    int? loanInr,
    int? sortOrder,
  }) => LocalBusiness(
    serverId: serverId.present ? serverId.value : this.serverId,
    clientId: clientId ?? this.clientId,
    syncState: syncState ?? this.syncState,
    localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
    ownerUserId: ownerUserId.present ? ownerUserId.value : this.ownerUserId,
    name: name ?? this.name,
    segment: segment ?? this.segment,
    sector: sector ?? this.sector,
    tenure: tenure ?? this.tenure,
    staffCount: staffCount ?? this.staffCount,
    isNewBusiness: isNewBusiness ?? this.isNewBusiness,
    yearsInOperation: yearsInOperation ?? this.yearsInOperation,
    savingsInr: savingsInr ?? this.savingsInr,
    loanInr: loanInr ?? this.loanInr,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  LocalBusiness copyWithCompanion(LocalBusinessesCompanion data) {
    return LocalBusiness(
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      localUpdatedAt: data.localUpdatedAt.present
          ? data.localUpdatedAt.value
          : this.localUpdatedAt,
      ownerUserId: data.ownerUserId.present
          ? data.ownerUserId.value
          : this.ownerUserId,
      name: data.name.present ? data.name.value : this.name,
      segment: data.segment.present ? data.segment.value : this.segment,
      sector: data.sector.present ? data.sector.value : this.sector,
      tenure: data.tenure.present ? data.tenure.value : this.tenure,
      staffCount: data.staffCount.present
          ? data.staffCount.value
          : this.staffCount,
      isNewBusiness: data.isNewBusiness.present
          ? data.isNewBusiness.value
          : this.isNewBusiness,
      yearsInOperation: data.yearsInOperation.present
          ? data.yearsInOperation.value
          : this.yearsInOperation,
      savingsInr: data.savingsInr.present
          ? data.savingsInr.value
          : this.savingsInr,
      loanInr: data.loanInr.present ? data.loanInr.value : this.loanInr,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalBusiness(')
          ..write('serverId: $serverId, ')
          ..write('clientId: $clientId, ')
          ..write('syncState: $syncState, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('name: $name, ')
          ..write('segment: $segment, ')
          ..write('sector: $sector, ')
          ..write('tenure: $tenure, ')
          ..write('staffCount: $staffCount, ')
          ..write('isNewBusiness: $isNewBusiness, ')
          ..write('yearsInOperation: $yearsInOperation, ')
          ..write('savingsInr: $savingsInr, ')
          ..write('loanInr: $loanInr, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    serverId,
    clientId,
    syncState,
    localUpdatedAt,
    ownerUserId,
    name,
    segment,
    sector,
    tenure,
    staffCount,
    isNewBusiness,
    yearsInOperation,
    savingsInr,
    loanInr,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalBusiness &&
          other.serverId == this.serverId &&
          other.clientId == this.clientId &&
          other.syncState == this.syncState &&
          other.localUpdatedAt == this.localUpdatedAt &&
          other.ownerUserId == this.ownerUserId &&
          other.name == this.name &&
          other.segment == this.segment &&
          other.sector == this.sector &&
          other.tenure == this.tenure &&
          other.staffCount == this.staffCount &&
          other.isNewBusiness == this.isNewBusiness &&
          other.yearsInOperation == this.yearsInOperation &&
          other.savingsInr == this.savingsInr &&
          other.loanInr == this.loanInr &&
          other.sortOrder == this.sortOrder);
}

class LocalBusinessesCompanion extends UpdateCompanion<LocalBusiness> {
  final Value<int?> serverId;
  final Value<String> clientId;
  final Value<RowSyncState> syncState;
  final Value<DateTime> localUpdatedAt;
  final Value<int?> ownerUserId;
  final Value<String> name;
  final Value<String> segment;
  final Value<String> sector;
  final Value<String> tenure;
  final Value<int> staffCount;
  final Value<bool> isNewBusiness;
  final Value<int> yearsInOperation;
  final Value<int> savingsInr;
  final Value<int> loanInr;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const LocalBusinessesCompanion({
    this.serverId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.syncState = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.name = const Value.absent(),
    this.segment = const Value.absent(),
    this.sector = const Value.absent(),
    this.tenure = const Value.absent(),
    this.staffCount = const Value.absent(),
    this.isNewBusiness = const Value.absent(),
    this.yearsInOperation = const Value.absent(),
    this.savingsInr = const Value.absent(),
    this.loanInr = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalBusinessesCompanion.insert({
    this.serverId = const Value.absent(),
    required String clientId,
    this.syncState = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    required String name,
    required String segment,
    required String sector,
    required String tenure,
    this.staffCount = const Value.absent(),
    this.isNewBusiness = const Value.absent(),
    this.yearsInOperation = const Value.absent(),
    this.savingsInr = const Value.absent(),
    this.loanInr = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : clientId = Value(clientId),
       name = Value(name),
       segment = Value(segment),
       sector = Value(sector),
       tenure = Value(tenure);
  static Insertable<LocalBusiness> custom({
    Expression<int>? serverId,
    Expression<String>? clientId,
    Expression<String>? syncState,
    Expression<DateTime>? localUpdatedAt,
    Expression<int>? ownerUserId,
    Expression<String>? name,
    Expression<String>? segment,
    Expression<String>? sector,
    Expression<String>? tenure,
    Expression<int>? staffCount,
    Expression<bool>? isNewBusiness,
    Expression<int>? yearsInOperation,
    Expression<int>? savingsInr,
    Expression<int>? loanInr,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (serverId != null) 'server_id': serverId,
      if (clientId != null) 'client_id': clientId,
      if (syncState != null) 'sync_state': syncState,
      if (localUpdatedAt != null) 'local_updated_at': localUpdatedAt,
      if (ownerUserId != null) 'owner_user_id': ownerUserId,
      if (name != null) 'name': name,
      if (segment != null) 'segment': segment,
      if (sector != null) 'sector': sector,
      if (tenure != null) 'tenure': tenure,
      if (staffCount != null) 'staff_count': staffCount,
      if (isNewBusiness != null) 'is_new_business': isNewBusiness,
      if (yearsInOperation != null) 'years_in_operation': yearsInOperation,
      if (savingsInr != null) 'savings_inr': savingsInr,
      if (loanInr != null) 'loan_inr': loanInr,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalBusinessesCompanion copyWith({
    Value<int?>? serverId,
    Value<String>? clientId,
    Value<RowSyncState>? syncState,
    Value<DateTime>? localUpdatedAt,
    Value<int?>? ownerUserId,
    Value<String>? name,
    Value<String>? segment,
    Value<String>? sector,
    Value<String>? tenure,
    Value<int>? staffCount,
    Value<bool>? isNewBusiness,
    Value<int>? yearsInOperation,
    Value<int>? savingsInr,
    Value<int>? loanInr,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return LocalBusinessesCompanion(
      serverId: serverId ?? this.serverId,
      clientId: clientId ?? this.clientId,
      syncState: syncState ?? this.syncState,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      name: name ?? this.name,
      segment: segment ?? this.segment,
      sector: sector ?? this.sector,
      tenure: tenure ?? this.tenure,
      staffCount: staffCount ?? this.staffCount,
      isNewBusiness: isNewBusiness ?? this.isNewBusiness,
      yearsInOperation: yearsInOperation ?? this.yearsInOperation,
      savingsInr: savingsInr ?? this.savingsInr,
      loanInr: loanInr ?? this.loanInr,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(
        $LocalBusinessesTable.$convertersyncState.toSql(syncState.value),
      );
    }
    if (localUpdatedAt.present) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt.value);
    }
    if (ownerUserId.present) {
      map['owner_user_id'] = Variable<int>(ownerUserId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (segment.present) {
      map['segment'] = Variable<String>(segment.value);
    }
    if (sector.present) {
      map['sector'] = Variable<String>(sector.value);
    }
    if (tenure.present) {
      map['tenure'] = Variable<String>(tenure.value);
    }
    if (staffCount.present) {
      map['staff_count'] = Variable<int>(staffCount.value);
    }
    if (isNewBusiness.present) {
      map['is_new_business'] = Variable<bool>(isNewBusiness.value);
    }
    if (yearsInOperation.present) {
      map['years_in_operation'] = Variable<int>(yearsInOperation.value);
    }
    if (savingsInr.present) {
      map['savings_inr'] = Variable<int>(savingsInr.value);
    }
    if (loanInr.present) {
      map['loan_inr'] = Variable<int>(loanInr.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalBusinessesCompanion(')
          ..write('serverId: $serverId, ')
          ..write('clientId: $clientId, ')
          ..write('syncState: $syncState, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('name: $name, ')
          ..write('segment: $segment, ')
          ..write('sector: $sector, ')
          ..write('tenure: $tenure, ')
          ..write('staffCount: $staffCount, ')
          ..write('isNewBusiness: $isNewBusiness, ')
          ..write('yearsInOperation: $yearsInOperation, ')
          ..write('savingsInr: $savingsInr, ')
          ..write('loanInr: $loanInr, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalMonthlySnapshotsTable extends LocalMonthlySnapshots
    with TableInfo<$LocalMonthlySnapshotsTable, LocalMonthlySnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalMonthlySnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _businessServerIdMeta = const VerificationMeta(
    'businessServerId',
  );
  @override
  late final GeneratedColumn<int> businessServerId = GeneratedColumn<int>(
    'business_server_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<DateTime> month = GeneratedColumn<DateTime>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moneyInMeta = const VerificationMeta(
    'moneyIn',
  );
  @override
  late final GeneratedColumn<int> moneyIn = GeneratedColumn<int>(
    'money_in',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _moneyOutMeta = const VerificationMeta(
    'moneyOut',
  );
  @override
  late final GeneratedColumn<int> moneyOut = GeneratedColumn<int>(
    'money_out',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _loanEmiMeta = const VerificationMeta(
    'loanEmi',
  );
  @override
  late final GeneratedColumn<int> loanEmi = GeneratedColumn<int>(
    'loan_emi',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _savingsMeta = const VerificationMeta(
    'savings',
  );
  @override
  late final GeneratedColumn<int> savings = GeneratedColumn<int>(
    'savings',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _basisMeta = const VerificationMeta('basis');
  @override
  late final GeneratedColumn<String> basis = GeneratedColumn<String>(
    'basis',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('rough'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    fetchedAt,
    businessServerId,
    month,
    moneyIn,
    moneyOut,
    loanEmi,
    savings,
    basis,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_monthly_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalMonthlySnapshot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    }
    if (data.containsKey('business_server_id')) {
      context.handle(
        _businessServerIdMeta,
        businessServerId.isAcceptableOrUnknown(
          data['business_server_id']!,
          _businessServerIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_businessServerIdMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('money_in')) {
      context.handle(
        _moneyInMeta,
        moneyIn.isAcceptableOrUnknown(data['money_in']!, _moneyInMeta),
      );
    }
    if (data.containsKey('money_out')) {
      context.handle(
        _moneyOutMeta,
        moneyOut.isAcceptableOrUnknown(data['money_out']!, _moneyOutMeta),
      );
    }
    if (data.containsKey('loan_emi')) {
      context.handle(
        _loanEmiMeta,
        loanEmi.isAcceptableOrUnknown(data['loan_emi']!, _loanEmiMeta),
      );
    }
    if (data.containsKey('savings')) {
      context.handle(
        _savingsMeta,
        savings.isAcceptableOrUnknown(data['savings']!, _savingsMeta),
      );
    }
    if (data.containsKey('basis')) {
      context.handle(
        _basisMeta,
        basis.isAcceptableOrUnknown(data['basis']!, _basisMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {businessServerId, month};
  @override
  LocalMonthlySnapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalMonthlySnapshot(
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
      businessServerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}business_server_id'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}month'],
      )!,
      moneyIn: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}money_in'],
      )!,
      moneyOut: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}money_out'],
      )!,
      loanEmi: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}loan_emi'],
      )!,
      savings: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}savings'],
      )!,
      basis: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}basis'],
      )!,
    );
  }

  @override
  $LocalMonthlySnapshotsTable createAlias(String alias) {
    return $LocalMonthlySnapshotsTable(attachedDatabase, alias);
  }
}

class LocalMonthlySnapshot extends DataClass
    implements Insertable<LocalMonthlySnapshot> {
  /// When this row was last pulled from the backend. Drives the "showing saved
  /// data from X" line on the offline home.
  final DateTime fetchedAt;
  final int businessServerId;

  /// First day of the month this snapshot describes.
  final DateTime month;
  final int moneyIn;
  final int moneyOut;
  final int loanEmi;
  final int savings;

  /// `rough` | `records`.
  final String basis;
  const LocalMonthlySnapshot({
    required this.fetchedAt,
    required this.businessServerId,
    required this.month,
    required this.moneyIn,
    required this.moneyOut,
    required this.loanEmi,
    required this.savings,
    required this.basis,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    map['business_server_id'] = Variable<int>(businessServerId);
    map['month'] = Variable<DateTime>(month);
    map['money_in'] = Variable<int>(moneyIn);
    map['money_out'] = Variable<int>(moneyOut);
    map['loan_emi'] = Variable<int>(loanEmi);
    map['savings'] = Variable<int>(savings);
    map['basis'] = Variable<String>(basis);
    return map;
  }

  LocalMonthlySnapshotsCompanion toCompanion(bool nullToAbsent) {
    return LocalMonthlySnapshotsCompanion(
      fetchedAt: Value(fetchedAt),
      businessServerId: Value(businessServerId),
      month: Value(month),
      moneyIn: Value(moneyIn),
      moneyOut: Value(moneyOut),
      loanEmi: Value(loanEmi),
      savings: Value(savings),
      basis: Value(basis),
    );
  }

  factory LocalMonthlySnapshot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalMonthlySnapshot(
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
      businessServerId: serializer.fromJson<int>(json['businessServerId']),
      month: serializer.fromJson<DateTime>(json['month']),
      moneyIn: serializer.fromJson<int>(json['moneyIn']),
      moneyOut: serializer.fromJson<int>(json['moneyOut']),
      loanEmi: serializer.fromJson<int>(json['loanEmi']),
      savings: serializer.fromJson<int>(json['savings']),
      basis: serializer.fromJson<String>(json['basis']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
      'businessServerId': serializer.toJson<int>(businessServerId),
      'month': serializer.toJson<DateTime>(month),
      'moneyIn': serializer.toJson<int>(moneyIn),
      'moneyOut': serializer.toJson<int>(moneyOut),
      'loanEmi': serializer.toJson<int>(loanEmi),
      'savings': serializer.toJson<int>(savings),
      'basis': serializer.toJson<String>(basis),
    };
  }

  LocalMonthlySnapshot copyWith({
    DateTime? fetchedAt,
    int? businessServerId,
    DateTime? month,
    int? moneyIn,
    int? moneyOut,
    int? loanEmi,
    int? savings,
    String? basis,
  }) => LocalMonthlySnapshot(
    fetchedAt: fetchedAt ?? this.fetchedAt,
    businessServerId: businessServerId ?? this.businessServerId,
    month: month ?? this.month,
    moneyIn: moneyIn ?? this.moneyIn,
    moneyOut: moneyOut ?? this.moneyOut,
    loanEmi: loanEmi ?? this.loanEmi,
    savings: savings ?? this.savings,
    basis: basis ?? this.basis,
  );
  LocalMonthlySnapshot copyWithCompanion(LocalMonthlySnapshotsCompanion data) {
    return LocalMonthlySnapshot(
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      businessServerId: data.businessServerId.present
          ? data.businessServerId.value
          : this.businessServerId,
      month: data.month.present ? data.month.value : this.month,
      moneyIn: data.moneyIn.present ? data.moneyIn.value : this.moneyIn,
      moneyOut: data.moneyOut.present ? data.moneyOut.value : this.moneyOut,
      loanEmi: data.loanEmi.present ? data.loanEmi.value : this.loanEmi,
      savings: data.savings.present ? data.savings.value : this.savings,
      basis: data.basis.present ? data.basis.value : this.basis,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalMonthlySnapshot(')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('businessServerId: $businessServerId, ')
          ..write('month: $month, ')
          ..write('moneyIn: $moneyIn, ')
          ..write('moneyOut: $moneyOut, ')
          ..write('loanEmi: $loanEmi, ')
          ..write('savings: $savings, ')
          ..write('basis: $basis')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    fetchedAt,
    businessServerId,
    month,
    moneyIn,
    moneyOut,
    loanEmi,
    savings,
    basis,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalMonthlySnapshot &&
          other.fetchedAt == this.fetchedAt &&
          other.businessServerId == this.businessServerId &&
          other.month == this.month &&
          other.moneyIn == this.moneyIn &&
          other.moneyOut == this.moneyOut &&
          other.loanEmi == this.loanEmi &&
          other.savings == this.savings &&
          other.basis == this.basis);
}

class LocalMonthlySnapshotsCompanion
    extends UpdateCompanion<LocalMonthlySnapshot> {
  final Value<DateTime> fetchedAt;
  final Value<int> businessServerId;
  final Value<DateTime> month;
  final Value<int> moneyIn;
  final Value<int> moneyOut;
  final Value<int> loanEmi;
  final Value<int> savings;
  final Value<String> basis;
  final Value<int> rowid;
  const LocalMonthlySnapshotsCompanion({
    this.fetchedAt = const Value.absent(),
    this.businessServerId = const Value.absent(),
    this.month = const Value.absent(),
    this.moneyIn = const Value.absent(),
    this.moneyOut = const Value.absent(),
    this.loanEmi = const Value.absent(),
    this.savings = const Value.absent(),
    this.basis = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalMonthlySnapshotsCompanion.insert({
    this.fetchedAt = const Value.absent(),
    required int businessServerId,
    required DateTime month,
    this.moneyIn = const Value.absent(),
    this.moneyOut = const Value.absent(),
    this.loanEmi = const Value.absent(),
    this.savings = const Value.absent(),
    this.basis = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : businessServerId = Value(businessServerId),
       month = Value(month);
  static Insertable<LocalMonthlySnapshot> custom({
    Expression<DateTime>? fetchedAt,
    Expression<int>? businessServerId,
    Expression<DateTime>? month,
    Expression<int>? moneyIn,
    Expression<int>? moneyOut,
    Expression<int>? loanEmi,
    Expression<int>? savings,
    Expression<String>? basis,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (businessServerId != null) 'business_server_id': businessServerId,
      if (month != null) 'month': month,
      if (moneyIn != null) 'money_in': moneyIn,
      if (moneyOut != null) 'money_out': moneyOut,
      if (loanEmi != null) 'loan_emi': loanEmi,
      if (savings != null) 'savings': savings,
      if (basis != null) 'basis': basis,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalMonthlySnapshotsCompanion copyWith({
    Value<DateTime>? fetchedAt,
    Value<int>? businessServerId,
    Value<DateTime>? month,
    Value<int>? moneyIn,
    Value<int>? moneyOut,
    Value<int>? loanEmi,
    Value<int>? savings,
    Value<String>? basis,
    Value<int>? rowid,
  }) {
    return LocalMonthlySnapshotsCompanion(
      fetchedAt: fetchedAt ?? this.fetchedAt,
      businessServerId: businessServerId ?? this.businessServerId,
      month: month ?? this.month,
      moneyIn: moneyIn ?? this.moneyIn,
      moneyOut: moneyOut ?? this.moneyOut,
      loanEmi: loanEmi ?? this.loanEmi,
      savings: savings ?? this.savings,
      basis: basis ?? this.basis,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (businessServerId.present) {
      map['business_server_id'] = Variable<int>(businessServerId.value);
    }
    if (month.present) {
      map['month'] = Variable<DateTime>(month.value);
    }
    if (moneyIn.present) {
      map['money_in'] = Variable<int>(moneyIn.value);
    }
    if (moneyOut.present) {
      map['money_out'] = Variable<int>(moneyOut.value);
    }
    if (loanEmi.present) {
      map['loan_emi'] = Variable<int>(loanEmi.value);
    }
    if (savings.present) {
      map['savings'] = Variable<int>(savings.value);
    }
    if (basis.present) {
      map['basis'] = Variable<String>(basis.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalMonthlySnapshotsCompanion(')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('businessServerId: $businessServerId, ')
          ..write('month: $month, ')
          ..write('moneyIn: $moneyIn, ')
          ..write('moneyOut: $moneyOut, ')
          ..write('loanEmi: $loanEmi, ')
          ..write('savings: $savings, ')
          ..write('basis: $basis, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalLedgerEntriesTable extends LocalLedgerEntries
    with TableInfo<$LocalLedgerEntriesTable, LocalLedgerEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalLedgerEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RowSyncState, String> syncState =
      GeneratedColumn<String>(
        'sync_state',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(RowSyncState.synced.name),
      ).withConverter<RowSyncState>(
        $LocalLedgerEntriesTable.$convertersyncState,
      );
  static const VerificationMeta _localUpdatedAtMeta = const VerificationMeta(
    'localUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> localUpdatedAt =
      GeneratedColumn<DateTime>(
        'local_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _businessServerIdMeta = const VerificationMeta(
    'businessServerId',
  );
  @override
  late final GeneratedColumn<int> businessServerId = GeneratedColumn<int>(
    'business_server_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerUserIdMeta = const VerificationMeta(
    'ownerUserId',
  );
  @override
  late final GeneratedColumn<int> ownerUserId = GeneratedColumn<int>(
    'owner_user_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountInrMeta = const VerificationMeta(
    'amountInr',
  );
  @override
  late final GeneratedColumn<int> amountInr = GeneratedColumn<int>(
    'amount_inr',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    serverId,
    clientId,
    syncState,
    localUpdatedAt,
    businessServerId,
    ownerUserId,
    kind,
    amountInr,
    category,
    recordedAt,
    source,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_ledger_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalLedgerEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('local_updated_at')) {
      context.handle(
        _localUpdatedAtMeta,
        localUpdatedAt.isAcceptableOrUnknown(
          data['local_updated_at']!,
          _localUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('business_server_id')) {
      context.handle(
        _businessServerIdMeta,
        businessServerId.isAcceptableOrUnknown(
          data['business_server_id']!,
          _businessServerIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_businessServerIdMeta);
    }
    if (data.containsKey('owner_user_id')) {
      context.handle(
        _ownerUserIdMeta,
        ownerUserId.isAcceptableOrUnknown(
          data['owner_user_id']!,
          _ownerUserIdMeta,
        ),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('amount_inr')) {
      context.handle(
        _amountInrMeta,
        amountInr.isAcceptableOrUnknown(data['amount_inr']!, _amountInrMeta),
      );
    } else if (isInserting) {
      context.missing(_amountInrMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  LocalLedgerEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalLedgerEntry(
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      syncState: $LocalLedgerEntriesTable.$convertersyncState.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_state'],
        )!,
      ),
      localUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}local_updated_at'],
      )!,
      businessServerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}business_server_id'],
      )!,
      ownerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owner_user_id'],
      ),
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      amountInr: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_inr'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $LocalLedgerEntriesTable createAlias(String alias) {
    return $LocalLedgerEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RowSyncState, String, String> $convertersyncState =
      const EnumNameConverter<RowSyncState>(RowSyncState.values);
}

class LocalLedgerEntry extends DataClass
    implements Insertable<LocalLedgerEntry> {
  /// The backend BIGINT, once known. Null only for a create that has never
  /// reached the server.
  final int? serverId;

  /// Client-generated UUID. Stable for the lifetime of the row.
  final String clientId;

  /// Local sync state — see [RowSyncState].
  final RowSyncState syncState;

  /// When the device last touched this row. Used for ordering and for showing
  /// "saved at" on pending items.
  final DateTime localUpdatedAt;

  /// Always a real backend id: businesses cannot be created offline, so an
  /// entry can never be attached to an unsynced business.
  final int businessServerId;
  final int? ownerUserId;

  /// `in` | `out`.
  final String kind;

  /// Whole rupees, always positive; [kind] carries the sign.
  final int amountInr;

  /// `milk_sale` | `fodder` | `vet` | `emi` | `other`.
  final String category;
  final DateTime recordedAt;

  /// `manual` | `voice`.
  final String source;

  /// Server-side acknowledgement time, echoed by `GET /entries`. Null while the
  /// row is still local-only.
  final DateTime? syncedAt;
  const LocalLedgerEntry({
    this.serverId,
    required this.clientId,
    required this.syncState,
    required this.localUpdatedAt,
    required this.businessServerId,
    this.ownerUserId,
    required this.kind,
    required this.amountInr,
    required this.category,
    required this.recordedAt,
    required this.source,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['client_id'] = Variable<String>(clientId);
    {
      map['sync_state'] = Variable<String>(
        $LocalLedgerEntriesTable.$convertersyncState.toSql(syncState),
      );
    }
    map['local_updated_at'] = Variable<DateTime>(localUpdatedAt);
    map['business_server_id'] = Variable<int>(businessServerId);
    if (!nullToAbsent || ownerUserId != null) {
      map['owner_user_id'] = Variable<int>(ownerUserId);
    }
    map['kind'] = Variable<String>(kind);
    map['amount_inr'] = Variable<int>(amountInr);
    map['category'] = Variable<String>(category);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  LocalLedgerEntriesCompanion toCompanion(bool nullToAbsent) {
    return LocalLedgerEntriesCompanion(
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      clientId: Value(clientId),
      syncState: Value(syncState),
      localUpdatedAt: Value(localUpdatedAt),
      businessServerId: Value(businessServerId),
      ownerUserId: ownerUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerUserId),
      kind: Value(kind),
      amountInr: Value(amountInr),
      category: Value(category),
      recordedAt: Value(recordedAt),
      source: Value(source),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory LocalLedgerEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalLedgerEntry(
      serverId: serializer.fromJson<int?>(json['serverId']),
      clientId: serializer.fromJson<String>(json['clientId']),
      syncState: $LocalLedgerEntriesTable.$convertersyncState.fromJson(
        serializer.fromJson<String>(json['syncState']),
      ),
      localUpdatedAt: serializer.fromJson<DateTime>(json['localUpdatedAt']),
      businessServerId: serializer.fromJson<int>(json['businessServerId']),
      ownerUserId: serializer.fromJson<int?>(json['ownerUserId']),
      kind: serializer.fromJson<String>(json['kind']),
      amountInr: serializer.fromJson<int>(json['amountInr']),
      category: serializer.fromJson<String>(json['category']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      source: serializer.fromJson<String>(json['source']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'serverId': serializer.toJson<int?>(serverId),
      'clientId': serializer.toJson<String>(clientId),
      'syncState': serializer.toJson<String>(
        $LocalLedgerEntriesTable.$convertersyncState.toJson(syncState),
      ),
      'localUpdatedAt': serializer.toJson<DateTime>(localUpdatedAt),
      'businessServerId': serializer.toJson<int>(businessServerId),
      'ownerUserId': serializer.toJson<int?>(ownerUserId),
      'kind': serializer.toJson<String>(kind),
      'amountInr': serializer.toJson<int>(amountInr),
      'category': serializer.toJson<String>(category),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'source': serializer.toJson<String>(source),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  LocalLedgerEntry copyWith({
    Value<int?> serverId = const Value.absent(),
    String? clientId,
    RowSyncState? syncState,
    DateTime? localUpdatedAt,
    int? businessServerId,
    Value<int?> ownerUserId = const Value.absent(),
    String? kind,
    int? amountInr,
    String? category,
    DateTime? recordedAt,
    String? source,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => LocalLedgerEntry(
    serverId: serverId.present ? serverId.value : this.serverId,
    clientId: clientId ?? this.clientId,
    syncState: syncState ?? this.syncState,
    localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
    businessServerId: businessServerId ?? this.businessServerId,
    ownerUserId: ownerUserId.present ? ownerUserId.value : this.ownerUserId,
    kind: kind ?? this.kind,
    amountInr: amountInr ?? this.amountInr,
    category: category ?? this.category,
    recordedAt: recordedAt ?? this.recordedAt,
    source: source ?? this.source,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  LocalLedgerEntry copyWithCompanion(LocalLedgerEntriesCompanion data) {
    return LocalLedgerEntry(
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      localUpdatedAt: data.localUpdatedAt.present
          ? data.localUpdatedAt.value
          : this.localUpdatedAt,
      businessServerId: data.businessServerId.present
          ? data.businessServerId.value
          : this.businessServerId,
      ownerUserId: data.ownerUserId.present
          ? data.ownerUserId.value
          : this.ownerUserId,
      kind: data.kind.present ? data.kind.value : this.kind,
      amountInr: data.amountInr.present ? data.amountInr.value : this.amountInr,
      category: data.category.present ? data.category.value : this.category,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      source: data.source.present ? data.source.value : this.source,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalLedgerEntry(')
          ..write('serverId: $serverId, ')
          ..write('clientId: $clientId, ')
          ..write('syncState: $syncState, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('businessServerId: $businessServerId, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('kind: $kind, ')
          ..write('amountInr: $amountInr, ')
          ..write('category: $category, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('source: $source, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    serverId,
    clientId,
    syncState,
    localUpdatedAt,
    businessServerId,
    ownerUserId,
    kind,
    amountInr,
    category,
    recordedAt,
    source,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalLedgerEntry &&
          other.serverId == this.serverId &&
          other.clientId == this.clientId &&
          other.syncState == this.syncState &&
          other.localUpdatedAt == this.localUpdatedAt &&
          other.businessServerId == this.businessServerId &&
          other.ownerUserId == this.ownerUserId &&
          other.kind == this.kind &&
          other.amountInr == this.amountInr &&
          other.category == this.category &&
          other.recordedAt == this.recordedAt &&
          other.source == this.source &&
          other.syncedAt == this.syncedAt);
}

class LocalLedgerEntriesCompanion extends UpdateCompanion<LocalLedgerEntry> {
  final Value<int?> serverId;
  final Value<String> clientId;
  final Value<RowSyncState> syncState;
  final Value<DateTime> localUpdatedAt;
  final Value<int> businessServerId;
  final Value<int?> ownerUserId;
  final Value<String> kind;
  final Value<int> amountInr;
  final Value<String> category;
  final Value<DateTime> recordedAt;
  final Value<String> source;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const LocalLedgerEntriesCompanion({
    this.serverId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.syncState = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.businessServerId = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.kind = const Value.absent(),
    this.amountInr = const Value.absent(),
    this.category = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.source = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalLedgerEntriesCompanion.insert({
    this.serverId = const Value.absent(),
    required String clientId,
    this.syncState = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    required int businessServerId,
    this.ownerUserId = const Value.absent(),
    required String kind,
    required int amountInr,
    required String category,
    required DateTime recordedAt,
    this.source = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : clientId = Value(clientId),
       businessServerId = Value(businessServerId),
       kind = Value(kind),
       amountInr = Value(amountInr),
       category = Value(category),
       recordedAt = Value(recordedAt);
  static Insertable<LocalLedgerEntry> custom({
    Expression<int>? serverId,
    Expression<String>? clientId,
    Expression<String>? syncState,
    Expression<DateTime>? localUpdatedAt,
    Expression<int>? businessServerId,
    Expression<int>? ownerUserId,
    Expression<String>? kind,
    Expression<int>? amountInr,
    Expression<String>? category,
    Expression<DateTime>? recordedAt,
    Expression<String>? source,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (serverId != null) 'server_id': serverId,
      if (clientId != null) 'client_id': clientId,
      if (syncState != null) 'sync_state': syncState,
      if (localUpdatedAt != null) 'local_updated_at': localUpdatedAt,
      if (businessServerId != null) 'business_server_id': businessServerId,
      if (ownerUserId != null) 'owner_user_id': ownerUserId,
      if (kind != null) 'kind': kind,
      if (amountInr != null) 'amount_inr': amountInr,
      if (category != null) 'category': category,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (source != null) 'source': source,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalLedgerEntriesCompanion copyWith({
    Value<int?>? serverId,
    Value<String>? clientId,
    Value<RowSyncState>? syncState,
    Value<DateTime>? localUpdatedAt,
    Value<int>? businessServerId,
    Value<int?>? ownerUserId,
    Value<String>? kind,
    Value<int>? amountInr,
    Value<String>? category,
    Value<DateTime>? recordedAt,
    Value<String>? source,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return LocalLedgerEntriesCompanion(
      serverId: serverId ?? this.serverId,
      clientId: clientId ?? this.clientId,
      syncState: syncState ?? this.syncState,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      businessServerId: businessServerId ?? this.businessServerId,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      kind: kind ?? this.kind,
      amountInr: amountInr ?? this.amountInr,
      category: category ?? this.category,
      recordedAt: recordedAt ?? this.recordedAt,
      source: source ?? this.source,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(
        $LocalLedgerEntriesTable.$convertersyncState.toSql(syncState.value),
      );
    }
    if (localUpdatedAt.present) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt.value);
    }
    if (businessServerId.present) {
      map['business_server_id'] = Variable<int>(businessServerId.value);
    }
    if (ownerUserId.present) {
      map['owner_user_id'] = Variable<int>(ownerUserId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (amountInr.present) {
      map['amount_inr'] = Variable<int>(amountInr.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalLedgerEntriesCompanion(')
          ..write('serverId: $serverId, ')
          ..write('clientId: $clientId, ')
          ..write('syncState: $syncState, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('businessServerId: $businessServerId, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('kind: $kind, ')
          ..write('amountInr: $amountInr, ')
          ..write('category: $category, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('source: $source, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalHealthScoresTable extends LocalHealthScores
    with TableInfo<$LocalHealthScoresTable, LocalHealthScore> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalHealthScoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _businessServerIdMeta = const VerificationMeta(
    'businessServerId',
  );
  @override
  late final GeneratedColumn<int> businessServerId = GeneratedColumn<int>(
    'business_server_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _asOnMeta = const VerificationMeta('asOn');
  @override
  late final GeneratedColumn<DateTime> asOn = GeneratedColumn<DateTime>(
    'as_on',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextUpdateMeta = const VerificationMeta(
    'nextUpdate',
  );
  @override
  late final GeneratedColumn<DateTime> nextUpdate = GeneratedColumn<DateTime>(
    'next_update',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _riskMeta = const VerificationMeta('risk');
  @override
  late final GeneratedColumn<String> risk = GeneratedColumn<String>(
    'risk',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deltaMeta = const VerificationMeta('delta');
  @override
  late final GeneratedColumn<int> delta = GeneratedColumn<int>(
    'delta',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _daysWrittenMeta = const VerificationMeta(
    'daysWritten',
  );
  @override
  late final GeneratedColumn<int> daysWritten = GeneratedColumn<int>(
    'days_written',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _daysInMonthMeta = const VerificationMeta(
    'daysInMonth',
  );
  @override
  late final GeneratedColumn<int> daysInMonth = GeneratedColumn<int>(
    'days_in_month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _bandMeta = const VerificationMeta('band');
  @override
  late final GeneratedColumn<String> band = GeneratedColumn<String>(
    'band',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pGreenMeta = const VerificationMeta('pGreen');
  @override
  late final GeneratedColumn<double> pGreen = GeneratedColumn<double>(
    'p_green',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _pAmberMeta = const VerificationMeta('pAmber');
  @override
  late final GeneratedColumn<double> pAmber = GeneratedColumn<double>(
    'p_amber',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _pRedMeta = const VerificationMeta('pRed');
  @override
  late final GeneratedColumn<double> pRed = GeneratedColumn<double>(
    'p_red',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _modelVersionMeta = const VerificationMeta(
    'modelVersion',
  );
  @override
  late final GeneratedColumn<String> modelVersion = GeneratedColumn<String>(
    'model_version',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    fetchedAt,
    serverId,
    businessServerId,
    asOn,
    nextUpdate,
    score,
    risk,
    delta,
    daysWritten,
    daysInMonth,
    band,
    pGreen,
    pAmber,
    pRed,
    modelVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_health_scores';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalHealthScore> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('business_server_id')) {
      context.handle(
        _businessServerIdMeta,
        businessServerId.isAcceptableOrUnknown(
          data['business_server_id']!,
          _businessServerIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_businessServerIdMeta);
    }
    if (data.containsKey('as_on')) {
      context.handle(
        _asOnMeta,
        asOn.isAcceptableOrUnknown(data['as_on']!, _asOnMeta),
      );
    } else if (isInserting) {
      context.missing(_asOnMeta);
    }
    if (data.containsKey('next_update')) {
      context.handle(
        _nextUpdateMeta,
        nextUpdate.isAcceptableOrUnknown(data['next_update']!, _nextUpdateMeta),
      );
    } else if (isInserting) {
      context.missing(_nextUpdateMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('risk')) {
      context.handle(
        _riskMeta,
        risk.isAcceptableOrUnknown(data['risk']!, _riskMeta),
      );
    } else if (isInserting) {
      context.missing(_riskMeta);
    }
    if (data.containsKey('delta')) {
      context.handle(
        _deltaMeta,
        delta.isAcceptableOrUnknown(data['delta']!, _deltaMeta),
      );
    }
    if (data.containsKey('days_written')) {
      context.handle(
        _daysWrittenMeta,
        daysWritten.isAcceptableOrUnknown(
          data['days_written']!,
          _daysWrittenMeta,
        ),
      );
    }
    if (data.containsKey('days_in_month')) {
      context.handle(
        _daysInMonthMeta,
        daysInMonth.isAcceptableOrUnknown(
          data['days_in_month']!,
          _daysInMonthMeta,
        ),
      );
    }
    if (data.containsKey('band')) {
      context.handle(
        _bandMeta,
        band.isAcceptableOrUnknown(data['band']!, _bandMeta),
      );
    } else if (isInserting) {
      context.missing(_bandMeta);
    }
    if (data.containsKey('p_green')) {
      context.handle(
        _pGreenMeta,
        pGreen.isAcceptableOrUnknown(data['p_green']!, _pGreenMeta),
      );
    }
    if (data.containsKey('p_amber')) {
      context.handle(
        _pAmberMeta,
        pAmber.isAcceptableOrUnknown(data['p_amber']!, _pAmberMeta),
      );
    }
    if (data.containsKey('p_red')) {
      context.handle(
        _pRedMeta,
        pRed.isAcceptableOrUnknown(data['p_red']!, _pRedMeta),
      );
    }
    if (data.containsKey('model_version')) {
      context.handle(
        _modelVersionMeta,
        modelVersion.isAcceptableOrUnknown(
          data['model_version']!,
          _modelVersionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {serverId};
  @override
  LocalHealthScore map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalHealthScore(
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      )!,
      businessServerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}business_server_id'],
      )!,
      asOn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}as_on'],
      )!,
      nextUpdate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_update'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      )!,
      risk: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}risk'],
      )!,
      delta: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}delta'],
      ),
      daysWritten: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}days_written'],
      )!,
      daysInMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}days_in_month'],
      )!,
      band: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}band'],
      )!,
      pGreen: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}p_green'],
      )!,
      pAmber: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}p_amber'],
      )!,
      pRed: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}p_red'],
      )!,
      modelVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_version'],
      ),
    );
  }

  @override
  $LocalHealthScoresTable createAlias(String alias) {
    return $LocalHealthScoresTable(attachedDatabase, alias);
  }
}

class LocalHealthScore extends DataClass
    implements Insertable<LocalHealthScore> {
  /// When this row was last pulled from the backend. Drives the "showing saved
  /// data from X" line on the offline home.
  final DateTime fetchedAt;
  final int serverId;
  final int businessServerId;
  final DateTime asOn;
  final DateTime nextUpdate;
  final int score;

  /// `low` | `medium` | `high`.
  final String risk;

  /// Score change against the previous month; null when this is the first.
  final int? delta;
  final int daysWritten;
  final int daysInMonth;

  /// `green` | `amber` | `red`.
  final String band;
  final double pGreen;
  final double pAmber;
  final double pRed;
  final String? modelVersion;
  const LocalHealthScore({
    required this.fetchedAt,
    required this.serverId,
    required this.businessServerId,
    required this.asOn,
    required this.nextUpdate,
    required this.score,
    required this.risk,
    this.delta,
    required this.daysWritten,
    required this.daysInMonth,
    required this.band,
    required this.pGreen,
    required this.pAmber,
    required this.pRed,
    this.modelVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    map['server_id'] = Variable<int>(serverId);
    map['business_server_id'] = Variable<int>(businessServerId);
    map['as_on'] = Variable<DateTime>(asOn);
    map['next_update'] = Variable<DateTime>(nextUpdate);
    map['score'] = Variable<int>(score);
    map['risk'] = Variable<String>(risk);
    if (!nullToAbsent || delta != null) {
      map['delta'] = Variable<int>(delta);
    }
    map['days_written'] = Variable<int>(daysWritten);
    map['days_in_month'] = Variable<int>(daysInMonth);
    map['band'] = Variable<String>(band);
    map['p_green'] = Variable<double>(pGreen);
    map['p_amber'] = Variable<double>(pAmber);
    map['p_red'] = Variable<double>(pRed);
    if (!nullToAbsent || modelVersion != null) {
      map['model_version'] = Variable<String>(modelVersion);
    }
    return map;
  }

  LocalHealthScoresCompanion toCompanion(bool nullToAbsent) {
    return LocalHealthScoresCompanion(
      fetchedAt: Value(fetchedAt),
      serverId: Value(serverId),
      businessServerId: Value(businessServerId),
      asOn: Value(asOn),
      nextUpdate: Value(nextUpdate),
      score: Value(score),
      risk: Value(risk),
      delta: delta == null && nullToAbsent
          ? const Value.absent()
          : Value(delta),
      daysWritten: Value(daysWritten),
      daysInMonth: Value(daysInMonth),
      band: Value(band),
      pGreen: Value(pGreen),
      pAmber: Value(pAmber),
      pRed: Value(pRed),
      modelVersion: modelVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(modelVersion),
    );
  }

  factory LocalHealthScore.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalHealthScore(
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
      serverId: serializer.fromJson<int>(json['serverId']),
      businessServerId: serializer.fromJson<int>(json['businessServerId']),
      asOn: serializer.fromJson<DateTime>(json['asOn']),
      nextUpdate: serializer.fromJson<DateTime>(json['nextUpdate']),
      score: serializer.fromJson<int>(json['score']),
      risk: serializer.fromJson<String>(json['risk']),
      delta: serializer.fromJson<int?>(json['delta']),
      daysWritten: serializer.fromJson<int>(json['daysWritten']),
      daysInMonth: serializer.fromJson<int>(json['daysInMonth']),
      band: serializer.fromJson<String>(json['band']),
      pGreen: serializer.fromJson<double>(json['pGreen']),
      pAmber: serializer.fromJson<double>(json['pAmber']),
      pRed: serializer.fromJson<double>(json['pRed']),
      modelVersion: serializer.fromJson<String?>(json['modelVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
      'serverId': serializer.toJson<int>(serverId),
      'businessServerId': serializer.toJson<int>(businessServerId),
      'asOn': serializer.toJson<DateTime>(asOn),
      'nextUpdate': serializer.toJson<DateTime>(nextUpdate),
      'score': serializer.toJson<int>(score),
      'risk': serializer.toJson<String>(risk),
      'delta': serializer.toJson<int?>(delta),
      'daysWritten': serializer.toJson<int>(daysWritten),
      'daysInMonth': serializer.toJson<int>(daysInMonth),
      'band': serializer.toJson<String>(band),
      'pGreen': serializer.toJson<double>(pGreen),
      'pAmber': serializer.toJson<double>(pAmber),
      'pRed': serializer.toJson<double>(pRed),
      'modelVersion': serializer.toJson<String?>(modelVersion),
    };
  }

  LocalHealthScore copyWith({
    DateTime? fetchedAt,
    int? serverId,
    int? businessServerId,
    DateTime? asOn,
    DateTime? nextUpdate,
    int? score,
    String? risk,
    Value<int?> delta = const Value.absent(),
    int? daysWritten,
    int? daysInMonth,
    String? band,
    double? pGreen,
    double? pAmber,
    double? pRed,
    Value<String?> modelVersion = const Value.absent(),
  }) => LocalHealthScore(
    fetchedAt: fetchedAt ?? this.fetchedAt,
    serverId: serverId ?? this.serverId,
    businessServerId: businessServerId ?? this.businessServerId,
    asOn: asOn ?? this.asOn,
    nextUpdate: nextUpdate ?? this.nextUpdate,
    score: score ?? this.score,
    risk: risk ?? this.risk,
    delta: delta.present ? delta.value : this.delta,
    daysWritten: daysWritten ?? this.daysWritten,
    daysInMonth: daysInMonth ?? this.daysInMonth,
    band: band ?? this.band,
    pGreen: pGreen ?? this.pGreen,
    pAmber: pAmber ?? this.pAmber,
    pRed: pRed ?? this.pRed,
    modelVersion: modelVersion.present ? modelVersion.value : this.modelVersion,
  );
  LocalHealthScore copyWithCompanion(LocalHealthScoresCompanion data) {
    return LocalHealthScore(
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      businessServerId: data.businessServerId.present
          ? data.businessServerId.value
          : this.businessServerId,
      asOn: data.asOn.present ? data.asOn.value : this.asOn,
      nextUpdate: data.nextUpdate.present
          ? data.nextUpdate.value
          : this.nextUpdate,
      score: data.score.present ? data.score.value : this.score,
      risk: data.risk.present ? data.risk.value : this.risk,
      delta: data.delta.present ? data.delta.value : this.delta,
      daysWritten: data.daysWritten.present
          ? data.daysWritten.value
          : this.daysWritten,
      daysInMonth: data.daysInMonth.present
          ? data.daysInMonth.value
          : this.daysInMonth,
      band: data.band.present ? data.band.value : this.band,
      pGreen: data.pGreen.present ? data.pGreen.value : this.pGreen,
      pAmber: data.pAmber.present ? data.pAmber.value : this.pAmber,
      pRed: data.pRed.present ? data.pRed.value : this.pRed,
      modelVersion: data.modelVersion.present
          ? data.modelVersion.value
          : this.modelVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalHealthScore(')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('serverId: $serverId, ')
          ..write('businessServerId: $businessServerId, ')
          ..write('asOn: $asOn, ')
          ..write('nextUpdate: $nextUpdate, ')
          ..write('score: $score, ')
          ..write('risk: $risk, ')
          ..write('delta: $delta, ')
          ..write('daysWritten: $daysWritten, ')
          ..write('daysInMonth: $daysInMonth, ')
          ..write('band: $band, ')
          ..write('pGreen: $pGreen, ')
          ..write('pAmber: $pAmber, ')
          ..write('pRed: $pRed, ')
          ..write('modelVersion: $modelVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    fetchedAt,
    serverId,
    businessServerId,
    asOn,
    nextUpdate,
    score,
    risk,
    delta,
    daysWritten,
    daysInMonth,
    band,
    pGreen,
    pAmber,
    pRed,
    modelVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalHealthScore &&
          other.fetchedAt == this.fetchedAt &&
          other.serverId == this.serverId &&
          other.businessServerId == this.businessServerId &&
          other.asOn == this.asOn &&
          other.nextUpdate == this.nextUpdate &&
          other.score == this.score &&
          other.risk == this.risk &&
          other.delta == this.delta &&
          other.daysWritten == this.daysWritten &&
          other.daysInMonth == this.daysInMonth &&
          other.band == this.band &&
          other.pGreen == this.pGreen &&
          other.pAmber == this.pAmber &&
          other.pRed == this.pRed &&
          other.modelVersion == this.modelVersion);
}

class LocalHealthScoresCompanion extends UpdateCompanion<LocalHealthScore> {
  final Value<DateTime> fetchedAt;
  final Value<int> serverId;
  final Value<int> businessServerId;
  final Value<DateTime> asOn;
  final Value<DateTime> nextUpdate;
  final Value<int> score;
  final Value<String> risk;
  final Value<int?> delta;
  final Value<int> daysWritten;
  final Value<int> daysInMonth;
  final Value<String> band;
  final Value<double> pGreen;
  final Value<double> pAmber;
  final Value<double> pRed;
  final Value<String?> modelVersion;
  const LocalHealthScoresCompanion({
    this.fetchedAt = const Value.absent(),
    this.serverId = const Value.absent(),
    this.businessServerId = const Value.absent(),
    this.asOn = const Value.absent(),
    this.nextUpdate = const Value.absent(),
    this.score = const Value.absent(),
    this.risk = const Value.absent(),
    this.delta = const Value.absent(),
    this.daysWritten = const Value.absent(),
    this.daysInMonth = const Value.absent(),
    this.band = const Value.absent(),
    this.pGreen = const Value.absent(),
    this.pAmber = const Value.absent(),
    this.pRed = const Value.absent(),
    this.modelVersion = const Value.absent(),
  });
  LocalHealthScoresCompanion.insert({
    this.fetchedAt = const Value.absent(),
    this.serverId = const Value.absent(),
    required int businessServerId,
    required DateTime asOn,
    required DateTime nextUpdate,
    required int score,
    required String risk,
    this.delta = const Value.absent(),
    this.daysWritten = const Value.absent(),
    this.daysInMonth = const Value.absent(),
    required String band,
    this.pGreen = const Value.absent(),
    this.pAmber = const Value.absent(),
    this.pRed = const Value.absent(),
    this.modelVersion = const Value.absent(),
  }) : businessServerId = Value(businessServerId),
       asOn = Value(asOn),
       nextUpdate = Value(nextUpdate),
       score = Value(score),
       risk = Value(risk),
       band = Value(band);
  static Insertable<LocalHealthScore> custom({
    Expression<DateTime>? fetchedAt,
    Expression<int>? serverId,
    Expression<int>? businessServerId,
    Expression<DateTime>? asOn,
    Expression<DateTime>? nextUpdate,
    Expression<int>? score,
    Expression<String>? risk,
    Expression<int>? delta,
    Expression<int>? daysWritten,
    Expression<int>? daysInMonth,
    Expression<String>? band,
    Expression<double>? pGreen,
    Expression<double>? pAmber,
    Expression<double>? pRed,
    Expression<String>? modelVersion,
  }) {
    return RawValuesInsertable({
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (serverId != null) 'server_id': serverId,
      if (businessServerId != null) 'business_server_id': businessServerId,
      if (asOn != null) 'as_on': asOn,
      if (nextUpdate != null) 'next_update': nextUpdate,
      if (score != null) 'score': score,
      if (risk != null) 'risk': risk,
      if (delta != null) 'delta': delta,
      if (daysWritten != null) 'days_written': daysWritten,
      if (daysInMonth != null) 'days_in_month': daysInMonth,
      if (band != null) 'band': band,
      if (pGreen != null) 'p_green': pGreen,
      if (pAmber != null) 'p_amber': pAmber,
      if (pRed != null) 'p_red': pRed,
      if (modelVersion != null) 'model_version': modelVersion,
    });
  }

  LocalHealthScoresCompanion copyWith({
    Value<DateTime>? fetchedAt,
    Value<int>? serverId,
    Value<int>? businessServerId,
    Value<DateTime>? asOn,
    Value<DateTime>? nextUpdate,
    Value<int>? score,
    Value<String>? risk,
    Value<int?>? delta,
    Value<int>? daysWritten,
    Value<int>? daysInMonth,
    Value<String>? band,
    Value<double>? pGreen,
    Value<double>? pAmber,
    Value<double>? pRed,
    Value<String?>? modelVersion,
  }) {
    return LocalHealthScoresCompanion(
      fetchedAt: fetchedAt ?? this.fetchedAt,
      serverId: serverId ?? this.serverId,
      businessServerId: businessServerId ?? this.businessServerId,
      asOn: asOn ?? this.asOn,
      nextUpdate: nextUpdate ?? this.nextUpdate,
      score: score ?? this.score,
      risk: risk ?? this.risk,
      delta: delta ?? this.delta,
      daysWritten: daysWritten ?? this.daysWritten,
      daysInMonth: daysInMonth ?? this.daysInMonth,
      band: band ?? this.band,
      pGreen: pGreen ?? this.pGreen,
      pAmber: pAmber ?? this.pAmber,
      pRed: pRed ?? this.pRed,
      modelVersion: modelVersion ?? this.modelVersion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (businessServerId.present) {
      map['business_server_id'] = Variable<int>(businessServerId.value);
    }
    if (asOn.present) {
      map['as_on'] = Variable<DateTime>(asOn.value);
    }
    if (nextUpdate.present) {
      map['next_update'] = Variable<DateTime>(nextUpdate.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (risk.present) {
      map['risk'] = Variable<String>(risk.value);
    }
    if (delta.present) {
      map['delta'] = Variable<int>(delta.value);
    }
    if (daysWritten.present) {
      map['days_written'] = Variable<int>(daysWritten.value);
    }
    if (daysInMonth.present) {
      map['days_in_month'] = Variable<int>(daysInMonth.value);
    }
    if (band.present) {
      map['band'] = Variable<String>(band.value);
    }
    if (pGreen.present) {
      map['p_green'] = Variable<double>(pGreen.value);
    }
    if (pAmber.present) {
      map['p_amber'] = Variable<double>(pAmber.value);
    }
    if (pRed.present) {
      map['p_red'] = Variable<double>(pRed.value);
    }
    if (modelVersion.present) {
      map['model_version'] = Variable<String>(modelVersion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalHealthScoresCompanion(')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('serverId: $serverId, ')
          ..write('businessServerId: $businessServerId, ')
          ..write('asOn: $asOn, ')
          ..write('nextUpdate: $nextUpdate, ')
          ..write('score: $score, ')
          ..write('risk: $risk, ')
          ..write('delta: $delta, ')
          ..write('daysWritten: $daysWritten, ')
          ..write('daysInMonth: $daysInMonth, ')
          ..write('band: $band, ')
          ..write('pGreen: $pGreen, ')
          ..write('pAmber: $pAmber, ')
          ..write('pRed: $pRed, ')
          ..write('modelVersion: $modelVersion')
          ..write(')'))
        .toString();
  }
}

class $LocalForecastsTable extends LocalForecasts
    with TableInfo<$LocalForecastsTable, LocalForecast> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalForecastsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _businessServerIdMeta = const VerificationMeta(
    'businessServerId',
  );
  @override
  late final GeneratedColumn<int> businessServerId = GeneratedColumn<int>(
    'business_server_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _asOnMeta = const VerificationMeta('asOn');
  @override
  late final GeneratedColumn<DateTime> asOn = GeneratedColumn<DateTime>(
    'as_on',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _horizonMeta = const VerificationMeta(
    'horizon',
  );
  @override
  late final GeneratedColumn<int> horizon = GeneratedColumn<int>(
    'horizon',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cfPredMeta = const VerificationMeta('cfPred');
  @override
  late final GeneratedColumn<double> cfPred = GeneratedColumn<double>(
    'cf_pred',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _inLevelMeta = const VerificationMeta(
    'inLevel',
  );
  @override
  late final GeneratedColumn<double> inLevel = GeneratedColumn<double>(
    'in_level',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _outLevelMeta = const VerificationMeta(
    'outLevel',
  );
  @override
  late final GeneratedColumn<double> outLevel = GeneratedColumn<double>(
    'out_level',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isRiskMonthMeta = const VerificationMeta(
    'isRiskMonth',
  );
  @override
  late final GeneratedColumn<bool> isRiskMonth = GeneratedColumn<bool>(
    'is_risk_month',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_risk_month" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    fetchedAt,
    businessServerId,
    asOn,
    horizon,
    cfPred,
    inLevel,
    outLevel,
    isRiskMonth,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_forecasts';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalForecast> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    }
    if (data.containsKey('business_server_id')) {
      context.handle(
        _businessServerIdMeta,
        businessServerId.isAcceptableOrUnknown(
          data['business_server_id']!,
          _businessServerIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_businessServerIdMeta);
    }
    if (data.containsKey('as_on')) {
      context.handle(
        _asOnMeta,
        asOn.isAcceptableOrUnknown(data['as_on']!, _asOnMeta),
      );
    } else if (isInserting) {
      context.missing(_asOnMeta);
    }
    if (data.containsKey('horizon')) {
      context.handle(
        _horizonMeta,
        horizon.isAcceptableOrUnknown(data['horizon']!, _horizonMeta),
      );
    } else if (isInserting) {
      context.missing(_horizonMeta);
    }
    if (data.containsKey('cf_pred')) {
      context.handle(
        _cfPredMeta,
        cfPred.isAcceptableOrUnknown(data['cf_pred']!, _cfPredMeta),
      );
    }
    if (data.containsKey('in_level')) {
      context.handle(
        _inLevelMeta,
        inLevel.isAcceptableOrUnknown(data['in_level']!, _inLevelMeta),
      );
    }
    if (data.containsKey('out_level')) {
      context.handle(
        _outLevelMeta,
        outLevel.isAcceptableOrUnknown(data['out_level']!, _outLevelMeta),
      );
    }
    if (data.containsKey('is_risk_month')) {
      context.handle(
        _isRiskMonthMeta,
        isRiskMonth.isAcceptableOrUnknown(
          data['is_risk_month']!,
          _isRiskMonthMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {businessServerId, asOn, horizon};
  @override
  LocalForecast map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalForecast(
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
      businessServerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}business_server_id'],
      )!,
      asOn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}as_on'],
      )!,
      horizon: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}horizon'],
      )!,
      cfPred: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cf_pred'],
      )!,
      inLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}in_level'],
      )!,
      outLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}out_level'],
      )!,
      isRiskMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_risk_month'],
      )!,
    );
  }

  @override
  $LocalForecastsTable createAlias(String alias) {
    return $LocalForecastsTable(attachedDatabase, alias);
  }
}

class LocalForecast extends DataClass implements Insertable<LocalForecast> {
  /// When this row was last pulled from the backend. Drives the "showing saved
  /// data from X" line on the offline home.
  final DateTime fetchedAt;
  final int businessServerId;

  /// The date the forecast window was stamped.
  final DateTime asOn;

  /// Months ahead of [asOn], 1..6.
  final int horizon;
  final double cfPred;
  final double inLevel;
  final double outLevel;
  final bool isRiskMonth;
  const LocalForecast({
    required this.fetchedAt,
    required this.businessServerId,
    required this.asOn,
    required this.horizon,
    required this.cfPred,
    required this.inLevel,
    required this.outLevel,
    required this.isRiskMonth,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    map['business_server_id'] = Variable<int>(businessServerId);
    map['as_on'] = Variable<DateTime>(asOn);
    map['horizon'] = Variable<int>(horizon);
    map['cf_pred'] = Variable<double>(cfPred);
    map['in_level'] = Variable<double>(inLevel);
    map['out_level'] = Variable<double>(outLevel);
    map['is_risk_month'] = Variable<bool>(isRiskMonth);
    return map;
  }

  LocalForecastsCompanion toCompanion(bool nullToAbsent) {
    return LocalForecastsCompanion(
      fetchedAt: Value(fetchedAt),
      businessServerId: Value(businessServerId),
      asOn: Value(asOn),
      horizon: Value(horizon),
      cfPred: Value(cfPred),
      inLevel: Value(inLevel),
      outLevel: Value(outLevel),
      isRiskMonth: Value(isRiskMonth),
    );
  }

  factory LocalForecast.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalForecast(
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
      businessServerId: serializer.fromJson<int>(json['businessServerId']),
      asOn: serializer.fromJson<DateTime>(json['asOn']),
      horizon: serializer.fromJson<int>(json['horizon']),
      cfPred: serializer.fromJson<double>(json['cfPred']),
      inLevel: serializer.fromJson<double>(json['inLevel']),
      outLevel: serializer.fromJson<double>(json['outLevel']),
      isRiskMonth: serializer.fromJson<bool>(json['isRiskMonth']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
      'businessServerId': serializer.toJson<int>(businessServerId),
      'asOn': serializer.toJson<DateTime>(asOn),
      'horizon': serializer.toJson<int>(horizon),
      'cfPred': serializer.toJson<double>(cfPred),
      'inLevel': serializer.toJson<double>(inLevel),
      'outLevel': serializer.toJson<double>(outLevel),
      'isRiskMonth': serializer.toJson<bool>(isRiskMonth),
    };
  }

  LocalForecast copyWith({
    DateTime? fetchedAt,
    int? businessServerId,
    DateTime? asOn,
    int? horizon,
    double? cfPred,
    double? inLevel,
    double? outLevel,
    bool? isRiskMonth,
  }) => LocalForecast(
    fetchedAt: fetchedAt ?? this.fetchedAt,
    businessServerId: businessServerId ?? this.businessServerId,
    asOn: asOn ?? this.asOn,
    horizon: horizon ?? this.horizon,
    cfPred: cfPred ?? this.cfPred,
    inLevel: inLevel ?? this.inLevel,
    outLevel: outLevel ?? this.outLevel,
    isRiskMonth: isRiskMonth ?? this.isRiskMonth,
  );
  LocalForecast copyWithCompanion(LocalForecastsCompanion data) {
    return LocalForecast(
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      businessServerId: data.businessServerId.present
          ? data.businessServerId.value
          : this.businessServerId,
      asOn: data.asOn.present ? data.asOn.value : this.asOn,
      horizon: data.horizon.present ? data.horizon.value : this.horizon,
      cfPred: data.cfPred.present ? data.cfPred.value : this.cfPred,
      inLevel: data.inLevel.present ? data.inLevel.value : this.inLevel,
      outLevel: data.outLevel.present ? data.outLevel.value : this.outLevel,
      isRiskMonth: data.isRiskMonth.present
          ? data.isRiskMonth.value
          : this.isRiskMonth,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalForecast(')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('businessServerId: $businessServerId, ')
          ..write('asOn: $asOn, ')
          ..write('horizon: $horizon, ')
          ..write('cfPred: $cfPred, ')
          ..write('inLevel: $inLevel, ')
          ..write('outLevel: $outLevel, ')
          ..write('isRiskMonth: $isRiskMonth')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    fetchedAt,
    businessServerId,
    asOn,
    horizon,
    cfPred,
    inLevel,
    outLevel,
    isRiskMonth,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalForecast &&
          other.fetchedAt == this.fetchedAt &&
          other.businessServerId == this.businessServerId &&
          other.asOn == this.asOn &&
          other.horizon == this.horizon &&
          other.cfPred == this.cfPred &&
          other.inLevel == this.inLevel &&
          other.outLevel == this.outLevel &&
          other.isRiskMonth == this.isRiskMonth);
}

class LocalForecastsCompanion extends UpdateCompanion<LocalForecast> {
  final Value<DateTime> fetchedAt;
  final Value<int> businessServerId;
  final Value<DateTime> asOn;
  final Value<int> horizon;
  final Value<double> cfPred;
  final Value<double> inLevel;
  final Value<double> outLevel;
  final Value<bool> isRiskMonth;
  final Value<int> rowid;
  const LocalForecastsCompanion({
    this.fetchedAt = const Value.absent(),
    this.businessServerId = const Value.absent(),
    this.asOn = const Value.absent(),
    this.horizon = const Value.absent(),
    this.cfPred = const Value.absent(),
    this.inLevel = const Value.absent(),
    this.outLevel = const Value.absent(),
    this.isRiskMonth = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalForecastsCompanion.insert({
    this.fetchedAt = const Value.absent(),
    required int businessServerId,
    required DateTime asOn,
    required int horizon,
    this.cfPred = const Value.absent(),
    this.inLevel = const Value.absent(),
    this.outLevel = const Value.absent(),
    this.isRiskMonth = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : businessServerId = Value(businessServerId),
       asOn = Value(asOn),
       horizon = Value(horizon);
  static Insertable<LocalForecast> custom({
    Expression<DateTime>? fetchedAt,
    Expression<int>? businessServerId,
    Expression<DateTime>? asOn,
    Expression<int>? horizon,
    Expression<double>? cfPred,
    Expression<double>? inLevel,
    Expression<double>? outLevel,
    Expression<bool>? isRiskMonth,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (businessServerId != null) 'business_server_id': businessServerId,
      if (asOn != null) 'as_on': asOn,
      if (horizon != null) 'horizon': horizon,
      if (cfPred != null) 'cf_pred': cfPred,
      if (inLevel != null) 'in_level': inLevel,
      if (outLevel != null) 'out_level': outLevel,
      if (isRiskMonth != null) 'is_risk_month': isRiskMonth,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalForecastsCompanion copyWith({
    Value<DateTime>? fetchedAt,
    Value<int>? businessServerId,
    Value<DateTime>? asOn,
    Value<int>? horizon,
    Value<double>? cfPred,
    Value<double>? inLevel,
    Value<double>? outLevel,
    Value<bool>? isRiskMonth,
    Value<int>? rowid,
  }) {
    return LocalForecastsCompanion(
      fetchedAt: fetchedAt ?? this.fetchedAt,
      businessServerId: businessServerId ?? this.businessServerId,
      asOn: asOn ?? this.asOn,
      horizon: horizon ?? this.horizon,
      cfPred: cfPred ?? this.cfPred,
      inLevel: inLevel ?? this.inLevel,
      outLevel: outLevel ?? this.outLevel,
      isRiskMonth: isRiskMonth ?? this.isRiskMonth,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (businessServerId.present) {
      map['business_server_id'] = Variable<int>(businessServerId.value);
    }
    if (asOn.present) {
      map['as_on'] = Variable<DateTime>(asOn.value);
    }
    if (horizon.present) {
      map['horizon'] = Variable<int>(horizon.value);
    }
    if (cfPred.present) {
      map['cf_pred'] = Variable<double>(cfPred.value);
    }
    if (inLevel.present) {
      map['in_level'] = Variable<double>(inLevel.value);
    }
    if (outLevel.present) {
      map['out_level'] = Variable<double>(outLevel.value);
    }
    if (isRiskMonth.present) {
      map['is_risk_month'] = Variable<bool>(isRiskMonth.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalForecastsCompanion(')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('businessServerId: $businessServerId, ')
          ..write('asOn: $asOn, ')
          ..write('horizon: $horizon, ')
          ..write('cfPred: $cfPred, ')
          ..write('inLevel: $inLevel, ')
          ..write('outLevel: $outLevel, ')
          ..write('isRiskMonth: $isRiskMonth, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalRiskAlertsTable extends LocalRiskAlerts
    with TableInfo<$LocalRiskAlertsTable, LocalRiskAlert> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalRiskAlertsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _businessServerIdMeta = const VerificationMeta(
    'businessServerId',
  );
  @override
  late final GeneratedColumn<int> businessServerId = GeneratedColumn<int>(
    'business_server_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _asOnMeta = const VerificationMeta('asOn');
  @override
  late final GeneratedColumn<DateTime> asOn = GeneratedColumn<DateTime>(
    'as_on',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _severityMeta = const VerificationMeta(
    'severity',
  );
  @override
  late final GeneratedColumn<String> severity = GeneratedColumn<String>(
    'severity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _driverMeta = const VerificationMeta('driver');
  @override
  late final GeneratedColumn<String> driver = GeneratedColumn<String>(
    'driver',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hasPlanMeta = const VerificationMeta(
    'hasPlan',
  );
  @override
  late final GeneratedColumn<bool> hasPlan = GeneratedColumn<bool>(
    'has_plan',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_plan" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _raisedOnMeta = const VerificationMeta(
    'raisedOn',
  );
  @override
  late final GeneratedColumn<DateTime> raisedOn = GeneratedColumn<DateTime>(
    'raised_on',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resolvedAtMeta = const VerificationMeta(
    'resolvedAt',
  );
  @override
  late final GeneratedColumn<DateTime> resolvedAt = GeneratedColumn<DateTime>(
    'resolved_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _detailFetchedMeta = const VerificationMeta(
    'detailFetched',
  );
  @override
  late final GeneratedColumn<bool> detailFetched = GeneratedColumn<bool>(
    'detail_fetched',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("detail_fetched" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    fetchedAt,
    serverId,
    businessServerId,
    asOn,
    kind,
    severity,
    driver,
    hasPlan,
    raisedOn,
    resolvedAt,
    detailFetched,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_risk_alerts';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalRiskAlert> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('business_server_id')) {
      context.handle(
        _businessServerIdMeta,
        businessServerId.isAcceptableOrUnknown(
          data['business_server_id']!,
          _businessServerIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_businessServerIdMeta);
    }
    if (data.containsKey('as_on')) {
      context.handle(
        _asOnMeta,
        asOn.isAcceptableOrUnknown(data['as_on']!, _asOnMeta),
      );
    } else if (isInserting) {
      context.missing(_asOnMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(
        _severityMeta,
        severity.isAcceptableOrUnknown(data['severity']!, _severityMeta),
      );
    } else if (isInserting) {
      context.missing(_severityMeta);
    }
    if (data.containsKey('driver')) {
      context.handle(
        _driverMeta,
        driver.isAcceptableOrUnknown(data['driver']!, _driverMeta),
      );
    }
    if (data.containsKey('has_plan')) {
      context.handle(
        _hasPlanMeta,
        hasPlan.isAcceptableOrUnknown(data['has_plan']!, _hasPlanMeta),
      );
    }
    if (data.containsKey('raised_on')) {
      context.handle(
        _raisedOnMeta,
        raisedOn.isAcceptableOrUnknown(data['raised_on']!, _raisedOnMeta),
      );
    } else if (isInserting) {
      context.missing(_raisedOnMeta);
    }
    if (data.containsKey('resolved_at')) {
      context.handle(
        _resolvedAtMeta,
        resolvedAt.isAcceptableOrUnknown(data['resolved_at']!, _resolvedAtMeta),
      );
    }
    if (data.containsKey('detail_fetched')) {
      context.handle(
        _detailFetchedMeta,
        detailFetched.isAcceptableOrUnknown(
          data['detail_fetched']!,
          _detailFetchedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {serverId};
  @override
  LocalRiskAlert map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalRiskAlert(
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      )!,
      businessServerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}business_server_id'],
      )!,
      asOn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}as_on'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      severity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}severity'],
      )!,
      driver: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}driver'],
      ),
      hasPlan: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_plan'],
      )!,
      raisedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}raised_on'],
      )!,
      resolvedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}resolved_at'],
      ),
      detailFetched: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}detail_fetched'],
      )!,
    );
  }

  @override
  $LocalRiskAlertsTable createAlias(String alias) {
    return $LocalRiskAlertsTable(attachedDatabase, alias);
  }
}

class LocalRiskAlert extends DataClass implements Insertable<LocalRiskAlert> {
  /// When this row was last pulled from the backend. Drives the "showing saved
  /// data from X" line on the offline home.
  final DateTime fetchedAt;
  final int serverId;
  final int businessServerId;
  final DateTime asOn;

  /// One of six backend kinds: `savings_low`, `liquidity_debt_stress`,
  /// `climate_deficit`, `climate_excess`, `market_stress`, `new_business`.
  /// Stored raw because the frontend's `toDomainKind()` collapses these six
  /// into three and the distinction is worth keeping on disk.
  final String kind;

  /// `urgent` | `info`.
  final String severity;
  final String? driver;
  final bool hasPlan;
  final DateTime raisedOn;
  final DateTime? resolvedAt;

  /// True once `GET /alerts/{id}` has filled in this alert's plan actions, so
  /// the detail screen can tell "no actions" from "not fetched yet" offline.
  final bool detailFetched;
  const LocalRiskAlert({
    required this.fetchedAt,
    required this.serverId,
    required this.businessServerId,
    required this.asOn,
    required this.kind,
    required this.severity,
    this.driver,
    required this.hasPlan,
    required this.raisedOn,
    this.resolvedAt,
    required this.detailFetched,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    map['server_id'] = Variable<int>(serverId);
    map['business_server_id'] = Variable<int>(businessServerId);
    map['as_on'] = Variable<DateTime>(asOn);
    map['kind'] = Variable<String>(kind);
    map['severity'] = Variable<String>(severity);
    if (!nullToAbsent || driver != null) {
      map['driver'] = Variable<String>(driver);
    }
    map['has_plan'] = Variable<bool>(hasPlan);
    map['raised_on'] = Variable<DateTime>(raisedOn);
    if (!nullToAbsent || resolvedAt != null) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt);
    }
    map['detail_fetched'] = Variable<bool>(detailFetched);
    return map;
  }

  LocalRiskAlertsCompanion toCompanion(bool nullToAbsent) {
    return LocalRiskAlertsCompanion(
      fetchedAt: Value(fetchedAt),
      serverId: Value(serverId),
      businessServerId: Value(businessServerId),
      asOn: Value(asOn),
      kind: Value(kind),
      severity: Value(severity),
      driver: driver == null && nullToAbsent
          ? const Value.absent()
          : Value(driver),
      hasPlan: Value(hasPlan),
      raisedOn: Value(raisedOn),
      resolvedAt: resolvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(resolvedAt),
      detailFetched: Value(detailFetched),
    );
  }

  factory LocalRiskAlert.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalRiskAlert(
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
      serverId: serializer.fromJson<int>(json['serverId']),
      businessServerId: serializer.fromJson<int>(json['businessServerId']),
      asOn: serializer.fromJson<DateTime>(json['asOn']),
      kind: serializer.fromJson<String>(json['kind']),
      severity: serializer.fromJson<String>(json['severity']),
      driver: serializer.fromJson<String?>(json['driver']),
      hasPlan: serializer.fromJson<bool>(json['hasPlan']),
      raisedOn: serializer.fromJson<DateTime>(json['raisedOn']),
      resolvedAt: serializer.fromJson<DateTime?>(json['resolvedAt']),
      detailFetched: serializer.fromJson<bool>(json['detailFetched']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
      'serverId': serializer.toJson<int>(serverId),
      'businessServerId': serializer.toJson<int>(businessServerId),
      'asOn': serializer.toJson<DateTime>(asOn),
      'kind': serializer.toJson<String>(kind),
      'severity': serializer.toJson<String>(severity),
      'driver': serializer.toJson<String?>(driver),
      'hasPlan': serializer.toJson<bool>(hasPlan),
      'raisedOn': serializer.toJson<DateTime>(raisedOn),
      'resolvedAt': serializer.toJson<DateTime?>(resolvedAt),
      'detailFetched': serializer.toJson<bool>(detailFetched),
    };
  }

  LocalRiskAlert copyWith({
    DateTime? fetchedAt,
    int? serverId,
    int? businessServerId,
    DateTime? asOn,
    String? kind,
    String? severity,
    Value<String?> driver = const Value.absent(),
    bool? hasPlan,
    DateTime? raisedOn,
    Value<DateTime?> resolvedAt = const Value.absent(),
    bool? detailFetched,
  }) => LocalRiskAlert(
    fetchedAt: fetchedAt ?? this.fetchedAt,
    serverId: serverId ?? this.serverId,
    businessServerId: businessServerId ?? this.businessServerId,
    asOn: asOn ?? this.asOn,
    kind: kind ?? this.kind,
    severity: severity ?? this.severity,
    driver: driver.present ? driver.value : this.driver,
    hasPlan: hasPlan ?? this.hasPlan,
    raisedOn: raisedOn ?? this.raisedOn,
    resolvedAt: resolvedAt.present ? resolvedAt.value : this.resolvedAt,
    detailFetched: detailFetched ?? this.detailFetched,
  );
  LocalRiskAlert copyWithCompanion(LocalRiskAlertsCompanion data) {
    return LocalRiskAlert(
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      businessServerId: data.businessServerId.present
          ? data.businessServerId.value
          : this.businessServerId,
      asOn: data.asOn.present ? data.asOn.value : this.asOn,
      kind: data.kind.present ? data.kind.value : this.kind,
      severity: data.severity.present ? data.severity.value : this.severity,
      driver: data.driver.present ? data.driver.value : this.driver,
      hasPlan: data.hasPlan.present ? data.hasPlan.value : this.hasPlan,
      raisedOn: data.raisedOn.present ? data.raisedOn.value : this.raisedOn,
      resolvedAt: data.resolvedAt.present
          ? data.resolvedAt.value
          : this.resolvedAt,
      detailFetched: data.detailFetched.present
          ? data.detailFetched.value
          : this.detailFetched,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalRiskAlert(')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('serverId: $serverId, ')
          ..write('businessServerId: $businessServerId, ')
          ..write('asOn: $asOn, ')
          ..write('kind: $kind, ')
          ..write('severity: $severity, ')
          ..write('driver: $driver, ')
          ..write('hasPlan: $hasPlan, ')
          ..write('raisedOn: $raisedOn, ')
          ..write('resolvedAt: $resolvedAt, ')
          ..write('detailFetched: $detailFetched')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    fetchedAt,
    serverId,
    businessServerId,
    asOn,
    kind,
    severity,
    driver,
    hasPlan,
    raisedOn,
    resolvedAt,
    detailFetched,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalRiskAlert &&
          other.fetchedAt == this.fetchedAt &&
          other.serverId == this.serverId &&
          other.businessServerId == this.businessServerId &&
          other.asOn == this.asOn &&
          other.kind == this.kind &&
          other.severity == this.severity &&
          other.driver == this.driver &&
          other.hasPlan == this.hasPlan &&
          other.raisedOn == this.raisedOn &&
          other.resolvedAt == this.resolvedAt &&
          other.detailFetched == this.detailFetched);
}

class LocalRiskAlertsCompanion extends UpdateCompanion<LocalRiskAlert> {
  final Value<DateTime> fetchedAt;
  final Value<int> serverId;
  final Value<int> businessServerId;
  final Value<DateTime> asOn;
  final Value<String> kind;
  final Value<String> severity;
  final Value<String?> driver;
  final Value<bool> hasPlan;
  final Value<DateTime> raisedOn;
  final Value<DateTime?> resolvedAt;
  final Value<bool> detailFetched;
  const LocalRiskAlertsCompanion({
    this.fetchedAt = const Value.absent(),
    this.serverId = const Value.absent(),
    this.businessServerId = const Value.absent(),
    this.asOn = const Value.absent(),
    this.kind = const Value.absent(),
    this.severity = const Value.absent(),
    this.driver = const Value.absent(),
    this.hasPlan = const Value.absent(),
    this.raisedOn = const Value.absent(),
    this.resolvedAt = const Value.absent(),
    this.detailFetched = const Value.absent(),
  });
  LocalRiskAlertsCompanion.insert({
    this.fetchedAt = const Value.absent(),
    this.serverId = const Value.absent(),
    required int businessServerId,
    required DateTime asOn,
    required String kind,
    required String severity,
    this.driver = const Value.absent(),
    this.hasPlan = const Value.absent(),
    required DateTime raisedOn,
    this.resolvedAt = const Value.absent(),
    this.detailFetched = const Value.absent(),
  }) : businessServerId = Value(businessServerId),
       asOn = Value(asOn),
       kind = Value(kind),
       severity = Value(severity),
       raisedOn = Value(raisedOn);
  static Insertable<LocalRiskAlert> custom({
    Expression<DateTime>? fetchedAt,
    Expression<int>? serverId,
    Expression<int>? businessServerId,
    Expression<DateTime>? asOn,
    Expression<String>? kind,
    Expression<String>? severity,
    Expression<String>? driver,
    Expression<bool>? hasPlan,
    Expression<DateTime>? raisedOn,
    Expression<DateTime>? resolvedAt,
    Expression<bool>? detailFetched,
  }) {
    return RawValuesInsertable({
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (serverId != null) 'server_id': serverId,
      if (businessServerId != null) 'business_server_id': businessServerId,
      if (asOn != null) 'as_on': asOn,
      if (kind != null) 'kind': kind,
      if (severity != null) 'severity': severity,
      if (driver != null) 'driver': driver,
      if (hasPlan != null) 'has_plan': hasPlan,
      if (raisedOn != null) 'raised_on': raisedOn,
      if (resolvedAt != null) 'resolved_at': resolvedAt,
      if (detailFetched != null) 'detail_fetched': detailFetched,
    });
  }

  LocalRiskAlertsCompanion copyWith({
    Value<DateTime>? fetchedAt,
    Value<int>? serverId,
    Value<int>? businessServerId,
    Value<DateTime>? asOn,
    Value<String>? kind,
    Value<String>? severity,
    Value<String?>? driver,
    Value<bool>? hasPlan,
    Value<DateTime>? raisedOn,
    Value<DateTime?>? resolvedAt,
    Value<bool>? detailFetched,
  }) {
    return LocalRiskAlertsCompanion(
      fetchedAt: fetchedAt ?? this.fetchedAt,
      serverId: serverId ?? this.serverId,
      businessServerId: businessServerId ?? this.businessServerId,
      asOn: asOn ?? this.asOn,
      kind: kind ?? this.kind,
      severity: severity ?? this.severity,
      driver: driver ?? this.driver,
      hasPlan: hasPlan ?? this.hasPlan,
      raisedOn: raisedOn ?? this.raisedOn,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      detailFetched: detailFetched ?? this.detailFetched,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (businessServerId.present) {
      map['business_server_id'] = Variable<int>(businessServerId.value);
    }
    if (asOn.present) {
      map['as_on'] = Variable<DateTime>(asOn.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(severity.value);
    }
    if (driver.present) {
      map['driver'] = Variable<String>(driver.value);
    }
    if (hasPlan.present) {
      map['has_plan'] = Variable<bool>(hasPlan.value);
    }
    if (raisedOn.present) {
      map['raised_on'] = Variable<DateTime>(raisedOn.value);
    }
    if (resolvedAt.present) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt.value);
    }
    if (detailFetched.present) {
      map['detail_fetched'] = Variable<bool>(detailFetched.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalRiskAlertsCompanion(')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('serverId: $serverId, ')
          ..write('businessServerId: $businessServerId, ')
          ..write('asOn: $asOn, ')
          ..write('kind: $kind, ')
          ..write('severity: $severity, ')
          ..write('driver: $driver, ')
          ..write('hasPlan: $hasPlan, ')
          ..write('raisedOn: $raisedOn, ')
          ..write('resolvedAt: $resolvedAt, ')
          ..write('detailFetched: $detailFetched')
          ..write(')'))
        .toString();
  }
}

class $LocalPlanActionsTable extends LocalPlanActions
    with TableInfo<$LocalPlanActionsTable, LocalPlanAction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalPlanActionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RowSyncState, String> syncState =
      GeneratedColumn<String>(
        'sync_state',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(RowSyncState.synced.name),
      ).withConverter<RowSyncState>($LocalPlanActionsTable.$convertersyncState);
  static const VerificationMeta _localUpdatedAtMeta = const VerificationMeta(
    'localUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> localUpdatedAt =
      GeneratedColumn<DateTime>(
        'local_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _alertServerIdMeta = const VerificationMeta(
    'alertServerId',
  );
  @override
  late final GeneratedColumn<int> alertServerId = GeneratedColumn<int>(
    'alert_server_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _businessServerIdMeta = const VerificationMeta(
    'businessServerId',
  );
  @override
  late final GeneratedColumn<int> businessServerId = GeneratedColumn<int>(
    'business_server_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('owner'),
  );
  static const VerificationMeta _ordinalMeta = const VerificationMeta(
    'ordinal',
  );
  @override
  late final GeneratedColumn<int> ordinal = GeneratedColumn<int>(
    'ordinal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _labelEnMeta = const VerificationMeta(
    'labelEn',
  );
  @override
  late final GeneratedColumn<String> labelEn = GeneratedColumn<String>(
    'label_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelHiMeta = const VerificationMeta(
    'labelHi',
  );
  @override
  late final GeneratedColumn<String> labelHi = GeneratedColumn<String>(
    'label_hi',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
    'done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    serverId,
    clientId,
    syncState,
    localUpdatedAt,
    alertServerId,
    businessServerId,
    role,
    ordinal,
    labelEn,
    labelHi,
    done,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_plan_actions';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalPlanAction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('local_updated_at')) {
      context.handle(
        _localUpdatedAtMeta,
        localUpdatedAt.isAcceptableOrUnknown(
          data['local_updated_at']!,
          _localUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('alert_server_id')) {
      context.handle(
        _alertServerIdMeta,
        alertServerId.isAcceptableOrUnknown(
          data['alert_server_id']!,
          _alertServerIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_alertServerIdMeta);
    }
    if (data.containsKey('business_server_id')) {
      context.handle(
        _businessServerIdMeta,
        businessServerId.isAcceptableOrUnknown(
          data['business_server_id']!,
          _businessServerIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_businessServerIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('ordinal')) {
      context.handle(
        _ordinalMeta,
        ordinal.isAcceptableOrUnknown(data['ordinal']!, _ordinalMeta),
      );
    }
    if (data.containsKey('label_en')) {
      context.handle(
        _labelEnMeta,
        labelEn.isAcceptableOrUnknown(data['label_en']!, _labelEnMeta),
      );
    } else if (isInserting) {
      context.missing(_labelEnMeta);
    }
    if (data.containsKey('label_hi')) {
      context.handle(
        _labelHiMeta,
        labelHi.isAcceptableOrUnknown(data['label_hi']!, _labelHiMeta),
      );
    }
    if (data.containsKey('done')) {
      context.handle(
        _doneMeta,
        done.isAcceptableOrUnknown(data['done']!, _doneMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  LocalPlanAction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalPlanAction(
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      syncState: $LocalPlanActionsTable.$convertersyncState.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_state'],
        )!,
      ),
      localUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}local_updated_at'],
      )!,
      alertServerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}alert_server_id'],
      )!,
      businessServerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}business_server_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      ordinal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ordinal'],
      )!,
      labelEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label_en'],
      )!,
      labelHi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label_hi'],
      ),
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}done'],
      )!,
    );
  }

  @override
  $LocalPlanActionsTable createAlias(String alias) {
    return $LocalPlanActionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RowSyncState, String, String> $convertersyncState =
      const EnumNameConverter<RowSyncState>(RowSyncState.values);
}

class LocalPlanAction extends DataClass implements Insertable<LocalPlanAction> {
  /// The backend BIGINT, once known. Null only for a create that has never
  /// reached the server.
  final int? serverId;

  /// Client-generated UUID. Stable for the lifetime of the row.
  final String clientId;

  /// Local sync state — see [RowSyncState].
  final RowSyncState syncState;

  /// When the device last touched this row. Used for ordering and for showing
  /// "saved at" on pending items.
  final DateTime localUpdatedAt;
  final int alertServerId;

  /// Denormalised so the push handler can build
  /// `/businesses/{bid}/alerts/{aid}/actions/{id}` without a join.
  final int businessServerId;

  /// `owner` | `field_officer`.
  final String role;
  final int ordinal;
  final String labelEn;
  final String? labelHi;
  final bool done;
  const LocalPlanAction({
    this.serverId,
    required this.clientId,
    required this.syncState,
    required this.localUpdatedAt,
    required this.alertServerId,
    required this.businessServerId,
    required this.role,
    required this.ordinal,
    required this.labelEn,
    this.labelHi,
    required this.done,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['client_id'] = Variable<String>(clientId);
    {
      map['sync_state'] = Variable<String>(
        $LocalPlanActionsTable.$convertersyncState.toSql(syncState),
      );
    }
    map['local_updated_at'] = Variable<DateTime>(localUpdatedAt);
    map['alert_server_id'] = Variable<int>(alertServerId);
    map['business_server_id'] = Variable<int>(businessServerId);
    map['role'] = Variable<String>(role);
    map['ordinal'] = Variable<int>(ordinal);
    map['label_en'] = Variable<String>(labelEn);
    if (!nullToAbsent || labelHi != null) {
      map['label_hi'] = Variable<String>(labelHi);
    }
    map['done'] = Variable<bool>(done);
    return map;
  }

  LocalPlanActionsCompanion toCompanion(bool nullToAbsent) {
    return LocalPlanActionsCompanion(
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      clientId: Value(clientId),
      syncState: Value(syncState),
      localUpdatedAt: Value(localUpdatedAt),
      alertServerId: Value(alertServerId),
      businessServerId: Value(businessServerId),
      role: Value(role),
      ordinal: Value(ordinal),
      labelEn: Value(labelEn),
      labelHi: labelHi == null && nullToAbsent
          ? const Value.absent()
          : Value(labelHi),
      done: Value(done),
    );
  }

  factory LocalPlanAction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalPlanAction(
      serverId: serializer.fromJson<int?>(json['serverId']),
      clientId: serializer.fromJson<String>(json['clientId']),
      syncState: $LocalPlanActionsTable.$convertersyncState.fromJson(
        serializer.fromJson<String>(json['syncState']),
      ),
      localUpdatedAt: serializer.fromJson<DateTime>(json['localUpdatedAt']),
      alertServerId: serializer.fromJson<int>(json['alertServerId']),
      businessServerId: serializer.fromJson<int>(json['businessServerId']),
      role: serializer.fromJson<String>(json['role']),
      ordinal: serializer.fromJson<int>(json['ordinal']),
      labelEn: serializer.fromJson<String>(json['labelEn']),
      labelHi: serializer.fromJson<String?>(json['labelHi']),
      done: serializer.fromJson<bool>(json['done']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'serverId': serializer.toJson<int?>(serverId),
      'clientId': serializer.toJson<String>(clientId),
      'syncState': serializer.toJson<String>(
        $LocalPlanActionsTable.$convertersyncState.toJson(syncState),
      ),
      'localUpdatedAt': serializer.toJson<DateTime>(localUpdatedAt),
      'alertServerId': serializer.toJson<int>(alertServerId),
      'businessServerId': serializer.toJson<int>(businessServerId),
      'role': serializer.toJson<String>(role),
      'ordinal': serializer.toJson<int>(ordinal),
      'labelEn': serializer.toJson<String>(labelEn),
      'labelHi': serializer.toJson<String?>(labelHi),
      'done': serializer.toJson<bool>(done),
    };
  }

  LocalPlanAction copyWith({
    Value<int?> serverId = const Value.absent(),
    String? clientId,
    RowSyncState? syncState,
    DateTime? localUpdatedAt,
    int? alertServerId,
    int? businessServerId,
    String? role,
    int? ordinal,
    String? labelEn,
    Value<String?> labelHi = const Value.absent(),
    bool? done,
  }) => LocalPlanAction(
    serverId: serverId.present ? serverId.value : this.serverId,
    clientId: clientId ?? this.clientId,
    syncState: syncState ?? this.syncState,
    localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
    alertServerId: alertServerId ?? this.alertServerId,
    businessServerId: businessServerId ?? this.businessServerId,
    role: role ?? this.role,
    ordinal: ordinal ?? this.ordinal,
    labelEn: labelEn ?? this.labelEn,
    labelHi: labelHi.present ? labelHi.value : this.labelHi,
    done: done ?? this.done,
  );
  LocalPlanAction copyWithCompanion(LocalPlanActionsCompanion data) {
    return LocalPlanAction(
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      localUpdatedAt: data.localUpdatedAt.present
          ? data.localUpdatedAt.value
          : this.localUpdatedAt,
      alertServerId: data.alertServerId.present
          ? data.alertServerId.value
          : this.alertServerId,
      businessServerId: data.businessServerId.present
          ? data.businessServerId.value
          : this.businessServerId,
      role: data.role.present ? data.role.value : this.role,
      ordinal: data.ordinal.present ? data.ordinal.value : this.ordinal,
      labelEn: data.labelEn.present ? data.labelEn.value : this.labelEn,
      labelHi: data.labelHi.present ? data.labelHi.value : this.labelHi,
      done: data.done.present ? data.done.value : this.done,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalPlanAction(')
          ..write('serverId: $serverId, ')
          ..write('clientId: $clientId, ')
          ..write('syncState: $syncState, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('alertServerId: $alertServerId, ')
          ..write('businessServerId: $businessServerId, ')
          ..write('role: $role, ')
          ..write('ordinal: $ordinal, ')
          ..write('labelEn: $labelEn, ')
          ..write('labelHi: $labelHi, ')
          ..write('done: $done')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    serverId,
    clientId,
    syncState,
    localUpdatedAt,
    alertServerId,
    businessServerId,
    role,
    ordinal,
    labelEn,
    labelHi,
    done,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalPlanAction &&
          other.serverId == this.serverId &&
          other.clientId == this.clientId &&
          other.syncState == this.syncState &&
          other.localUpdatedAt == this.localUpdatedAt &&
          other.alertServerId == this.alertServerId &&
          other.businessServerId == this.businessServerId &&
          other.role == this.role &&
          other.ordinal == this.ordinal &&
          other.labelEn == this.labelEn &&
          other.labelHi == this.labelHi &&
          other.done == this.done);
}

class LocalPlanActionsCompanion extends UpdateCompanion<LocalPlanAction> {
  final Value<int?> serverId;
  final Value<String> clientId;
  final Value<RowSyncState> syncState;
  final Value<DateTime> localUpdatedAt;
  final Value<int> alertServerId;
  final Value<int> businessServerId;
  final Value<String> role;
  final Value<int> ordinal;
  final Value<String> labelEn;
  final Value<String?> labelHi;
  final Value<bool> done;
  final Value<int> rowid;
  const LocalPlanActionsCompanion({
    this.serverId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.syncState = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.alertServerId = const Value.absent(),
    this.businessServerId = const Value.absent(),
    this.role = const Value.absent(),
    this.ordinal = const Value.absent(),
    this.labelEn = const Value.absent(),
    this.labelHi = const Value.absent(),
    this.done = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalPlanActionsCompanion.insert({
    this.serverId = const Value.absent(),
    required String clientId,
    this.syncState = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    required int alertServerId,
    required int businessServerId,
    this.role = const Value.absent(),
    this.ordinal = const Value.absent(),
    required String labelEn,
    this.labelHi = const Value.absent(),
    this.done = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : clientId = Value(clientId),
       alertServerId = Value(alertServerId),
       businessServerId = Value(businessServerId),
       labelEn = Value(labelEn);
  static Insertable<LocalPlanAction> custom({
    Expression<int>? serverId,
    Expression<String>? clientId,
    Expression<String>? syncState,
    Expression<DateTime>? localUpdatedAt,
    Expression<int>? alertServerId,
    Expression<int>? businessServerId,
    Expression<String>? role,
    Expression<int>? ordinal,
    Expression<String>? labelEn,
    Expression<String>? labelHi,
    Expression<bool>? done,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (serverId != null) 'server_id': serverId,
      if (clientId != null) 'client_id': clientId,
      if (syncState != null) 'sync_state': syncState,
      if (localUpdatedAt != null) 'local_updated_at': localUpdatedAt,
      if (alertServerId != null) 'alert_server_id': alertServerId,
      if (businessServerId != null) 'business_server_id': businessServerId,
      if (role != null) 'role': role,
      if (ordinal != null) 'ordinal': ordinal,
      if (labelEn != null) 'label_en': labelEn,
      if (labelHi != null) 'label_hi': labelHi,
      if (done != null) 'done': done,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalPlanActionsCompanion copyWith({
    Value<int?>? serverId,
    Value<String>? clientId,
    Value<RowSyncState>? syncState,
    Value<DateTime>? localUpdatedAt,
    Value<int>? alertServerId,
    Value<int>? businessServerId,
    Value<String>? role,
    Value<int>? ordinal,
    Value<String>? labelEn,
    Value<String?>? labelHi,
    Value<bool>? done,
    Value<int>? rowid,
  }) {
    return LocalPlanActionsCompanion(
      serverId: serverId ?? this.serverId,
      clientId: clientId ?? this.clientId,
      syncState: syncState ?? this.syncState,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      alertServerId: alertServerId ?? this.alertServerId,
      businessServerId: businessServerId ?? this.businessServerId,
      role: role ?? this.role,
      ordinal: ordinal ?? this.ordinal,
      labelEn: labelEn ?? this.labelEn,
      labelHi: labelHi ?? this.labelHi,
      done: done ?? this.done,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(
        $LocalPlanActionsTable.$convertersyncState.toSql(syncState.value),
      );
    }
    if (localUpdatedAt.present) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt.value);
    }
    if (alertServerId.present) {
      map['alert_server_id'] = Variable<int>(alertServerId.value);
    }
    if (businessServerId.present) {
      map['business_server_id'] = Variable<int>(businessServerId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (ordinal.present) {
      map['ordinal'] = Variable<int>(ordinal.value);
    }
    if (labelEn.present) {
      map['label_en'] = Variable<String>(labelEn.value);
    }
    if (labelHi.present) {
      map['label_hi'] = Variable<String>(labelHi.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalPlanActionsCompanion(')
          ..write('serverId: $serverId, ')
          ..write('clientId: $clientId, ')
          ..write('syncState: $syncState, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('alertServerId: $alertServerId, ')
          ..write('businessServerId: $businessServerId, ')
          ..write('role: $role, ')
          ..write('ordinal: $ordinal, ')
          ..write('labelEn: $labelEn, ')
          ..write('labelHi: $labelHi, ')
          ..write('done: $done, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalStatesTable extends LocalStates
    with TableInfo<$LocalStatesTable, LocalState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameHiMeta = const VerificationMeta('nameHi');
  @override
  late final GeneratedColumn<String> nameHi = GeneratedColumn<String>(
    'name_hi',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [fetchedAt, code, nameEn, nameHi];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('name_hi')) {
      context.handle(
        _nameHiMeta,
        nameHi.isAcceptableOrUnknown(data['name_hi']!, _nameHiMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  LocalState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalState(
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
      nameHi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_hi'],
      ),
    );
  }

  @override
  $LocalStatesTable createAlias(String alias) {
    return $LocalStatesTable(attachedDatabase, alias);
  }
}

class LocalState extends DataClass implements Insertable<LocalState> {
  /// When this row was last pulled from the backend. Drives the "showing saved
  /// data from X" line on the offline home.
  final DateTime fetchedAt;

  /// Two-letter code, e.g. `AP`. Matches the backend's `code`.
  final String code;
  final String nameEn;
  final String? nameHi;
  const LocalState({
    required this.fetchedAt,
    required this.code,
    required this.nameEn,
    this.nameHi,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    map['code'] = Variable<String>(code);
    map['name_en'] = Variable<String>(nameEn);
    if (!nullToAbsent || nameHi != null) {
      map['name_hi'] = Variable<String>(nameHi);
    }
    return map;
  }

  LocalStatesCompanion toCompanion(bool nullToAbsent) {
    return LocalStatesCompanion(
      fetchedAt: Value(fetchedAt),
      code: Value(code),
      nameEn: Value(nameEn),
      nameHi: nameHi == null && nullToAbsent
          ? const Value.absent()
          : Value(nameHi),
    );
  }

  factory LocalState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalState(
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
      code: serializer.fromJson<String>(json['code']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      nameHi: serializer.fromJson<String?>(json['nameHi']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
      'code': serializer.toJson<String>(code),
      'nameEn': serializer.toJson<String>(nameEn),
      'nameHi': serializer.toJson<String?>(nameHi),
    };
  }

  LocalState copyWith({
    DateTime? fetchedAt,
    String? code,
    String? nameEn,
    Value<String?> nameHi = const Value.absent(),
  }) => LocalState(
    fetchedAt: fetchedAt ?? this.fetchedAt,
    code: code ?? this.code,
    nameEn: nameEn ?? this.nameEn,
    nameHi: nameHi.present ? nameHi.value : this.nameHi,
  );
  LocalState copyWithCompanion(LocalStatesCompanion data) {
    return LocalState(
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      code: data.code.present ? data.code.value : this.code,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      nameHi: data.nameHi.present ? data.nameHi.value : this.nameHi,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalState(')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('code: $code, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameHi: $nameHi')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(fetchedAt, code, nameEn, nameHi);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalState &&
          other.fetchedAt == this.fetchedAt &&
          other.code == this.code &&
          other.nameEn == this.nameEn &&
          other.nameHi == this.nameHi);
}

class LocalStatesCompanion extends UpdateCompanion<LocalState> {
  final Value<DateTime> fetchedAt;
  final Value<String> code;
  final Value<String> nameEn;
  final Value<String?> nameHi;
  final Value<int> rowid;
  const LocalStatesCompanion({
    this.fetchedAt = const Value.absent(),
    this.code = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.nameHi = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalStatesCompanion.insert({
    this.fetchedAt = const Value.absent(),
    required String code,
    required String nameEn,
    this.nameHi = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : code = Value(code),
       nameEn = Value(nameEn);
  static Insertable<LocalState> custom({
    Expression<DateTime>? fetchedAt,
    Expression<String>? code,
    Expression<String>? nameEn,
    Expression<String>? nameHi,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (code != null) 'code': code,
      if (nameEn != null) 'name_en': nameEn,
      if (nameHi != null) 'name_hi': nameHi,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalStatesCompanion copyWith({
    Value<DateTime>? fetchedAt,
    Value<String>? code,
    Value<String>? nameEn,
    Value<String?>? nameHi,
    Value<int>? rowid,
  }) {
    return LocalStatesCompanion(
      fetchedAt: fetchedAt ?? this.fetchedAt,
      code: code ?? this.code,
      nameEn: nameEn ?? this.nameEn,
      nameHi: nameHi ?? this.nameHi,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (nameHi.present) {
      map['name_hi'] = Variable<String>(nameHi.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalStatesCompanion(')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('code: $code, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameHi: $nameHi, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalDistrictsTable extends LocalDistricts
    with TableInfo<$LocalDistrictsTable, LocalDistrict> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalDistrictsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _stateCodeMeta = const VerificationMeta(
    'stateCode',
  );
  @override
  late final GeneratedColumn<String> stateCode = GeneratedColumn<String>(
    'state_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [fetchedAt, stateCode, nameEn];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_districts';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalDistrict> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    }
    if (data.containsKey('state_code')) {
      context.handle(
        _stateCodeMeta,
        stateCode.isAcceptableOrUnknown(data['state_code']!, _stateCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_stateCodeMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {stateCode, nameEn};
  @override
  LocalDistrict map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalDistrict(
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
      stateCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state_code'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
    );
  }

  @override
  $LocalDistrictsTable createAlias(String alias) {
    return $LocalDistrictsTable(attachedDatabase, alias);
  }
}

class LocalDistrict extends DataClass implements Insertable<LocalDistrict> {
  /// When this row was last pulled from the backend. Drives the "showing saved
  /// data from X" line on the offline home.
  final DateTime fetchedAt;
  final String stateCode;
  final String nameEn;
  const LocalDistrict({
    required this.fetchedAt,
    required this.stateCode,
    required this.nameEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    map['state_code'] = Variable<String>(stateCode);
    map['name_en'] = Variable<String>(nameEn);
    return map;
  }

  LocalDistrictsCompanion toCompanion(bool nullToAbsent) {
    return LocalDistrictsCompanion(
      fetchedAt: Value(fetchedAt),
      stateCode: Value(stateCode),
      nameEn: Value(nameEn),
    );
  }

  factory LocalDistrict.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalDistrict(
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
      stateCode: serializer.fromJson<String>(json['stateCode']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
      'stateCode': serializer.toJson<String>(stateCode),
      'nameEn': serializer.toJson<String>(nameEn),
    };
  }

  LocalDistrict copyWith({
    DateTime? fetchedAt,
    String? stateCode,
    String? nameEn,
  }) => LocalDistrict(
    fetchedAt: fetchedAt ?? this.fetchedAt,
    stateCode: stateCode ?? this.stateCode,
    nameEn: nameEn ?? this.nameEn,
  );
  LocalDistrict copyWithCompanion(LocalDistrictsCompanion data) {
    return LocalDistrict(
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      stateCode: data.stateCode.present ? data.stateCode.value : this.stateCode,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalDistrict(')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('stateCode: $stateCode, ')
          ..write('nameEn: $nameEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(fetchedAt, stateCode, nameEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalDistrict &&
          other.fetchedAt == this.fetchedAt &&
          other.stateCode == this.stateCode &&
          other.nameEn == this.nameEn);
}

class LocalDistrictsCompanion extends UpdateCompanion<LocalDistrict> {
  final Value<DateTime> fetchedAt;
  final Value<String> stateCode;
  final Value<String> nameEn;
  final Value<int> rowid;
  const LocalDistrictsCompanion({
    this.fetchedAt = const Value.absent(),
    this.stateCode = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalDistrictsCompanion.insert({
    this.fetchedAt = const Value.absent(),
    required String stateCode,
    required String nameEn,
    this.rowid = const Value.absent(),
  }) : stateCode = Value(stateCode),
       nameEn = Value(nameEn);
  static Insertable<LocalDistrict> custom({
    Expression<DateTime>? fetchedAt,
    Expression<String>? stateCode,
    Expression<String>? nameEn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (stateCode != null) 'state_code': stateCode,
      if (nameEn != null) 'name_en': nameEn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalDistrictsCompanion copyWith({
    Value<DateTime>? fetchedAt,
    Value<String>? stateCode,
    Value<String>? nameEn,
    Value<int>? rowid,
  }) {
    return LocalDistrictsCompanion(
      fetchedAt: fetchedAt ?? this.fetchedAt,
      stateCode: stateCode ?? this.stateCode,
      nameEn: nameEn ?? this.nameEn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (stateCode.present) {
      map['state_code'] = Variable<String>(stateCode.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalDistrictsCompanion(')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('stateCode: $stateCode, ')
          ..write('nameEn: $nameEn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncOpsTable extends SyncOps with TableInfo<$SyncOpsTable, SyncOpRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOpsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncEntity, String> entity =
      GeneratedColumn<String>(
        'entity',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SyncEntity>($SyncOpsTable.$converterentity);
  @override
  late final GeneratedColumnWithTypeConverter<SyncOpKind, String> op =
      GeneratedColumn<String>(
        'op',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SyncOpKind>($SyncOpsTable.$converterop);
  static const VerificationMeta _localRowIdMeta = const VerificationMeta(
    'localRowId',
  );
  @override
  late final GeneratedColumn<String> localRowId = GeneratedColumn<String>(
    'local_row_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _businessServerIdMeta = const VerificationMeta(
    'businessServerId',
  );
  @override
  late final GeneratedColumn<int> businessServerId = GeneratedColumn<int>(
    'business_server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _dedupeKeyMeta = const VerificationMeta(
    'dedupeKey',
  );
  @override
  late final GeneratedColumn<String> dedupeKey = GeneratedColumn<String>(
    'dedupe_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextAttemptAtMeta = const VerificationMeta(
    'nextAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextAttemptAt =
      GeneratedColumn<DateTime>(
        'next_attempt_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _deadLetteredMeta = const VerificationMeta(
    'deadLettered',
  );
  @override
  late final GeneratedColumn<bool> deadLettered = GeneratedColumn<bool>(
    'dead_lettered',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dead_lettered" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entity,
    op,
    localRowId,
    serverId,
    businessServerId,
    payload,
    dedupeKey,
    revision,
    attempts,
    lastError,
    nextAttemptAt,
    deadLettered,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_ops';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncOpRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('local_row_id')) {
      context.handle(
        _localRowIdMeta,
        localRowId.isAcceptableOrUnknown(
          data['local_row_id']!,
          _localRowIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localRowIdMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('business_server_id')) {
      context.handle(
        _businessServerIdMeta,
        businessServerId.isAcceptableOrUnknown(
          data['business_server_id']!,
          _businessServerIdMeta,
        ),
      );
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    }
    if (data.containsKey('dedupe_key')) {
      context.handle(
        _dedupeKeyMeta,
        dedupeKey.isAcceptableOrUnknown(data['dedupe_key']!, _dedupeKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dedupeKeyMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('next_attempt_at')) {
      context.handle(
        _nextAttemptAtMeta,
        nextAttemptAt.isAcceptableOrUnknown(
          data['next_attempt_at']!,
          _nextAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('dead_lettered')) {
      context.handle(
        _deadLetteredMeta,
        deadLettered.isAcceptableOrUnknown(
          data['dead_lettered']!,
          _deadLetteredMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncOpRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOpRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entity: $SyncOpsTable.$converterentity.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}entity'],
        )!,
      ),
      op: $SyncOpsTable.$converterop.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}op'],
        )!,
      ),
      localRowId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_row_id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
      businessServerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}business_server_id'],
      ),
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      dedupeKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dedupe_key'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      nextAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_attempt_at'],
      )!,
      deadLettered: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dead_lettered'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SyncOpsTable createAlias(String alias) {
    return $SyncOpsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncEntity, String, String> $converterentity =
      const EnumNameConverter<SyncEntity>(SyncEntity.values);
  static JsonTypeConverter2<SyncOpKind, String, String> $converterop =
      const EnumNameConverter<SyncOpKind>(SyncOpKind.values);
}

class SyncOpRow extends DataClass implements Insertable<SyncOpRow> {
  final int id;

  /// Which record type this op targets.
  final SyncEntity entity;

  /// Create, update or delete.
  final SyncOpKind op;

  /// The [SyncableRow.clientId] of the row this op will send. The push handler
  /// re-reads the row at drain time rather than trusting [payload] alone, so a
  /// coalesced op always sends current values.
  final String localRowId;

  /// Backend id, when known at enqueue time. Ledger creates leave this null and
  /// have it filled in by the id-resolution pass after the batch lands.
  final int? serverId;

  /// Scoping id for endpoints nested under a business.
  final int? businessServerId;

  /// JSON request body. Merged in place when an op is coalesced.
  final String payload;

  /// `entity:op:localRowId`. Two ops sharing a key collapse into one instead of
  /// queueing a redundant round trip.
  final String dedupeKey;

  /// Bumped every time this op is coalesced with a newer write.
  ///
  /// Guards against losing an edit made while the op is mid-flight: the engine
  /// captures the revision when it claims the op and deletes on success only if
  /// it still matches. If the user edited the row while the request was in the
  /// air, the delete matches nothing and the newer payload survives for the
  /// next cycle instead of being acknowledged away.
  final int revision;
  final int attempts;

  /// Last failure message, kept for the Sync screen's failed section.
  final String? lastError;

  /// Backoff gate — the engine skips ops scheduled for the future.
  final DateTime nextAttemptAt;

  /// Set once the op has exhausted its retries. Dead ops stay on disk so the
  /// user can see what failed, but the engine stops trying.
  final bool deadLettered;
  final DateTime createdAt;
  const SyncOpRow({
    required this.id,
    required this.entity,
    required this.op,
    required this.localRowId,
    this.serverId,
    this.businessServerId,
    required this.payload,
    required this.dedupeKey,
    required this.revision,
    required this.attempts,
    this.lastError,
    required this.nextAttemptAt,
    required this.deadLettered,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['entity'] = Variable<String>(
        $SyncOpsTable.$converterentity.toSql(entity),
      );
    }
    {
      map['op'] = Variable<String>($SyncOpsTable.$converterop.toSql(op));
    }
    map['local_row_id'] = Variable<String>(localRowId);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    if (!nullToAbsent || businessServerId != null) {
      map['business_server_id'] = Variable<int>(businessServerId);
    }
    map['payload'] = Variable<String>(payload);
    map['dedupe_key'] = Variable<String>(dedupeKey);
    map['revision'] = Variable<int>(revision);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt);
    map['dead_lettered'] = Variable<bool>(deadLettered);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SyncOpsCompanion toCompanion(bool nullToAbsent) {
    return SyncOpsCompanion(
      id: Value(id),
      entity: Value(entity),
      op: Value(op),
      localRowId: Value(localRowId),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      businessServerId: businessServerId == null && nullToAbsent
          ? const Value.absent()
          : Value(businessServerId),
      payload: Value(payload),
      dedupeKey: Value(dedupeKey),
      revision: Value(revision),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      nextAttemptAt: Value(nextAttemptAt),
      deadLettered: Value(deadLettered),
      createdAt: Value(createdAt),
    );
  }

  factory SyncOpRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncOpRow(
      id: serializer.fromJson<int>(json['id']),
      entity: $SyncOpsTable.$converterentity.fromJson(
        serializer.fromJson<String>(json['entity']),
      ),
      op: $SyncOpsTable.$converterop.fromJson(
        serializer.fromJson<String>(json['op']),
      ),
      localRowId: serializer.fromJson<String>(json['localRowId']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      businessServerId: serializer.fromJson<int?>(json['businessServerId']),
      payload: serializer.fromJson<String>(json['payload']),
      dedupeKey: serializer.fromJson<String>(json['dedupeKey']),
      revision: serializer.fromJson<int>(json['revision']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      nextAttemptAt: serializer.fromJson<DateTime>(json['nextAttemptAt']),
      deadLettered: serializer.fromJson<bool>(json['deadLettered']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entity': serializer.toJson<String>(
        $SyncOpsTable.$converterentity.toJson(entity),
      ),
      'op': serializer.toJson<String>($SyncOpsTable.$converterop.toJson(op)),
      'localRowId': serializer.toJson<String>(localRowId),
      'serverId': serializer.toJson<int?>(serverId),
      'businessServerId': serializer.toJson<int?>(businessServerId),
      'payload': serializer.toJson<String>(payload),
      'dedupeKey': serializer.toJson<String>(dedupeKey),
      'revision': serializer.toJson<int>(revision),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
      'nextAttemptAt': serializer.toJson<DateTime>(nextAttemptAt),
      'deadLettered': serializer.toJson<bool>(deadLettered),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SyncOpRow copyWith({
    int? id,
    SyncEntity? entity,
    SyncOpKind? op,
    String? localRowId,
    Value<int?> serverId = const Value.absent(),
    Value<int?> businessServerId = const Value.absent(),
    String? payload,
    String? dedupeKey,
    int? revision,
    int? attempts,
    Value<String?> lastError = const Value.absent(),
    DateTime? nextAttemptAt,
    bool? deadLettered,
    DateTime? createdAt,
  }) => SyncOpRow(
    id: id ?? this.id,
    entity: entity ?? this.entity,
    op: op ?? this.op,
    localRowId: localRowId ?? this.localRowId,
    serverId: serverId.present ? serverId.value : this.serverId,
    businessServerId: businessServerId.present
        ? businessServerId.value
        : this.businessServerId,
    payload: payload ?? this.payload,
    dedupeKey: dedupeKey ?? this.dedupeKey,
    revision: revision ?? this.revision,
    attempts: attempts ?? this.attempts,
    lastError: lastError.present ? lastError.value : this.lastError,
    nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
    deadLettered: deadLettered ?? this.deadLettered,
    createdAt: createdAt ?? this.createdAt,
  );
  SyncOpRow copyWithCompanion(SyncOpsCompanion data) {
    return SyncOpRow(
      id: data.id.present ? data.id.value : this.id,
      entity: data.entity.present ? data.entity.value : this.entity,
      op: data.op.present ? data.op.value : this.op,
      localRowId: data.localRowId.present
          ? data.localRowId.value
          : this.localRowId,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      businessServerId: data.businessServerId.present
          ? data.businessServerId.value
          : this.businessServerId,
      payload: data.payload.present ? data.payload.value : this.payload,
      dedupeKey: data.dedupeKey.present ? data.dedupeKey.value : this.dedupeKey,
      revision: data.revision.present ? data.revision.value : this.revision,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
      deadLettered: data.deadLettered.present
          ? data.deadLettered.value
          : this.deadLettered,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncOpRow(')
          ..write('id: $id, ')
          ..write('entity: $entity, ')
          ..write('op: $op, ')
          ..write('localRowId: $localRowId, ')
          ..write('serverId: $serverId, ')
          ..write('businessServerId: $businessServerId, ')
          ..write('payload: $payload, ')
          ..write('dedupeKey: $dedupeKey, ')
          ..write('revision: $revision, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('deadLettered: $deadLettered, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entity,
    op,
    localRowId,
    serverId,
    businessServerId,
    payload,
    dedupeKey,
    revision,
    attempts,
    lastError,
    nextAttemptAt,
    deadLettered,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncOpRow &&
          other.id == this.id &&
          other.entity == this.entity &&
          other.op == this.op &&
          other.localRowId == this.localRowId &&
          other.serverId == this.serverId &&
          other.businessServerId == this.businessServerId &&
          other.payload == this.payload &&
          other.dedupeKey == this.dedupeKey &&
          other.revision == this.revision &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError &&
          other.nextAttemptAt == this.nextAttemptAt &&
          other.deadLettered == this.deadLettered &&
          other.createdAt == this.createdAt);
}

class SyncOpsCompanion extends UpdateCompanion<SyncOpRow> {
  final Value<int> id;
  final Value<SyncEntity> entity;
  final Value<SyncOpKind> op;
  final Value<String> localRowId;
  final Value<int?> serverId;
  final Value<int?> businessServerId;
  final Value<String> payload;
  final Value<String> dedupeKey;
  final Value<int> revision;
  final Value<int> attempts;
  final Value<String?> lastError;
  final Value<DateTime> nextAttemptAt;
  final Value<bool> deadLettered;
  final Value<DateTime> createdAt;
  const SyncOpsCompanion({
    this.id = const Value.absent(),
    this.entity = const Value.absent(),
    this.op = const Value.absent(),
    this.localRowId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.businessServerId = const Value.absent(),
    this.payload = const Value.absent(),
    this.dedupeKey = const Value.absent(),
    this.revision = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.deadLettered = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SyncOpsCompanion.insert({
    this.id = const Value.absent(),
    required SyncEntity entity,
    required SyncOpKind op,
    required String localRowId,
    this.serverId = const Value.absent(),
    this.businessServerId = const Value.absent(),
    this.payload = const Value.absent(),
    required String dedupeKey,
    this.revision = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.deadLettered = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : entity = Value(entity),
       op = Value(op),
       localRowId = Value(localRowId),
       dedupeKey = Value(dedupeKey);
  static Insertable<SyncOpRow> custom({
    Expression<int>? id,
    Expression<String>? entity,
    Expression<String>? op,
    Expression<String>? localRowId,
    Expression<int>? serverId,
    Expression<int>? businessServerId,
    Expression<String>? payload,
    Expression<String>? dedupeKey,
    Expression<int>? revision,
    Expression<int>? attempts,
    Expression<String>? lastError,
    Expression<DateTime>? nextAttemptAt,
    Expression<bool>? deadLettered,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entity != null) 'entity': entity,
      if (op != null) 'op': op,
      if (localRowId != null) 'local_row_id': localRowId,
      if (serverId != null) 'server_id': serverId,
      if (businessServerId != null) 'business_server_id': businessServerId,
      if (payload != null) 'payload': payload,
      if (dedupeKey != null) 'dedupe_key': dedupeKey,
      if (revision != null) 'revision': revision,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (deadLettered != null) 'dead_lettered': deadLettered,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SyncOpsCompanion copyWith({
    Value<int>? id,
    Value<SyncEntity>? entity,
    Value<SyncOpKind>? op,
    Value<String>? localRowId,
    Value<int?>? serverId,
    Value<int?>? businessServerId,
    Value<String>? payload,
    Value<String>? dedupeKey,
    Value<int>? revision,
    Value<int>? attempts,
    Value<String?>? lastError,
    Value<DateTime>? nextAttemptAt,
    Value<bool>? deadLettered,
    Value<DateTime>? createdAt,
  }) {
    return SyncOpsCompanion(
      id: id ?? this.id,
      entity: entity ?? this.entity,
      op: op ?? this.op,
      localRowId: localRowId ?? this.localRowId,
      serverId: serverId ?? this.serverId,
      businessServerId: businessServerId ?? this.businessServerId,
      payload: payload ?? this.payload,
      dedupeKey: dedupeKey ?? this.dedupeKey,
      revision: revision ?? this.revision,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      deadLettered: deadLettered ?? this.deadLettered,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entity.present) {
      map['entity'] = Variable<String>(
        $SyncOpsTable.$converterentity.toSql(entity.value),
      );
    }
    if (op.present) {
      map['op'] = Variable<String>($SyncOpsTable.$converterop.toSql(op.value));
    }
    if (localRowId.present) {
      map['local_row_id'] = Variable<String>(localRowId.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (businessServerId.present) {
      map['business_server_id'] = Variable<int>(businessServerId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (dedupeKey.present) {
      map['dedupe_key'] = Variable<String>(dedupeKey.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt.value);
    }
    if (deadLettered.present) {
      map['dead_lettered'] = Variable<bool>(deadLettered.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOpsCompanion(')
          ..write('id: $id, ')
          ..write('entity: $entity, ')
          ..write('op: $op, ')
          ..write('localRowId: $localRowId, ')
          ..write('serverId: $serverId, ')
          ..write('businessServerId: $businessServerId, ')
          ..write('payload: $payload, ')
          ..write('dedupeKey: $dedupeKey, ')
          ..write('revision: $revision, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('deadLettered: $deadLettered, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SyncMetaTable extends SyncMeta
    with TableInfo<$SyncMetaTable, SyncMetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncMetaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SyncMetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetaData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SyncMetaTable createAlias(String alias) {
    return $SyncMetaTable(attachedDatabase, alias);
  }
}

class SyncMetaData extends DataClass implements Insertable<SyncMetaData> {
  final String key;
  final String? value;
  final DateTime updatedAt;
  const SyncMetaData({required this.key, this.value, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SyncMetaCompanion toCompanion(bool nullToAbsent) {
    return SyncMetaCompanion(
      key: Value(key),
      value: value == null && nullToAbsent
          ? const Value.absent()
          : Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncMetaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetaData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String?>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String?>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SyncMetaData copyWith({
    String? key,
    Value<String?> value = const Value.absent(),
    DateTime? updatedAt,
  }) => SyncMetaData(
    key: key ?? this.key,
    value: value.present ? value.value : this.value,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SyncMetaData copyWithCompanion(SyncMetaCompanion data) {
    return SyncMetaData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetaData(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetaData &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class SyncMetaCompanion extends UpdateCompanion<SyncMetaData> {
  final Value<String> key;
  final Value<String?> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SyncMetaCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetaCompanion.insert({
    required String key,
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key);
  static Insertable<SyncMetaData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetaCompanion copyWith({
    Value<String>? key,
    Value<String?>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SyncMetaCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetaCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalUsersTable localUsers = $LocalUsersTable(this);
  late final $LocalBusinessesTable localBusinesses = $LocalBusinessesTable(
    this,
  );
  late final $LocalMonthlySnapshotsTable localMonthlySnapshots =
      $LocalMonthlySnapshotsTable(this);
  late final $LocalLedgerEntriesTable localLedgerEntries =
      $LocalLedgerEntriesTable(this);
  late final $LocalHealthScoresTable localHealthScores =
      $LocalHealthScoresTable(this);
  late final $LocalForecastsTable localForecasts = $LocalForecastsTable(this);
  late final $LocalRiskAlertsTable localRiskAlerts = $LocalRiskAlertsTable(
    this,
  );
  late final $LocalPlanActionsTable localPlanActions = $LocalPlanActionsTable(
    this,
  );
  late final $LocalStatesTable localStates = $LocalStatesTable(this);
  late final $LocalDistrictsTable localDistricts = $LocalDistrictsTable(this);
  late final $SyncOpsTable syncOps = $SyncOpsTable(this);
  late final $SyncMetaTable syncMeta = $SyncMetaTable(this);
  late final Index idxBusinessOwner = Index(
    'idx_business_owner',
    'CREATE INDEX idx_business_owner ON local_businesses (owner_user_id, sort_order)',
  );
  late final Index idxBusinessServerId = Index(
    'idx_business_server_id',
    'CREATE INDEX idx_business_server_id ON local_businesses (server_id)',
  );
  late final Index idxLedgerBusinessRecorded = Index(
    'idx_ledger_business_recorded',
    'CREATE INDEX idx_ledger_business_recorded ON local_ledger_entries (business_server_id, recorded_at)',
  );
  late final Index idxLedgerServerId = Index(
    'idx_ledger_server_id',
    'CREATE INDEX idx_ledger_server_id ON local_ledger_entries (server_id)',
  );
  late final Index idxLedgerSyncState = Index(
    'idx_ledger_sync_state',
    'CREATE INDEX idx_ledger_sync_state ON local_ledger_entries (sync_state)',
  );
  late final Index idxHealthBusiness = Index(
    'idx_health_business',
    'CREATE INDEX idx_health_business ON local_health_scores (business_server_id, as_on)',
  );
  late final Index idxAlertBusiness = Index(
    'idx_alert_business',
    'CREATE INDEX idx_alert_business ON local_risk_alerts (business_server_id, raised_on)',
  );
  late final Index idxPlanActionAlert = Index(
    'idx_plan_action_alert',
    'CREATE INDEX idx_plan_action_alert ON local_plan_actions (alert_server_id, ordinal)',
  );
  late final Index idxPlanActionServerId = Index(
    'idx_plan_action_server_id',
    'CREATE INDEX idx_plan_action_server_id ON local_plan_actions (server_id)',
  );
  late final Index idxSyncOpsDedupe = Index(
    'idx_sync_ops_dedupe',
    'CREATE INDEX idx_sync_ops_dedupe ON sync_ops (dedupe_key)',
  );
  late final Index idxSyncOpsReady = Index(
    'idx_sync_ops_ready',
    'CREATE INDEX idx_sync_ops_ready ON sync_ops (dead_lettered, next_attempt_at)',
  );
  late final Index idxSyncOpsRow = Index(
    'idx_sync_ops_row',
    'CREATE INDEX idx_sync_ops_row ON sync_ops (entity, local_row_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localUsers,
    localBusinesses,
    localMonthlySnapshots,
    localLedgerEntries,
    localHealthScores,
    localForecasts,
    localRiskAlerts,
    localPlanActions,
    localStates,
    localDistricts,
    syncOps,
    syncMeta,
    idxBusinessOwner,
    idxBusinessServerId,
    idxLedgerBusinessRecorded,
    idxLedgerServerId,
    idxLedgerSyncState,
    idxHealthBusiness,
    idxAlertBusiness,
    idxPlanActionAlert,
    idxPlanActionServerId,
    idxSyncOpsDedupe,
    idxSyncOpsReady,
    idxSyncOpsRow,
  ];
}

typedef $$LocalUsersTableCreateCompanionBuilder =
    LocalUsersCompanion Function({
      Value<int?> serverId,
      required String clientId,
      Value<RowSyncState> syncState,
      Value<DateTime> localUpdatedAt,
      Value<String?> firebaseUid,
      Value<String?> phoneE164,
      Value<String?> name,
      Value<String> language,
      Value<String?> state,
      Value<String?> district,
      Value<String?> village,
      Value<int> savingsInr,
      Value<int> loanInr,
      Value<bool> notificationsEnabled,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$LocalUsersTableUpdateCompanionBuilder =
    LocalUsersCompanion Function({
      Value<int?> serverId,
      Value<String> clientId,
      Value<RowSyncState> syncState,
      Value<DateTime> localUpdatedAt,
      Value<String?> firebaseUid,
      Value<String?> phoneE164,
      Value<String?> name,
      Value<String> language,
      Value<String?> state,
      Value<String?> district,
      Value<String?> village,
      Value<int> savingsInr,
      Value<int> loanInr,
      Value<bool> notificationsEnabled,
      Value<bool> isActive,
      Value<int> rowid,
    });

class $$LocalUsersTableFilterComposer
    extends Composer<_$AppDatabase, $LocalUsersTable> {
  $$LocalUsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RowSyncState, RowSyncState, String>
  get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get localUpdatedAt => $composableBuilder(
    column: $table.localUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firebaseUid => $composableBuilder(
    column: $table.firebaseUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneE164 => $composableBuilder(
    column: $table.phoneE164,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get district => $composableBuilder(
    column: $table.district,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get village => $composableBuilder(
    column: $table.village,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get savingsInr => $composableBuilder(
    column: $table.savingsInr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get loanInr => $composableBuilder(
    column: $table.loanInr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalUsersTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalUsersTable> {
  $$LocalUsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get localUpdatedAt => $composableBuilder(
    column: $table.localUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firebaseUid => $composableBuilder(
    column: $table.firebaseUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneE164 => $composableBuilder(
    column: $table.phoneE164,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get district => $composableBuilder(
    column: $table.district,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get village => $composableBuilder(
    column: $table.village,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get savingsInr => $composableBuilder(
    column: $table.savingsInr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get loanInr => $composableBuilder(
    column: $table.loanInr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalUsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalUsersTable> {
  $$LocalUsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RowSyncState, String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<DateTime> get localUpdatedAt => $composableBuilder(
    column: $table.localUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get firebaseUid => $composableBuilder(
    column: $table.firebaseUid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phoneE164 =>
      $composableBuilder(column: $table.phoneE164, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get district =>
      $composableBuilder(column: $table.district, builder: (column) => column);

  GeneratedColumn<String> get village =>
      $composableBuilder(column: $table.village, builder: (column) => column);

  GeneratedColumn<int> get savingsInr => $composableBuilder(
    column: $table.savingsInr,
    builder: (column) => column,
  );

  GeneratedColumn<int> get loanInr =>
      $composableBuilder(column: $table.loanInr, builder: (column) => column);

  GeneratedColumn<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$LocalUsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalUsersTable,
          LocalUser,
          $$LocalUsersTableFilterComposer,
          $$LocalUsersTableOrderingComposer,
          $$LocalUsersTableAnnotationComposer,
          $$LocalUsersTableCreateCompanionBuilder,
          $$LocalUsersTableUpdateCompanionBuilder,
          (
            LocalUser,
            BaseReferences<_$AppDatabase, $LocalUsersTable, LocalUser>,
          ),
          LocalUser,
          PrefetchHooks Function()
        > {
  $$LocalUsersTableTableManager(_$AppDatabase db, $LocalUsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalUsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalUsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalUsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int?> serverId = const Value.absent(),
                Value<String> clientId = const Value.absent(),
                Value<RowSyncState> syncState = const Value.absent(),
                Value<DateTime> localUpdatedAt = const Value.absent(),
                Value<String?> firebaseUid = const Value.absent(),
                Value<String?> phoneE164 = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> district = const Value.absent(),
                Value<String?> village = const Value.absent(),
                Value<int> savingsInr = const Value.absent(),
                Value<int> loanInr = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalUsersCompanion(
                serverId: serverId,
                clientId: clientId,
                syncState: syncState,
                localUpdatedAt: localUpdatedAt,
                firebaseUid: firebaseUid,
                phoneE164: phoneE164,
                name: name,
                language: language,
                state: state,
                district: district,
                village: village,
                savingsInr: savingsInr,
                loanInr: loanInr,
                notificationsEnabled: notificationsEnabled,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int?> serverId = const Value.absent(),
                required String clientId,
                Value<RowSyncState> syncState = const Value.absent(),
                Value<DateTime> localUpdatedAt = const Value.absent(),
                Value<String?> firebaseUid = const Value.absent(),
                Value<String?> phoneE164 = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> district = const Value.absent(),
                Value<String?> village = const Value.absent(),
                Value<int> savingsInr = const Value.absent(),
                Value<int> loanInr = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalUsersCompanion.insert(
                serverId: serverId,
                clientId: clientId,
                syncState: syncState,
                localUpdatedAt: localUpdatedAt,
                firebaseUid: firebaseUid,
                phoneE164: phoneE164,
                name: name,
                language: language,
                state: state,
                district: district,
                village: village,
                savingsInr: savingsInr,
                loanInr: loanInr,
                notificationsEnabled: notificationsEnabled,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalUsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalUsersTable,
      LocalUser,
      $$LocalUsersTableFilterComposer,
      $$LocalUsersTableOrderingComposer,
      $$LocalUsersTableAnnotationComposer,
      $$LocalUsersTableCreateCompanionBuilder,
      $$LocalUsersTableUpdateCompanionBuilder,
      (LocalUser, BaseReferences<_$AppDatabase, $LocalUsersTable, LocalUser>),
      LocalUser,
      PrefetchHooks Function()
    >;
typedef $$LocalBusinessesTableCreateCompanionBuilder =
    LocalBusinessesCompanion Function({
      Value<int?> serverId,
      required String clientId,
      Value<RowSyncState> syncState,
      Value<DateTime> localUpdatedAt,
      Value<int?> ownerUserId,
      required String name,
      required String segment,
      required String sector,
      required String tenure,
      Value<int> staffCount,
      Value<bool> isNewBusiness,
      Value<int> yearsInOperation,
      Value<int> savingsInr,
      Value<int> loanInr,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$LocalBusinessesTableUpdateCompanionBuilder =
    LocalBusinessesCompanion Function({
      Value<int?> serverId,
      Value<String> clientId,
      Value<RowSyncState> syncState,
      Value<DateTime> localUpdatedAt,
      Value<int?> ownerUserId,
      Value<String> name,
      Value<String> segment,
      Value<String> sector,
      Value<String> tenure,
      Value<int> staffCount,
      Value<bool> isNewBusiness,
      Value<int> yearsInOperation,
      Value<int> savingsInr,
      Value<int> loanInr,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$LocalBusinessesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalBusinessesTable> {
  $$LocalBusinessesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RowSyncState, RowSyncState, String>
  get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get localUpdatedAt => $composableBuilder(
    column: $table.localUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get segment => $composableBuilder(
    column: $table.segment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sector => $composableBuilder(
    column: $table.sector,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tenure => $composableBuilder(
    column: $table.tenure,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get staffCount => $composableBuilder(
    column: $table.staffCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isNewBusiness => $composableBuilder(
    column: $table.isNewBusiness,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get yearsInOperation => $composableBuilder(
    column: $table.yearsInOperation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get savingsInr => $composableBuilder(
    column: $table.savingsInr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get loanInr => $composableBuilder(
    column: $table.loanInr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalBusinessesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalBusinessesTable> {
  $$LocalBusinessesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get localUpdatedAt => $composableBuilder(
    column: $table.localUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get segment => $composableBuilder(
    column: $table.segment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sector => $composableBuilder(
    column: $table.sector,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tenure => $composableBuilder(
    column: $table.tenure,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get staffCount => $composableBuilder(
    column: $table.staffCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isNewBusiness => $composableBuilder(
    column: $table.isNewBusiness,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get yearsInOperation => $composableBuilder(
    column: $table.yearsInOperation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get savingsInr => $composableBuilder(
    column: $table.savingsInr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get loanInr => $composableBuilder(
    column: $table.loanInr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalBusinessesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalBusinessesTable> {
  $$LocalBusinessesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RowSyncState, String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<DateTime> get localUpdatedAt => $composableBuilder(
    column: $table.localUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get segment =>
      $composableBuilder(column: $table.segment, builder: (column) => column);

  GeneratedColumn<String> get sector =>
      $composableBuilder(column: $table.sector, builder: (column) => column);

  GeneratedColumn<String> get tenure =>
      $composableBuilder(column: $table.tenure, builder: (column) => column);

  GeneratedColumn<int> get staffCount => $composableBuilder(
    column: $table.staffCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isNewBusiness => $composableBuilder(
    column: $table.isNewBusiness,
    builder: (column) => column,
  );

  GeneratedColumn<int> get yearsInOperation => $composableBuilder(
    column: $table.yearsInOperation,
    builder: (column) => column,
  );

  GeneratedColumn<int> get savingsInr => $composableBuilder(
    column: $table.savingsInr,
    builder: (column) => column,
  );

  GeneratedColumn<int> get loanInr =>
      $composableBuilder(column: $table.loanInr, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$LocalBusinessesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalBusinessesTable,
          LocalBusiness,
          $$LocalBusinessesTableFilterComposer,
          $$LocalBusinessesTableOrderingComposer,
          $$LocalBusinessesTableAnnotationComposer,
          $$LocalBusinessesTableCreateCompanionBuilder,
          $$LocalBusinessesTableUpdateCompanionBuilder,
          (
            LocalBusiness,
            BaseReferences<_$AppDatabase, $LocalBusinessesTable, LocalBusiness>,
          ),
          LocalBusiness,
          PrefetchHooks Function()
        > {
  $$LocalBusinessesTableTableManager(
    _$AppDatabase db,
    $LocalBusinessesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalBusinessesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalBusinessesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalBusinessesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int?> serverId = const Value.absent(),
                Value<String> clientId = const Value.absent(),
                Value<RowSyncState> syncState = const Value.absent(),
                Value<DateTime> localUpdatedAt = const Value.absent(),
                Value<int?> ownerUserId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> segment = const Value.absent(),
                Value<String> sector = const Value.absent(),
                Value<String> tenure = const Value.absent(),
                Value<int> staffCount = const Value.absent(),
                Value<bool> isNewBusiness = const Value.absent(),
                Value<int> yearsInOperation = const Value.absent(),
                Value<int> savingsInr = const Value.absent(),
                Value<int> loanInr = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalBusinessesCompanion(
                serverId: serverId,
                clientId: clientId,
                syncState: syncState,
                localUpdatedAt: localUpdatedAt,
                ownerUserId: ownerUserId,
                name: name,
                segment: segment,
                sector: sector,
                tenure: tenure,
                staffCount: staffCount,
                isNewBusiness: isNewBusiness,
                yearsInOperation: yearsInOperation,
                savingsInr: savingsInr,
                loanInr: loanInr,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int?> serverId = const Value.absent(),
                required String clientId,
                Value<RowSyncState> syncState = const Value.absent(),
                Value<DateTime> localUpdatedAt = const Value.absent(),
                Value<int?> ownerUserId = const Value.absent(),
                required String name,
                required String segment,
                required String sector,
                required String tenure,
                Value<int> staffCount = const Value.absent(),
                Value<bool> isNewBusiness = const Value.absent(),
                Value<int> yearsInOperation = const Value.absent(),
                Value<int> savingsInr = const Value.absent(),
                Value<int> loanInr = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalBusinessesCompanion.insert(
                serverId: serverId,
                clientId: clientId,
                syncState: syncState,
                localUpdatedAt: localUpdatedAt,
                ownerUserId: ownerUserId,
                name: name,
                segment: segment,
                sector: sector,
                tenure: tenure,
                staffCount: staffCount,
                isNewBusiness: isNewBusiness,
                yearsInOperation: yearsInOperation,
                savingsInr: savingsInr,
                loanInr: loanInr,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalBusinessesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalBusinessesTable,
      LocalBusiness,
      $$LocalBusinessesTableFilterComposer,
      $$LocalBusinessesTableOrderingComposer,
      $$LocalBusinessesTableAnnotationComposer,
      $$LocalBusinessesTableCreateCompanionBuilder,
      $$LocalBusinessesTableUpdateCompanionBuilder,
      (
        LocalBusiness,
        BaseReferences<_$AppDatabase, $LocalBusinessesTable, LocalBusiness>,
      ),
      LocalBusiness,
      PrefetchHooks Function()
    >;
typedef $$LocalMonthlySnapshotsTableCreateCompanionBuilder =
    LocalMonthlySnapshotsCompanion Function({
      Value<DateTime> fetchedAt,
      required int businessServerId,
      required DateTime month,
      Value<int> moneyIn,
      Value<int> moneyOut,
      Value<int> loanEmi,
      Value<int> savings,
      Value<String> basis,
      Value<int> rowid,
    });
typedef $$LocalMonthlySnapshotsTableUpdateCompanionBuilder =
    LocalMonthlySnapshotsCompanion Function({
      Value<DateTime> fetchedAt,
      Value<int> businessServerId,
      Value<DateTime> month,
      Value<int> moneyIn,
      Value<int> moneyOut,
      Value<int> loanEmi,
      Value<int> savings,
      Value<String> basis,
      Value<int> rowid,
    });

class $$LocalMonthlySnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalMonthlySnapshotsTable> {
  $$LocalMonthlySnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get businessServerId => $composableBuilder(
    column: $table.businessServerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get moneyIn => $composableBuilder(
    column: $table.moneyIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get moneyOut => $composableBuilder(
    column: $table.moneyOut,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get loanEmi => $composableBuilder(
    column: $table.loanEmi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get savings => $composableBuilder(
    column: $table.savings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get basis => $composableBuilder(
    column: $table.basis,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalMonthlySnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalMonthlySnapshotsTable> {
  $$LocalMonthlySnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get businessServerId => $composableBuilder(
    column: $table.businessServerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get moneyIn => $composableBuilder(
    column: $table.moneyIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get moneyOut => $composableBuilder(
    column: $table.moneyOut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get loanEmi => $composableBuilder(
    column: $table.loanEmi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get savings => $composableBuilder(
    column: $table.savings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get basis => $composableBuilder(
    column: $table.basis,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalMonthlySnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalMonthlySnapshotsTable> {
  $$LocalMonthlySnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<int> get businessServerId => $composableBuilder(
    column: $table.businessServerId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get moneyIn =>
      $composableBuilder(column: $table.moneyIn, builder: (column) => column);

  GeneratedColumn<int> get moneyOut =>
      $composableBuilder(column: $table.moneyOut, builder: (column) => column);

  GeneratedColumn<int> get loanEmi =>
      $composableBuilder(column: $table.loanEmi, builder: (column) => column);

  GeneratedColumn<int> get savings =>
      $composableBuilder(column: $table.savings, builder: (column) => column);

  GeneratedColumn<String> get basis =>
      $composableBuilder(column: $table.basis, builder: (column) => column);
}

class $$LocalMonthlySnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalMonthlySnapshotsTable,
          LocalMonthlySnapshot,
          $$LocalMonthlySnapshotsTableFilterComposer,
          $$LocalMonthlySnapshotsTableOrderingComposer,
          $$LocalMonthlySnapshotsTableAnnotationComposer,
          $$LocalMonthlySnapshotsTableCreateCompanionBuilder,
          $$LocalMonthlySnapshotsTableUpdateCompanionBuilder,
          (
            LocalMonthlySnapshot,
            BaseReferences<
              _$AppDatabase,
              $LocalMonthlySnapshotsTable,
              LocalMonthlySnapshot
            >,
          ),
          LocalMonthlySnapshot,
          PrefetchHooks Function()
        > {
  $$LocalMonthlySnapshotsTableTableManager(
    _$AppDatabase db,
    $LocalMonthlySnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalMonthlySnapshotsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LocalMonthlySnapshotsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalMonthlySnapshotsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> businessServerId = const Value.absent(),
                Value<DateTime> month = const Value.absent(),
                Value<int> moneyIn = const Value.absent(),
                Value<int> moneyOut = const Value.absent(),
                Value<int> loanEmi = const Value.absent(),
                Value<int> savings = const Value.absent(),
                Value<String> basis = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalMonthlySnapshotsCompanion(
                fetchedAt: fetchedAt,
                businessServerId: businessServerId,
                month: month,
                moneyIn: moneyIn,
                moneyOut: moneyOut,
                loanEmi: loanEmi,
                savings: savings,
                basis: basis,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> fetchedAt = const Value.absent(),
                required int businessServerId,
                required DateTime month,
                Value<int> moneyIn = const Value.absent(),
                Value<int> moneyOut = const Value.absent(),
                Value<int> loanEmi = const Value.absent(),
                Value<int> savings = const Value.absent(),
                Value<String> basis = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalMonthlySnapshotsCompanion.insert(
                fetchedAt: fetchedAt,
                businessServerId: businessServerId,
                month: month,
                moneyIn: moneyIn,
                moneyOut: moneyOut,
                loanEmi: loanEmi,
                savings: savings,
                basis: basis,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalMonthlySnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalMonthlySnapshotsTable,
      LocalMonthlySnapshot,
      $$LocalMonthlySnapshotsTableFilterComposer,
      $$LocalMonthlySnapshotsTableOrderingComposer,
      $$LocalMonthlySnapshotsTableAnnotationComposer,
      $$LocalMonthlySnapshotsTableCreateCompanionBuilder,
      $$LocalMonthlySnapshotsTableUpdateCompanionBuilder,
      (
        LocalMonthlySnapshot,
        BaseReferences<
          _$AppDatabase,
          $LocalMonthlySnapshotsTable,
          LocalMonthlySnapshot
        >,
      ),
      LocalMonthlySnapshot,
      PrefetchHooks Function()
    >;
typedef $$LocalLedgerEntriesTableCreateCompanionBuilder =
    LocalLedgerEntriesCompanion Function({
      Value<int?> serverId,
      required String clientId,
      Value<RowSyncState> syncState,
      Value<DateTime> localUpdatedAt,
      required int businessServerId,
      Value<int?> ownerUserId,
      required String kind,
      required int amountInr,
      required String category,
      required DateTime recordedAt,
      Value<String> source,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$LocalLedgerEntriesTableUpdateCompanionBuilder =
    LocalLedgerEntriesCompanion Function({
      Value<int?> serverId,
      Value<String> clientId,
      Value<RowSyncState> syncState,
      Value<DateTime> localUpdatedAt,
      Value<int> businessServerId,
      Value<int?> ownerUserId,
      Value<String> kind,
      Value<int> amountInr,
      Value<String> category,
      Value<DateTime> recordedAt,
      Value<String> source,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$LocalLedgerEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalLedgerEntriesTable> {
  $$LocalLedgerEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RowSyncState, RowSyncState, String>
  get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get localUpdatedAt => $composableBuilder(
    column: $table.localUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get businessServerId => $composableBuilder(
    column: $table.businessServerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountInr => $composableBuilder(
    column: $table.amountInr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalLedgerEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalLedgerEntriesTable> {
  $$LocalLedgerEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get localUpdatedAt => $composableBuilder(
    column: $table.localUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get businessServerId => $composableBuilder(
    column: $table.businessServerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountInr => $composableBuilder(
    column: $table.amountInr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalLedgerEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalLedgerEntriesTable> {
  $$LocalLedgerEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RowSyncState, String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<DateTime> get localUpdatedAt => $composableBuilder(
    column: $table.localUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get businessServerId => $composableBuilder(
    column: $table.businessServerId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get amountInr =>
      $composableBuilder(column: $table.amountInr, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$LocalLedgerEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalLedgerEntriesTable,
          LocalLedgerEntry,
          $$LocalLedgerEntriesTableFilterComposer,
          $$LocalLedgerEntriesTableOrderingComposer,
          $$LocalLedgerEntriesTableAnnotationComposer,
          $$LocalLedgerEntriesTableCreateCompanionBuilder,
          $$LocalLedgerEntriesTableUpdateCompanionBuilder,
          (
            LocalLedgerEntry,
            BaseReferences<
              _$AppDatabase,
              $LocalLedgerEntriesTable,
              LocalLedgerEntry
            >,
          ),
          LocalLedgerEntry,
          PrefetchHooks Function()
        > {
  $$LocalLedgerEntriesTableTableManager(
    _$AppDatabase db,
    $LocalLedgerEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalLedgerEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalLedgerEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalLedgerEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int?> serverId = const Value.absent(),
                Value<String> clientId = const Value.absent(),
                Value<RowSyncState> syncState = const Value.absent(),
                Value<DateTime> localUpdatedAt = const Value.absent(),
                Value<int> businessServerId = const Value.absent(),
                Value<int?> ownerUserId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int> amountInr = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalLedgerEntriesCompanion(
                serverId: serverId,
                clientId: clientId,
                syncState: syncState,
                localUpdatedAt: localUpdatedAt,
                businessServerId: businessServerId,
                ownerUserId: ownerUserId,
                kind: kind,
                amountInr: amountInr,
                category: category,
                recordedAt: recordedAt,
                source: source,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int?> serverId = const Value.absent(),
                required String clientId,
                Value<RowSyncState> syncState = const Value.absent(),
                Value<DateTime> localUpdatedAt = const Value.absent(),
                required int businessServerId,
                Value<int?> ownerUserId = const Value.absent(),
                required String kind,
                required int amountInr,
                required String category,
                required DateTime recordedAt,
                Value<String> source = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalLedgerEntriesCompanion.insert(
                serverId: serverId,
                clientId: clientId,
                syncState: syncState,
                localUpdatedAt: localUpdatedAt,
                businessServerId: businessServerId,
                ownerUserId: ownerUserId,
                kind: kind,
                amountInr: amountInr,
                category: category,
                recordedAt: recordedAt,
                source: source,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalLedgerEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalLedgerEntriesTable,
      LocalLedgerEntry,
      $$LocalLedgerEntriesTableFilterComposer,
      $$LocalLedgerEntriesTableOrderingComposer,
      $$LocalLedgerEntriesTableAnnotationComposer,
      $$LocalLedgerEntriesTableCreateCompanionBuilder,
      $$LocalLedgerEntriesTableUpdateCompanionBuilder,
      (
        LocalLedgerEntry,
        BaseReferences<
          _$AppDatabase,
          $LocalLedgerEntriesTable,
          LocalLedgerEntry
        >,
      ),
      LocalLedgerEntry,
      PrefetchHooks Function()
    >;
typedef $$LocalHealthScoresTableCreateCompanionBuilder =
    LocalHealthScoresCompanion Function({
      Value<DateTime> fetchedAt,
      Value<int> serverId,
      required int businessServerId,
      required DateTime asOn,
      required DateTime nextUpdate,
      required int score,
      required String risk,
      Value<int?> delta,
      Value<int> daysWritten,
      Value<int> daysInMonth,
      required String band,
      Value<double> pGreen,
      Value<double> pAmber,
      Value<double> pRed,
      Value<String?> modelVersion,
    });
typedef $$LocalHealthScoresTableUpdateCompanionBuilder =
    LocalHealthScoresCompanion Function({
      Value<DateTime> fetchedAt,
      Value<int> serverId,
      Value<int> businessServerId,
      Value<DateTime> asOn,
      Value<DateTime> nextUpdate,
      Value<int> score,
      Value<String> risk,
      Value<int?> delta,
      Value<int> daysWritten,
      Value<int> daysInMonth,
      Value<String> band,
      Value<double> pGreen,
      Value<double> pAmber,
      Value<double> pRed,
      Value<String?> modelVersion,
    });

class $$LocalHealthScoresTableFilterComposer
    extends Composer<_$AppDatabase, $LocalHealthScoresTable> {
  $$LocalHealthScoresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get businessServerId => $composableBuilder(
    column: $table.businessServerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get asOn => $composableBuilder(
    column: $table.asOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextUpdate => $composableBuilder(
    column: $table.nextUpdate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get risk => $composableBuilder(
    column: $table.risk,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get delta => $composableBuilder(
    column: $table.delta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get daysWritten => $composableBuilder(
    column: $table.daysWritten,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get daysInMonth => $composableBuilder(
    column: $table.daysInMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get band => $composableBuilder(
    column: $table.band,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pGreen => $composableBuilder(
    column: $table.pGreen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pAmber => $composableBuilder(
    column: $table.pAmber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pRed => $composableBuilder(
    column: $table.pRed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelVersion => $composableBuilder(
    column: $table.modelVersion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalHealthScoresTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalHealthScoresTable> {
  $$LocalHealthScoresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get businessServerId => $composableBuilder(
    column: $table.businessServerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get asOn => $composableBuilder(
    column: $table.asOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextUpdate => $composableBuilder(
    column: $table.nextUpdate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get risk => $composableBuilder(
    column: $table.risk,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get delta => $composableBuilder(
    column: $table.delta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get daysWritten => $composableBuilder(
    column: $table.daysWritten,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get daysInMonth => $composableBuilder(
    column: $table.daysInMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get band => $composableBuilder(
    column: $table.band,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pGreen => $composableBuilder(
    column: $table.pGreen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pAmber => $composableBuilder(
    column: $table.pAmber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pRed => $composableBuilder(
    column: $table.pRed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelVersion => $composableBuilder(
    column: $table.modelVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalHealthScoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalHealthScoresTable> {
  $$LocalHealthScoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<int> get businessServerId => $composableBuilder(
    column: $table.businessServerId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get asOn =>
      $composableBuilder(column: $table.asOn, builder: (column) => column);

  GeneratedColumn<DateTime> get nextUpdate => $composableBuilder(
    column: $table.nextUpdate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<String> get risk =>
      $composableBuilder(column: $table.risk, builder: (column) => column);

  GeneratedColumn<int> get delta =>
      $composableBuilder(column: $table.delta, builder: (column) => column);

  GeneratedColumn<int> get daysWritten => $composableBuilder(
    column: $table.daysWritten,
    builder: (column) => column,
  );

  GeneratedColumn<int> get daysInMonth => $composableBuilder(
    column: $table.daysInMonth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get band =>
      $composableBuilder(column: $table.band, builder: (column) => column);

  GeneratedColumn<double> get pGreen =>
      $composableBuilder(column: $table.pGreen, builder: (column) => column);

  GeneratedColumn<double> get pAmber =>
      $composableBuilder(column: $table.pAmber, builder: (column) => column);

  GeneratedColumn<double> get pRed =>
      $composableBuilder(column: $table.pRed, builder: (column) => column);

  GeneratedColumn<String> get modelVersion => $composableBuilder(
    column: $table.modelVersion,
    builder: (column) => column,
  );
}

class $$LocalHealthScoresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalHealthScoresTable,
          LocalHealthScore,
          $$LocalHealthScoresTableFilterComposer,
          $$LocalHealthScoresTableOrderingComposer,
          $$LocalHealthScoresTableAnnotationComposer,
          $$LocalHealthScoresTableCreateCompanionBuilder,
          $$LocalHealthScoresTableUpdateCompanionBuilder,
          (
            LocalHealthScore,
            BaseReferences<
              _$AppDatabase,
              $LocalHealthScoresTable,
              LocalHealthScore
            >,
          ),
          LocalHealthScore,
          PrefetchHooks Function()
        > {
  $$LocalHealthScoresTableTableManager(
    _$AppDatabase db,
    $LocalHealthScoresTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalHealthScoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalHealthScoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalHealthScoresTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> serverId = const Value.absent(),
                Value<int> businessServerId = const Value.absent(),
                Value<DateTime> asOn = const Value.absent(),
                Value<DateTime> nextUpdate = const Value.absent(),
                Value<int> score = const Value.absent(),
                Value<String> risk = const Value.absent(),
                Value<int?> delta = const Value.absent(),
                Value<int> daysWritten = const Value.absent(),
                Value<int> daysInMonth = const Value.absent(),
                Value<String> band = const Value.absent(),
                Value<double> pGreen = const Value.absent(),
                Value<double> pAmber = const Value.absent(),
                Value<double> pRed = const Value.absent(),
                Value<String?> modelVersion = const Value.absent(),
              }) => LocalHealthScoresCompanion(
                fetchedAt: fetchedAt,
                serverId: serverId,
                businessServerId: businessServerId,
                asOn: asOn,
                nextUpdate: nextUpdate,
                score: score,
                risk: risk,
                delta: delta,
                daysWritten: daysWritten,
                daysInMonth: daysInMonth,
                band: band,
                pGreen: pGreen,
                pAmber: pAmber,
                pRed: pRed,
                modelVersion: modelVersion,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> serverId = const Value.absent(),
                required int businessServerId,
                required DateTime asOn,
                required DateTime nextUpdate,
                required int score,
                required String risk,
                Value<int?> delta = const Value.absent(),
                Value<int> daysWritten = const Value.absent(),
                Value<int> daysInMonth = const Value.absent(),
                required String band,
                Value<double> pGreen = const Value.absent(),
                Value<double> pAmber = const Value.absent(),
                Value<double> pRed = const Value.absent(),
                Value<String?> modelVersion = const Value.absent(),
              }) => LocalHealthScoresCompanion.insert(
                fetchedAt: fetchedAt,
                serverId: serverId,
                businessServerId: businessServerId,
                asOn: asOn,
                nextUpdate: nextUpdate,
                score: score,
                risk: risk,
                delta: delta,
                daysWritten: daysWritten,
                daysInMonth: daysInMonth,
                band: band,
                pGreen: pGreen,
                pAmber: pAmber,
                pRed: pRed,
                modelVersion: modelVersion,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalHealthScoresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalHealthScoresTable,
      LocalHealthScore,
      $$LocalHealthScoresTableFilterComposer,
      $$LocalHealthScoresTableOrderingComposer,
      $$LocalHealthScoresTableAnnotationComposer,
      $$LocalHealthScoresTableCreateCompanionBuilder,
      $$LocalHealthScoresTableUpdateCompanionBuilder,
      (
        LocalHealthScore,
        BaseReferences<
          _$AppDatabase,
          $LocalHealthScoresTable,
          LocalHealthScore
        >,
      ),
      LocalHealthScore,
      PrefetchHooks Function()
    >;
typedef $$LocalForecastsTableCreateCompanionBuilder =
    LocalForecastsCompanion Function({
      Value<DateTime> fetchedAt,
      required int businessServerId,
      required DateTime asOn,
      required int horizon,
      Value<double> cfPred,
      Value<double> inLevel,
      Value<double> outLevel,
      Value<bool> isRiskMonth,
      Value<int> rowid,
    });
typedef $$LocalForecastsTableUpdateCompanionBuilder =
    LocalForecastsCompanion Function({
      Value<DateTime> fetchedAt,
      Value<int> businessServerId,
      Value<DateTime> asOn,
      Value<int> horizon,
      Value<double> cfPred,
      Value<double> inLevel,
      Value<double> outLevel,
      Value<bool> isRiskMonth,
      Value<int> rowid,
    });

class $$LocalForecastsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalForecastsTable> {
  $$LocalForecastsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get businessServerId => $composableBuilder(
    column: $table.businessServerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get asOn => $composableBuilder(
    column: $table.asOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get horizon => $composableBuilder(
    column: $table.horizon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cfPred => $composableBuilder(
    column: $table.cfPred,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get inLevel => $composableBuilder(
    column: $table.inLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get outLevel => $composableBuilder(
    column: $table.outLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRiskMonth => $composableBuilder(
    column: $table.isRiskMonth,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalForecastsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalForecastsTable> {
  $$LocalForecastsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get businessServerId => $composableBuilder(
    column: $table.businessServerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get asOn => $composableBuilder(
    column: $table.asOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get horizon => $composableBuilder(
    column: $table.horizon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cfPred => $composableBuilder(
    column: $table.cfPred,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get inLevel => $composableBuilder(
    column: $table.inLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get outLevel => $composableBuilder(
    column: $table.outLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRiskMonth => $composableBuilder(
    column: $table.isRiskMonth,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalForecastsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalForecastsTable> {
  $$LocalForecastsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<int> get businessServerId => $composableBuilder(
    column: $table.businessServerId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get asOn =>
      $composableBuilder(column: $table.asOn, builder: (column) => column);

  GeneratedColumn<int> get horizon =>
      $composableBuilder(column: $table.horizon, builder: (column) => column);

  GeneratedColumn<double> get cfPred =>
      $composableBuilder(column: $table.cfPred, builder: (column) => column);

  GeneratedColumn<double> get inLevel =>
      $composableBuilder(column: $table.inLevel, builder: (column) => column);

  GeneratedColumn<double> get outLevel =>
      $composableBuilder(column: $table.outLevel, builder: (column) => column);

  GeneratedColumn<bool> get isRiskMonth => $composableBuilder(
    column: $table.isRiskMonth,
    builder: (column) => column,
  );
}

class $$LocalForecastsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalForecastsTable,
          LocalForecast,
          $$LocalForecastsTableFilterComposer,
          $$LocalForecastsTableOrderingComposer,
          $$LocalForecastsTableAnnotationComposer,
          $$LocalForecastsTableCreateCompanionBuilder,
          $$LocalForecastsTableUpdateCompanionBuilder,
          (
            LocalForecast,
            BaseReferences<_$AppDatabase, $LocalForecastsTable, LocalForecast>,
          ),
          LocalForecast,
          PrefetchHooks Function()
        > {
  $$LocalForecastsTableTableManager(
    _$AppDatabase db,
    $LocalForecastsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalForecastsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalForecastsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalForecastsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> businessServerId = const Value.absent(),
                Value<DateTime> asOn = const Value.absent(),
                Value<int> horizon = const Value.absent(),
                Value<double> cfPred = const Value.absent(),
                Value<double> inLevel = const Value.absent(),
                Value<double> outLevel = const Value.absent(),
                Value<bool> isRiskMonth = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalForecastsCompanion(
                fetchedAt: fetchedAt,
                businessServerId: businessServerId,
                asOn: asOn,
                horizon: horizon,
                cfPred: cfPred,
                inLevel: inLevel,
                outLevel: outLevel,
                isRiskMonth: isRiskMonth,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> fetchedAt = const Value.absent(),
                required int businessServerId,
                required DateTime asOn,
                required int horizon,
                Value<double> cfPred = const Value.absent(),
                Value<double> inLevel = const Value.absent(),
                Value<double> outLevel = const Value.absent(),
                Value<bool> isRiskMonth = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalForecastsCompanion.insert(
                fetchedAt: fetchedAt,
                businessServerId: businessServerId,
                asOn: asOn,
                horizon: horizon,
                cfPred: cfPred,
                inLevel: inLevel,
                outLevel: outLevel,
                isRiskMonth: isRiskMonth,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalForecastsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalForecastsTable,
      LocalForecast,
      $$LocalForecastsTableFilterComposer,
      $$LocalForecastsTableOrderingComposer,
      $$LocalForecastsTableAnnotationComposer,
      $$LocalForecastsTableCreateCompanionBuilder,
      $$LocalForecastsTableUpdateCompanionBuilder,
      (
        LocalForecast,
        BaseReferences<_$AppDatabase, $LocalForecastsTable, LocalForecast>,
      ),
      LocalForecast,
      PrefetchHooks Function()
    >;
typedef $$LocalRiskAlertsTableCreateCompanionBuilder =
    LocalRiskAlertsCompanion Function({
      Value<DateTime> fetchedAt,
      Value<int> serverId,
      required int businessServerId,
      required DateTime asOn,
      required String kind,
      required String severity,
      Value<String?> driver,
      Value<bool> hasPlan,
      required DateTime raisedOn,
      Value<DateTime?> resolvedAt,
      Value<bool> detailFetched,
    });
typedef $$LocalRiskAlertsTableUpdateCompanionBuilder =
    LocalRiskAlertsCompanion Function({
      Value<DateTime> fetchedAt,
      Value<int> serverId,
      Value<int> businessServerId,
      Value<DateTime> asOn,
      Value<String> kind,
      Value<String> severity,
      Value<String?> driver,
      Value<bool> hasPlan,
      Value<DateTime> raisedOn,
      Value<DateTime?> resolvedAt,
      Value<bool> detailFetched,
    });

class $$LocalRiskAlertsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalRiskAlertsTable> {
  $$LocalRiskAlertsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get businessServerId => $composableBuilder(
    column: $table.businessServerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get asOn => $composableBuilder(
    column: $table.asOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get driver => $composableBuilder(
    column: $table.driver,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasPlan => $composableBuilder(
    column: $table.hasPlan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get raisedOn => $composableBuilder(
    column: $table.raisedOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get detailFetched => $composableBuilder(
    column: $table.detailFetched,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalRiskAlertsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalRiskAlertsTable> {
  $$LocalRiskAlertsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get businessServerId => $composableBuilder(
    column: $table.businessServerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get asOn => $composableBuilder(
    column: $table.asOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get driver => $composableBuilder(
    column: $table.driver,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasPlan => $composableBuilder(
    column: $table.hasPlan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get raisedOn => $composableBuilder(
    column: $table.raisedOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get detailFetched => $composableBuilder(
    column: $table.detailFetched,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalRiskAlertsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalRiskAlertsTable> {
  $$LocalRiskAlertsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<int> get businessServerId => $composableBuilder(
    column: $table.businessServerId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get asOn =>
      $composableBuilder(column: $table.asOn, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<String> get driver =>
      $composableBuilder(column: $table.driver, builder: (column) => column);

  GeneratedColumn<bool> get hasPlan =>
      $composableBuilder(column: $table.hasPlan, builder: (column) => column);

  GeneratedColumn<DateTime> get raisedOn =>
      $composableBuilder(column: $table.raisedOn, builder: (column) => column);

  GeneratedColumn<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get detailFetched => $composableBuilder(
    column: $table.detailFetched,
    builder: (column) => column,
  );
}

class $$LocalRiskAlertsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalRiskAlertsTable,
          LocalRiskAlert,
          $$LocalRiskAlertsTableFilterComposer,
          $$LocalRiskAlertsTableOrderingComposer,
          $$LocalRiskAlertsTableAnnotationComposer,
          $$LocalRiskAlertsTableCreateCompanionBuilder,
          $$LocalRiskAlertsTableUpdateCompanionBuilder,
          (
            LocalRiskAlert,
            BaseReferences<
              _$AppDatabase,
              $LocalRiskAlertsTable,
              LocalRiskAlert
            >,
          ),
          LocalRiskAlert,
          PrefetchHooks Function()
        > {
  $$LocalRiskAlertsTableTableManager(
    _$AppDatabase db,
    $LocalRiskAlertsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalRiskAlertsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalRiskAlertsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalRiskAlertsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> serverId = const Value.absent(),
                Value<int> businessServerId = const Value.absent(),
                Value<DateTime> asOn = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> severity = const Value.absent(),
                Value<String?> driver = const Value.absent(),
                Value<bool> hasPlan = const Value.absent(),
                Value<DateTime> raisedOn = const Value.absent(),
                Value<DateTime?> resolvedAt = const Value.absent(),
                Value<bool> detailFetched = const Value.absent(),
              }) => LocalRiskAlertsCompanion(
                fetchedAt: fetchedAt,
                serverId: serverId,
                businessServerId: businessServerId,
                asOn: asOn,
                kind: kind,
                severity: severity,
                driver: driver,
                hasPlan: hasPlan,
                raisedOn: raisedOn,
                resolvedAt: resolvedAt,
                detailFetched: detailFetched,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> serverId = const Value.absent(),
                required int businessServerId,
                required DateTime asOn,
                required String kind,
                required String severity,
                Value<String?> driver = const Value.absent(),
                Value<bool> hasPlan = const Value.absent(),
                required DateTime raisedOn,
                Value<DateTime?> resolvedAt = const Value.absent(),
                Value<bool> detailFetched = const Value.absent(),
              }) => LocalRiskAlertsCompanion.insert(
                fetchedAt: fetchedAt,
                serverId: serverId,
                businessServerId: businessServerId,
                asOn: asOn,
                kind: kind,
                severity: severity,
                driver: driver,
                hasPlan: hasPlan,
                raisedOn: raisedOn,
                resolvedAt: resolvedAt,
                detailFetched: detailFetched,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalRiskAlertsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalRiskAlertsTable,
      LocalRiskAlert,
      $$LocalRiskAlertsTableFilterComposer,
      $$LocalRiskAlertsTableOrderingComposer,
      $$LocalRiskAlertsTableAnnotationComposer,
      $$LocalRiskAlertsTableCreateCompanionBuilder,
      $$LocalRiskAlertsTableUpdateCompanionBuilder,
      (
        LocalRiskAlert,
        BaseReferences<_$AppDatabase, $LocalRiskAlertsTable, LocalRiskAlert>,
      ),
      LocalRiskAlert,
      PrefetchHooks Function()
    >;
typedef $$LocalPlanActionsTableCreateCompanionBuilder =
    LocalPlanActionsCompanion Function({
      Value<int?> serverId,
      required String clientId,
      Value<RowSyncState> syncState,
      Value<DateTime> localUpdatedAt,
      required int alertServerId,
      required int businessServerId,
      Value<String> role,
      Value<int> ordinal,
      required String labelEn,
      Value<String?> labelHi,
      Value<bool> done,
      Value<int> rowid,
    });
typedef $$LocalPlanActionsTableUpdateCompanionBuilder =
    LocalPlanActionsCompanion Function({
      Value<int?> serverId,
      Value<String> clientId,
      Value<RowSyncState> syncState,
      Value<DateTime> localUpdatedAt,
      Value<int> alertServerId,
      Value<int> businessServerId,
      Value<String> role,
      Value<int> ordinal,
      Value<String> labelEn,
      Value<String?> labelHi,
      Value<bool> done,
      Value<int> rowid,
    });

class $$LocalPlanActionsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalPlanActionsTable> {
  $$LocalPlanActionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RowSyncState, RowSyncState, String>
  get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get localUpdatedAt => $composableBuilder(
    column: $table.localUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get alertServerId => $composableBuilder(
    column: $table.alertServerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get businessServerId => $composableBuilder(
    column: $table.businessServerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ordinal => $composableBuilder(
    column: $table.ordinal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get labelEn => $composableBuilder(
    column: $table.labelEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get labelHi => $composableBuilder(
    column: $table.labelHi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalPlanActionsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalPlanActionsTable> {
  $$LocalPlanActionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get localUpdatedAt => $composableBuilder(
    column: $table.localUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get alertServerId => $composableBuilder(
    column: $table.alertServerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get businessServerId => $composableBuilder(
    column: $table.businessServerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ordinal => $composableBuilder(
    column: $table.ordinal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get labelEn => $composableBuilder(
    column: $table.labelEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get labelHi => $composableBuilder(
    column: $table.labelHi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalPlanActionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalPlanActionsTable> {
  $$LocalPlanActionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RowSyncState, String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<DateTime> get localUpdatedAt => $composableBuilder(
    column: $table.localUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get alertServerId => $composableBuilder(
    column: $table.alertServerId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get businessServerId => $composableBuilder(
    column: $table.businessServerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<int> get ordinal =>
      $composableBuilder(column: $table.ordinal, builder: (column) => column);

  GeneratedColumn<String> get labelEn =>
      $composableBuilder(column: $table.labelEn, builder: (column) => column);

  GeneratedColumn<String> get labelHi =>
      $composableBuilder(column: $table.labelHi, builder: (column) => column);

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);
}

class $$LocalPlanActionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalPlanActionsTable,
          LocalPlanAction,
          $$LocalPlanActionsTableFilterComposer,
          $$LocalPlanActionsTableOrderingComposer,
          $$LocalPlanActionsTableAnnotationComposer,
          $$LocalPlanActionsTableCreateCompanionBuilder,
          $$LocalPlanActionsTableUpdateCompanionBuilder,
          (
            LocalPlanAction,
            BaseReferences<
              _$AppDatabase,
              $LocalPlanActionsTable,
              LocalPlanAction
            >,
          ),
          LocalPlanAction,
          PrefetchHooks Function()
        > {
  $$LocalPlanActionsTableTableManager(
    _$AppDatabase db,
    $LocalPlanActionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalPlanActionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalPlanActionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalPlanActionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int?> serverId = const Value.absent(),
                Value<String> clientId = const Value.absent(),
                Value<RowSyncState> syncState = const Value.absent(),
                Value<DateTime> localUpdatedAt = const Value.absent(),
                Value<int> alertServerId = const Value.absent(),
                Value<int> businessServerId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<int> ordinal = const Value.absent(),
                Value<String> labelEn = const Value.absent(),
                Value<String?> labelHi = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPlanActionsCompanion(
                serverId: serverId,
                clientId: clientId,
                syncState: syncState,
                localUpdatedAt: localUpdatedAt,
                alertServerId: alertServerId,
                businessServerId: businessServerId,
                role: role,
                ordinal: ordinal,
                labelEn: labelEn,
                labelHi: labelHi,
                done: done,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int?> serverId = const Value.absent(),
                required String clientId,
                Value<RowSyncState> syncState = const Value.absent(),
                Value<DateTime> localUpdatedAt = const Value.absent(),
                required int alertServerId,
                required int businessServerId,
                Value<String> role = const Value.absent(),
                Value<int> ordinal = const Value.absent(),
                required String labelEn,
                Value<String?> labelHi = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPlanActionsCompanion.insert(
                serverId: serverId,
                clientId: clientId,
                syncState: syncState,
                localUpdatedAt: localUpdatedAt,
                alertServerId: alertServerId,
                businessServerId: businessServerId,
                role: role,
                ordinal: ordinal,
                labelEn: labelEn,
                labelHi: labelHi,
                done: done,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalPlanActionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalPlanActionsTable,
      LocalPlanAction,
      $$LocalPlanActionsTableFilterComposer,
      $$LocalPlanActionsTableOrderingComposer,
      $$LocalPlanActionsTableAnnotationComposer,
      $$LocalPlanActionsTableCreateCompanionBuilder,
      $$LocalPlanActionsTableUpdateCompanionBuilder,
      (
        LocalPlanAction,
        BaseReferences<_$AppDatabase, $LocalPlanActionsTable, LocalPlanAction>,
      ),
      LocalPlanAction,
      PrefetchHooks Function()
    >;
typedef $$LocalStatesTableCreateCompanionBuilder =
    LocalStatesCompanion Function({
      Value<DateTime> fetchedAt,
      required String code,
      required String nameEn,
      Value<String?> nameHi,
      Value<int> rowid,
    });
typedef $$LocalStatesTableUpdateCompanionBuilder =
    LocalStatesCompanion Function({
      Value<DateTime> fetchedAt,
      Value<String> code,
      Value<String> nameEn,
      Value<String?> nameHi,
      Value<int> rowid,
    });

class $$LocalStatesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalStatesTable> {
  $$LocalStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameHi => $composableBuilder(
    column: $table.nameHi,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalStatesTable> {
  $$LocalStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameHi => $composableBuilder(
    column: $table.nameHi,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalStatesTable> {
  $$LocalStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get nameHi =>
      $composableBuilder(column: $table.nameHi, builder: (column) => column);
}

class $$LocalStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalStatesTable,
          LocalState,
          $$LocalStatesTableFilterComposer,
          $$LocalStatesTableOrderingComposer,
          $$LocalStatesTableAnnotationComposer,
          $$LocalStatesTableCreateCompanionBuilder,
          $$LocalStatesTableUpdateCompanionBuilder,
          (
            LocalState,
            BaseReferences<_$AppDatabase, $LocalStatesTable, LocalState>,
          ),
          LocalState,
          PrefetchHooks Function()
        > {
  $$LocalStatesTableTableManager(_$AppDatabase db, $LocalStatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<String?> nameHi = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalStatesCompanion(
                fetchedAt: fetchedAt,
                code: code,
                nameEn: nameEn,
                nameHi: nameHi,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> fetchedAt = const Value.absent(),
                required String code,
                required String nameEn,
                Value<String?> nameHi = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalStatesCompanion.insert(
                fetchedAt: fetchedAt,
                code: code,
                nameEn: nameEn,
                nameHi: nameHi,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalStatesTable,
      LocalState,
      $$LocalStatesTableFilterComposer,
      $$LocalStatesTableOrderingComposer,
      $$LocalStatesTableAnnotationComposer,
      $$LocalStatesTableCreateCompanionBuilder,
      $$LocalStatesTableUpdateCompanionBuilder,
      (
        LocalState,
        BaseReferences<_$AppDatabase, $LocalStatesTable, LocalState>,
      ),
      LocalState,
      PrefetchHooks Function()
    >;
typedef $$LocalDistrictsTableCreateCompanionBuilder =
    LocalDistrictsCompanion Function({
      Value<DateTime> fetchedAt,
      required String stateCode,
      required String nameEn,
      Value<int> rowid,
    });
typedef $$LocalDistrictsTableUpdateCompanionBuilder =
    LocalDistrictsCompanion Function({
      Value<DateTime> fetchedAt,
      Value<String> stateCode,
      Value<String> nameEn,
      Value<int> rowid,
    });

class $$LocalDistrictsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalDistrictsTable> {
  $$LocalDistrictsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stateCode => $composableBuilder(
    column: $table.stateCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalDistrictsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalDistrictsTable> {
  $$LocalDistrictsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stateCode => $composableBuilder(
    column: $table.stateCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalDistrictsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalDistrictsTable> {
  $$LocalDistrictsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<String> get stateCode =>
      $composableBuilder(column: $table.stateCode, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);
}

class $$LocalDistrictsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalDistrictsTable,
          LocalDistrict,
          $$LocalDistrictsTableFilterComposer,
          $$LocalDistrictsTableOrderingComposer,
          $$LocalDistrictsTableAnnotationComposer,
          $$LocalDistrictsTableCreateCompanionBuilder,
          $$LocalDistrictsTableUpdateCompanionBuilder,
          (
            LocalDistrict,
            BaseReferences<_$AppDatabase, $LocalDistrictsTable, LocalDistrict>,
          ),
          LocalDistrict,
          PrefetchHooks Function()
        > {
  $$LocalDistrictsTableTableManager(
    _$AppDatabase db,
    $LocalDistrictsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalDistrictsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalDistrictsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalDistrictsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<String> stateCode = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalDistrictsCompanion(
                fetchedAt: fetchedAt,
                stateCode: stateCode,
                nameEn: nameEn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> fetchedAt = const Value.absent(),
                required String stateCode,
                required String nameEn,
                Value<int> rowid = const Value.absent(),
              }) => LocalDistrictsCompanion.insert(
                fetchedAt: fetchedAt,
                stateCode: stateCode,
                nameEn: nameEn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalDistrictsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalDistrictsTable,
      LocalDistrict,
      $$LocalDistrictsTableFilterComposer,
      $$LocalDistrictsTableOrderingComposer,
      $$LocalDistrictsTableAnnotationComposer,
      $$LocalDistrictsTableCreateCompanionBuilder,
      $$LocalDistrictsTableUpdateCompanionBuilder,
      (
        LocalDistrict,
        BaseReferences<_$AppDatabase, $LocalDistrictsTable, LocalDistrict>,
      ),
      LocalDistrict,
      PrefetchHooks Function()
    >;
typedef $$SyncOpsTableCreateCompanionBuilder =
    SyncOpsCompanion Function({
      Value<int> id,
      required SyncEntity entity,
      required SyncOpKind op,
      required String localRowId,
      Value<int?> serverId,
      Value<int?> businessServerId,
      Value<String> payload,
      required String dedupeKey,
      Value<int> revision,
      Value<int> attempts,
      Value<String?> lastError,
      Value<DateTime> nextAttemptAt,
      Value<bool> deadLettered,
      Value<DateTime> createdAt,
    });
typedef $$SyncOpsTableUpdateCompanionBuilder =
    SyncOpsCompanion Function({
      Value<int> id,
      Value<SyncEntity> entity,
      Value<SyncOpKind> op,
      Value<String> localRowId,
      Value<int?> serverId,
      Value<int?> businessServerId,
      Value<String> payload,
      Value<String> dedupeKey,
      Value<int> revision,
      Value<int> attempts,
      Value<String?> lastError,
      Value<DateTime> nextAttemptAt,
      Value<bool> deadLettered,
      Value<DateTime> createdAt,
    });

class $$SyncOpsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncOpsTable> {
  $$SyncOpsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncEntity, SyncEntity, String> get entity =>
      $composableBuilder(
        column: $table.entity,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<SyncOpKind, SyncOpKind, String> get op =>
      $composableBuilder(
        column: $table.op,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get localRowId => $composableBuilder(
    column: $table.localRowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get businessServerId => $composableBuilder(
    column: $table.businessServerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dedupeKey => $composableBuilder(
    column: $table.dedupeKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deadLettered => $composableBuilder(
    column: $table.deadLettered,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncOpsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncOpsTable> {
  $$SyncOpsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localRowId => $composableBuilder(
    column: $table.localRowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get businessServerId => $composableBuilder(
    column: $table.businessServerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dedupeKey => $composableBuilder(
    column: $table.dedupeKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deadLettered => $composableBuilder(
    column: $table.deadLettered,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncOpsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncOpsTable> {
  $$SyncOpsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncEntity, String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncOpKind, String> get op =>
      $composableBuilder(column: $table.op, builder: (column) => column);

  GeneratedColumn<String> get localRowId => $composableBuilder(
    column: $table.localRowId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<int> get businessServerId => $composableBuilder(
    column: $table.businessServerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get dedupeKey =>
      $composableBuilder(column: $table.dedupeKey, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get deadLettered => $composableBuilder(
    column: $table.deadLettered,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncOpsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncOpsTable,
          SyncOpRow,
          $$SyncOpsTableFilterComposer,
          $$SyncOpsTableOrderingComposer,
          $$SyncOpsTableAnnotationComposer,
          $$SyncOpsTableCreateCompanionBuilder,
          $$SyncOpsTableUpdateCompanionBuilder,
          (SyncOpRow, BaseReferences<_$AppDatabase, $SyncOpsTable, SyncOpRow>),
          SyncOpRow,
          PrefetchHooks Function()
        > {
  $$SyncOpsTableTableManager(_$AppDatabase db, $SyncOpsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOpsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOpsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOpsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<SyncEntity> entity = const Value.absent(),
                Value<SyncOpKind> op = const Value.absent(),
                Value<String> localRowId = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                Value<int?> businessServerId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<String> dedupeKey = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> nextAttemptAt = const Value.absent(),
                Value<bool> deadLettered = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SyncOpsCompanion(
                id: id,
                entity: entity,
                op: op,
                localRowId: localRowId,
                serverId: serverId,
                businessServerId: businessServerId,
                payload: payload,
                dedupeKey: dedupeKey,
                revision: revision,
                attempts: attempts,
                lastError: lastError,
                nextAttemptAt: nextAttemptAt,
                deadLettered: deadLettered,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required SyncEntity entity,
                required SyncOpKind op,
                required String localRowId,
                Value<int?> serverId = const Value.absent(),
                Value<int?> businessServerId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                required String dedupeKey,
                Value<int> revision = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> nextAttemptAt = const Value.absent(),
                Value<bool> deadLettered = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SyncOpsCompanion.insert(
                id: id,
                entity: entity,
                op: op,
                localRowId: localRowId,
                serverId: serverId,
                businessServerId: businessServerId,
                payload: payload,
                dedupeKey: dedupeKey,
                revision: revision,
                attempts: attempts,
                lastError: lastError,
                nextAttemptAt: nextAttemptAt,
                deadLettered: deadLettered,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncOpsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncOpsTable,
      SyncOpRow,
      $$SyncOpsTableFilterComposer,
      $$SyncOpsTableOrderingComposer,
      $$SyncOpsTableAnnotationComposer,
      $$SyncOpsTableCreateCompanionBuilder,
      $$SyncOpsTableUpdateCompanionBuilder,
      (SyncOpRow, BaseReferences<_$AppDatabase, $SyncOpsTable, SyncOpRow>),
      SyncOpRow,
      PrefetchHooks Function()
    >;
typedef $$SyncMetaTableCreateCompanionBuilder =
    SyncMetaCompanion Function({
      required String key,
      Value<String?> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$SyncMetaTableUpdateCompanionBuilder =
    SyncMetaCompanion Function({
      Value<String> key,
      Value<String?> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SyncMetaTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncMetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncMetaTable,
          SyncMetaData,
          $$SyncMetaTableFilterComposer,
          $$SyncMetaTableOrderingComposer,
          $$SyncMetaTableAnnotationComposer,
          $$SyncMetaTableCreateCompanionBuilder,
          $$SyncMetaTableUpdateCompanionBuilder,
          (
            SyncMetaData,
            BaseReferences<_$AppDatabase, $SyncMetaTable, SyncMetaData>,
          ),
          SyncMetaData,
          PrefetchHooks Function()
        > {
  $$SyncMetaTableTableManager(_$AppDatabase db, $SyncMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String?> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncMetaCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                Value<String?> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncMetaCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncMetaTable,
      SyncMetaData,
      $$SyncMetaTableFilterComposer,
      $$SyncMetaTableOrderingComposer,
      $$SyncMetaTableAnnotationComposer,
      $$SyncMetaTableCreateCompanionBuilder,
      $$SyncMetaTableUpdateCompanionBuilder,
      (
        SyncMetaData,
        BaseReferences<_$AppDatabase, $SyncMetaTable, SyncMetaData>,
      ),
      SyncMetaData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalUsersTableTableManager get localUsers =>
      $$LocalUsersTableTableManager(_db, _db.localUsers);
  $$LocalBusinessesTableTableManager get localBusinesses =>
      $$LocalBusinessesTableTableManager(_db, _db.localBusinesses);
  $$LocalMonthlySnapshotsTableTableManager get localMonthlySnapshots =>
      $$LocalMonthlySnapshotsTableTableManager(_db, _db.localMonthlySnapshots);
  $$LocalLedgerEntriesTableTableManager get localLedgerEntries =>
      $$LocalLedgerEntriesTableTableManager(_db, _db.localLedgerEntries);
  $$LocalHealthScoresTableTableManager get localHealthScores =>
      $$LocalHealthScoresTableTableManager(_db, _db.localHealthScores);
  $$LocalForecastsTableTableManager get localForecasts =>
      $$LocalForecastsTableTableManager(_db, _db.localForecasts);
  $$LocalRiskAlertsTableTableManager get localRiskAlerts =>
      $$LocalRiskAlertsTableTableManager(_db, _db.localRiskAlerts);
  $$LocalPlanActionsTableTableManager get localPlanActions =>
      $$LocalPlanActionsTableTableManager(_db, _db.localPlanActions);
  $$LocalStatesTableTableManager get localStates =>
      $$LocalStatesTableTableManager(_db, _db.localStates);
  $$LocalDistrictsTableTableManager get localDistricts =>
      $$LocalDistrictsTableTableManager(_db, _db.localDistricts);
  $$SyncOpsTableTableManager get syncOps =>
      $$SyncOpsTableTableManager(_db, _db.syncOps);
  $$SyncMetaTableTableManager get syncMeta =>
      $$SyncMetaTableTableManager(_db, _db.syncMeta);
}
