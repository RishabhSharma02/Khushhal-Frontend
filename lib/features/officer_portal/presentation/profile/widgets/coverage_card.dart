/// The officer's coverage stats (Officer Portal 5l).
library;

import 'package:flutter/material.dart';

import '../../../domain/officer_profile.dart';
import '../../theme/officer_palette.dart';
import '../../widgets/officer_card.dart';

/// Enterprises, villages, visits this month, flags resolved.
class CoverageCard extends StatelessWidget {
  /// Creates the coverage card.
  const CoverageCard({super.key, required this.coverage});

  /// The officer's coverage stats.
  final OfficerCoverage coverage;

  @override
  Widget build(BuildContext context) {
    return OfficerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Row(
            children: <Widget>[
              Icon(Icons.map_outlined, size: 17, color: OfficerPalette.forest),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'My coverage',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: OfficerPalette.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: _Tile(
                  label: 'Enterprises',
                  value: '${coverage.enterpriseCount}',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Tile(
                  label: 'Villages',
                  value: '${coverage.villageCount}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: _Tile(
                  label: 'Visits this month',
                  value: '${coverage.visitsThisMonth}',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Tile(
                  label: 'Flags resolved (30d)',
                  value: '${coverage.flagsResolvedLast30Days}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: OfficerPalette.soft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: OfficerPalette.muted),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: OfficerPalette.ink,
            ),
          ),
        ],
      ),
    );
  }
}
