/// Setup 5 · Monthly money — rough estimate / from my records (1m, 1n).
library;

import 'package:flutter/material.dart';

import '../../../app/demo_data.dart';
import '../../../app/model/business.dart';
import '../../../core/formatting.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/gradient_cta_button.dart';
import '../../../core/widgets/info_note.dart';
import '../../../core/widgets/khushhal_card.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/business_draft.dart';
import 'widgets/setup_progress_header.dart';
import 'widgets/step_page.dart';

/// Rough sliders by default — nothing is a hard number and no field is
/// mandatory. Records mode takes exact typed figures for owners with a
/// bahi-khata; the model weights those higher.
class MoneyStep extends StatefulWidget {
  /// Creates the money step for business [businessNumber].
  const MoneyStep({
    super.key,
    required this.draft,
    required this.businessNumber,
    required this.onSubmit,
  });

  /// The draft being filled in.
  final BusinessDraft draft;

  /// 1-based position of this business, for the header.
  final int businessNumber;

  /// Called with the finished business record.
  final ValueChanged<Business> onSubmit;

  @override
  State<MoneyStep> createState() => _MoneyStepState();
}

class _MoneyStepState extends State<MoneyStep> {
  final TextEditingController _recordsIn = TextEditingController();
  final TextEditingController _recordsOut = TextEditingController();
  final TextEditingController _recordsEmi = TextEditingController();
  final TextEditingController _recordsSavings = TextEditingController();

  @override
  void dispose() {
    _recordsIn.dispose();
    _recordsOut.dispose();
    _recordsEmi.dispose();
    _recordsSavings.dispose();
    super.dispose();
  }

  bool get _fromRecords => widget.draft.basis == MoneyBasis.fromRecords;

  /// The month the records-mode figures describe — the last full month.
  DateTime get _recordsMonth {
    final DateTime today = DemoData.today;

    return DateTime(today.year, today.month - 1);
  }

  int _parsed(TextEditingController controller, double fallback) {
    return int.tryParse(controller.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
        fallback.round();
  }

  void _submit() {
    final BusinessDraft draft = widget.draft;

    final MonthlyMoney monthly = _fromRecords
        ? MonthlyMoney(
            moneyIn: _parsed(_recordsIn, draft.roughIn),
            moneyOut: _parsed(_recordsOut, draft.roughOut),
            loanEmi: _parsed(_recordsEmi, draft.roughEmi),
            savings: _parsed(_recordsSavings, draft.roughSavings),
            basis: MoneyBasis.fromRecords,
          )
        : MonthlyMoney(
            moneyIn: draft.roughIn.round(),
            moneyOut: draft.roughOut.round(),
            loanEmi: draft.roughEmi.round(),
            savings: draft.roughSavings.round(),
            basis: MoneyBasis.roughEstimate,
          );

    widget.onSubmit(
      draft.build(
        fallbackName: AppLocalizations.of(
          context,
        )!.businessN(widget.businessNumber),
        monthly: monthly,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return StepPage(
      header: SetupProgressHeader(
        label: l10n.setupStepOfBusiness(
          5,
          5,
          l10n.businessN(widget.businessNumber),
        ),
        filled: 5,
      ),
      cta: GradientCtaButton(label: l10n.moneySeeCardCta, onPressed: _submit),
      children: <Widget>[
        Text(
          l10n.moneyHeading,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppPalette.ink,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            _ModePill(
              label: l10n.moneyModeRough,
              selected: !_fromRecords,
              onTap: () =>
                  setState(() => widget.draft.basis = MoneyBasis.roughEstimate),
            ),
            const SizedBox(width: 8),
            _ModePill(
              label: l10n.moneyModeRecords,
              selected: _fromRecords,
              onTap: () =>
                  setState(() => widget.draft.basis = MoneyBasis.fromRecords),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_fromRecords) ..._recordsFields(l10n) else ..._roughSliders(l10n),
      ],
    );
  }

  List<Widget> _roughSliders(AppLocalizations l10n) {
    final BusinessDraft draft = widget.draft;

    return <Widget>[
      _SliderCard(
        label: l10n.moneyInLabel,
        value: draft.roughIn,
        max: 100000,
        step: 2500,
        onChanged: (double value) => setState(() => draft.roughIn = value),
      ),
      const SizedBox(height: 9),
      _SliderCard(
        label: l10n.moneyOutLabel,
        value: draft.roughOut,
        max: 100000,
        step: 2500,
        onChanged: (double value) => setState(() => draft.roughOut = value),
      ),
      const SizedBox(height: 9),
      _SliderCard(
        label: l10n.moneyEmiLabel,
        value: draft.roughEmi,
        max: 30000,
        step: 500,
        onChanged: (double value) => setState(() => draft.roughEmi = value),
      ),
      const SizedBox(height: 9),
      _SliderCard(
        label: l10n.moneySavingsLabel,
        value: draft.roughSavings,
        max: 100000,
        step: 2500,
        onChanged: (double value) => setState(() => draft.roughSavings = value),
      ),
    ];
  }

  List<Widget> _recordsFields(AppLocalizations l10n) {
    return <Widget>[
      InfoNote(text: l10n.moneyRecordsNote),
      const SizedBox(height: 12),
      _RecordsField(
        label: l10n.moneyInMonthLabel(monthName(context, _recordsMonth)),
        controller: _recordsIn,
        highlighted: true,
      ),
      const SizedBox(height: 9),
      _RecordsField(label: l10n.moneyOutLabel, controller: _recordsOut),
      const SizedBox(height: 9),
      _RecordsField(label: l10n.moneyEmiLabel, controller: _recordsEmi),
      const SizedBox(height: 9),
      _RecordsField(label: l10n.moneySavingsLabel, controller: _recordsSavings),
      const SizedBox(height: 11),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFC9D8CC), width: 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          l10n.moneyMoreMonths,
          style: const TextStyle(
            fontSize: 12.5,
            height: 1.5,
            color: AppPalette.hint,
          ),
        ),
      ),
    ];
  }
}

/// One half of the rough / records mode toggle.
class _ModePill extends StatelessWidget {
  const _ModePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;

  final bool selected;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: selected ? AppPalette.forest : AppPalette.onPrimary,
        shape: StadiumBorder(
          side: selected
              ? BorderSide.none
              : const BorderSide(color: AppPalette.line, width: 1.5),
        ),
        child: InkWell(
          onTap: onTap,
          customBorder: const StadiumBorder(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? AppPalette.onPrimary : AppPalette.body,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A rough-estimate row: label, live rupee value, slider.
class _SliderCard extends StatelessWidget {
  const _SliderCard({
    required this.label,
    required this.value,
    required this.max,
    required this.step,
    required this.onChanged,
  });

  final String label;

  final double value;

  final double max;

  final double step;

  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return KhushhalCard(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: AppPalette.body,
                  ),
                ),
              ),
              Text(
                rupees(context, value.round()),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppPalette.forest,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 7,
              activeTrackColor: AppPalette.leaf,
              inactiveTrackColor: AppPalette.mintWash,
              thumbColor: AppPalette.onPrimary,
              overlayColor: AppPalette.leaf.withValues(alpha: 0.12),
            ),
            child: Slider(
              value: value.clamp(0, max),
              max: max,
              divisions: (max / step).round(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

/// A records-mode row: label and a typed rupee amount.
class _RecordsField extends StatelessWidget {
  const _RecordsField({
    required this.label,
    required this.controller,
    this.highlighted = false,
  });

  final String label;

  final TextEditingController controller;

  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return KhushhalCard(
      highlighted: highlighted,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 13.5, color: AppPalette.body),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '₹',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppPalette.cardInk,
            ),
          ),
          SizedBox(
            width: 92,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppPalette.cardInk,
              ),
              decoration: const InputDecoration(
                filled: false,
                isCollapsed: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: '____',
                contentPadding: EdgeInsets.symmetric(vertical: 6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
