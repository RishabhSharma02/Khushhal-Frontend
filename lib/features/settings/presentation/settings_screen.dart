/// Settings — profile, businesses, preferences, support (design 1x).
library;

import 'package:flutter/material.dart';

import '../../../app/labels.dart';
import '../../../app/model/business.dart';
import '../../../app/session.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/khushhal_card.dart';
import '../../../core/widgets/section_label.dart';
import '../../../core/widgets/sync_chip.dart';
import '../../../l10n/app_localizations.dart';
import '../../businesses/presentation/edit_business_sheet.dart';
import '../../onboarding/domain/app_language.dart';
import '../../setup/presentation/setup_flow.dart';
import '../../sync/presentation/sync_screen.dart';

/// The settings tab: who is signed in, their businesses, and the few
/// preferences the app has.
///
/// The language row carries an inline `Eng | हिंदी` toggle that re-renders
/// the whole app on the spot — one language on screen at any time.
class SettingsScreen extends StatelessWidget {
  /// Creates the settings tab.
  const SettingsScreen({
    super.key,
    required this.onLanguageSelected,
    required this.onLogout,
    required this.onShowHome,
  });

  /// Called when the language toggle picks a different app language.
  final ValueChanged<AppLanguage> onLanguageSelected;

  /// Called by "Log out" — resets the app to onboarding.
  final VoidCallback onLogout;

  /// Switches the shell to the Home tab. Used after "Add new business", so
  /// the wizard's "See my health card" lands on the card it promised.
  final VoidCallback onShowHome;

  /// Icon standing in for a sector on the business rows.
  static const Map<BusinessSector, IconData> _sectorIcons =
      <BusinessSector, IconData>{
        BusinessSector.dairy: Icons.water_drop_rounded,
        BusinessSector.poultry: Icons.egg_rounded,
        BusinessSector.foodProcessing: Icons.restaurant_rounded,
        BusinessSector.crafts: Icons.handyman_rounded,
        BusinessSector.shop: Icons.storefront_rounded,
        BusinessSector.other: Icons.work_rounded,
      };

  Future<void> _openAddBusiness(BuildContext context) async {
    final int before = SessionScope.of(context).businesses.length;
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(
        // `pop`, not `maybePop`: SetupFlow wraps itself in a PopScope that
        // turns an attempted pop into "one step back", so maybePop would
        // rewind to the details step instead of closing the wizard.
        builder: (BuildContext routeContext) => SetupFlow(
          startAtKind: true,
          onFinished: () => Navigator.of(routeContext).pop(),
        ),
      ),
    );
    if (!context.mounted) return;
    // Backing out of the wizard leaves the count alone; only a completed
    // setup should pull the user off the Settings tab.
    if (SessionScope.of(context).businesses.length > before) onShowHome();
  }

  Future<void> _openEditBusinessSheet(
    BuildContext context,
    AppSession session,
    int index,
    Business business,
  ) async {
    final backendId = index < session.backendBusinessIds.length
        ? session.backendBusinessIds[index]
        : null;
    final Business? saved = await showModalBottomSheet<Business>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppPalette.onPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => EditBusinessSheet(business: business, backendId: backendId),
    );
    // Mirror the saved edit into the session so Home's name pill and health
    // card headline pick up the new name without waiting for a cold restart.
    if (saved != null) session.updateBusiness(index, saved);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AppSession session = SessionScope.of(context);
    final AppLanguage language = AppLanguage.fromLocale(
      Localizations.localeOf(context),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Wrap, not Row: at the largest text sizes the chip drops to its own
        // line instead of overflowing the 320px screens this app targets.
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 6,
          children: <Widget>[
            Text(
              l10n.settingsTitle,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w600,
                color: AppPalette.ink,
                height: 1.25,
              ),
            ),
            SyncChip(
              status: session.connectivity,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext _) => const SyncScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 8),
            children: <Widget>[
              _ProfileCard(
                name: session.ownerName ?? '—',
                phone: session.ownerPhone ?? '—',
                editLabel: l10n.settingsEdit,
              ),
              const SizedBox(height: 13),
              SectionLabel(l10n.settingsMyBusinesses),
              const SizedBox(height: 7),
              KhushhalCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: <Widget>[
                    for (final (int idx, Business business) in session.businesses.indexed)
                      _SettingsRow(
                        well: _IconWell(
                          icon:
                              _sectorIcons[business.sector] ??
                              Icons.work_rounded,
                        ),
                        title: business.name,
                        subtitle:
                            '${business.sector.label(l10n)} · '
                            '${l10n.settingsPlaceValue}',
                        divider: true,
                        onTap: () => _openEditBusinessSheet(context, session, idx, business),
                      ),
                    _SettingsRow(
                      well: const _IconWell(
                        icon: Icons.add_rounded,
                        dashed: true,
                      ),
                      title: l10n.settingsAddBusiness,
                      titleColor: AppPalette.leaf,
                      onTap: () => _openAddBusiness(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 13),
              SectionLabel(l10n.settingsPreferences),
              const SizedBox(height: 7),
              KhushhalCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: <Widget>[
                    _SettingsRow(
                      well: const _IconWell(icon: Icons.translate_rounded),
                      title: l10n.settingsLanguage,
                      divider: true,
                      trailing: _LanguageToggle(
                        current: language,
                        onSelected: onLanguageSelected,
                      ),
                    ),
                    _SettingsRow(
                      well: const _IconWell(icon: Icons.notifications_rounded),
                      title: l10n.settingsNotifications,
                      subtitle: l10n.settingsNotificationsValue,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 13),
              SectionLabel(l10n.settingsSupport),
              const SizedBox(height: 7),
              KhushhalCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: <Widget>[
                    _SettingsRow(
                      well: const _IconWell(icon: Icons.support_agent_rounded),
                      title: l10n.settingsContact,
                      divider: true,
                      onTap: () {},
                    ),
                    _SettingsRow(
                      well: const _IconWell(icon: Icons.info_rounded),
                      title: l10n.settingsAbout,
                      subtitle: l10n.settingsVersion,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Material(
                color: AppPalette.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(
                    color: AppPalette.dangerBorder,
                    width: 1.5,
                  ),
                ),
                child: InkWell(
                  onTap: onLogout,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(13),
                    alignment: Alignment.center,
                    child: Text(
                      l10n.settingsLogOut,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppPalette.danger,
                        height: 1.3,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The owner card on top.
class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.name,
    required this.phone,
    required this.editLabel,
  });

  final String name;
  final String phone;
  final String editLabel;

  @override
  Widget build(BuildContext context) {
    return KhushhalCard(
      radius: 20,
      child: Row(
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[AppPalette.forest, AppPalette.sprout],
              ),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              name.isEmpty ? '·' : name.characters.first,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w700,
                color: AppPalette.onPrimary,
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.cardInk,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  phone,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppPalette.hint,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: AppPalette.onPrimary,
            shape: const StadiumBorder(
              side: BorderSide(color: AppPalette.outline, width: 1.5),
            ),
            child: InkWell(
              onTap: () {},
              customBorder: const StadiumBorder(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                child: Text(
                  editLabel,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.forest,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The rounded-square icon at the start of a settings row.
class _IconWell extends StatelessWidget {
  const _IconWell({required this.icon, this.dashed = false});

  final IconData icon;

  /// Softer treatment for "add new" — mint wash with an idle border standing
  /// in for the mock's dashes.
  final bool dashed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: dashed ? AppPalette.mintNote : AppPalette.mintChip,
        border: dashed ? Border.all(color: AppPalette.idle, width: 1.5) : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        size: 17,
        color: dashed ? AppPalette.leaf : AppPalette.forest,
      ),
    );
  }
}

/// One tappable settings row.
class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.well,
    required this.title,
    this.subtitle,
    this.titleColor = AppPalette.cardInk,
    this.divider = false,
    this.onTap,
    this.trailing,
  });

  final Widget well;
  final String title;
  final String? subtitle;
  final Color titleColor;
  final bool divider;
  final VoidCallback? onTap;

  /// Replaces the chevron for rows that act in place instead of navigating.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: divider
            ? const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFEFF5EF))),
              )
            : null,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
        child: Row(
          children: <Widget>[
            well,
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                      height: 1.3,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppPalette.hint,
                        height: 1.3,
                      ),
                    ),
                ],
              ),
            ),
            trailing ??
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: AppPalette.idle,
                ),
          ],
        ),
      ),
    );
  }
}

/// The `Eng | हिंदी` segmented button that sits in the language row.
///
/// Switching language re-renders the whole app on the spot, so the toggle
/// doubles as the current-value display — there is no separate picker.
class _LanguageToggle extends StatelessWidget {
  const _LanguageToggle({required this.current, required this.onSelected});

  /// English first, matching the label order in the design. [AppLanguage]
  /// declares Hindi first because that is the onboarding default.
  static const List<AppLanguage> _order = <AppLanguage>[
    AppLanguage.english,
    AppLanguage.hindi,
  ];

  final AppLanguage current;
  final ValueChanged<AppLanguage> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppPalette.mintNote,
        border: Border.all(color: AppPalette.line),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (final AppLanguage language in _order)
            _LanguageSegment(
              label: language.shortEndonym,
              selected: language == current,
              onTap: language == current ? null : () => onSelected(language),
            ),
        ],
      ),
    );
  }
}

/// One half of the language toggle.
class _LanguageSegment extends StatelessWidget {
  const _LanguageSegment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppPalette.forest : Colors.transparent,
      shape: const StadiumBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: selected ? AppPalette.onPrimary : AppPalette.forest,
              height: 1.3,
            ),
          ),
        ),
      ),
    );
  }
}
