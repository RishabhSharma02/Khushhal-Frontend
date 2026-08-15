/// Stand-in model output for the Officer Portal, while there is no backend.
///
/// Numbers mirror the approved "Officer Portal Hi-Fi" mocks (Ramesh Verma's
/// Sitapur beat, 1 Aug 2026) so every screen renders the scenario that was
/// signed off. Dates are pinned — nothing here reads the real clock, which
/// keeps the demo deterministic.
library;

import '../domain/action_step.dart';
import '../domain/contact_log.dart';
import '../domain/enterprise.dart';
import '../domain/forecast_month.dart';
import '../domain/officer_profile.dart';
import '../domain/report_summary.dart';
import '../domain/sync_status.dart';
import '../domain/visit.dart';

/// The demo scenario behind every Officer Portal screen.
abstract final class OfficerDemoData {
  /// The scenario's "today".
  static final DateTime today = DateTime(2026, 8, 1);

  // ── Officer ────────────────────────────────────────────────────────────

  /// The signed-in officer, before a session timestamp is stamped on.
  static final OfficerProfile officer = OfficerProfile(
    fullName: 'Ramesh Verma',
    employeeId: 'UP-SIT-0482',
    employeeIdVerified: true,
    pincode: '261001',
    block: 'Sitapur',
    state: 'UP',
    email: 'r.verma@khush-hal.in',
    mobile: '+91 94150 22331',
  );

  /// Demo "My coverage" stats — fetched from a real endpoint once signed
  /// in (see ProfileRepository.fetchCoverage), kept here only as fixture
  /// data for widget tests / the fake repository.
  static const OfficerCoverage coverage = OfficerCoverage(
    enterpriseCount: 48,
    villageCount: 17,
    visitsThisMonth: 17,
    flagsResolvedLast30Days: 11,
  );

  // ── Enterprises ────────────────────────────────────────────────────────

  /// The officer's enterprises. Six are the ones tabled on 5b; three more
  /// (Bhagwati SHG, Devi Poultry, Sona Tailors) only ever appear in the
  /// sync table (5f), but still need full records so that screen's rows can
  /// still be tapped through to a real detail page.
  static final List<Enterprise> enterprises = <Enterprise>[
    Enterprise(
      id: 'shanti-dairy',
      name: 'Shanti Dairy',
      icon: '🐄',
      segment: EnterpriseSegment.shg,
      sector: EnterpriseSector.dairy,
      village: 'Rampur',
      establishedYear: 2018,
      staffCount: 4,
      memberSince: DateTime(2025, 3, 1),
      contact: const EnterpriseContact(
        name: 'Sunita Devi',
        role: 'owner',
        phone: '+91 98765 43210',
        language: 'Hindi',
        bestTime: '6–8 pm',
      ),
      healthScore: 38,
      scoreRising: false,
      riskLevel: RiskLevel.atRisk,
      flagSummary: 'Nov gap ₹32k forecast',
      financials: const EnterpriseFinancials(
        cashOnHandInr: 28400,
        monthNetInr: 5200,
        savingsInr: 31000,
        loanLeftInr: 86000,
        emiInr: 8000,
      ),
      lastSyncHoursAgo: 2,
    ),
    Enterprise(
      id: 'gram-poultry-fpo',
      name: 'Gram Poultry FPO',
      icon: '🐔',
      segment: EnterpriseSegment.fpo,
      sector: EnterpriseSector.poultry,
      village: 'Khairabad',
      establishedYear: 2020,
      staffCount: 6,
      memberSince: DateTime(2024, 11, 1),
      contact: const EnterpriseContact(
        name: 'K. Yadav',
        role: 'treasurer',
        phone: '+91 91234 56789',
        language: 'Hindi',
        bestTime: '10 am – noon',
      ),
      healthScore: 34,
      scoreRising: false,
      riskLevel: RiskLevel.atRisk,
      flagSummary: 'EMI missed ×2',
      financials: const EnterpriseFinancials(
        cashOnHandInr: 11050,
        monthNetInr: -2400,
        savingsInr: 9000,
        loanLeftInr: 64000,
        emiInr: 6200,
      ),
      lastSyncHoursAgo: 24,
    ),
    Enterprise(
      id: 'meera-crafts',
      name: 'Meera Crafts',
      icon: '🧵',
      segment: EnterpriseSegment.shg,
      sector: EnterpriseSector.crafts,
      village: 'Biswan',
      establishedYear: 2019,
      staffCount: 5,
      memberSince: DateTime(2025, 1, 1),
      contact: const EnterpriseContact(
        name: 'Meera Ben',
        role: 'owner',
        phone: '+91 99887 66554',
        language: 'Hindi',
        bestTime: '4–6 pm',
      ),
      healthScore: 52,
      scoreRising: false,
      riskLevel: RiskLevel.watch,
      flagSummary: 'Income −40% vs norm',
      financials: const EnterpriseFinancials(
        cashOnHandInr: 19300,
        monthNetInr: 900,
        savingsInr: 14000,
        loanLeftInr: 22000,
        emiInr: 2500,
      ),
      lastSyncHoursAgo: 4,
    ),
    Enterprise(
      id: 'anaj-kirana',
      name: 'Anaj Kirana',
      icon: '🏪',
      segment: EnterpriseSegment.own,
      sector: EnterpriseSector.shop,
      village: 'Sitapur',
      establishedYear: 2016,
      staffCount: 2,
      memberSince: DateTime(2024, 6, 1),
      contact: const EnterpriseContact(
        name: 'R. Gupta',
        role: 'owner',
        phone: '+91 90909 12345',
        language: 'Hindi',
        bestTime: 'evenings',
      ),
      healthScore: 47,
      scoreRising: false,
      riskLevel: RiskLevel.watch,
      flagSummary: 'No entries 12 days',
      financials: const EnterpriseFinancials(
        cashOnHandInr: 16200,
        monthNetInr: 1100,
        savingsInr: 8000,
        loanLeftInr: 12000,
        emiInr: 1800,
      ),
      lastSyncHoursAgo: null,
      staleDays: 12,
    ),
    Enterprise(
      id: 'lakshmi-foods',
      name: 'Lakshmi Foods',
      icon: '🏭',
      segment: EnterpriseSegment.shg,
      sector: EnterpriseSector.foodProcessing,
      village: 'Mahmudabad',
      establishedYear: 2015,
      staffCount: 9,
      memberSince: DateTime(2023, 9, 1),
      contact: const EnterpriseContact(
        name: 'L. Sharma',
        role: 'owner',
        phone: '+91 93456 78901',
        language: 'Hindi',
        bestTime: '9–11 am',
      ),
      healthScore: 74,
      scoreRising: true,
      riskLevel: RiskLevel.healthy,
      flagSummary: null,
      financials: const EnterpriseFinancials(
        cashOnHandInr: 52700,
        monthNetInr: 8600,
        savingsInr: 61000,
        loanLeftInr: 40000,
        emiInr: 7000,
      ),
      lastSyncHoursAgo: 1,
    ),
    Enterprise(
      id: 'kisan-dugdh-fpo',
      name: 'Kisan Dugdh FPO',
      icon: '🐄',
      segment: EnterpriseSegment.fpo,
      sector: EnterpriseSector.dairy,
      village: 'Laharpur',
      establishedYear: 2012,
      staffCount: 14,
      memberSince: DateTime(2022, 4, 1),
      contact: const EnterpriseContact(
        name: 'S. Singh',
        role: 'treasurer',
        phone: '+91 97654 32109',
        language: 'Hindi',
        bestTime: 'mornings',
      ),
      healthScore: 81,
      scoreRising: true,
      riskLevel: RiskLevel.healthy,
      flagSummary: null,
      financials: const EnterpriseFinancials(
        cashOnHandInr: 104000,
        monthNetInr: 15200,
        savingsInr: 132000,
        loanLeftInr: 28000,
        emiInr: 9000,
      ),
      lastSyncHoursAgo: 0,
    ),
    Enterprise(
      id: 'bhagwati-shg',
      name: 'Bhagwati SHG',
      icon: '🧵',
      segment: EnterpriseSegment.shg,
      sector: EnterpriseSector.crafts,
      village: 'Tambaur',
      establishedYear: 2021,
      staffCount: 6,
      memberSince: DateTime(2024, 8, 1),
      contact: const EnterpriseContact(
        name: 'Kamla Devi',
        role: 'owner',
        phone: '+91 92233 44556',
        language: 'Hindi',
        bestTime: '6–8 pm',
      ),
      healthScore: 55,
      scoreRising: false,
      riskLevel: RiskLevel.watch,
      flagSummary: 'Poor network zone — offline entries safe',
      financials: const EnterpriseFinancials(
        cashOnHandInr: 13400,
        monthNetInr: 600,
        savingsInr: 7000,
        loanLeftInr: 9000,
        emiInr: 1200,
      ),
      lastSyncHoursAgo: null,
      staleDays: 9,
    ),
    Enterprise(
      id: 'devi-poultry',
      name: 'Devi Poultry',
      icon: '🐔',
      segment: EnterpriseSegment.own,
      sector: EnterpriseSector.poultry,
      village: 'Khairabad',
      establishedYear: 2019,
      staffCount: 3,
      memberSince: DateTime(2024, 2, 1),
      contact: const EnterpriseContact(
        name: 'Devi Prasad',
        role: 'owner',
        phone: '+91 90011 22334',
        language: 'Hindi',
        bestTime: 'afternoons',
      ),
      healthScore: 44,
      scoreRising: false,
      riskLevel: RiskLevel.watch,
      flagSummary: 'Phone changed? OTP re-login needed',
      financials: const EnterpriseFinancials(
        cashOnHandInr: 8100,
        monthNetInr: -300,
        savingsInr: 4000,
        loanLeftInr: 15000,
        emiInr: 1900,
      ),
      lastSyncHoursAgo: null,
      staleDays: 8,
    ),
    Enterprise(
      id: 'sona-tailors',
      name: 'Sona Tailors',
      icon: '🧵',
      segment: EnterpriseSegment.own,
      sector: EnterpriseSector.crafts,
      village: 'Biswan',
      establishedYear: 2017,
      staffCount: 2,
      memberSince: DateTime(2023, 12, 1),
      contact: const EnterpriseContact(
        name: 'Sona Lal',
        role: 'owner',
        phone: '+91 98800 11223',
        language: 'Hindi',
        bestTime: 'evenings',
      ),
      healthScore: 49,
      scoreRising: false,
      riskLevel: RiskLevel.watch,
      flagSummary: 'Syncing but not entering — re-train habit',
      financials: const EnterpriseFinancials(
        cashOnHandInr: 10600,
        monthNetInr: 200,
        savingsInr: 6000,
        loanLeftInr: 5000,
        emiInr: 800,
      ),
      lastSyncHoursAgo: 24,
    ),
  ];

  /// Looks up an enterprise by id, falling back to the first one so demo
  /// deep links never crash.
  static Enterprise enterpriseById(String id) {
    return enterprises.firstWhere(
      (Enterprise e) => e.id == id,
      orElse: () => enterprises.first,
    );
  }

  // ── Dashboard ──────────────────────────────────────────────────────────

  /// Total enterprise count shown on the dashboard (48 — more than the 9
  /// fully modelled above; the rest are represented in aggregate only).
  static const int totalEnterpriseCount = 48;

  /// Enterprises currently healthy, over the last 6 months.
  static const int healthyCount = 31;

  /// Enterprises on watch.
  static const int watchCount = 10;

  /// Enterprises at risk.
  static const int atRiskCount = 7;

  /// Average health score across all 48, oldest first, one point a month.
  static const List<int> averageScoreHistory = <int>[52, 55, 54, 58, 57, 61];

  /// Change in average score vs. the previous period.
  static const int averageScoreDelta = 4;

  /// Currently open flags.
  static const int openFlagCount = 7;

  /// Change in open-flag count vs. the previous period.
  static const int openFlagDelta = -3;

  /// Visits completed this week, out of [visitsPlannedThisWeek].
  static const int visitsDoneThisWeek = 2;

  /// Visits planned this week.
  static const int visitsPlannedThisWeek = 3;

  /// Enterprises that haven't synced in 7+ days (mirrors [syncStatuses]'
  /// stale count).
  static const int staleSyncCount = 9;

  // ── Visits ─────────────────────────────────────────────────────────────

  /// The officer's visit plan for the week of 1 Aug 2026.
  static final List<Visit> visits = <Visit>[
    Visit(
      id: 'visit-shanti-dairy-jul28',
      enterpriseId: 'shanti-dairy',
      enterpriseName: 'Shanti Dairy',
      village: 'Rampur',
      date: DateTime(2026, 7, 28, 9, 30),
      agenda:
          'Nov cash-gap plan walked through · fodder stock checked · '
          'passbook verified',
      status: VisitStatus.done,
    ),
    Visit(
      id: 'visit-gram-poultry-aug6',
      enterpriseId: 'gram-poultry-fpo',
      enterpriseName: 'Gram Poultry FPO',
      village: 'Khairabad',
      date: DateTime(2026, 8, 6, 11, 30),
      agenda:
          'EMI restructure paperwork · bring bank form 12-C · meet treasurer',
      status: VisitStatus.next,
      riskLevel: RiskLevel.atRisk,
      distanceKm: 11,
    ),
    Visit(
      id: 'visit-meera-crafts-aug8',
      enterpriseId: 'meera-crafts',
      enterpriseName: 'Meera Crafts SHG',
      village: 'Biswan',
      date: DateTime(2026, 8, 8, 14, 0),
      agenda: 'Income dip — check order pipeline · Diwali bulk-buyer lead',
      status: VisitStatus.upcoming,
      riskLevel: RiskLevel.watch,
      distanceKm: 8,
    ),
    Visit(
      id: 'visit-anaj-kirana-aug8',
      enterpriseId: 'anaj-kirana',
      enterpriseName: 'Anaj Kirana',
      village: 'Sitapur',
      date: DateTime(2026, 8, 8, 16, 30),
      agenda: 'No app entries for 12 days — re-train daily entry, check phone',
      status: VisitStatus.upcoming,
      riskLevel: RiskLevel.watch,
      distanceKm: 3,
    ),
  ];

  // ── Enterprise detail (5c) ────────────────────────────────────────────

  /// Shanti Dairy's 12-month cash flow: 6 recorded, 6 forecast, Nov flagged.
  static final List<CashFlowMonth> shantiDairyCashFlow = _cashFlow(
    labels: const <String>[
      "Feb '26",
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
      "Jan '27",
    ],
    moneyIn: const <int>[
      38000,
      40000,
      39000,
      42000,
      41000,
      44000,
      40000,
      39000,
      37000,
      28000,
      37000,
      39000,
    ],
    moneyOut: const <int>[
      32000,
      33000,
      31000,
      34000,
      33000,
      35000,
      33000,
      32000,
      31000,
      60000,
      32000,
      31000,
    ],
    flaggedIndex: 9,
  );

  /// A generic 12-month cash flow for enterprises without a bespoke one —
  /// gently trending from the enterprise's current numbers, flagged at the
  /// enterprise's own [Enterprise.flagSummary] month when it has one.
  static List<CashFlowMonth> cashFlowFor(Enterprise enterprise) {
    if (enterprise.id == 'shanti-dairy') {
      return shantiDairyCashFlow;
    }

    final int baseIn = enterprise.financials.cashOnHandInr ~/ 2 + 15000;
    final int baseOut = baseIn - enterprise.financials.monthNetInr;
    final bool flagged = enterprise.flagSummary != null;

    return _cashFlow(
      labels: const <String>[
        "Feb '26",
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
        "Jan '27",
      ],
      moneyIn: List<int>.generate(12, (int i) => baseIn + (i - 6) * 400),
      moneyOut: List<int>.generate(
        12,
        (int i) => baseOut + (flagged && i == 9 ? 9000 : (i - 6) * 300),
      ),
      flaggedIndex: flagged ? 9 : null,
    );
  }

  static List<CashFlowMonth> _cashFlow({
    required List<String> labels,
    required List<int> moneyIn,
    required List<int> moneyOut,
    int? flaggedIndex,
  }) {
    return List<CashFlowMonth>.generate(labels.length, (int i) {
      return CashFlowMonth(
        label: labels[i],
        moneyInInr: moneyIn[i],
        moneyOutInr: moneyOut[i],
        netInr: i >= 6 ? moneyIn[i] - moneyOut[i] : null,
        isForecast: i >= 6,
        isFlagged: i == flaggedIndex,
      );
    });
  }

  /// Shanti Dairy's AI-flag narrative for the November gap.
  static const String shantiDairyFlagNarrative =
      'November OUT exceeds IN by ~₹32,000. Drivers: fodder ↑14% (Sitapur '
      'mandi), EMI ₹8,000, seasonal milk dip.';

  /// Shanti Dairy's cash-gap action plan.
  static const List<ActionStep> shantiDairyActionPlan = <ActionStep>[
    ActionStep(
      order: 1,
      title: 'Now — start ₹500/week buffer',
      detail: 'begin by 8 Aug · adds ₹6,000 by Nov',
      impact: ActionStepImpact.high,
    ),
    ActionStep(
      order: 2,
      title: 'Aug — group fodder purchase with SHG',
      detail: 'before the price rise · saves ~₹2,500',
      impact: ActionStepImpact.medium,
    ),
    ActionStep(
      order: 3,
      title: 'Sep — shift EMI to milk-payment week',
      detail: 'bank form 12-C · eases Nov by ₹8,000',
      impact: ActionStepImpact.low,
    ),
  ];

  /// Shanti Dairy's visit/call history.
  static final List<ContactLogEntry> shantiDairyHistory = <ContactLogEntry>[
    ContactLogEntry(
      date: DateTime(2026, 7, 28),
      kind: ContactKind.visit,
      note: 'verified stock, passbook ✓',
    ),
    ContactLogEntry(
      date: DateTime(2026, 7, 15),
      kind: ContactKind.call,
      note: 'EMI reminder, entry gap fixed',
    ),
    ContactLogEntry(
      date: DateTime(2026, 6, 2),
      kind: ContactKind.visit,
      note: 'onboarded, trained voice entry',
    ),
  ];

  /// Action plan for an enterprise — only Shanti Dairy has a bespoke one in
  /// the mocks; others fall back to an empty plan (no open cash-gap flag).
  static List<ActionStep> actionPlanFor(Enterprise enterprise) {
    return enterprise.id == 'shanti-dairy' ? shantiDairyActionPlan : const [];
  }

  /// Contact history for an enterprise — Shanti Dairy's is the one shown in
  /// the mocks; others get a single onboarding entry.
  static List<ContactLogEntry> contactHistoryFor(Enterprise enterprise) {
    if (enterprise.id == 'shanti-dairy') {
      return shantiDairyHistory;
    }
    return <ContactLogEntry>[
      ContactLogEntry(
        date: enterprise.memberSince,
        kind: ContactKind.visit,
        note: 'onboarded, trained voice entry',
      ),
    ];
  }

  /// Data-quality stats for an enterprise's detail page.
  static ({int entryStreakDaysPerWeek, int forecastConfidencePercent})
  dataQualityFor(Enterprise enterprise) {
    return enterprise.riskLevel == RiskLevel.healthy
        ? (entryStreakDaysPerWeek: 6, forecastConfidencePercent: 88)
        : enterprise.riskLevel == RiskLevel.watch
        ? (entryStreakDaysPerWeek: 4, forecastConfidencePercent: 65)
        : (entryStreakDaysPerWeek: 6, forecastConfidencePercent: 78);
  }

  // ── Data sync (5f) ─────────────────────────────────────────────────────

  /// Synced within the last 24 hours.
  static const int syncedUnder24hCount = 35;

  /// Synced 1–7 days ago.
  static const int synced1To7DaysCount = 4;

  /// Stale for 7+ days.
  static const int syncedStale7PlusCount = 9;

  /// Entries missing for 5+ days.
  static const int entryGap5PlusCount = 6;

  /// The stale-device table.
  static const List<DeviceSyncStatus> syncStatuses = <DeviceSyncStatus>[
    DeviceSyncStatus(
      enterpriseId: 'anaj-kirana',
      enterpriseName: 'Anaj Kirana',
      village: 'Sitapur',
      lastSyncDays: 12,
      lastEntryDays: 12,
      pendingEstimateLabel: '~14 entries',
      likelyCause: 'stopped using app? was regular before',
      actionKind: SyncActionKind.call,
      actionLabel: '📞 Call',
    ),
    DeviceSyncStatus(
      enterpriseId: 'devi-poultry',
      enterpriseName: 'Devi Poultry',
      village: 'Khairabad',
      lastSyncDays: 8,
      lastEntryDays: 8,
      pendingEstimateLabel: 'unknown',
      likelyCause: 'phone changed? OTP re-login needed',
      actionKind: SyncActionKind.resendLogin,
      actionLabel: '📩 Re-login link',
    ),
    DeviceSyncStatus(
      enterpriseId: 'sona-tailors',
      enterpriseName: 'Sona Tailors',
      village: 'Biswan',
      lastSyncDays: 1,
      lastEntryDays: 6,
      pendingEstimateLabel: '0',
      likelyCause: 'syncing but not entering — re-train entry habit',
      actionKind: SyncActionKind.addToRoute,
      actionLabel: '🗓 Add to visit',
    ),
  ];

  // ── Reports (5e) ───────────────────────────────────────────────────────

  /// The month-in-review shown on the Reports screen.
  static const ReportSummary reportSummary = ReportSummary(
    monthLabel: 'July 2026',
    comparedToLabel: 'Compared with June',
    averageHealthScore: 61,
    averageHealthScoreDelta: 4,
    flagsResolved: 11,
    flagsOpened: 14,
    averageResolutionDays: 6,
    visitsDone: 17,
    riskLedVisits: 12,
    sectorScores: <SectorScore>[
      SectorScore(
        icon: '🐄',
        label: 'Dairy',
        enterpriseCount: 14,
        averageScore: 72,
      ),
      SectorScore(
        icon: '🏭',
        label: 'Food',
        enterpriseCount: 8,
        averageScore: 66,
      ),
      SectorScore(
        icon: '🏪',
        label: 'Shops',
        enterpriseCount: 9,
        averageScore: 58,
      ),
      SectorScore(
        icon: '🧵',
        label: 'Crafts',
        enterpriseCount: 11,
        averageScore: 54,
      ),
      SectorScore(
        icon: '🐔',
        label: 'Poultry',
        enterpriseCount: 6,
        averageScore: 41,
      ),
    ],
    insight:
        'Poultry dragging the block — feed price ↑ hit all 6 units. Consider '
        'group feed procurement (worked for dairy in May).',
    forecastAccuracy: ForecastAccuracy(
      predictedVsActualLabel: '±9%',
      flagsThatCameTrue: 8,
      flagsRaised: 10,
      falseAlarms: 2,
    ),
    appAdoption: AppAdoption(
      enterprisesWithStreak: 29,
      totalEnterprises: 48,
      voiceEntryUsers: 21,
      activeSavingsPlans: 18,
    ),
  );
}
