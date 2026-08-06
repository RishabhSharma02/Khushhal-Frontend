/// The business-name switcher pill on home and history.
library;

import 'package:flutter/material.dart';

import '../../../../app/model/business.dart';
import '../../../../app/session.dart';
import '../../../../core/theme/theme.dart';

/// White stadium pill carrying the active business name.
///
/// Tapping it opens the business switcher sheet — the pill itself is the
/// only affordance, so home spells it out in the hint line beneath.
class BusinessPill extends StatelessWidget {
  /// Creates the pill for [label].
  const BusinessPill({super.key, required this.label, this.onTap});

  /// Active business name.
  final String label;

  /// Usually [showBusinessSwitcher].
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppPalette.onPrimary,
      shape: const StadiumBorder(
        side: BorderSide(color: AppPalette.line, width: 1.5),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.ink,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.expand_more_rounded,
                size: 16,
                color: AppPalette.forest,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Opens the switcher sheet listing every business in the session.
Future<void> showBusinessSwitcher(BuildContext context) {
  final AppSession session = SessionScope.of(context);

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppPalette.onPrimary,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (BuildContext sheetContext) {
      final List<Business> businesses = session.businesses;
      final Business? active = session.activeBusiness;

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List<Widget>.generate(businesses.length, (int index) {
              final Business business = businesses[index];
              final bool selected = business == active;

              return InkWell(
                onTap: () {
                  session.selectBusiness(index);
                  Navigator.of(sheetContext).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 14,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          business.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: AppPalette.cardInk,
                          ),
                        ),
                      ),
                      if (selected)
                        const Icon(
                          Icons.check_rounded,
                          size: 20,
                          color: AppPalette.leaf,
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      );
    },
  );
}
