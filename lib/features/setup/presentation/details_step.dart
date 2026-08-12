/// Setup 4 · Business details (design 1l).
library;

import 'package:flutter/material.dart';

import '../../../app/labels.dart';
import '../../../app/model/business.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/choice_pill.dart';
import '../../../core/widgets/gradient_cta_button.dart';
import '../../../core/widgets/khushhal_card.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/business_draft.dart';
import 'widgets/setup_progress_header.dart';
import 'widgets/step_page.dart';

/// Only the name needs typing; year and staff are chips and a stepper.
class DetailsStep extends StatefulWidget {
  /// Creates the details step for business [businessNumber].
  const DetailsStep({
    super.key,
    required this.draft,
    required this.businessNumber,
    required this.onNext,
    this.standalone = false,
  });

  /// The draft being filled in.
  final BusinessDraft draft;

  /// 1-based position of this business, for the header.
  final int businessNumber;

  /// Advances to monthly money (1m).
  final VoidCallback onNext;

  /// True when opened as Settings → Add business (see [KindStep.standalone]).
  final bool standalone;

  @override
  State<DetailsStep> createState() => _DetailsStepState();
}

class _DetailsStepState extends State<DetailsStep> {
  late final TextEditingController _name = TextEditingController(
    text: widget.draft.name,
  );

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final BusinessDraft draft = widget.draft;

    return StepPage(
      header: SetupProgressHeader(
        label: l10n.setupStepOfBusiness(
          widget.standalone ? 2 : 4,
          widget.standalone ? 3 : 5,
          l10n.businessN(widget.businessNumber),
        ),
        filled: widget.standalone ? 2 : 4,
        total: widget.standalone ? 3 : 5,
      ),
      cta: GradientCtaButton(
        label: l10n.setupNextCta,
        onPressed: widget.onNext,
      ),
      children: <Widget>[
        Text(
          l10n.detailsHeading,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppPalette.ink,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 16),
        KhushhalCard(
          highlighted: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                l10n.detailsNameLabel,
                style: const TextStyle(fontSize: 12, color: AppPalette.hint),
              ),
              TextField(
                controller: _name,
                onChanged: (String value) => draft.name = value,
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppPalette.cardInk,
                ),
                decoration: const InputDecoration(
                  filled: false,
                  isCollapsed: true,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 5),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        KhushhalCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                l10n.detailsSinceLabel,
                style: const TextStyle(fontSize: 12, color: AppPalette.hint),
              ),
              const SizedBox(height: 9),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: <Widget>[
                  for (final BusinessTenure tenure in BusinessTenure.values)
                    ChoicePill(
                      label: tenure.label(l10n),
                      selected: draft.tenure == tenure,
                      onTap: () => setState(() => draft.tenure = tenure),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        KhushhalCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                l10n.detailsStaffLabel,
                style: const TextStyle(fontSize: 12, color: AppPalette.hint),
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  _StepperButton(
                    glyph: '−',
                    onTap: draft.staffCount > 1
                        ? () => setState(() => draft.staffCount--)
                        : null,
                  ),
                  Expanded(
                    child: Text(
                      '${draft.staffCount}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: AppPalette.cardInk,
                      ),
                    ),
                  ),
                  _StepperButton(
                    glyph: '＋',
                    onTap: () => setState(() => draft.staffCount++),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// One side of the staff stepper.
class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.glyph, required this.onTap});

  final String glyph;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppPalette.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppPalette.line, width: 1.5),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 52,
          padding: const EdgeInsets.symmetric(vertical: 9),
          alignment: Alignment.center,
          child: Text(
            glyph,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: onTap == null ? AppPalette.idle : AppPalette.forest,
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
