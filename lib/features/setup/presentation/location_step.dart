/// Setup 1 · Location (design 1h).
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
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

  bool _locating = false;
  String? _locateError;
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

  Future<void> _useMyLocation() async {
    if (_locating) return;
    setState(() {
      _locating = true;
      _locateError = null;
    });
    try {
      final serviceOn = await Geolocator.isLocationServiceEnabled();
      if (!serviceOn) {
        setState(() {
          _locating = false;
          _locateError = 'Turn on device location and try again.';
        });
        return;
      }
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied) {
        setState(() {
          _locating = false;
          _locateError = 'Location permission denied.';
        });
        return;
      }
      if (perm == LocationPermission.deniedForever) {
        setState(() {
          _locating = false;
          _locateError =
              'Location permission is blocked — enable it from system settings.';
        });
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 12),
        ),
      );
      final at = LatLng(pos.latitude, pos.longitude);
      // Reverse-geocode via Nominatim (Mappls would slot in here).
      final res = await _geocoder.reverse(at);
      if (!mounted) return;

      // Match the returned state name to one we ship dropdowns for.
      RemoteState? matched;
      if (res?.state != null) {
        final needle = res!.state!.toLowerCase().trim();
        for (final s in _states) {
          if (s.nameEn.toLowerCase() == needle) { matched = s; break; }
        }
      }
      setState(() {
        _pin = at;
        if (matched != null) _state = matched;
        if (res?.district != null) _district = res!.district;
        if (res?.village != null) _village = res!.village;
        _locating = false;
      });
      // Refresh district list for the matched state so the picker below
      // reflects the auto-filled district.
      if (matched != null) {
        try {
          final repo = _repo();
          if (repo != null) {
            final ds = await repo.listDistricts(matched.code);
            if (mounted) setState(() => _districts = ds);
          }
        } catch (_) {}
      }
      _mapController.move(at, 13);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _locating = false;
        _locateError = 'Could not get a location fix: $e';
      });
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
        const SizedBox(height: 10),
        _UseMyLocationCard(
          busy: _locating,
          error: _locateError,
          onTap: _useMyLocation,
        ),
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
    // Defer the actual OSM map render until we have a real pin — otherwise
    // the emulator spends multi-second frames rasterising tiles at zoom 4
    // just to show an outline of India before the user has picked anything.
    if (pin == null) return const _MapPlaceholder();
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
              initialCenter: pin!,
              initialZoom: 9.5,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.khushhal.app',
              ),
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

/// Highlighted "Use my location" tile — taps kick off the GPS permission
/// prompt + reverse-geocode. Renders inline error copy under the row when
/// the request fails so the user knows why nothing filled in.
class _UseMyLocationCard extends StatelessWidget {
  const _UseMyLocationCard({required this.busy, required this.error, required this.onTap});
  final bool busy;
  final String? error;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KhushhalCard(
          highlighted: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          onTap: busy ? null : onTap,
          child: Row(
            children: [
              busy
                  ? const SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  : const Icon(Icons.my_location, size: 20, color: AppPalette.forest),
              const SizedBox(width: 10),
              Expanded(
                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                      text: l10n.locationUseMine,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: '  ·  ${l10n.locationOneTap}'),
                  ]),
                  style: const TextStyle(fontSize: 15, color: AppPalette.ink),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppPalette.forest),
            ],
          ),
        ),
        if (error != null) Padding(
          padding: const EdgeInsets.only(top: 6, left: 4),
          child: Text(error!,
              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.error)),
        ),
      ],
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: AppPalette.mintNote,
        border: Border.all(color: const Color(0xFFA9C9B2), width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.place_outlined, size: 22, color: Color(0xFF5C8468)),
          const SizedBox(height: 5),
          Text(
            AppLocalizations.of(context)!.locationMapHint,
            style: const TextStyle(fontSize: 12, color: Color(0xFF5C8468)),
          ),
        ],
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
