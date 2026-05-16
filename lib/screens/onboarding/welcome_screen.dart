import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.deepBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),

              // Logo / wordmark
              Text(
                'Pool',
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: AppColors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Vibe',
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: AppColors.waterTeal,
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Know exactly what to add,\nwhat to buy, and when your\npool service is getting it wrong.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 18,
                  height: 1.5,
                ),
              ),

              const Spacer(flex: 2),

              // Feature bullets
              _FeatureBullet(
                icon: Icons.pool,
                text: 'Build your pool profile from photos',
              ),
              const SizedBox(height: 12),
              _FeatureBullet(
                icon: Icons.water_drop,
                text: "We'll estimate your pool size — you don't need to know exact gallons",
              ),
              const SizedBox(height: 12),
              _FeatureBullet(
                icon: Icons.science,
                text: 'Get an exact action plan from your test values',
              ),
              const SizedBox(height: 12),
              _FeatureBullet(
                icon: Icons.verified_user,
                text: 'Catch when your maintenance company underdoses',
              ),

              const Spacer(),

              // CTA
              ElevatedButton(
                onPressed: () => context.go('/profile/photos'),
                child: const Text('Set Up My Pool'),
              ),

              const SizedBox(height: 16),

              Center(
                child: TextButton(
                  onPressed: () => context.go('/intake'),
                  child: Text(
                    'I already have a pool profile',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureBullet extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureBullet({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.waterTeal.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.waterTeal, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
