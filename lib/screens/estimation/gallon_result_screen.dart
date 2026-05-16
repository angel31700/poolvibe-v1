import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../models/pool_profile.dart';
import '../../widgets/confidence_badge.dart';

/// Gallon estimation result — shows the range and confidence note.
/// Designed so the user never feels bad about not knowing exact gallons.
class GallonResultScreen extends StatelessWidget {
  const GallonResultScreen({super.key});

  // TODO: receive actual result from Riverpod provider
  static const _mockGallonsLow  = 14200.0;
  static const _mockGallonsHigh = 19500.0;
  static const _mockConfidence  = ConfidenceLevel.medium;
  static const _mockNote =
      'Based on your 20×40 ft rectangle pool with an average depth of '
      '4.5 ft. Confidence improves if you can confirm dimensions from your '
      "pool builder's documentation.";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.deepBlue,
      appBar: AppBar(
        backgroundColor: AppColors.deepBlue,
        automaticallyImplyLeading: false,
        title: Text('Pool Size Estimate', style: TextStyle(color: AppColors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Big result card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.poolBlue, AppColors.cardSurface],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.waterTeal.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.pool, color: AppColors.waterTeal, size: 40),
                  const SizedBox(height: 16),
                  Text(
                    'Your Pool',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '14,200 – 19,500',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: AppColors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'gallons',
                    style: TextStyle(color: AppColors.waterTeal, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  ConfidenceBadge(level: _mockConfidence),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Confidence note
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.waterTeal, size: 18),
                      const SizedBox(width: 8),
                      Text('How we calculated this',
                          style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _mockNote,
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Why range not exact
            _InfoBox(
              icon: Icons.help_outline,
              title: "Why a range, not an exact number?",
              body: "Pool dimensions at home are usually approximate. A range is honest — "
                  "your actual dosing will be based on the midpoint (≈16,850 gal) "
                  "with a small safety margin.",
            ),

            const Spacer(),

            // Action buttons
            ElevatedButton(
              onPressed: () => context.go('/intake'),
              child: const Text('Enter Today\'s Readings →'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => context.go('/profile/dimensions'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                side: const BorderSide(color: AppColors.textSecondary),
              ),
              child: Text('Adjust Dimensions',
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _InfoBox({required this.icon, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.waterTeal.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.waterTeal.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.waterTeal, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: AppColors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 4),
                Text(body,
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 12, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
