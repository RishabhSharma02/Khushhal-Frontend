/// The officer's own profile and session (Officer Portal 5l).
library;

import 'package:flutter/material.dart';

import '../../domain/officer_profile.dart';
import '../auth/logout_screen.dart';
import '../officer_session.dart';
import '../theme/officer_palette.dart';
import '../widgets/officer_nav_rail.dart';
import '../widgets/officer_shell_scaffold.dart';
import 'widgets/account_details_card.dart';
import 'widgets/coverage_card.dart';
import 'widgets/edit_profile_dialog.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/session_card.dart';

/// Identity, account details, coverage stats, and the log-out entry point.
class ProfileScreen extends StatefulWidget {
  /// Creates the profile screen.
  const ProfileScreen({
    super.key,
    required this.onSectionSelected,
    required this.onLoggedOut,
  });

  /// Called when a rail section is tapped.
  final ValueChanged<OfficerSection> onSectionSelected;

  /// Called once the officer confirms logging out and taps "Sign in again".
  final VoidCallback onLoggedOut;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<OfficerCoverage>? _coverageFuture;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      _coverageFuture = OfficerSessionScope.of(context).profileRepository?.fetchCoverage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final OfficerSession session = OfficerSessionScope.of(context);

    return OfficerShellScaffold(
      section: OfficerSection.profile,
      onSectionSelected: widget.onSectionSelected,
      children: <Widget>[
        const Text(
          'My profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: OfficerPalette.ink,
          ),
        ),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final Widget left = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ProfileHeaderCard(
                  officer: session.profile,
                  onEdit: () => showEditProfileDialog(context: context),
                ),
                const SizedBox(height: 14),
                AccountDetailsCard(officer: session.profile),
              ],
            );
            final Widget right = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                FutureBuilder<OfficerCoverage>(
                  future: _coverageFuture,
                  builder: (BuildContext context, AsyncSnapshot<OfficerCoverage> snapshot) {
                    if (!snapshot.hasData) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return CoverageCard(coverage: snapshot.data!);
                  },
                ),
                const SizedBox(height: 14),
                SessionCard(
                  officer: session.profile,
                  onLogOut: () => showLogoutDialog(
                    context: context,
                    onSignedOut: widget.onLoggedOut,
                  ),
                ),
              ],
            );

            if (constraints.maxWidth > 780) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(flex: 6, child: left),
                  const SizedBox(width: 14),
                  Expanded(flex: 5, child: right),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[left, const SizedBox(height: 14), right],
            );
          },
        ),
      ],
    );
  }
}
