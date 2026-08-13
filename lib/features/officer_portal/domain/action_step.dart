/// One step of an enterprise's cash-gap action plan (Officer Portal 5c).
library;

import 'package:flutter/foundation.dart';

/// How much moving the needle a step is expected to have.
enum ActionStepImpact {
  /// Small or incidental effect.
  low,

  /// Meaningful but not decisive.
  medium,

  /// A major contributor to closing the gap.
  high;

  /// The label shown on the step's impact chip, e.g. "High".
  String get label => switch (this) {
    ActionStepImpact.low => 'Low',
    ActionStepImpact.medium => 'Medium',
    ActionStepImpact.high => 'High',
  };
}

/// A single, ordered step in an enterprise's action plan.
@immutable
class ActionStep {
  /// Creates a step.
  const ActionStep({
    required this.order,
    required this.title,
    required this.detail,
    required this.impact,
  });

  /// 1-based position — the order it must happen in.
  final int order;

  /// Short bold title, e.g. "Now — start ₹500/week buffer".
  final String title;

  /// Supporting detail line.
  final String detail;

  /// How much this step is expected to move the needle.
  final ActionStepImpact impact;
}
