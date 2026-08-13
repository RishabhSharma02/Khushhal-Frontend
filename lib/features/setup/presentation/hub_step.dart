/// Business setup hub (design 1j).
library;

import 'package:flutter/material.dart';

import '../../../app/model/business.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/gradient_cta_button.dart';
import '../../../core/widgets/khushhal_card.dart';
import '../../../core/widgets/secondary_cta_button.dart';
import '../../../l10n/app_localizations.dart';

/// Hub-and-spoke: each Start setup runs setup 3–5 for one business and
/// returns here with a check. Finish unlocks after the first one.
class HubStep extends StatelessWidget {
  /// Creates the hub.
  const HubStep({
    super.key,
    required this.planned,
    required this.businesses,
    required this.onStartSetup,
    required this.onFinish,
    this.onBack,
  });

  /// How many businesses design 1i planned for. `4` represents "4+" and
  /// unlocks unlimited additions via the "Add new business" tile below.
  final int planned;

  /// The ones set up so far.
  final List<Business> businesses;

  /// Starts the 1k–1m subflow for the next business.
  final VoidCallback onStartSetup;

  /// Leaves setup; only offered once at least one business is done.
  final VoidCallback onFinish;

  /// Optional — renders a leading back button in the header when provided.
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final int done = businesses.length;
    final bool unlimited = planned >= 4;

    // How many rows to render before the persistent "Add new business" tile.
    // - Fixed count (1..3): show all done + placeholders up to `planned`.
    // - 4+ (unlimited): show all done + one active "Next up" until finished.
    final int rowCount = unlimited
        ? (done + 1)
        : (done < planned ? planned : done);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 4),
          // A Wrap, not a Row: at large text sizes the done-count drops to
          // its own line instead of squeezing the title out of existence.
          child: Row(
            children: <Widget>[
              if (onBack != null)
                _BackChip(onTap: onBack!),
              if (onBack != null) const SizedBox(width: 8),
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 10,
                  children: <Widget>[
                    Text(
                      l10n.hubTitle,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppPalette.muted,
                      ),
                    ),
                    Text(
                      unlimited
                          ? l10n.hubDoneOf(done, done > planned ? done : planned)
                          : l10n.hubDoneOf(done, planned),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppPalette.forest,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 14, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  l10n.hubHeading,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.ink,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 16),
                for (int i = 0; i < rowCount; i++) ...<Widget>[
                  if (i > 0) const SizedBox(height: 10),
                  if (i < done)
                    _DoneCard(index: i, business: businesses[i])
                  else if (i == done)
                    _NextUpCard(index: i, onStart: onStartSetup)
                  else
                    _WaitingCard(index: i),
                ],
                // Explicit "Add new business" tile — always visible so the
                // user has a clear entry point even after all planned slots
                // are done (required for the 4+ path, harmless otherwise).
                if (done > 0 && (unlimited || done < planned)) ...<Widget>[
                  const SizedBox(height: 10),
                  _AddAnotherCard(onTap: onStartSetup),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        if (done > 0)
          GradientCtaButton(
            label: l10n.hubFinishCta,
            icon: Icons.check_rounded,
            onPressed: onFinish,
          )
        else
          SecondaryCtaButton(
            label: l10n.hubFinishCta,
            enabled: false,
            onPressed: onFinish,
          ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 4),
          child: Text(
            l10n.hubFinishHint,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: AppPalette.hint),
          ),
        ),
      ],
    );
  }
}

/// Small back chip rendered inline with the hub header — mirrors the back
/// affordance the setup subflow (kind → details → money) offers.
class _BackChip extends StatelessWidget {
  const _BackChip({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 22,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppPalette.onPrimary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppPalette.line, width: 1.5),
        ),
        child: const Icon(Icons.arrow_back_rounded, size: 18, color: AppPalette.forest),
      ),
    );
  }
}

/// Dashed "Add new business" tile shown below the last row of the hub.
class _AddAnotherCard extends StatelessWidget {
  const _AddAnotherCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Material(
      color: AppPalette.mintNote,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppPalette.idle, width: 1.5),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: AppPalette.mintChip,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.add_rounded, size: 20, color: AppPalette.leaf),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.hubAddAnother,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.leaf,
                    height: 1.3,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, size: 18, color: AppPalette.leaf),
            ],
          ),
        ),
      ),
    );
  }
}

/// The numbered circle at the head of each hub card.
class _IndexBadge extends StatelessWidget {
  const _IndexBadge({required this.index, required this.active});

  final int index;

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? AppPalette.mintChip : const Color(0xFFEFF5EF),
      ),
      child: Text(
        '${index + 1}',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: active ? AppPalette.forest : AppPalette.hint,
        ),
      ),
    );
  }
}

/// A business already set up — collapsed, with its typed name and a check.
class _DoneCard extends StatelessWidget {
  const _DoneCard({required this.index, required this.business});

  final int index;

  final Business business;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return KhushhalCard(
      radius: 18,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: <Widget>[
          _IndexBadge(index: index, active: true),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  business.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.cardInk,
                  ),
                ),
                Text(
                  l10n.hubStatusDone,
                  style: const TextStyle(fontSize: 12, color: AppPalette.leaf),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle, size: 22, color: AppPalette.leaf),
        ],
      ),
    );
  }
}

/// The next business to set up — expanded with its checklist and the start
/// button.
class _NextUpCard extends StatelessWidget {
  const _NextUpCard({required this.index, required this.onStart});

  final int index;

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return KhushhalCard(
      radius: 18,
      highlighted: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              _IndexBadge(index: index, active: true),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      l10n.businessN(index + 1),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppPalette.cardInk,
                      ),
                    ),
                    Text(
                      l10n.hubStatusNotStarted,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppPalette.hint,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.expand_more, size: 20, color: AppPalette.hint),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.only(top: 12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFEAF2EA))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _TaskRow(label: l10n.hubTaskKind),
                const SizedBox(height: 9),
                _TaskRow(label: l10n.hubTaskDetails),
                const SizedBox(height: 9),
                _TaskRow(label: l10n.hubTaskMoney),
                const SizedBox(height: 11),
                Material(
                  color: Colors.transparent,
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[AppPalette.leaf, AppPalette.sprout],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: InkWell(
                      onTap: onStart,
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        alignment: Alignment.center,
                        child: Text(
                          l10n.hubStartCta,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppPalette.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One pending line of the expanded card's checklist.
class _TaskRow extends StatelessWidget {
  const _TaskRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppPalette.body),
          ),
        ),
        Text(
          l10n.hubTaskPending,
          style: const TextStyle(fontSize: 13, color: AppPalette.idle),
        ),
      ],
    );
  }
}

/// A business further down the queue — collapsed and dimmed.
class _WaitingCard extends StatelessWidget {
  const _WaitingCard({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return KhushhalCard(
      radius: 18,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: <Widget>[
          _IndexBadge(index: index, active: false),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.businessN(index + 1),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.cardInk,
                  ),
                ),
                Text(
                  l10n.hubStatusNotStarted,
                  style: const TextStyle(fontSize: 12, color: AppPalette.hint),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 20, color: AppPalette.hint),
        ],
      ),
    );
  }
}
