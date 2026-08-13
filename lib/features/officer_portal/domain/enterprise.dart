/// The enterprises a field officer covers (Officer Portal 5a–5c).
library;

import 'package:flutter/foundation.dart';

/// Overall standing, driving every status dot/chip across the portal.
enum RiskLevel {
  /// Score comfortably above the healthy threshold.
  healthy,

  /// Slipping — worth a look before it becomes a flag.
  watch,

  /// An open flag needs action now.
  atRisk,
}

/// Who runs the enterprise — mirrors the consumer app's `BusinessSegment`
/// but kept separate since the officer portal reads it as free-form text
/// from the block register rather than from guided setup.
enum EnterpriseSegment {
  /// Self-help group.
  shg,

  /// Farmer producer organisation.
  fpo,

  /// Sole owner.
  own,
}

/// Line of work, each with its own icon on 5b/5c.
enum EnterpriseSector { dairy, poultry, foodProcessing, crafts, shop, other }

/// A field contact reachable about the enterprise (5c's contact card).
@immutable
class EnterpriseContact {
  /// Creates a contact.
  const EnterpriseContact({
    required this.name,
    required this.role,
    required this.phone,
    required this.language,
    required this.bestTime,
  });

  /// Contact's name.
  final String name;

  /// Their role, e.g. "owner".
  final String role;

  /// Phone number, as dialled.
  final String phone;

  /// Preferred spoken language.
  final String language;

  /// Best time to call, e.g. "6–8 pm".
  final String bestTime;
}

/// The money figures shown on the enterprise detail's stat row (5c).
@immutable
class EnterpriseFinancials {
  /// Creates a financial snapshot.
  const EnterpriseFinancials({
    required this.cashOnHandInr,
    required this.monthNetInr,
    required this.savingsInr,
    required this.loanLeftInr,
    required this.emiInr,
    required this.emiOnTime,
  });

  /// Cash on hand today.
  final int cashOnHandInr;

  /// Net money in minus out this month (may be negative).
  final int monthNetInr;

  /// Savings balance.
  final int savingsInr;

  /// Loan principal remaining.
  final int loanLeftInr;

  /// Monthly EMI.
  final int emiInr;

  /// Whether EMIs are currently on time.
  final bool emiOnTime;
}

/// One enterprise on the officer's beat.
@immutable
class Enterprise {
  /// Creates an enterprise record.
  const Enterprise({
    required this.id,
    required this.name,
    required this.icon,
    required this.segment,
    required this.sector,
    required this.village,
    required this.establishedYear,
    required this.staffCount,
    required this.memberSince,
    required this.contact,
    required this.healthScore,
    required this.scoreRising,
    required this.riskLevel,
    required this.flagSummary,
    required this.financials,
    required this.lastSyncHoursAgo,
    this.staleDays,
  });

  /// Stable identifier, used for routing between list and detail.
  final String id;

  /// Enterprise name, e.g. "Shanti Dairy".
  final String name;

  /// The emoji used as its icon across the portal.
  final String icon;

  /// Who runs it.
  final EnterpriseSegment segment;

  /// Line of work.
  final EnterpriseSector sector;

  /// Village / block.
  final String village;

  /// Year it was established.
  final int establishedYear;

  /// People working, including the owner.
  final int staffCount;

  /// When this enterprise joined Khushhal.
  final DateTime memberSince;

  /// Primary contact for calls and visits.
  final EnterpriseContact contact;

  /// Current business-health score, 0–100.
  final int healthScore;

  /// Whether the score moved up (▲) or down (▼) this period.
  final bool scoreRising;

  /// Current standing.
  final RiskLevel riskLevel;

  /// Short human-readable reason for the current flag, if any.
  final String? flagSummary;

  /// The stat-row money figures.
  final EnterpriseFinancials financials;

  /// Hours since the device last synced; `null` reads as "stale".
  final int? lastSyncHoursAgo;

  /// Days since last sync, once it has gone stale (7+ days).
  final int? staleDays;

  /// A short "sector · type" label for table rows.
  String get typeSectorLabel {
    final String segmentLabel = switch (segment) {
      EnterpriseSegment.shg => 'SHG',
      EnterpriseSegment.fpo => 'FPO',
      EnterpriseSegment.own => 'Own',
    };
    final String sectorLabel = switch (sector) {
      EnterpriseSector.dairy => 'Dairy',
      EnterpriseSector.poultry => 'Poultry',
      EnterpriseSector.foodProcessing => 'Food proc.',
      EnterpriseSector.crafts => 'Crafts',
      EnterpriseSector.shop => 'Shop',
      EnterpriseSector.other => 'Other',
    };
    return '$segmentLabel · $icon $sectorLabel';
  }
}
