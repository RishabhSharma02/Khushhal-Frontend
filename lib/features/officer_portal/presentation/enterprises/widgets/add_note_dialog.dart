/// The "Add note" modal for an enterprise's visit & call history (5c).
library;

import 'package:flutter/material.dart';

import '../../../domain/contact_log.dart';
import '../../officer_session.dart';
import '../../theme/officer_palette.dart';
import '../../widgets/labeled_field.dart';
import '../../widgets/officer_buttons.dart';
import '../../widgets/officer_card.dart';

/// Opens the Add-note dialog for [enterpriseId]'s contact history.
Future<void> showAddNoteDialog({
  required BuildContext context,
  required String enterpriseId,
}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) => _AddNoteDialog(enterpriseId: enterpriseId),
  );
}

class _AddNoteDialog extends StatefulWidget {
  const _AddNoteDialog({required this.enterpriseId});

  final String enterpriseId;

  @override
  State<_AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<_AddNoteDialog> {
  final TextEditingController _note = TextEditingController();
  ContactKind _kind = ContactKind.visit;
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _note.dispose();
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
      setState(
        () => _date = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _date.hour,
          _date.minute,
        ),
      );
    }
  }

  void _submit() {
    if (_note.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Write a note first.')),
      );
      return;
    }

    OfficerSessionScope.of(context).addContactNote(
      enterpriseId: widget.enterpriseId,
      date: _date,
      kind: _kind,
      note: _note.text.trim(),
    );

    Navigator.of(context).pop();
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
                  const Text(
                    'Add note',
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
              const Padding(
                padding: EdgeInsets.only(bottom: 6, left: 2),
                child: Text(
                  'KIND',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: OfficerPalette.muted,
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _KindOption(
                      label: 'Visit',
                      icon: Icons.event_note_rounded,
                      selected: _kind == ContactKind.visit,
                      onTap: () => setState(() => _kind = ContactKind.visit),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _KindOption(
                      label: 'Call',
                      icon: Icons.call_rounded,
                      selected: _kind == ContactKind.call,
                      onTap: () => setState(() => _kind = ContactKind.call),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LabeledDisplayField(
                label: 'DATE',
                value: _formatDate(_date),
                onTap: _pickDate,
                trailing: const Icon(
                  Icons.calendar_today_rounded,
                  size: 16,
                  color: OfficerPalette.muted,
                ),
              ),
              const SizedBox(height: 12),
              LabeledField(
                label: 'NOTE',
                controller: _note,
                maxLines: 3,
                hintText: 'e.g. verified stock, passbook up to date',
              ),
              const SizedBox(height: 16),
              OfficerPrimaryButton(label: 'Add note ✓', onPressed: _submit),
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
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _KindOption extends StatelessWidget {
  const _KindOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? OfficerPalette.forest : OfficerPalette.soft,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: 15,
              color: selected ? OfficerPalette.onForest : OfficerPalette.body,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: selected ? OfficerPalette.onForest : OfficerPalette.body,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
