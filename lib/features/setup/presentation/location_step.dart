/// Setup 1 · Location (design 1h).
library;

import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/gradient_cta_button.dart';
import '../../../core/widgets/info_note.dart';
import '../../../core/widgets/khushhal_card.dart';
import '../../../core/widgets/section_label.dart';
import '../../../l10n/app_localizations.dart';
import 'widgets/setup_progress_header.dart';
import 'widgets/step_page.dart';

/// GPS one-tap first, dropdown fallback for shared phones, and the reason
/// for asking stated in plain words.
class LocationStep extends StatelessWidget {
  /// Creates the location step.
  const LocationStep({super.key, required this.onConfirm});

  /// Called when the location is confirmed.
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return StepPage(
      header: SetupProgressHeader(label: l10n.setupStepOf(1, 5), filled: 1),
      cta: GradientCtaButton(
        label: l10n.locationConfirmCta,
        onPressed: onConfirm,
      ),
      children: <Widget>[
        Text(
          l10n.locationHeading,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppPalette.ink,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 14),
        KhushhalCard(
          highlighted: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: <Widget>[
              const Icon(Icons.my_location, size: 20, color: AppPalette.forest),
              const SizedBox(width: 10),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      TextSpan(
                        text: l10n.locationUseMine,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(text: ' · ${l10n.locationOneTap}'),
                    ],
                  ),
                  style: const TextStyle(fontSize: 15, color: AppPalette.ink),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: AppPalette.mintNote,
            border: Border.all(color: const Color(0xFFA9C9B2), width: 1.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.place, size: 22, color: Color(0xFF5C8468)),
              const SizedBox(height: 5),
              Text(
                l10n.locationMapHint,
                style: const TextStyle(fontSize: 12, color: Color(0xFF5C8468)),
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
              SectionLabel(l10n.locationDetectedLabel),
              const SizedBox(height: 3),
              Text(
                l10n.locationDetectedValue,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppPalette.cardInk,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                l10n.locationDetectedMandi,
                style: const TextStyle(fontSize: 12.5, color: AppPalette.muted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.locationPickByHand,
          style: const TextStyle(fontSize: 13, color: AppPalette.muted),
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            _PickerStub(
              label: l10n.locationState,
              value: l10n.locationDetectedValue,
            ),
            const SizedBox(width: 8),
            _PickerStub(
              label: l10n.locationDistrict,
              value: l10n.locationDetectedValue,
            ),
            const SizedBox(width: 8),
            _PickerStub(
              label: l10n.locationVillage,
              value: l10n.locationDetectedValue,
            ),
          ],
        ),
        const SizedBox(height: 12),
        InfoNote(text: l10n.locationWhy),
      ],
    );
  }
}

/// One of the State / District / Village fallback pickers.
///
/// The demo has a single detected place, so the menu offers just that — the
/// affordance is real, the data is not yet.
class _PickerStub extends StatelessWidget {
  const _PickerStub({required this.label, required this.value});

  final String label;

  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PopupMenuButton<String>(
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry<String>>[
            PopupMenuItem<String>(value: value, child: Text(value)),
          ];
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: AppPalette.onPrimary,
            border: Border.all(color: AppPalette.line, width: 1.5),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: AppPalette.body,
                  ),
                ),
              ),
              const Icon(Icons.expand_more, size: 16, color: AppPalette.body),
            ],
          ),
        ),
      ),
    );
  }
}
