/// Setup 3 · Segment + sector (design 1k).
library;

import 'package:flutter/material.dart';

import '../../../app/labels.dart';
import '../../../app/model/business.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/gradient_cta_button.dart';
import '../../../core/widgets/info_note.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/business_draft.dart';
import 'widgets/setup_progress_header.dart';
import 'widgets/step_page.dart';

/// Pure icon-tap, zero typing. The sector silently loads the seasonality
/// and commodity model — the note under the grid says so in plain words.
class KindStep extends StatefulWidget {
  /// Creates the kind step for business [businessNumber].
  const KindStep({
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

  /// Advances to details (1l).
  final VoidCallback onNext;

  /// When true (Settings → Add business), the header renders "Step 1 of 3"
  /// instead of "Step 3 of 5" so the user doesn't wonder where steps 1–2 are.
  final bool standalone;

  @override
  State<KindStep> createState() => _KindStepState();
}

class _KindStepState extends State<KindStep> {
  static const Map<BusinessSegment, IconData> _segmentIcons =
      <BusinessSegment, IconData>{
        BusinessSegment.shg: Icons.groups,
        BusinessSegment.fpo: Icons.agriculture,
        BusinessSegment.own: Icons.person,
      };

  static const Map<BusinessSector, IconData> _sectorIcons =
      <BusinessSector, IconData>{
        BusinessSector.dairy: Icons.water_drop,
        BusinessSector.poultry: Icons.egg,
        BusinessSector.foodProcessing: Icons.soup_kitchen,
        BusinessSector.crafts: Icons.palette,
        BusinessSector.shop: Icons.storefront,
        BusinessSector.other: Icons.add,
      };

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final BusinessDraft draft = widget.draft;

    return StepPage(
      header: SetupProgressHeader(
        label: l10n.setupStepOfBusiness(
          widget.standalone ? 1 : 3,
          widget.standalone ? 3 : 5,
          l10n.businessN(widget.businessNumber),
        ),
        filled: widget.standalone ? 1 : 3,
        total: widget.standalone ? 3 : 5,
      ),
      cta: GradientCtaButton(
        label: l10n.setupNextCta,
        onPressed: widget.onNext,
      ),
      children: <Widget>[
        Text(
          l10n.kindHeading,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppPalette.ink,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          l10n.segmentPrompt,
          style: const TextStyle(fontSize: 13, color: AppPalette.muted),
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            for (final BusinessSegment segment
                in BusinessSegment.values) ...<Widget>[
              if (segment != BusinessSegment.values.first)
                const SizedBox(width: 8),
              Expanded(
                child: _PickCell(
                  icon: _segmentIcons[segment]!,
                  label: segment.label(l10n),
                  selected: draft.segment == segment,
                  onTap: () => setState(() => draft.segment = segment),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 14),
        Text(
          l10n.sectorPrompt,
          style: const TextStyle(fontSize: 13, color: AppPalette.muted),
        ),
        const SizedBox(height: 8),
        for (
          int row = 0;
          row < BusinessSector.values.length;
          row += 2
        ) ...<Widget>[
          if (row > 0) const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(child: _sectorCell(BusinessSector.values[row])),
              const SizedBox(width: 8),
              Expanded(child: _sectorCell(BusinessSector.values[row + 1])),
            ],
          ),
        ],
        if (draft.sector == BusinessSector.dairy) ...<Widget>[
          const SizedBox(height: 12),
          InfoNote(text: l10n.kindDairyHint),
        ],
      ],
    );
  }

  Widget _sectorCell(BusinessSector sector) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return _PickCell(
      icon: _sectorIcons[sector]!,
      label: sector.label(l10n),
      selected: widget.draft.sector == sector,
      soft: sector == BusinessSector.other,
      horizontal: true,
      onTap: () => setState(() => widget.draft.sector = sector),
    );
  }
}

/// One selectable cell of the segment or sector grid.
class _PickCell extends StatelessWidget {
  const _PickCell({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.horizontal = false,
    this.soft = false,
  });

  final IconData icon;

  final String label;

  final bool selected;

  final VoidCallback onTap;

  /// Icon beside the label (sector cells) instead of above it (segments).
  final bool horizontal;

  /// The gentler border for the open-ended "Other" cell.
  final bool soft;

  @override
  Widget build(BuildContext context) {
    final Color foreground = selected
        ? AppPalette.onPrimary
        : soft
        ? AppPalette.hint
        : AppPalette.body;

    final Widget content = horizontal
        ? Row(
            children: <Widget>[
              Icon(icon, size: 18, color: foreground),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    color: foreground,
                  ),
                ),
              ),
              if (selected)
                const Icon(
                  Icons.check_circle,
                  size: 16,
                  color: AppPalette.onPrimary,
                ),
            ],
          )
        : Column(
            children: <Widget>[
              Icon(icon, size: 20, color: foreground),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: foreground,
                ),
              ),
            ],
          );

    return Material(
      color: selected ? Colors.transparent : AppPalette.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: selected
            ? BorderSide.none
            : BorderSide(
                color: soft ? const Color(0xFFC9D8CC) : AppPalette.line,
                width: 1.5,
              ),
      ),
      child: Ink(
        decoration: selected
            ? BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[AppPalette.forest, AppPalette.leaf],
                ),
                borderRadius: BorderRadius.circular(16),
              )
            : null,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: horizontal
                ? const EdgeInsets.symmetric(horizontal: 14, vertical: 12)
                : const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: content,
          ),
        ),
      ),
    );
  }
}
