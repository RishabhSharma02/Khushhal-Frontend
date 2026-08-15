/// Builds the "PDF for block office" export (Officer Portal 5e).
library;

import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../domain/report_summary.dart';

/// Renders [summary] as a one-page PDF and returns its bytes.
Future<Uint8List> buildReportPdf(ReportSummary summary) async {
  final pw.Document doc = pw.Document();

  doc.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: <pw.Widget>[
            pw.Text(
              'Khushhal Officer Portal',
              style: pw.TextStyle(fontSize: 11, color: PdfColors.grey600),
            ),
            pw.Text(
              'Reports — ${summary.monthLabel}',
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(summary.comparedToLabel, style: const pw.TextStyle(fontSize: 11)),
            pw.SizedBox(height: 18),
            pw.TableHelper.fromTextArray(
              headers: <String>['Metric', 'Value'],
              data: <List<String>>[
                <String>['Average health score', '${summary.averageHealthScore}'],
                <String>[
                  'Flags resolved',
                  '${summary.flagsResolved} of ${summary.flagsOpened} (avg ${summary.averageResolutionDays}d)',
                ],
                <String>[
                  'Visits done',
                  '${summary.visitsDone} (${summary.riskLedVisits} risk-led)',
                ],
              ],
            ),
            pw.SizedBox(height: 18),
            pw.Text(
              'Health score by sector',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 6),
            pw.TableHelper.fromTextArray(
              headers: <String>['Sector', 'Enterprises', 'Avg score'],
              data: <List<String>>[
                for (final SectorScore sector in summary.sectorScores)
                  <String>[
                    sector.label,
                    '${sector.enterpriseCount}',
                    '${sector.averageScore}',
                  ],
              ],
            ),
            pw.SizedBox(height: 12),
            pw.Text('Insight: ${summary.insight}', style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 18),
            pw.Text(
              'Forecast accuracy (AI)',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 6),
            pw.TableHelper.fromTextArray(
              headers: <String>['Metric', 'Value'],
              data: <List<String>>[
                <String>[
                  'Predicted vs actual',
                  summary.forecastAccuracy.predictedVsActualLabel,
                ],
                <String>[
                  'Flags that came true',
                  '${summary.forecastAccuracy.flagsThatCameTrue} of ${summary.forecastAccuracy.flagsRaised}',
                ],
                <String>['False alarms', '${summary.forecastAccuracy.falseAlarms}'],
              ],
            ),
            pw.SizedBox(height: 18),
            pw.Text(
              'App adoption',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 6),
            pw.TableHelper.fromTextArray(
              headers: <String>['Metric', 'Value'],
              data: <List<String>>[
                <String>[
                  'Entry streak ≥5/wk',
                  '${summary.appAdoption.enterprisesWithStreak} of ${summary.appAdoption.totalEnterprises}',
                ],
                <String>['Voice entry users', '${summary.appAdoption.voiceEntryUsers}'],
                <String>[
                  'Savings plans active',
                  '${summary.appAdoption.activeSavingsPlans}',
                ],
              ],
            ),
          ],
        );
      },
    ),
  );

  return doc.save();
}
