/// Setup 1 · Location (design 1h).
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/gradient_cta_button.dart';
import '../../../core/widgets/info_note.dart';
import '../../../core/widgets/khushhal_card.dart';
import '../../../core/widgets/searchable_picker.dart';
import '../../../core/widgets/section_label.dart';
import '../../../l10n/app_localizations.dart';
import '../../locations/data/geocoder.dart';
import '../../locations/data/location_repository.dart';
import 'widgets/setup_progress_header.dart';
import 'widgets/step_page.dart';

/// Guided setup step 1 — pick state → district → village, with a live map
/// centred on the picked district for confirmation.
///
/// Reads states / districts from the backend when a [LocationRepository]
/// is provided; village is a free-typed searchable field since we don't
/// ship a curated village dataset.
class LocationStep extends StatefulWidget {
  const LocationStep({super.key, required this.onConfirm});

  final VoidCallback onConfirm;

  @override
  State<LocationStep> createState() => _LocationStepState();
}

class _LocationStepState extends State<LocationStep> {
  final _geocoder = Geocoder();
  final MapController _mapController = MapController();

  List<RemoteState> _states = const [];
  List<String> _districts = const [];

  RemoteState? _state;
  String? _district;
  String? _village;
  LatLng? _pin;

  bool _loading = false;
  bool _saving = false;

  static const _indiaCentre = LatLng(22.9734, 78.6569);

  @override
  void initState() {
    super.initState();
    _fetchStates();
  }

  Future<void> _fetchStates() async {
    final repo = _repo();
    if (repo == null) return;
    setState(() => _loading = true);
    try {
      final rows = await repo.listStates();
      if (!mounted) return;
      setState(() => _states = rows);
    } catch (_) {/* silent */} finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _onStatePicked(RemoteState s) async {
    setState(() {
      _state = s;
      _district = null;
      _districts = const [];
      _village = null;
      _pin = null;
    });
    final repo = _repo();
    if (repo == null) return;
    try {
      final ds = await repo.listDistricts(s.code);
      if (!mounted) return;
      setState(() => _districts = ds);
    } catch (_) {}
  }

  Future<void> _onDistrictPicked(String d) async {
    setState(() => _district = d);
    final pin = await _geocoder.forDistrict(state: _state!.nameEn, district: d);
    if (!mounted) return;
    if (pin != null) {
      setState(() => _pin = pin);
      _mapController.move(pin, 9.5);
    }
  }

  LocationRepository? _repo() {
    try {
      return context.read<LocationRepository>();
    } catch (_) {
      return null;
    }
  }

  Future<void> _confirm() async {
    final repo = _repo();
    if (repo == null) {
      widget.onConfirm();
      return;
    }
    setState(() => _saving = true);
    try {
      await repo.saveOnUser(
        state: _state?.nameEn,
        district: _district,
        village: _village,
      );
    } catch (_) {/* best-effort */}
    if (!mounted) return;
    setState(() => _saving = false);
    widget.onConfirm();
  }

  Future<void> _pickState() async {
    final s = await SearchablePicker.show<RemoteState>(
      context,
      title: 'Select state',
      items: _states,
      labelBuilder: (s) => s.nameEn,
      searchHint: 'Search state',
    );
    if (s != null) await _onStatePicked(s);
  }

  Future<void> _pickDistrict() async {
    if (_districts.isEmpty) return;
    final d = await SearchablePicker.show<String>(
      context,
      title: 'Select district',
      items: _districts,
      labelBuilder: (d) => d,
      searchHint: 'Search district',
    );
    if (d != null) await _onDistrictPicked(d);
  }

  Future<void> _pickVillage() async {
    final v = await SearchablePicker.show<String>(
      context,
      title: 'Select village',
      // No curated village dataset yet — allow freetext entry.
      items: const <String>[],
      labelBuilder: (v) => v,
      searchHint: 'Type village name',
      emptyText: 'Type a village name and tap "Use" to add it.',
      allowFreetext: true,
      freetextBuilder: (q) => q,
    );
    if (v != null) setState(() => _village = v);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final canConfirm = _state != null && _district != null;

    return StepPage(
      header: SetupProgressHeader(label: l10n.setupStepOf(1, 5), filled: 1, showBack: false),
      cta: GradientCtaButton(
        label: _saving ? '${l10n.locationConfirmCta}…' : l10n.locationConfirmCta,
        onPressed: (canConfirm && !_saving) ? _confirm : () {},
      ),
      children: <Widget>[
        Text(
          l10n.locationHeading,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppPalette.ink, height: 1.25),
        ),
        const SizedBox(height: 14),
        _MapCard(controller: _mapController, pin: _pin, fallback: _indiaCentre),
        const SizedBox(height: 12),
        SectionLabel(l10n.locationDetectedLabel),
        const SizedBox(height: 8),
        if (_loading) const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: LinearProgressIndicator(minHeight: 2),
        ),
        _FieldRow(
          label: l10n.locationState,
          value: _state?.nameEn,
          enabled: _states.isNotEmpty,
          onTap: _pickState,
        ),
        const SizedBox(height: 8),
        _FieldRow(
          label: l10n.locationDistrict,
          value: _district,
          enabled: _districts.isNotEmpty,
          onTap: _pickDistrict,
        ),
        const SizedBox(height: 8),
        _FieldRow(
          label: l10n.locationVillage,
          value: _village,
          enabled: true,
          onTap: _pickVillage,
        ),
        const SizedBox(height: 14),
        InfoNote(text: l10n.locationWhy),
      ],
    );
  }
}

class _MapCard extends StatelessWidget {
  const _MapCard({required this.controller, required this.pin, required this.fallback});
  final MapController controller;
  final LatLng? pin;
  final LatLng fallback;

  @override
  Widget build(BuildContext context) {
    return KhushhalCard(
      padding: EdgeInsets.zero,
      radius: 16,
      child: SizedBox(
        height: 180,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: FlutterMap(
            mapController: controller,
            options: MapOptions(
              initialCenter: pin ?? fallback,
              initialZoom: pin != null ? 9.5 : 4.6,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.khushhal.app',
              ),
              if (pin != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: pin!,
                      width: 32, height: 32,
                      child: const Icon(Icons.place, color: AppPalette.forest, size: 32),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  const _FieldRow({
    required this.label,
    required this.value,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final String? value;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final display = value ?? label;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppPalette.onPrimary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppPalette.line, width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 11.5, color: AppPalette.muted)),
                  const SizedBox(height: 3),
                  Text(display,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: value != null ? FontWeight.w600 : FontWeight.w400,
                        color: value != null ? AppPalette.cardInk : AppPalette.muted,
                      )),
                ],
              ),
            ),
            Icon(enabled ? Icons.arrow_drop_down_rounded : Icons.lock_outline,
                color: enabled ? AppPalette.body : AppPalette.muted, size: 22),
          ],
        ),
      ),
    );
  }
}
