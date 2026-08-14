/// The AI flag narrative under the cash flow chart (Officer Portal 5c).
library;

import 'package:flutter/material.dart';

import '../../theme/officer_palette.dart';

/// A risk-red callout explaining why a month was flagged.
class AiFlagBanner extends StatelessWidget {
  /// Creates the AI flag banner.
  const AiFlagBanner({super.key, required this.narrative});

  /// The narrative text, e.g. "November OUT exceeds IN by ~₹32,000…".
  final String narrative;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: OfficerPalette.chipRedBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text.rich(
        TextSpan(
          children: <InlineSpan>[
            const TextSpan(
              text: '⚠ AI flag: ',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: OfficerPalette.statusRed,
              ),
            ),
            TextSpan(text: narrative),
          ],
        ),
        style: const TextStyle(
          fontSize: 12.5,
          height: 1.45,
          color: OfficerPalette.body,
        ),
      ),
    );
  }
}
