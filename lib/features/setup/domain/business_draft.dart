/// The in-progress answers while one business walks setup 3–5 (1k–1m).
library;

import '../../../app/model/business.dart';

/// Mutable scratch state for the per-business subflow.
///
/// Defaults mirror the mocks' preselected states, so every step can be
/// confirmed with a tap and typing stays optional everywhere except the
/// name.
class BusinessDraft {
  /// Who runs it (1k, top row).
  BusinessSegment segment = BusinessSegment.shg;

  /// Line of work (1k, bottom grid).
  BusinessSector sector = BusinessSector.dairy;

  /// Running-since chip (1l).
  BusinessTenure tenure = BusinessTenure.threeToTenYears;

  /// People working, including the owner (1l).
  int staffCount = 1;

  /// Business name — the only typed field in setup (1l).
  String name = '';

  /// Which money mode the user is on (1m vs 1n).
  MoneyBasis basis = MoneyBasis.roughEstimate;

  /// Slider values for rough-estimate mode (1m), in rupees.
  double roughIn = 45000;

  /// Costs slider.
  double roughOut = 30000;

  /// EMI slider.
  double roughEmi = 8000;

  /// Savings slider.
  double roughSavings = 40000;

  /// Builds the finished record; [fallbackName] covers an empty name field.
  Business build({
    required String fallbackName,
    required MonthlyMoney monthly,
  }) {
    final String trimmed = name.trim();

    return Business(
      name: trimmed.isEmpty ? fallbackName : trimmed,
      segment: segment,
      sector: sector,
      tenure: tenure,
      staffCount: staffCount,
      monthly: monthly,
      // The wizard's savings figure is this business's opening balance, and
      // the backend seeds the same value from the create payload. Setting it
      // here means Home's savings tile is right before the first list refresh
      // comes back.
      savingsInr: monthly.savings,
      // The wizard only asks for a monthly EMI — surface that on Home's
      // loan tile as an initial value so it isn't zero after onboarding.
      // The owner can replace it with the true outstanding balance from
      // the savings & loan screen.
      loanInr: monthly.loanEmi,
    );
  }
}
