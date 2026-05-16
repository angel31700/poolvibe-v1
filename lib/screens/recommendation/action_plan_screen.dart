import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../models/recommendation.dart';
import '../../widgets/chemical_card.dart';
import '../../widgets/confidence_badge.dart';

/// Action Plan — the core output screen. Shows diagnosis + ordered chemical steps.
class ActionPlanScreen extends StatelessWidget {
  const ActionPlanScreen({super.key});

  // TODO: replace with Riverpod provider state
  static final _mockRec = Recommendation(
    id: '1',
    poolProfileId: 'pool1',
    readingId: 'reading1',
    generatedAt: DateTime.now(),
    primaryDiagnosis: 'Low chlorine + High pH',
    diagnosisExplanation:
        'Your pool has insufficient sanitizer and an elevated pH. '
        'High pH is reducing chlorine effectiveness — fixing pH first '
        'will allow chlorine to work better.',
    actions: [
      ChemicalAction(
        chemicalName: 'Muriatic Acid (pH Down)',
        amountLbs: 0,
        amountOz: 24,
        amountDisplay: '24 fl oz',
        reason: 'pH is 7.9 — above the 7.2–7.6 target. High pH reduces chlorine effectiveness by up to 80%.',
        stepOrder: 1,
        timingNote: 'Pour slowly around perimeter with pump running. Wait 2 hours.',
        warningNote: 'Wear gloves and eye protection. Never mix with chlorine.',
      ),
      ChemicalAction(
        chemicalName: 'Liquid Chlorine (10%)',
        amountLbs: 0,
        amountGallons: 1.0,
        amountDisplay: '1 gallon',
        reason: 'Free chlorine is 0.8 ppm — below the 1–3 ppm target. Fix pH first for maximum effect.',
        stepOrder: 2,
        timingNote: 'Add after pH has been corrected (2+ hours after acid). Retest in 4 hours.',
      ),
    ],
    confidence: ConfidenceLevel.medium,
    confidenceNote:
        'pH and chlorine were provided. Alkalinity and CYA not entered — '
        'add those values for a more complete plan.',
    dataGaps: ['Total alkalinity', 'CYA/Stabilizer', 'Calcium hardness'],
    urgencyHigh: true,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rec = _mockRec;

    return Scaffold(
      backgroundColor: AppColors.deepBlue,
      appBar: AppBar(
        backgroundColor: AppColors.deepBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => context.go('/intake'),
        ),
        title: Text('Action Plan', style: TextStyle(color: AppColors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Urgency banner
            if (rec.urgencyHigh)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.alertRed.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.alertRed.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, color: AppColors.alertRed, size: 18),
                    const SizedBox(width: 8),
                    Text('Address today — low chlorine is a health risk',
                        style: TextStyle(color: AppColors.alertRed, fontSize: 13)),
                  ],
                ),
              ),

            // Diagnosis card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Diagnosis',
                          style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0)),
                      ConfidenceBadge(level: rec.confidence),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(rec.primaryDiagnosis,
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(rec.diagnosisExplanation,
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 13, height: 1.5)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Action steps
            Text('What to do',
                style: theme.textTheme.titleLarge?.copyWith(color: AppColors.white)),
            const SizedBox(height: 4),
            Text('In this order:',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 14),

            ...rec.orderedActions.map((action) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ChemicalCard(action: action),
                )),

            // Confidence note
            if (rec.dataGaps.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.sunYellow.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.sunYellow.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline,
                            color: AppColors.sunYellow, size: 16),
                        const SizedBox(width: 8),
                        Text('Improve this plan',
                            style: TextStyle(
                                color: AppColors.sunYellow,
                                fontWeight: FontWeight.w600,
                                fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(rec.confidenceNote,
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 12, height: 1.4)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: rec.dataGaps.map((gap) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.sunYellow.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text('+ $gap',
                                style: TextStyle(
                                    color: AppColors.sunYellow, fontSize: 11)),
                          )).toList(),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Bottom actions
            ElevatedButton.icon(
              onPressed: () => context.go('/products'),
              icon: const Icon(Icons.shopping_cart_outlined),
              label: const Text('See Product Recommendations →'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => context.go('/maintenance'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                side: BorderSide(color: AppColors.textSecondary.withOpacity(0.4)),
              ),
              child: Text('Check Maintenance Report',
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
