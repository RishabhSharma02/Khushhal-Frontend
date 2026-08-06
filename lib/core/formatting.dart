/// Locale-aware number and date rendering shared across the app.
library;

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// [amount] as rupees with Indian digit grouping, e.g. `₹43,750`.
String rupees(BuildContext context, num amount) {
  final String locale = Localizations.localeOf(context).languageCode == 'hi'
      ? 'hi_IN'
      : 'en_IN';

  return '₹${NumberFormat.decimalPattern(locale).format(amount)}';
}

/// [date] as a short day-and-month, e.g. `1 Nov` / `1 नवंबर`.
///
/// Hindi spells the month out: its abbreviations ("नव॰") read as typos to
/// exactly the low-literacy audience this app is for.
String dayMonth(BuildContext context, DateTime date) {
  final bool hindi = Localizations.localeOf(context).languageCode == 'hi';

  return DateFormat(
    hindi ? 'd MMMM' : 'd MMM',
    hindi ? 'hi' : 'en',
  ).format(date);
}

/// [date]'s month on its own, e.g. `November` / `नवंबर`.
String monthName(BuildContext context, DateTime date) {
  final bool hindi = Localizations.localeOf(context).languageCode == 'hi';

  return DateFormat('MMMM', hindi ? 'hi' : 'en').format(date);
}

/// [date]'s month abbreviated for tight spots, e.g. `Nov` / `नवंबर`.
String monthShort(BuildContext context, DateTime date) {
  final bool hindi = Localizations.localeOf(context).languageCode == 'hi';

  // Hindi keeps the full month name — see [dayMonth].
  return DateFormat(hindi ? 'MMMM' : 'MMM', hindi ? 'hi' : 'en').format(date);
}

/// [time] as a short clock reading, e.g. `9:30 am`.
String clockTime(BuildContext context, DateTime time) {
  final bool hindi = Localizations.localeOf(context).languageCode == 'hi';

  return DateFormat('h:mm a', hindi ? 'hi' : 'en').format(time).toLowerCase();
}
