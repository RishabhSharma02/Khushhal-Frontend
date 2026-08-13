/// Root widget for the Officer Portal.
library;

import 'package:flutter/material.dart';

import 'auth/officer_auth_flow.dart';
import 'officer_session.dart';
import 'officer_shell.dart';
import 'theme/officer_theme.dart';

/// The top-level stretches of the officer's journey.
enum _OfficerPhase {
  /// Login, sign up, set password, forgot password (5h–5k).
  auth,

  /// The rail-navigated portal proper (5a onwards).
  shell,
}

/// Owns the [OfficerSession] and the [MaterialApp] — the Officer Portal's
/// equivalent of the consumer app's `MyApp`.
///
/// [OfficerSessionScope] is applied via [MaterialApp.builder], above the
/// `Navigator` rather than around `home`, so pushed routes and dialogs (add
/// visit, enterprise detail, logout) can still find the session.
class OfficerPortalRoot extends StatefulWidget {
  /// Creates the root widget.
  const OfficerPortalRoot({super.key});

  @override
  State<OfficerPortalRoot> createState() => _OfficerPortalRootState();
}

class _OfficerPortalRootState extends State<OfficerPortalRoot> {
  _OfficerPhase _phase = _OfficerPhase.auth;
  OfficerSession _session = OfficerSession();

  void _handleAuthenticated() {
    _session.markSignedIn(DateTime(2026, 8, 1, 9, 2));
    setState(() => _phase = _OfficerPhase.shell);
  }

  void _handleLoggedOut() {
    setState(() {
      _phase = _OfficerPhase.auth;
      _session = OfficerSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "KHUSH-HAL Officers' Portal",
      theme: OfficerTheme.light,
      themeMode: ThemeMode.light,
      builder: (BuildContext context, Widget? child) {
        return OfficerSessionScope(session: _session, child: child!);
      },
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: switch (_phase) {
          _OfficerPhase.auth => OfficerAuthFlow(
            key: const ValueKey<_OfficerPhase>(_OfficerPhase.auth),
            onAuthenticated: _handleAuthenticated,
          ),
          _OfficerPhase.shell => OfficerShell(
            key: const ValueKey<_OfficerPhase>(_OfficerPhase.shell),
            onLoggedOut: _handleLoggedOut,
          ),
        },
      ),
    );
  }
}
