/// The full enterprise roster (Officer Portal 5b).
library;

import 'package:flutter/material.dart';

import '../../domain/enterprise.dart';
import '../officer_session.dart';
import '../theme/officer_palette.dart';
import '../widgets/officer_buttons.dart';
import '../widgets/officer_nav_rail.dart';
import '../widgets/officer_shell_scaffold.dart';
import '../widgets/responsive_header.dart';
import 'enterprise_detail_screen.dart';
import 'widgets/enterprise_filter_bar.dart';
import 'widgets/enterprise_table.dart';

/// Searchable, filterable table of every enterprise on the beat.
class EnterpriseListScreen extends StatefulWidget {
  /// Creates the enterprise list screen.
  const EnterpriseListScreen({super.key, required this.onSectionSelected});

  /// Called when a rail section is tapped.
  final ValueChanged<OfficerSection> onSectionSelected;

  @override
  State<EnterpriseListScreen> createState() => _EnterpriseListScreenState();
}

class _EnterpriseListScreenState extends State<EnterpriseListScreen> {
  final TextEditingController _search = TextEditingController();
  EnterpriseStatusFilter _filter = EnterpriseStatusFilter.all;
  EnterpriseSector? _sectorFilter;

  @override
  void initState() {
    super.initState();
    _search.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Enterprise> _filtered(List<Enterprise> enterprises) {
    final String query = _search.text.trim().toLowerCase();

    return enterprises.where((Enterprise e) {
      final bool matchesFilter = switch (_filter) {
        EnterpriseStatusFilter.all => true,
        EnterpriseStatusFilter.atRisk => e.riskLevel == RiskLevel.atRisk,
        EnterpriseStatusFilter.watch => e.riskLevel == RiskLevel.watch,
        EnterpriseStatusFilter.healthy => e.riskLevel == RiskLevel.healthy,
      };
      if (!matchesFilter) {
        return false;
      }
      if (_sectorFilter != null && e.sector != _sectorFilter) {
        return false;
      }
      if (query.isEmpty) {
        return true;
      }
      return e.name.toLowerCase().contains(query) ||
          e.contact.name.toLowerCase().contains(query) ||
          e.contact.phone.contains(query);
    }).toList()..sort((Enterprise a, Enterprise b) {
      const List<RiskLevel> order = <RiskLevel>[
        RiskLevel.atRisk,
        RiskLevel.watch,
        RiskLevel.healthy,
      ];
      return order.indexOf(a.riskLevel).compareTo(order.indexOf(b.riskLevel));
    });
  }

  @override
  Widget build(BuildContext context) {
    final OfficerSession session = OfficerSessionScope.of(context);
    final List<Enterprise> all = session.enterprises;
    final List<Enterprise> filtered = _filtered(all);

    final Map<EnterpriseStatusFilter, int> counts =
        <EnterpriseStatusFilter, int>{
          EnterpriseStatusFilter.all: all.length,
          EnterpriseStatusFilter.atRisk: all
              .where((Enterprise e) => e.riskLevel == RiskLevel.atRisk)
              .length,
          EnterpriseStatusFilter.watch: all
              .where((Enterprise e) => e.riskLevel == RiskLevel.watch)
              .length,
          EnterpriseStatusFilter.healthy: all
              .where((Enterprise e) => e.riskLevel == RiskLevel.healthy)
              .length,
        };

    return OfficerShellScaffold(
      section: OfficerSection.enterprises,
      onSectionSelected: widget.onSectionSelected,
      children: <Widget>[
        ResponsiveHeader(
          title: const Text(
            'Enterprises',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: OfficerPalette.ink,
            ),
          ),
          actions: <Widget>[
            OfficerSecondaryButton(
              label: '⬇ Export CSV',
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Export isn’t wired up in this demo yet.'),
                ),
              ),
            ),
          ],
        ),
        EnterpriseFilterBar(
          searchController: _search,
          counts: counts,
          filter: _filter,
          onFilterChanged: (EnterpriseStatusFilter filter) =>
              setState(() => _filter = filter),
          sectorFilter: _sectorFilter,
          onSectorChanged: (EnterpriseSector? sector) =>
              setState(() => _sectorFilter = sector),
        ),
        EnterpriseTable(
          enterprises: filtered,
          onSelected: (Enterprise enterprise) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (BuildContext _) => EnterpriseDetailScreen(
                  enterpriseId: enterprise.id,
                  onSectionSelected: widget.onSectionSelected,
                ),
              ),
            );
          },
        ),
        Text(
          'Showing ${filtered.length} of ${all.length}',
          style: const TextStyle(fontSize: 12, color: OfficerPalette.muted),
        ),
      ],
    );
  }
}
