/// Host for guided setup (designs 1h–1n).
library;

import 'package:flutter/material.dart';

import '../../../app/model/business.dart';
import '../../../app/session.dart';
import '../../../core/widgets/page_backdrop.dart';
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
  const SetupFlow({super.key, required this.onFinished});

  /// Called when the hub's Finish unlocks and is tapped.
  final VoidCallback onFinished;

  @override
  State<SetupFlow> createState() => _SetupFlowState();
}

class _SetupFlowState extends State<SetupFlow> {
  _SetupStage _stage = _SetupStage.location;

  /// Scratch state for the business currently in the 1k–1m subflow.
  BusinessDraft _draft = BusinessDraft();

  void _advance(_SetupStage next) {
    setState(() => _stage = next);
  }

  /// One stage backwards; swallows back at the first screen.
  void _back() {
    final _SetupStage? previous = switch (_stage) {
      _SetupStage.location => null,
      _SetupStage.count => _SetupStage.location,
      _SetupStage.hub => _SetupStage.count,
      _SetupStage.kind => _SetupStage.hub,
      _SetupStage.details => _SetupStage.kind,
      _SetupStage.money => _SetupStage.details,
    };

    if (previous != null) {
      setState(() => _stage = previous);
    }
  }

  void _submitBusiness(AppSession session, Business business) {
    session.addBusiness(business);
    setState(() {
      _draft = BusinessDraft();
      _stage = _SetupStage.hub;
    });
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
