import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../models/pool_profile.dart';
import '../../widgets/step_progress.dart';

/// Step 3: Pool shape selection.
class PoolShapeScreen extends StatefulWidget {
  const PoolShapeScreen({super.key});

  @override
  State<PoolShapeScreen> createState() => _PoolShapeScreenState();
}

class _PoolShapeScreenState extends State<PoolShapeScreen> {
  PoolShape? _selected;

  static const _shapes = [
    (PoolShape.rectangle, 'Rectangle',  'Standard rectangular pool',          Icons.crop_square),
    (PoolShape.oval,      'Oval',        'Elliptical / rounded rectangle',     Icons.circle_outlined),
    (PoolShape.kidney,    'Kidney',      'Curved, kidney-bean shape',          Icons.waves),
    (PoolShape.round,     'Round',       'Circular above-ground or inground',  Icons.radio_button_unchecked),
    (PoolShape.lShape,    'L-Shape',     'Two connected rectangles',           Icons.crop_7_5),
    (PoolShape.freeform,  'Freeform',    'Irregular / custom shape',           Icons.gesture),
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
          onPressed: () => context.go('/profile/type'),
        ),
        title: Text('Pool Profile', style: TextStyle(color: AppColors.white)),
      ),
      body: Column(
        children: [
          StepProgress(currentStep: 3, totalSteps: 5, label: 'Pool Shape'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What shape is your pool?',
                    style: theme.textTheme.headlineMedium?.copyWith(color: AppColors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Shape affects the gallon calculation formula.',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.3,
                      children: _shapes.map((s) {
                        final (shape, title, subtitle, icon) = s;
                        final isSelected = _selected == shape;
                        return GestureDetector(
                          onTap: () => setState(() => _selected = shape),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.waterTeal.withOpacity(0.15)
                                  : AppColors.cardSurface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected ? AppColors.waterTeal : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(icon,
                                    color: isSelected
                                        ? AppColors.waterTeal
                                        : AppColors.textSecondary,
                                    size: 28),
                                const SizedBox(height: 8),
                                Text(title,
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    )),
                                Text(subtitle,
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: _selected != null ? () => context.go('/profile/dimensions') : null,
              child: const Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }
}
