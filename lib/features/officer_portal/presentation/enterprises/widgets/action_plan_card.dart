/// The cash-gap action-plan checklist (Officer Portal 5c).
library;

import 'package:flutter/material.dart';

import '../../../domain/action_step.dart';
import '../../theme/officer_palette.dart';
import '../../widgets/officer_avatar.dart';
import '../../widgets/officer_buttons.dart';
import '../../widgets/officer_card.dart';
import '../../widgets/status_chip.dart';

/// Ordered steps to close a cash gap, with a "send plan" hand-off.
class ActionPlanCard extends StatefulWidget {
  /// Creates the action-plan card.
  const ActionPlanCard({
    super.key,
    required this.steps,
    required this.gapLabel,
    required this.onAddStepManually,
    required this.onEditStep,
    required this.onDeleteStep,
    required this.onSendPlan,
  });

  /// The plan's ordered steps.
  final List<ActionStep> steps;

  /// The total gap this plan covers, e.g. "covers ₹32,000".
  final String gapLabel;

  /// Called when "+ Add step manually" is tapped.
  final VoidCallback onAddStepManually;

  /// Called with a step when its edit control is tapped.
  final ValueChanged<ActionStep> onEditStep;

  /// Called with a step when its delete control is tapped.
  final ValueChanged<ActionStep> onDeleteStep;

  /// Called when "Send plan" is tapped — publishes the steps to the
  /// enterprise's open flag so the owner's app shows them. Throws if there's
  /// no open flag to attach to.
  final Future<void> Function() onSendPlan;

  /// How many steps show before "View all" is needed.
  static const int previewCount = 3;

  @override
  State<ActionPlanCard> createState() => _ActionPlanCardState();
}

class _ActionPlanCardState extends State<ActionPlanCard> {
  bool _expanded = false;
  bool _sending = false;

  Future<void> _handleSendPlan() async {
    setState(() => _sending = true);
    try {
      await widget.onSendPlan();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Plan sent to the owner’s app.')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not send: $e')));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  static const Map<ActionStepImpact, OfficerTone> _impactTone =
      <ActionStepImpact, OfficerTone>{
        ActionStepImpact.low: OfficerTone.neutral,
        ActionStepImpact.medium: OfficerTone.amber,
        ActionStepImpact.high: OfficerTone.green,
      };

  @override
  Widget build(BuildContext context) {
    final List<ActionStep> steps = widget.steps;
    final bool canCollapse = steps.length > ActionPlanCard.previewCount;
    final List<ActionStep> shown = _expanded || !canCollapse
        ? steps
        : steps.take(ActionPlanCard.previewCount).toList();

    return OfficerCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Wrap(
            spacing: 8,
            runSpacing: 2,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.checklist_rounded,
                size: 17,
                color: OfficerPalette.forest,
              ),
              const Text(
                'Action plan for cash gap',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  color: OfficerPalette.ink,
                ),
              ),
              if (widget.gapLabel.isNotEmpty)
                Text(
                  widget.gapLabel,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: OfficerPalette.muted,
                  ),
                ),
            ],
          ),
          const Text(
            'In the order it must happen · impact per step',
            style: TextStyle(fontSize: 10.5, color: OfficerPalette.muted),
          ),
          const SizedBox(height: 10),
          for (final ActionStep step in shown) ...<Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: OfficerPalette.soft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  OfficerAvatar(text: '${step.order}', size: 24, fontSize: 11),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          step.title,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: OfficerPalette.ink,
                          ),
                        ),
                        Text(
                          step.detail,
                          style: const TextStyle(
                            fontSize: 11,
                            color: OfficerPalette.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatusChip(
                    label: step.impact.label,
                    tone: _impactTone[step.impact]!,
                    dense: true,
                  ),
                  InkWell(
                    onTap: () => widget.onEditStep(step),
                    borderRadius: BorderRadius.circular(12),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.edit_outlined,
                        size: 16,
                        color: OfficerPalette.muted,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => widget.onDeleteStep(step),
                    borderRadius: BorderRadius.circular(12),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: OfficerPalette.muted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (steps.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'No open cash-gap flag for this enterprise right now.',
                style: TextStyle(fontSize: 12, color: OfficerPalette.muted),
              ),
            ),
          if (canCollapse)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () => setState(() => _expanded = !_expanded),
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      _expanded ? 'Show less' : 'View all ${steps.length} steps',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: OfficerPalette.forest,
                      ),
                    ),
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: OfficerPalette.forest,
                    ),
                  ],
                ),
              ),
            ),
          Row(
            children: <Widget>[
              Expanded(
                child: OfficerSecondaryButton(
                  label: '＋ Add step manually',
                  expand: true,
                  onPressed: widget.onAddStepManually,
                ),
              ),
              if (steps.isNotEmpty) ...<Widget>[
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: OfficerPrimaryButton(
                    label: _sending ? 'Sending…' : 'Send plan 📲',
                    onPressed: _sending ? null : _handleSendPlan,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
