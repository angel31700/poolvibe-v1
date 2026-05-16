import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../models/maintenance_report.dart';

/// Maintenance Report Comparison — the oversight feature.
/// Shows what should have happened vs what the service report says happened.
class ReportComparisonScreen extends StatelessWidget {
  const ReportComparisonScreen({super.key});

  static final _mockResult = MaintenanceComparisonResult(
    appearsReasonable: false,
    summary: '⚠️ This report shows signs of underdosing',
    flags: [
      MaintenanceFlag(
        type: MaintenanceFlagType.dosageTooLow,
        chemicalName: 'Chlorine Shock',
        explanation:
            'Report says 1 lb of shock was added. For a ~17,000 gallon pool with '
            'green algae visible, a minimum of 3 lbs Cal-Hypo is recommended.',
        expectedAmount: '3+ lbs',
        reportedAmount: '1 lb',
      ),
      MaintenanceFlag(
        type: MaintenanceFlagType.chemicalMissing,
        chemicalName: 'pH adjustment',
        explanation:
            'Report shows no pH chemical was added, but the pool has a history '
            'of running high pH (8.0+). High pH reduces chlorine effectiveness. '
            'This likely explains why the algae returned.',
        expectedAmount: '8–12 fl oz muriatic acid',
        reportedAmount: 'Nothing added',
      ),
    ],
    whatShouldHaveHappened:
        'For a 17,000 gallon pool with visible algae and low chlorine: '
        '(1) Adjust pH to 7.2–7.4 with muriatic acid, '
        '(2) Shock with 3 lbs Cal-Hypo at dusk, '
        '(3) Run filter 24 hours, '
        '(4) Brush walls and floor before shocking.',
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final result = _mockResult;

    return Scaffold(
      backgroundColor: AppColors.deepBlue,
      appBar: AppBar(
        backgroundColor: AppColors.deepBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => context.go('/plan'),
        ),
        title: Text('Report Analysis', style: TextStyle(color: AppColors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Verdict banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: result.appearsReasonable
                    ? AppColors.successGreen.withOpacity(0.1)
                    : AppColors.alertRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: result.appearsReasonable
                      ? AppColors.successGreen.withOpacity(0.4)
                      : AppColors.alertRed.withOpacity(0.4),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    result.appearsReasonable
                        ? Icons.check_circle
                        : Icons.warning_amber,
                    color: result.appearsReasonable
                        ? AppColors.successGreen
                        : AppColors.alertRed,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      result.summary,
                      style: TextStyle(
                        color: result.appearsReasonable
                            ? AppColors.successGreen
                            : AppColors.alertRed,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Flags
            if (result.hasFlags) ...[
              const SizedBox(height: 20),
              Text('Issues found',
                  style: theme.textTheme.titleLarge?.copyWith(color: AppColors.white)),
              const SizedBox(height: 12),

              ...result.flags.map((flag) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardSurface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: AppColors.alertRed.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(flag.chemicalName,
                            style: const TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14)),
                        const SizedBox(height: 8),
                        Text(flag.explanation,
                            style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                height: 1.5)),
                        if (flag.reportedAmount != null ||
                            flag.expectedAmount != null) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _ComparisonBox(
                                  label: 'Report says',
                                  value: flag.reportedAmount ?? '—',
                                  color: AppColors.alertRed,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _ComparisonBox(
                                  label: 'Should be',
                                  value: flag.expectedAmount ?? '—',
                                  color: AppColors.successGreen,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  )),
            ],

            // What should have happened
            if (result.whatShouldHaveHappened != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.waterTeal.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.waterTeal.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb, color: AppColors.waterTeal, size: 18),
                        const SizedBox(width: 8),
                        Text('What should have happened',
                            style: TextStyle(
                                color: AppColors.waterTeal,
                                fontWeight: FontWeight.w600,
                                fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      result.whatShouldHaveHappened!,
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 13, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () => context.go('/plan'),
              child: const Text('Go to My Action Plan →'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => context.go('/intake/report'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                side: BorderSide(color: AppColors.textSecondary.withOpacity(0.4)),
              ),
              child: Text('Update Report',
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _ComparisonBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ComparisonBox({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    color: AppColors.white, fontSize: 14, fontWeight: FontWeight.w700)),
          ],
        ),
      );
}
