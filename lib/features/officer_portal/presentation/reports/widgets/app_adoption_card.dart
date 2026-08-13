/// App-adoption stats across the officer's enterprises (Officer Portal 5e).
library;

import 'package:flutter/material.dart';

import '../../../domain/report_summary.dart';
import '../../theme/officer_palette.dart';
import '../../widgets/officer_card.dart';

/// Entry streak, voice-entry users, active savings plans.
class AppAdoptionCard extends StatelessWidget {
  /// Creates the app-adoption card.
  const AppAdoptionCard({super.key, required this.adoption});

  /// The month's adoption stats.
  final AppAdoption adoption;

  @override
  Widget build(BuildContext context) {
    return OfficerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Row(
            children: <Widget>[
              Icon(
                Icons.smartphone_rounded,
                size: 17,
                color: OfficerPalette.forest,
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'App adoption',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: OfficerPalette.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _Row(
            label: 'Entry streak ≥5/wk',
            value:
                '${adoption.enterprisesWithStreak} of ${adoption.totalEnterprises}',
          ),
          const SizedBox(height: 6),
          _Row(
            label: 'Voice entry users',
            value: '${adoption.voiceEntryUsers}',
          ),
          const SizedBox(height: 6),
          _Row(
            label: 'Savings plans active',
            value: '${adoption.activeSavingsPlans}',
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12.5, color: OfficerPalette.body),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: OfficerPalette.ink,
          ),
        ),
      ],
    );
  }
}
