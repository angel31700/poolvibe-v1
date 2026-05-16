import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../models/pool_profile.dart';
import '../../widgets/step_progress.dart';

/// Step 2: Saltwater or chlorine pool?
class PoolTypeScreen extends StatefulWidget {
  const PoolTypeScreen({super.key});

  @override
  State<PoolTypeScreen> createState() => _PoolTypeScreenState();
}

class _PoolTypeScreenState extends State<PoolTypeScreen> {
  PoolType? _selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.deepBlue,
      appBar: AppBar(
        backgroundColor: AppColors.deepBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => context.go('/profile/photos'),
        ),
        title: Text('Pool Profile', style: TextStyle(color: AppColors.white)),
      ),
      body: Column(
        children: [
          StepProgress(currentStep: 2, totalSteps: 5, label: 'Pool Type'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What type of pool do you have?',
                    style: theme.textTheme.headlineMedium?.copyWith(color: AppColors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This affects chlorine targets, CYA ranges, and salt readings.',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                  const SizedBox(height: 32),

                  _PoolTypeCard(
                    type: PoolType.saltwater,
                    title: 'Saltwater',
                    subtitle: 'Uses a salt chlorine generator (SWG/salt cell)',
                    icon: Icons.waves,
                    selected: _selected == PoolType.saltwater,
                    onTap: () => setState(() => _selected = PoolType.saltwater),
                  ),
                  const SizedBox(height: 16),
                  _PoolTypeCard(
                    type: PoolType.chlorine,
                    title: 'Chlorine',
                    subtitle: 'Uses tablets, liquid, or granular chlorine',
                    icon: Icons.science,
                    selected: _selected == PoolType.chlorine,
                    onTap: () => setState(() => _selected = PoolType.chlorine),
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: _selected != null ? () => context.go('/profile/shape') : null,
              child: const Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PoolTypeCard extends StatelessWidget {
  final PoolType type;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _PoolTypeCard({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: selected ? AppColors.waterTeal.withOpacity(0.15) : AppColors.cardSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.waterTeal : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.waterTeal.withOpacity(0.2)
                    : AppColors.poolBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon,
                  color: selected ? AppColors.waterTeal : AppColors.textSecondary,
                  size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      )),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_circle, color: AppColors.waterTeal),
          ],
        ),
      ),
    );
  }
}
