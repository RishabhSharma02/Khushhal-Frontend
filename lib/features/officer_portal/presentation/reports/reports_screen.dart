/// The month-in-review reporting screen (Officer Portal 5e).
library;

import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../domain/report_summary.dart';
import '../officer_session.dart';
import '../theme/officer_palette.dart';
import '../widgets/file_download/file_download.dart';
import '../widgets/officer_buttons.dart';
import '../widgets/officer_nav_rail.dart';
import '../widgets/officer_shell_scaffold.dart';
import '../widgets/responsive_header.dart';
import 'widgets/app_adoption_card.dart';
import 'widgets/forecast_accuracy_card.dart';
import 'widgets/report_kpi_row.dart';
import 'widgets/report_pdf.dart';
import 'widgets/sector_score_bars.dart';

/// Aggregate KPIs, sector breakdown, forecast accuracy, and app adoption,
/// with export buttons for the block office.
class ReportsScreen extends StatefulWidget {
  /// Creates the reports screen.
  const ReportsScreen({super.key, required this.onSectionSelected});

  /// Called when a rail section is tapped.
  final ValueChanged<OfficerSection> onSectionSelected;

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  Future<ReportSummary>? _summaryFuture;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      _summaryFuture = OfficerSessionScope.of(context).reportsRepository?.fetchReports();
    }
  }

  static String _csvFor(ReportSummary summary) {
    final StringBuffer buffer = StringBuffer()
      ..writeln('Khushhal Officer Portal — ${summary.monthLabel}')
      ..writeln()
      ..writeln('Metric,Value')
      ..writeln('Average health score,${summary.averageHealthScore}')
      ..writeln(
        'Flags resolved,${summary.flagsResolved}/${summary.flagsOpened}',
      )
      ..writeln('EMIs on time,${summary.emisOnTimePercent}%')
      ..writeln('Visits done,${summary.visitsDone}')
      ..writeln()
      ..writeln('Sector,Enterprises,Avg score');
    for (final SectorScore sector in summary.sectorScores) {
      buffer.writeln(
        '${sector.label},${sector.enterpriseCount},${sector.averageScore}',
      );
    }
    return buffer.toString();
  }

  Future<void> _exportPdf(BuildContext context, ReportSummary summary) async {
    final Uint8List bytes = await buildReportPdf(summary);
    if (!context.mounted) return;
    final bool downloaded = downloadBytesFile(
      filename:
          'khushhal-report-${summary.monthLabel.replaceAll(' ', '-').toLowerCase()}.pdf',
      bytes: bytes,
      mimeType: 'application/pdf',
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          downloaded
              ? 'PDF downloaded.'
              : 'PDF export only works from a browser in this demo.',
        ),
      ),
    );
  }

  void _exportCsv(BuildContext context, ReportSummary summary) {
    final bool downloaded = downloadTextFile(
      filename:
          'khushhal-report-${summary.monthLabel.replaceAll(' ', '-').toLowerCase()}.csv',
      content: _csvFor(summary),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          downloaded
              ? 'CSV downloaded.'
              : 'CSV export only works from a browser in this demo.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OfficerShellScaffold(
      section: OfficerSection.reports,
      onSectionSelected: widget.onSectionSelected,
      children: <Widget>[
        FutureBuilder<ReportSummary>(
          future: _summaryFuture,
          builder: (BuildContext context, AsyncSnapshot<ReportSummary> snapshot) {
            if (!snapshot.hasData) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return _ReportsBody(
              summary: snapshot.data!,
              onExportPdf: _exportPdf,
              onExportCsv: _exportCsv,
            );
          },
        ),
      ],
    );
  }
}

class _ReportsBody extends StatelessWidget {
  const _ReportsBody({
    required this.summary,
    required this.onExportPdf,
    required this.onExportCsv,
  });

  final ReportSummary summary;
  final Future<void> Function(BuildContext context, ReportSummary summary) onExportPdf;
  final void Function(BuildContext context, ReportSummary summary) onExportCsv;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ResponsiveHeader(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Reports — ${summary.monthLabel}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: OfficerPalette.ink,
                ),
              ),
              Text(
                summary.comparedToLabel,
                style: const TextStyle(fontSize: 13, color: OfficerPalette.muted),
              ),
            ],
          ),
          actions: <Widget>[
            OfficerSecondaryButton(
              label: '⬇ PDF for block office',
              onPressed: () => onExportPdf(context, summary),
            ),
            OfficerSecondaryButton(
              label: '⬇ CSV',
              onPressed: () => onExportCsv(context, summary),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ReportKpiRow(summary: summary),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final Widget sectors = SectorScoreBars(
              scores: summary.sectorScores,
              insight: summary.insight,
            );
            final List<Widget> side = <Widget>[
              ForecastAccuracyCard(accuracy: summary.forecastAccuracy),
              const SizedBox(height: 14),
              AppAdoptionCard(adoption: summary.appAdoption),
            ];

            if (constraints.maxWidth > 780) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(flex: 7, child: sectors),
                  const SizedBox(width: 14),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: side,
                    ),
                  ),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[sectors, const SizedBox(height: 14), ...side],
            );
          },
        ),
      ],
    );
  }
}
