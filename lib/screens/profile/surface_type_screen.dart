import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../models/pool_profile.dart';
import '../../widgets/step_progress.dart';

/// Step 5: Surface type — affects calcium hardness targets and chemical behavior.
class SurfaceTypeScreen extends StatefulWidget {
  const SurfaceTypeScreen({super.key});

  @override
  State<SurfaceTypeScreen> createState() => _SurfaceTypeScreenState();
}

class _SurfaceTypeScreenState extends State<SurfaceTypeScreen> {
  SurfaceType? _selected;

  static const _surfaces = [
    (SurfaceType.plaster,    'Plaster / Marcite',  'Classic white or colored plaster',     '200–400 ppm Ca'),
    (SurfaceType.vinyl,      'Vinyl Liner',         'Flexible vinyl lining',                'Keep Ca < 250 ppm'),
    (SurfaceType.fiberglass, 'Fiberglass',          'Smooth molded shell',                  'Keep Ca < 350 ppm'),
    (SurfaceType.pebbleTec,  'PebbleTec / Pebble', 'Exposed aggregate finish',             '200–400 ppm Ca'),
    (SurfaceType.tile,       'Tile',                'Full tile interior',                   '200–350 ppm Ca'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.deepBlue,
      appBar: AppBar(
        backgroundColor: AppColors.deepBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => context.go('/profile/dimensions'),
        ),
        title: Text('Pool Profile', style: TextStyle(color: AppColors.white)),
      ),
      body: Column(
        children: [
          StepProgress(currentStep: 5, totalSteps: 5, label: 'Surface'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pool surface type',
                    style: theme.textTheme.headlineMedium?.copyWith(color: AppColors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Surface affects calcium hardness targets and treatment approach.',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: ListView.separated(
                      itemCount: _surfaces.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final (surface, title, subtitle, caNote) = _surfaces[i];
                        final isSelected = _selected == surface;
                        return GestureDetector(
                          onTap: () => setState(() => _selected = surface),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.waterTeal.withOpacity(0.12)
                                  : AppColors.cardSurface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected ? AppColors.waterTeal : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(title,
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          )),
                                      const SizedBox(height: 2),
                                      Text(subtitle,
                                          style: TextStyle(
                                              color: AppColors.textSecondary, fontSize: 12)),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.poolBlue,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(caNote,
                                      style: TextStyle(
                                          color: AppColors.textSecondary, fontSize: 10)),
                                ),
                                if (isSelected) ...[
                                  const SizedBox(width: 8),
                                  Icon(Icons.check_circle, color: AppColors.waterTeal, size: 20),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: _selected != null
                  ? () => context.go('/estimation/result')
                  : null,
              child: const Text('Estimate My Pool Size →'),
            ),
          ),
        ],
      ),
    );
  }
}
