/// Search + status filter chips atop the Enterprises list (Officer Portal 5b).
library;

import 'package:flutter/material.dart';

import '../../../domain/enterprise.dart';
import '../../theme/officer_palette.dart';
import '../../widgets/status_chip.dart';

/// Which status filter is active on the Enterprises list.
enum EnterpriseStatusFilter { all, atRisk, watch, healthy }

/// A sector's short label for the filter dropdown and table.
String enterpriseSectorLabel(EnterpriseSector sector) => switch (sector) {
  EnterpriseSector.dairy => 'Dairy',
  EnterpriseSector.poultry => 'Poultry',
  EnterpriseSector.foodProcessing => 'Food proc.',
  EnterpriseSector.crafts => 'Crafts',
  EnterpriseSector.shop => 'Shop',
  EnterpriseSector.other => 'Other',
};

/// The search field, status chips, and sector dropdown atop the
/// Enterprises list.
class EnterpriseFilterBar extends StatelessWidget {
  /// Creates the filter bar.
  const EnterpriseFilterBar({
    super.key,
    required this.searchController,
    required this.counts,
    required this.filter,
    required this.onFilterChanged,
    required this.sectorFilter,
    required this.onSectorChanged,
  });

  /// The search text field's controller.
  final TextEditingController searchController;

  /// Counts per status, keyed by [EnterpriseStatusFilter].
  final Map<EnterpriseStatusFilter, int> counts;

  /// The currently selected filter.
  final EnterpriseStatusFilter filter;

  /// Called when a filter chip is tapped.
  final ValueChanged<EnterpriseStatusFilter> onFilterChanged;

  /// The currently selected sector, or `null` for every sector.
  final EnterpriseSector? sectorFilter;

  /// Called when the sector dropdown changes.
  final ValueChanged<EnterpriseSector?> onSectorChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 260,
          child: TextField(
            controller: searchController,
            style: const TextStyle(fontSize: 13),
            decoration: const InputDecoration(
              isDense: true,
              prefixIcon: Icon(
                Icons.search_rounded,
                size: 18,
                color: OfficerPalette.muted,
              ),
              hintText: 'Search name / owner / mobile…',
            ),
          ),
        ),
        _FilterChip(
          label: 'All ${counts[EnterpriseStatusFilter.all]}',
          selected: filter == EnterpriseStatusFilter.all,
          onTap: () => onFilterChanged(EnterpriseStatusFilter.all),
        ),
        _FilterChip(
          label: 'At risk ${counts[EnterpriseStatusFilter.atRisk]}',
          tone: OfficerTone.red,
          selected: filter == EnterpriseStatusFilter.atRisk,
          onTap: () => onFilterChanged(EnterpriseStatusFilter.atRisk),
        ),
        _FilterChip(
          label: 'Watch ${counts[EnterpriseStatusFilter.watch]}',
          tone: OfficerTone.amber,
          selected: filter == EnterpriseStatusFilter.watch,
          onTap: () => onFilterChanged(EnterpriseStatusFilter.watch),
        ),
        _FilterChip(
          label: 'Healthy ${counts[EnterpriseStatusFilter.healthy]}',
          tone: OfficerTone.green,
          selected: filter == EnterpriseStatusFilter.healthy,
          onTap: () => onFilterChanged(EnterpriseStatusFilter.healthy),
        ),
        _SectorDropdown(value: sectorFilter, onChanged: onSectorChanged),
      ],
    );
  }
}

class _SectorDropdown extends StatelessWidget {
  const _SectorDropdown({required this.value, required this.onChanged});

  final EnterpriseSector? value;
  final ValueChanged<EnterpriseSector?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: OfficerPalette.soft,
        borderRadius: BorderRadius.circular(99),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<EnterpriseSector?>(
          value: value,
          isDense: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: OfficerPalette.muted,
          ),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: OfficerPalette.chipNeutralInk,
          ),
          hint: const Text('All sectors'),
          items: <DropdownMenuItem<EnterpriseSector?>>[
            const DropdownMenuItem<EnterpriseSector?>(
              value: null,
              child: Text('All sectors'),
            ),
            for (final EnterpriseSector sector in EnterpriseSector.values)
              DropdownMenuItem<EnterpriseSector?>(
                value: sector,
                child: Text(enterpriseSectorLabel(sector)),
              ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.tone = OfficerTone.neutral,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final OfficerTone tone;

  /// Strong fill used only when selected — pale category tints alone
  /// weren't a clear enough "this is active" signal.
  Color get _selectedColor => switch (tone) {
    OfficerTone.green => OfficerPalette.statusGreen,
    OfficerTone.amber => OfficerPalette.statusAmber,
    OfficerTone.red => OfficerPalette.statusRed,
    OfficerTone.neutral => OfficerPalette.forest,
  };

  (Color bg, Color fg) get _unselectedColors => switch (tone) {
    OfficerTone.green => (OfficerPalette.chipGreenBg, OfficerPalette.chipGreenInk),
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

  @override
  Widget build(BuildContext context) {
    final (Color unselectedBg, Color unselectedFg) = _unselectedColors;
    final Color bg = selected ? _selectedColor : unselectedBg;
    final Color fg = selected ? Colors.white : unselectedFg;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 104,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(99)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (selected) ...<Widget>[
              Icon(Icons.check_rounded, size: 13, color: fg),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
