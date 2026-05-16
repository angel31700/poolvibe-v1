import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

/// Symptom input — visual flags + photo upload.
class SymptomScreen extends StatefulWidget {
  const SymptomScreen({super.key});

  @override
  State<SymptomScreen> createState() => _SymptomScreenState();
}

class _SymptomScreenState extends State<SymptomScreen> {
  final _selected = <String>{};
  final _noteCtrl = TextEditingController();
  String? _photoPath;

  static const _symptoms = [
    ('cloudy',       'Cloudy / Milky Water',  Icons.water_drop,       'Most common: low chlorine or high phosphates'),
    ('green_algae',  'Green Algae',            Icons.eco,              'Walls, floor, or floating in water'),
    ('black_algae',  'Black Spots / Algae',    Icons.circle,           'Stubborn black dots on surface'),
    ('staining',     'Staining',               Icons.format_color_fill,'Brown, purple, or rust-colored marks'),
    ('scaling',      'Scaling / Deposits',     Icons.layers,           'White or gray buildup on surface or tile'),
    ('foaming',      'Foaming',                Icons.bubble_chart,     'Foam on surface or near returns'),
    ('low_cl_feel',  'Feels Like Low Chlorine',Icons.science,          'Strong smell, eye irritation, skin irritation'),
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
          onPressed: () => context.go('/intake'),
        ),
        title: Text('Symptoms', style: TextStyle(color: AppColors.white)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "What's wrong with your pool?",
                    style: theme.textTheme.headlineMedium?.copyWith(color: AppColors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select all that apply. Symptoms guide the recommendation even without strip values.',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 20),

                  // Symptom chips
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _symptoms.map((s) {
                      final (key, label, icon, desc) = s;
                      final isSelected = _selected.contains(key);
                      return GestureDetector(
                        onTap: () => setState(() {
                          isSelected ? _selected.remove(key) : _selected.add(key);
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.waterTeal.withOpacity(0.15)
                                : AppColors.cardSurface,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                              color: isSelected ? AppColors.waterTeal : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(icon,
                                  color: isSelected
                                      ? AppColors.waterTeal
                                      : AppColors.textSecondary,
                                  size: 16),
                              const SizedBox(width: 6),
                              Text(label,
                                  style: TextStyle(
                                    color: isSelected ? AppColors.white : AppColors.textSecondary,
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  )),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Photo upload
                  Text('Add a photo (optional)',
                      style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {}, // TODO: image_picker
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.cardSurface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.textSecondary.withOpacity(0.3),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, color: AppColors.textSecondary, size: 28),
                            const SizedBox(height: 6),
                            Text('Tap to add pool photo',
                                style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Notes
                  Text('Additional notes (optional)',
                      style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _noteCtrl,
                    maxLines: 3,
                    style: const TextStyle(color: AppColors.white),
                    decoration: InputDecoration(
                      hintText: 'e.g. "Water was green for 3 days after heavy rain"',
                      hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () => context.go('/plan'),
              child: const Text('Get My Action Plan →'),
            ),
          ),
        ],
      ),
    );
  }
}
