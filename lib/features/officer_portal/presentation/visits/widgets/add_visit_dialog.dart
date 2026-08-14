/// The "Log visit" modal: form then success state (Officer Portal 5n).
///
/// Records a visit that has already happened — date/time default to now,
/// notes capture the outcome, and the entry is saved as done. This isn't a
/// scheduler: officers log visits after the fact, not plan future ones.
library;

import 'package:flutter/material.dart';

import '../../../domain/enterprise.dart';
import '../../officer_session.dart';
import '../../theme/officer_palette.dart';
import '../../widgets/labeled_field.dart';
import '../../widgets/officer_buttons.dart';
import '../../widgets/officer_card.dart';
import '../../widgets/status_chip.dart';

/// Opens the Add-visit dialog, optionally pre-selecting [initialEnterpriseId]
/// (used by the enterprise detail screen's "Schedule visit" button).
Future<void> showAddVisitDialog({
  required BuildContext context,
  String? initialEnterpriseId,
}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) =>
        _AddVisitDialog(initialEnterpriseId: initialEnterpriseId),
  );
}

class _AddVisitDialog extends StatefulWidget {
  const _AddVisitDialog({this.initialEnterpriseId});

  final String? initialEnterpriseId;

  @override
  State<_AddVisitDialog> createState() => _AddVisitDialogState();
}

class _AddVisitDialogState extends State<_AddVisitDialog> {
  Enterprise? _enterprise;
  RiskLevel? _status;
  late DateTime _date = DateTime.now();
  late TimeOfDay _time = TimeOfDay.fromDateTime(DateTime.now());
  final TextEditingController _agenda = TextEditingController();
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialEnterpriseId != null) {
      final OfficerSession session = OfficerSessionScope.of(context);
      _enterprise = session.enterpriseById(widget.initialEnterpriseId!);
      _status = _enterprise?.riskLevel;
    }
  }

  @override
  void dispose() {
    _agenda.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2026, 1, 1),
      lastDate: DateTime(2027, 12, 31),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null) {
      setState(() => _time = picked);
    }
  }

  bool _submitting = false;

  Future<void> _submit() async {
    final Enterprise? enterprise = _enterprise;
    if (enterprise == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pick an enterprise first.')),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final OfficerSession session = OfficerSessionScope.of(context);
      await session.addVisit(
        businessId: enterprise.id,
        date: DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute),
        agenda: _agenda.text.trim().isEmpty ? 'Field visit' : _agenda.text.trim(),
        riskLevel: _status ?? enterprise.riskLevel,
      );
      if (!mounted) return;
      setState(() => _submitted = true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not log the visit: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Enterprise? enterprise = _enterprise;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: OfficerCard(
          padding: const EdgeInsets.all(22),
          child: _submitted
              ? _SuccessContent(enterprise: enterprise)
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Text(
                          'Log visit',
                          style: TextStyle(
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
                    _EnterprisePicker(
                      selected: enterprise,
                      onSelected: (Enterprise e) => setState(() {
                        _enterprise = e;
                        _status = e.riskLevel;
                      }),
                    ),
                    const SizedBox(height: 12),
                    _StatusPicker(
                      selected: _status,
                      onSelected: (RiskLevel level) =>
                          setState(() => _status = level),
                    ),
                    const SizedBox(height: 12),
                    LabeledDisplayField(
                      label: 'VISIT DATE',
                      value: _formatDate(_date),
                      onTap: _pickDate,
                      trailing: const Icon(
                        Icons.calendar_today_rounded,
                        size: 16,
                        color: OfficerPalette.muted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    LabeledDisplayField(
                      label: 'VISIT TIME',
                      value: _time.format(context),
                      onTap: _pickTime,
                      trailing: const Icon(
                        Icons.schedule_rounded,
                        size: 16,
                        color: OfficerPalette.muted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    LabeledField(
                      label: 'VISIT NOTES',
                      controller: _agenda,
                      maxLines: 3,
                      hintText:
                          'e.g. reviewed passbook, discussed EMI restructure, next steps agreed',
                    ),
                    const SizedBox(height: 16),
                    OfficerPrimaryButton(
                      label: _submitting ? 'Logging…' : 'Log visit ✓',
                      onPressed: _submitting ? null : _submit,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    const List<String> months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    const List<String> weekdays = <String>[
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];
    return '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

/// Lets the officer record the enterprise's standing as observed on this
/// visit — this is what makes the outcome show up back on the visits list,
/// instead of silently inheriting whatever the enterprise's last status was.
class _StatusPicker extends StatelessWidget {
  const _StatusPicker({required this.selected, required this.onSelected});

  final RiskLevel? selected;
  final ValueChanged<RiskLevel> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text(
          'VISIT STATUS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: OfficerPalette.muted,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: <Widget>[
            for (final RiskLevel level in RiskLevel.values) ...<Widget>[
              if (level != RiskLevel.values.first) const SizedBox(width: 8),
              Expanded(
                child: _StatusOption(
                  level: level,
                  selected: selected == level,
                  onTap: () => onSelected(level),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _StatusOption extends StatelessWidget {
  const _StatusOption({
    required this.level,
    required this.selected,
    required this.onTap,
  });

  final RiskLevel level;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg) = switch (level.tone) {
      OfficerTone.green => (
        OfficerPalette.chipGreenBg,
        OfficerPalette.chipGreenInk,
      ),
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

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? bg : OfficerPalette.soft,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? fg : Colors.transparent, width: 1.4),
        ),
        child: Text(
          level.label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: selected ? fg : OfficerPalette.body,
          ),
        ),
      ),
    );
  }
}

class _EnterprisePicker extends StatelessWidget {
  const _EnterprisePicker({required this.selected, required this.onSelected});

  final Enterprise? selected;
  final ValueChanged<Enterprise> onSelected;

  @override
  Widget build(BuildContext context) {
    final OfficerSession session = OfficerSessionScope.of(context);

    return LabeledDisplayField(
      label: 'ENTERPRISE',
      value: selected == null ? '🔍 Search enterprise…' : selected!.name,
      onTap: () async {
        final Enterprise? picked = await showModalBottomSheet<Enterprise>(
          context: context,
          builder: (BuildContext context) =>
              _EnterprisePickerSheet(enterprises: session.enterprises),
        );
        if (picked != null) {
          onSelected(picked);
        }
      },
    );
  }
}

class _EnterprisePickerSheet extends StatelessWidget {
  const _EnterprisePickerSheet({required this.enterprises});

  final List<Enterprise> enterprises;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: enterprises.length,
        itemBuilder: (BuildContext context, int index) {
          final Enterprise enterprise = enterprises[index];
          return ListTile(
            title: Text(enterprise.name),
            subtitle: Text(
              '${enterprise.village} · ${enterprise.contact.name}',
            ),
            onTap: () => Navigator.of(context).pop(enterprise),
          );
        },
      ),
    );
  }
}

class _SuccessContent extends StatelessWidget {
  const _SuccessContent({required this.enterprise});

  final Enterprise? enterprise;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 52,
          height: 52,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: OfficerPalette.chipGreenBg,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            color: OfficerPalette.forest,
            size: 24,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Visit logged',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: OfficerPalette.ink,
          ),
        ),
        const SizedBox(height: 4),
        if (enterprise != null)
          Text(
            enterprise!.name,
            style: const TextStyle(fontSize: 12.5, color: OfficerPalette.muted),
          ),
        const SizedBox(height: 12),
        OfficerPrimaryButton(
          label: 'Back to visits',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
