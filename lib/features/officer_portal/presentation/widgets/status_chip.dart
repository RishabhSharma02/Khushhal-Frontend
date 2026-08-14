/// The small rounded status pill (".chip cg/cy/cr/cn" in the mocks).
library;

import 'package:flutter/material.dart';

import '../../domain/enterprise.dart';
import '../theme/officer_palette.dart';

/// Which color a [StatusChip] or [StatusDot] renders in.
enum OfficerTone {
  /// Positive / healthy.
  green,

  /// Caution / watch.
  amber,

  /// Negative / at risk.
  red,

  /// No particular status.
  neutral,
}

/// Maps a business [RiskLevel] to its chip/dot [OfficerTone].
extension RiskLevelTone on RiskLevel {
  /// The tone this risk level renders as everywhere in the portal.
  OfficerTone get tone => switch (this) {
    RiskLevel.healthy => OfficerTone.green,
    RiskLevel.watch => OfficerTone.amber,
    RiskLevel.atRisk => OfficerTone.red,
  };

  /// The short label used on chips, e.g. "at risk".
  String get label => switch (this) {
    RiskLevel.healthy => 'healthy',
    RiskLevel.watch => 'watch',
    RiskLevel.atRisk => 'at risk',
  };
}

(Color bg, Color fg) _chipColors(OfficerTone tone) => switch (tone) {
  OfficerTone.green => (
    OfficerPalette.chipGreenBg,
    OfficerPalette.chipGreenInk,
  ),
  OfficerTone.amber => (
    OfficerPalette.chipAmberBg,
    OfficerPalette.chipAmberInk,
  ),
  OfficerTone.red => (OfficerPalette.chipRedBg, OfficerPalette.chipRedInk),
  OfficerTone.neutral => (
    OfficerPalette.chipNeutralBg,
    OfficerPalette.chipNeutralInk,
  ),
};

/// A small bold rounded-pill label, colored by [tone].
class StatusChip extends StatelessWidget {
  /// Creates a status chip.
  const StatusChip({
    super.key,
    required this.label,
    this.tone = OfficerTone.neutral,
    this.dense = false,
  });

  /// The chip's text.
  final String label;

  /// The chip's color tone.
  final OfficerTone tone;

  /// A slightly smaller variant used inline in table rows.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg) = _chipColors(tone);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 8 : 10,
        vertical: dense ? 1 : 3,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: dense ? 10 : 11,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

/// A small filled circle used as a compact status indicator.
class StatusDot extends StatelessWidget {
  /// Creates a status dot.
  const StatusDot({super.key, this.tone = OfficerTone.neutral, this.size = 10});

  /// The dot's color tone.
  final OfficerTone tone;

  /// Diameter in logical pixels.
  final double size;

  @override
  Widget build(BuildContext context) {
    final Color color = switch (tone) {
      OfficerTone.green => OfficerPalette.statusGreen,
      OfficerTone.amber => OfficerPalette.statusAmber,
      OfficerTone.red => OfficerPalette.statusRed,
      OfficerTone.neutral => OfficerPalette.muted,
    };

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
