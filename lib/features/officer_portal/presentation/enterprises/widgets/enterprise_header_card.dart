/// The enterprise detail's header: identity, risk chip, contact (5c).
library;

import 'package:flutter/material.dart';

import '../../../domain/enterprise.dart';
import '../../theme/officer_palette.dart';
import '../../widgets/officer_avatar.dart';
import '../../widgets/officer_buttons.dart';
import '../../widgets/status_chip.dart';

/// Icon, name, risk chip, meta line, and a contact card with quick actions.
class EnterpriseHeaderCard extends StatelessWidget {
  /// Creates the header.
  const EnterpriseHeaderCard({
    super.key,
    required this.enterprise,
    required this.onScheduleVisit,
  });

  /// The enterprise being viewed.
  final Enterprise enterprise;

  /// Called when "Schedule visit" is tapped.
  final VoidCallback onScheduleVisit;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool wide = constraints.maxWidth > 760;

        final Widget identity = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            OfficerAvatar(
              text: enterprise.icon,
              size: 52,
              fontSize: 24,
              background: OfficerPalette.chipGreenBg,
              foreground: OfficerPalette.ink,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    children: <Widget>[
                      Text(
                        enterprise.name,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: OfficerPalette.ink,
                        ),
                      ),
                      StatusChip(
                        label:
                            '● ${enterprise.riskLevel.label} · score ${enterprise.healthScore}'
                            '${enterprise.scoreRising ? ' ▲' : ' ▼'}',
                        tone: enterprise.riskLevel.tone,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${enterprise.typeSectorLabel} · ${enterprise.village} · '
                    '${enterprise.contact.name} · est. ${enterprise.establishedYear} · '
                    '${enterprise.staffCount} workers',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: OfficerPalette.muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

        final Widget contact = _ContactCard(
          enterprise: enterprise,
          onScheduleVisit: onScheduleVisit,
        );

        if (wide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(child: identity),
              const SizedBox(width: 16),
              SizedBox(width: 620, child: contact),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[identity, const SizedBox(height: 14), contact],
        );
      },
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.enterprise, required this.onScheduleVisit});

  final Enterprise enterprise;
  final VoidCallback onScheduleVisit;

  @override
  Widget build(BuildContext context) {
    final Widget infoBox = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: OfficerPalette.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: <Widget>[
          OfficerAvatar(
            text: _initials(enterprise.contact.name),
            size: 36,
            fontSize: 13,
            background: OfficerPalette.chipGreenBg,
            foreground: OfficerPalette.forest,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      TextSpan(
                        text: enterprise.contact.name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: OfficerPalette.ink,
                        ),
                      ),
                      TextSpan(
                        text: ' · ${enterprise.contact.role}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: OfficerPalette.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '📞 ${enterprise.contact.phone} · 🗣 ${enterprise.contact.language}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: OfficerPalette.body,
                  ),
                ),
                Text(
                  '${enterprise.village} · best time ${enterprise.contact.bestTime}',
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: OfficerPalette.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final Widget actions = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        OfficerSecondaryButton(label: '💬 Send SMS advice', onPressed: null),
        const SizedBox(height: 6),
        OfficerPrimaryButton(
          label: '🗓 Schedule visit',
          expand: false,
          onPressed: null,
        ),
      ],
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth >= 560) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: infoBox),
              const SizedBox(width: 10),
              SizedBox(width: 200, child: actions),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[infoBox, const SizedBox(height: 10), actions],
        );
      },
    );
  }

  static String _initials(String name) {
    final List<String> parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) {
      return '';
    }
    final String first = parts.first.isNotEmpty ? parts.first[0] : '';
    final String last = parts.length > 1 && parts.last.isNotEmpty
        ? parts.last[0]
        : '';
    return (first + last).toUpperCase();
  }
}
