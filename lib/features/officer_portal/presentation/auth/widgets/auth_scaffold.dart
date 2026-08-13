/// The shared logo + title + card wrapper for every auth screen (5h–5k).
library;

import 'package:flutter/material.dart';

import '../../theme/officer_palette.dart';
import '../../widgets/officer_card.dart';

/// Centers a titled card on the portal's window background — the mocks'
/// ".auth"/".acard" pair.
class AuthScaffold extends StatelessWidget {
  /// Creates the auth screen wrapper.
  const AuthScaffold({
    super.key,
    this.logo,
    required this.title,
    this.subtitle,
    required this.child,
  });

  /// An optional icon/logo shown above the title (login screen only).
  final Widget? logo;

  /// The screen's heading.
  final String title;

  /// A muted line under the heading.
  final String? subtitle;

  /// The form card's content.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OfficerPalette.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: OfficerPalette.windowSurface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ?logo,
                    if (logo != null) const SizedBox(height: 10),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: OfficerPalette.ink,
                      ),
                    ),
                    if (subtitle != null) ...<Widget>[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          color: OfficerPalette.muted,
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 360),
                      child: OfficerCard(
                        padding: const EdgeInsets.all(24),
                        child: child,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
