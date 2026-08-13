/// A planned or completed field visit (Officer Portal 5d, 5n).
library;

import 'package:flutter/foundation.dart';

import 'enterprise.dart';

/// Where a visit sits in the officer's week.
enum VisitStatus {
  /// Already carried out.
  done,

  /// The very next visit on the plan.
  next,

  /// Planned but further out.
  upcoming,
}

/// One row on the Visits screen (5d) — planned around a single enterprise.
@immutable
class Visit {
  /// Creates a visit.
  const Visit({
    required this.id,
    required this.enterpriseId,
    required this.enterpriseName,
    required this.village,
    required this.date,
    required this.agenda,
    required this.status,
    this.riskLevel,
    this.distanceKm,
  });

  /// Stable identifier.
  final String id;

  /// The enterprise this visit is for.
  final String enterpriseId;

  /// Denormalised for the list row (avoids a join on every build).
  final String enterpriseName;

  /// Denormalised village for the list row.
  final String village;

  /// Date and time of the visit.
  final DateTime date;

  /// What the visit is for, e.g. "EMI restructure paperwork".
  final String agenda;

  /// Where this visit sits in the week (done / next / upcoming).
  final VisitStatus status;

  /// The enterprise's risk level at planning time, for the row's chip.
  final RiskLevel? riskLevel;

  /// Distance from the officer's current location, in km.
  final double? distanceKm;

  /// A copy with [status] replaced — used when a new visit is inserted and
  /// bumps who counts as "next".
  Visit withStatus(VisitStatus status) {
    return Visit(
      id: id,
      enterpriseId: enterpriseId,
      enterpriseName: enterpriseName,
      village: village,
      date: date,
      agenda: agenda,
      status: status,
      riskLevel: riskLevel,
      distanceKm: distanceKm,
    );
  }
}
