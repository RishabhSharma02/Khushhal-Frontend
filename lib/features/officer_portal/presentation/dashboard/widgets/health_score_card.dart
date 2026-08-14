/// The average business-health score card (Officer Portal 5a).
library;

import 'package:flutter/material.dart';

import '../../theme/officer_palette.dart';
import '../../widgets/officer_card.dart';
import '../../widgets/status_chip.dart';

/// Avg-score line chart plus three mini stats.
class HealthScoreCard extends StatelessWidget {
  /// Creates the health-score card.
  const HealthScoreCard({
    super.key,
    required this.enterpriseCount,
    required this.averageScoreHistory,
    required this.averageScoreDelta,
    required this.emisOnTimePercent,
    required this.emisOnTimeDelta,
    required this.openFlagCount,
    required this.openFlagDelta,
  });

  /// Every enterprise on the officer's beat, for the subtitle count.
  final int enterpriseCount;

  /// Up to 6 months of average health score, oldest first.
  final List<int> averageScoreHistory;

  /// Change in average score vs. the previous period.
  final int averageScoreDelta;

  /// Percent of EMIs on time across all enterprises.
  final int emisOnTimePercent;

  /// Change in EMIs-on-time percent vs. the previous period.
  final int emisOnTimeDelta;

  /// Currently open flags.
  final int openFlagCount;

  /// Change in open-flag count vs. the previous period.
  final int openFlagDelta;

  static const List<String> _monthNames = <String>[
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  /// The last 6 months' labels ending at the current month, which is
  /// marked "*" since it's still accruing entries.
  List<String> _months() {
    final DateTime now = DateTime.now();
    return List<String>.generate(6, (int i) {
      final int monthIndex = (now.month - 1 - (5 - i) + 24) % 12;
      final String label = _monthNames[monthIndex];
      return i == 5 ? '$label*' : label;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OfficerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(
                Icons.show_chart_rounded,
                size: 18,
                color: OfficerPalette.forest,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Average business-health score',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: OfficerPalette.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'All $enterpriseCount enterprises · 0–100 scale · last 6 months',
                      style: const TextStyle(
                        fontSize: 11,
                        color: OfficerPalette.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const StatusChip(label: '✓ On track', tone: OfficerTone.green),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: _MiniStat(
                  label: 'Avg score',
                  value: '${averageScoreHistory.isEmpty ? 0 : averageScoreHistory.last}',
                  deltaLabel: '${averageScoreDelta >= 0 ? '+' : ''}$averageScoreDelta',
                  positive: averageScoreDelta >= 0,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniStat(
                  label: 'EMIs on time',
                  value: '$emisOnTimePercent%',
                  deltaLabel: '${emisOnTimeDelta >= 0 ? '+' : ''}$emisOnTimeDelta%',
                  positive: emisOnTimeDelta >= 0,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniStat(
                  label: 'Flags open',
                  value: '$openFlagCount',
                  deltaLabel: '$openFlagDelta',
                  positive: openFlagDelta <= 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 100,
            width: double.infinity,
            child: CustomPaint(
              painter: _ScoreLinePainter(averageScoreHistory),
            ),
          ),
          Row(
            children: <Widget>[
              for (final String month in _months())
                Expanded(
                  child: Text(
                    month,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: OfficerPalette.muted,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: <Widget>[
              const Expanded(
                child: Text(
                  'Higher is better · 60+ = healthy',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10.5, color: OfficerPalette.muted),
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                '*Aug = forecast',
                style: TextStyle(fontSize: 10.5, color: OfficerPalette.muted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.deltaLabel,
    required this.positive,
  });

  final String label;
  final String value;
  final String deltaLabel;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: OfficerPalette.soft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: OfficerPalette.muted),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 2,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: OfficerPalette.ink,
                ),
              ),
              StatusChip(
                label: deltaLabel,
                tone: positive ? OfficerTone.green : OfficerTone.red,
                dense: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScoreLinePainter extends CustomPainter {
  _ScoreLinePainter(this.values);

  final List<int> values;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) {
      return;
    }

    final int minValue = values.reduce((int a, int b) => a < b ? a : b);
    final int maxValue = values.reduce((int a, int b) => a > b ? a : b);
    final double range = (maxValue - minValue).toDouble().clamp(
      1,
      double.infinity,
    );

    final List<Offset> points = List<Offset>.generate(values.length, (int i) {
      final double x = values.length == 1
          ? 0
          : size.width * i / (values.length - 1);
      final double normalized = (values[i] - minValue) / range;
      final double y = size.height - normalized * (size.height - 8) - 4;
      return Offset(x, y);
    });

    final Path line = Path()..moveTo(points.first.dx, points.first.dy);
    for (final Offset point in points.skip(1)) {
      line.lineTo(point.dx, point.dy);
    }

    final Path fill = Path.from(line)
      ..lineTo(points.last.dx, size.height)
      ..lineTo(points.first.dx, size.height)
      ..close();

    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            OfficerPalette.statusGreen.withValues(alpha: 0.22),
            OfficerPalette.statusGreen.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    canvas.drawPath(
      line,
      Paint()
        ..color = OfficerPalette.forest
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _ScoreLinePainter oldDelegate) =>
      oldDelegate.values != values;
}
