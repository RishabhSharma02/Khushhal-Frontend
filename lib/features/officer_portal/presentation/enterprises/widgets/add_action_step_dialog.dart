/// The "Add step manually" / "Edit step" modal for an enterprise's action
/// plan (5c).
library;

import 'package:flutter/material.dart';

import '../../../domain/action_step.dart';
import '../../theme/officer_palette.dart';
import '../../widgets/labeled_field.dart';
import '../../widgets/officer_buttons.dart';
import '../../widgets/officer_card.dart';

/// Opens the Add-step dialog. Pass [existingStep] to edit a step in place
/// instead of adding a new one. [onSubmit] persists the change — the
/// caller decides whether that means POST (add) or PATCH (edit) since it
/// already knows which mode this is.
Future<void> showAddActionStepDialog({
  required BuildContext context,
  ActionStep? existingStep,
  required Future<void> Function({
    required String title,
    required String detail,
    required ActionStepImpact impact,
  })
  onSubmit,
}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) => _AddActionStepDialog(
      existingStep: existingStep,
      onSubmit: onSubmit,
    ),
  );
}

class _AddActionStepDialog extends StatefulWidget {
  const _AddActionStepDialog({this.existingStep, required this.onSubmit});

  final ActionStep? existingStep;
  final Future<void> Function({
    required String title,
    required String detail,
    required ActionStepImpact impact,
  })
  onSubmit;

  @override
  State<_AddActionStepDialog> createState() => _AddActionStepDialogState();
}

class _AddActionStepDialogState extends State<_AddActionStepDialog> {
  late final TextEditingController _title = TextEditingController(
    text: widget.existingStep?.title,
  );
  late final TextEditingController _detail = TextEditingController(
    text: widget.existingStep?.detail,
  );
  late ActionStepImpact _impact =
      widget.existingStep?.impact ?? ActionStepImpact.medium;

  bool get _isEditing => widget.existingStep != null;

  @override
  void dispose() {
    _title.dispose();
    _detail.dispose();
    super.dispose();
  }

  bool _submitting = false;

  Future<void> _submit() async {
    if (_title.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Give the step a title first.')),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      await widget.onSubmit(
        title: _title.text.trim(),
        detail: _detail.text.trim(),
        impact: _impact,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not save: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: OfficerCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    _isEditing ? 'Edit step' : 'Add step manually',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: OfficerPalette.ink,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              LabeledField(
                label: 'STEP TITLE',
                controller: _title,
                hintText: 'e.g. Oct — top up buffer before festival spend',
              ),
              const SizedBox(height: 12),
              LabeledField(
                label: 'DETAIL',
                controller: _detail,
                maxLines: 2,
                hintText: 'e.g. begin by 20 Sep · covers the Diwali dip',
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.only(bottom: 6, left: 2),
                child: Text(
                  'IMPACT',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: OfficerPalette.muted,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: OfficerPalette.soft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<ActionStepImpact>(
                    value: _impact,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: OfficerPalette.muted,
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      color: OfficerPalette.ink,
                    ),
                    items: <DropdownMenuItem<ActionStepImpact>>[
                      for (final ActionStepImpact impact
                          in ActionStepImpact.values)
                        DropdownMenuItem<ActionStepImpact>(
                          value: impact,
                          child: Text(impact.label),
                        ),
                    ],
                    onChanged: (ActionStepImpact? value) {
                      if (value != null) {
                        setState(() => _impact = value);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              OfficerPrimaryButton(
                label: _submitting
                    ? 'Saving…'
                    : (_isEditing ? 'Save changes ✓' : 'Add step ✓'),
                onPressed: _submitting ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
