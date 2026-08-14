/// The three-tab shell around the app proper (designs 1o, 1v, 1x).
library;

import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/page_backdrop.dart';
import '../../../l10n/app_localizations.dart';
import '../../entries/presentation/history_screen.dart';
import '../../onboarding/domain/app_language.dart';
import '../../settings/presentation/settings_screen.dart';
import 'home_screen.dart';

/// Bottom-nav shell: Home (1o), History (1v), Settings (1x).
///
/// The three tabs live in an [IndexedStack] so switching keeps each tab's
/// scroll position; deeper screens (add entry, forecast, sync…) are pushed
/// on top of the whole shell and cover the nav, exactly as in the mocks.
class AppShell extends StatefulWidget {
  /// Creates the shell.
  const AppShell({
    super.key,
    required this.onLanguageSelected,
    required this.onLogout,
  });

  /// Called when Settings picks a different app language.
  final ValueChanged<AppLanguage> onLanguageSelected;

  /// Called by Settings' "Log out" — resets the app to onboarding.
  final VoidCallback onLogout;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  /// Index of the Home tab in the [IndexedStack] and the nav row.
  static const int _homeTab = 0;

  int _tab = _homeTab;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: PageBackdrop(
        child: Column(
          children: <Widget>[
            Expanded(
              child: IndexedStack(
                index: _tab,
                children: <Widget>[
                  const HomeScreen(),
                  const HistoryScreen(),
                  SettingsScreen(
                    onLanguageSelected: widget.onLanguageSelected,
                    onLogout: widget.onLogout,
                    onShowHome: () => setState(() => _tab = _homeTab),
                  ),
                ],
              ),
            ),
            _ShellNav(
              current: _tab,
              labels: <String>[l10n.navHome, l10n.navHistory, l10n.navSettings],
              onSelected: (int tab) => setState(() => _tab = tab),
            ),
          ],
        ),
      ),
    );
  }
}

/// The three-item bottom navigation row.
class _ShellNav extends StatelessWidget {
  const _ShellNav({
    required this.current,
    required this.labels,
    required this.onSelected,
  });

  final int current;
  final List<String> labels;
  final ValueChanged<int> onSelected;

  static const List<IconData> _icons = <IconData>[
    Icons.home_rounded,
    Icons.receipt_long_rounded,
    Icons.settings_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE4EDE5), width: 1.5)),
      ),
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.only(top: 12),
      child: Row(
        children: List<Widget>.generate(labels.length, (int index) {
          final bool active = index == current;
          final Color color = active ? AppPalette.forest : AppPalette.hint;

          return Expanded(
            child: InkWell(
              onTap: () => onSelected(index),
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(_icons[index], size: 22, color: color),
                    const SizedBox(height: 3),
                    Text(
                      labels[index],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                        color: color,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
