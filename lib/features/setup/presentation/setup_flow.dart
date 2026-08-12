/// Host for guided setup (designs 1h–1n).
library;

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/model/business.dart';
import '../../../app/session.dart';
import '../../../core/widgets/page_backdrop.dart';
import '../../businesses/data/business_repository.dart';
import '../domain/business_draft.dart';
import 'count_step.dart';
import 'details_step.dart';
import 'hub_step.dart';
import 'kind_step.dart';
import 'location_step.dart';
import 'money_step.dart';

/// Where guided setup currently is.
enum _SetupStage { location, count, hub, kind, details, money }

/// Runs guided setup: location (1h), business count (1i), then the
/// hub-and-spoke (1j) that walks each business through kind, details and
/// monthly money (1k–1m).
///
/// The whole flow is one widget with an internal stage — like the
/// onboarding flow, screens hand over via a short [AnimatedSwitcher] fade
/// rather than routes, and the system back gesture steps backwards through
/// stages instead of leaving the app.
class SetupFlow extends StatefulWidget {
  /// Creates the setup flow.
  ///
  /// [startAtKind] skips Location / Count / Hub — used when opening the
  /// flow from Settings → "Add new business" for a signed-in user whose
  /// location + plan is already set.
  const SetupFlow({super.key, required this.onFinished, this.startAtKind = false});

  /// Called when the hub's Finish unlocks and is tapped.
  final VoidCallback onFinished;

  final bool startAtKind;

  @override
  State<SetupFlow> createState() => _SetupFlowState();
}

class _SetupFlowState extends State<SetupFlow> {
  late _SetupStage _stage = widget.startAtKind ? _SetupStage.kind : _SetupStage.location;

  /// Scratch state for the business currently in the 1k–1m subflow.
  BusinessDraft _draft = BusinessDraft();

  void _advance(_SetupStage next) {
    setState(() => _stage = next);
  }

  /// One stage backwards. Pops the whole flow when we're at the natural
  /// first stage — either LocationStep for the onboarding path or KindStep
  /// for the "Add new business from Settings" path.
  void _back() {
    if ((widget.startAtKind && _stage == _SetupStage.kind)
        || _stage == _SetupStage.location) {
      Navigator.of(context).maybePop();
      return;
    }
    final _SetupStage previous = switch (_stage) {
      _SetupStage.location => _SetupStage.location, // unreachable — handled above
      _SetupStage.count => _SetupStage.location,
      _SetupStage.hub => _SetupStage.count,
      _SetupStage.kind => _SetupStage.hub,
      _SetupStage.details => _SetupStage.kind,
      _SetupStage.money => _SetupStage.details,
    };
    setState(() => _stage = previous);
  }

  Future<void> _submitBusiness(AppSession session, Business business) async {
    session.addBusiness(business);
    if (widget.startAtKind) {
      // Add-from-Settings path: no Hub to return to — pop straight back.
      widget.onFinished();
    } else {
      setState(() {
        _draft = BusinessDraft();
        _stage = _SetupStage.hub;
      });
    }

    // Best-effort backend persistence — the demo state is now updated so the
    // UI moves on immediately; if the network call succeeds we register the
    // backend id so subsequent ledger entries know where to land, otherwise
    // we surface a snackbar and leave the local state alone.
    BusinessRepository? repo;
    try {
      repo = context.read<BusinessRepository>();
    } catch (_) {
      return;
    }
    try {
      final remote = await repo.create(business);
      if (!mounted) return;
      session.registerBackendBusinessId(remote.id);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Business saved locally — sync failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppSession session = SessionScope.of(context);
    final int businessNumber = session.businesses.length + 1;

    final Widget step = switch (_stage) {
      _SetupStage.location => LocationStep(
        onConfirm: () {
          session.confirmLocation();
          _advance(_SetupStage.count);
        },
      ),
      _SetupStage.count => CountStep(
        onNext: (int count) {
          session.plannedBusinessCount = count;
          _advance(_SetupStage.hub);
        },
      ),
      _SetupStage.hub => HubStep(
        planned: session.plannedBusinessCount,
        businesses: session.businesses,
        onStartSetup: () => _advance(_SetupStage.kind),
        onFinish: widget.onFinished,
      ),
      _SetupStage.kind => KindStep(
        draft: _draft,
        businessNumber: businessNumber,
        onNext: () => _advance(_SetupStage.details),
      ),
      _SetupStage.details => DetailsStep(
        draft: _draft,
        businessNumber: businessNumber,
        onNext: () => _advance(_SetupStage.money),
      ),
      _SetupStage.money => MoneyStep(
        draft: _draft,
        businessNumber: businessNumber,
        onSubmit: (Business business) => _submitBusiness(session, business),
      ),
    };

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          _back();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: PageBackdrop(
          gradient: true,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            child: KeyedSubtree(
              key: ValueKey<String>('$_stage-${session.businesses.length}'),
              child: step,
            ),
          ),
        ),
      ),
    );
  }
}
