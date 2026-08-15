import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/labels.dart';
import '../../../app/model/business.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/gradient_cta_button.dart';
import '../../../l10n/app_localizations.dart';
import '../data/business_api.dart';
import '../data/business_repository.dart';

/// Bottom sheet for editing the three cheap fields on a business: name,
/// staff count, tenure. Segment + sector stay locked because changing them
/// invalidates every stamped health score.
///
/// Pops the edited [Business] once Save commits — including when the edit
/// could only be applied locally — or null when the sheet is dismissed.
/// Callers mirror the returned record into `AppSession`.
class EditBusinessSheet extends StatefulWidget {
  const EditBusinessSheet({super.key, required this.business, required this.backendId});

  final Business business;
  final int? backendId;

  @override
  State<EditBusinessSheet> createState() => _EditBusinessSheetState();
}

class _EditBusinessSheetState extends State<EditBusinessSheet> {
  late final TextEditingController _name = TextEditingController(text: widget.business.name);
  late int _staff = widget.business.staffCount;
  late BusinessTenure _tenure = widget.business.tenure;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Business get _edited => widget.business.copyWith(
        name: _name.text.trim(),
        staffCount: _staff,
        tenure: _tenure,
      );

  Future<void> _save() async {
    if (widget.backendId == null) {
      // Nothing to address the local row by yet.
      Navigator.of(context).pop(_edited);
      return;
    }
    final BusinessRepository repo;
    try {
      repo = context.read<BusinessRepository>();
    } catch (_) {
      Navigator.of(context).pop(_edited);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      // Writes to SQLite and queues the PATCH, so this returns immediately and
      // succeeds with or without a connection.
      final String? clientId = await repo.clientIdFor(widget.backendId!);
      if (clientId != null) {
        await repo.update(
          clientId,
          name: _name.text.trim(),
          staffCount: _staff,
          tenure: BusinessApiMapper.tenure(_tenure),
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop(_edited);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = 'Save failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final khushhal = Theme.of(context).extension<KhushhalColors>()!;
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: khushhal.line, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 16),
          Text(l10n.editBusinessTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: khushhal.forest)),
          const SizedBox(height: 16),
          _LockedRow(
            label: l10n.editBusinessKindLabel,
            value: widget.business.segment.label(l10n),
          ),
          const SizedBox(height: 8),
          _LockedRow(
            label: l10n.editBusinessSectorLabel,
            value: widget.business.sector.label(l10n),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lock_outline_rounded, size: 14, color: AppPalette.hint),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.editBusinessLockedNote,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppPalette.hint,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('Staff', style: TextStyle(color: khushhal.ink, fontSize: 14)),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: _staff > 1 ? () => setState(() => _staff--) : null,
              ),
              Text('$_staff', style: TextStyle(color: khushhal.ink, fontSize: 18, fontWeight: FontWeight.w600)),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => setState(() => _staff++),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final t in BusinessTenure.values)
                ChoiceChip(
                  label: Text(_tenureLabel(t)),
                  selected: _tenure == t,
                  onSelected: (_) => setState(() => _tenure = t),
                ),
            ],
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ],
          const SizedBox(height: 20),
          if (_saving) const LinearProgressIndicator(minHeight: 2),
          const SizedBox(height: 12),
          GradientCtaButton(label: _saving ? 'Saving…' : 'Save', onPressed: _saving ? () {} : _save),
        ],
      ),
    );
  }

  String _tenureLabel(BusinessTenure t) => switch (t) {
        BusinessTenure.underOneYear => '< 1 year',
        BusinessTenure.oneToThreeYears => '1–3 years',
        BusinessTenure.threeToTenYears => '3–10 years',
        BusinessTenure.tenPlus => '10+ years',
      };
}

/// Read-only pill for segment/sector on the edit sheet — greyed out to signal
/// that the field cannot be changed.
class _LockedRow extends StatelessWidget {
  const _LockedRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppPalette.mintNote,
        border: Border.all(color: AppPalette.mintNoteBorder),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppPalette.muted,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.mintNoteInk,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.lock_outline_rounded, size: 16, color: AppPalette.faint),
        ],
      ),
    );
  }
}
