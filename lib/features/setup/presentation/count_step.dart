/// Setup 2 · How many businesses? (design 1i).
library;

import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/gradient_cta_button.dart';
import '../../../core/widgets/info_note.dart';
import '../../../l10n/app_localizations.dart';
import 'widgets/setup_progress_header.dart';
import 'widgets/step_page.dart';

/// One tap, one question.
class CountStep extends StatefulWidget {
  /// Creates the count step.
  const CountStep({super.key, required this.onNext});

  /// Called with the chosen count (4+ reports 4).
  final ValueChanged<int> onNext;

  @override
  State<CountStep> createState() => _CountStepState();
}

class _CountStepState extends State<CountStep> {
  int _count = 1;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return StepPage(
      header: SetupProgressHeader(label: l10n.setupStepOf(2, 5), filled: 2),
      cta: GradientCtaButton(
        label: l10n.setupNextCta,
        onPressed: () => widget.onNext(_count),
      ),
      children: <Widget>[
        Text(
          l10n.countHeading,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppPalette.ink,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: <Widget>[
            _CountCard(
              label: '1',
              selected: _count == 1,
              onTap: () => setState(() => _count = 1),
            ),
            const SizedBox(width: 12),
            _CountCard(
              label: '2',
              selected: _count == 2,
              onTap: () => setState(() => _count = 2),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            _CountCard(
              label: '3',
              selected: _count == 3,
              onTap: () => setState(() => _count = 3),
            ),
            const SizedBox(width: 12),
            _CountCard(
              label: l10n.countFourPlus,
              selected: _count == 4,
              onTap: () => setState(() => _count = 4),
            ),
          ],
        ),
        const SizedBox(height: 14),
        InfoNote(text: l10n.countNote),
      ],
    );
  }
}

/// One cell of the 2×2 count grid.
class _CountCard extends StatelessWidget {
  const _CountCard({
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
        color: selected ? Colors.transparent : AppPalette.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: selected ? AppPalette.forest : AppPalette.line,
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
                  borderRadius: BorderRadius.circular(18),
                )
              : null,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                        color: selected
                            ? AppPalette.onPrimary
                            : AppPalette.cardInk,
                      ),
                    ),
                  ),
                  if (selected) ...<Widget>[
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.check_circle,
                      size: 22,
                      color: AppPalette.onPrimary,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
