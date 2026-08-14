/// Banner and helper for the handful of screens that genuinely need a
/// connection.
library;

import 'package:flutter/material.dart';

import '../../app/session.dart';
import '../theme/theme.dart';

/// Explains why a screen cannot proceed offline.
///
/// Most of this app works without a connection, which makes the exceptions
/// worth naming rather than letting a button silently do nothing. The
/// exceptions all share a reason: they mint identity or server ids that
/// everything else keys off. Phone login and OTP need Firebase to issue a
/// token; onboarding and business creation need the backend to assign the
/// BIGINT that entries, health scores and alerts all reference.
class OnlineRequiredNotice extends StatelessWidget {
  const OnlineRequiredNotice({super.key, required this.action});

  /// What the user was trying to do, e.g. "sign in".
  final String action;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF6E3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD9C88F), width: 1.5),
      ),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.wifi_off_rounded,
            size: 18,
            color: Color(0xFF8A6D00),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'You need an internet connection to $action.',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF8A6D00),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Whether the app currently believes it can reach the backend.
bool isOnline(BuildContext context) =>
    SessionScope.of(context).connectivity != ConnectivityStatus.offline;

/// Blocks an online-only action, telling the user why.
///
/// Returns true when it is safe to proceed.
bool requireOnline(BuildContext context, String action) {
  if (isOnline(context)) return true;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('You need an internet connection to $action.'),
      backgroundColor: AppPalette.forest,
    ),
  );
  return false;
}
