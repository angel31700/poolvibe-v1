import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

/// Intake hub — user picks what data they have today.
/// Multiple paths can be combined before generating a recommendation.
class IntakeChoiceScreen extends StatefulWidget {
  const IntakeChoiceScreen({super.key});

  @override
  State<IntakeChoiceScreen> createState() => _IntakeChoiceScreenState();
}

class _IntakeChoiceScreenState extends State<IntakeChoiceScreen> {
  final _selected = <String>{};

  static const _options = [
    (
      'strip',
      'Test Strip Values',
      'Enter chlorine, pH, alkalinity, and other readings manually',
      Icons.science,
      true, // primary
    ),
    (
      'symptoms',
      'Describe Symptoms',
      'Cloudy water, algae, staining, low chlorine feel',
      Icons.report_problem,
      true,
    ),
    (
      'report',
      'Upload Maintenance Report',
      'A service company left a report — upload it for analysis',
      Icons.assignment,
      false,
    ),
  ];

  bool get _canContinue => _selected.isNotEmpty;

  void _toggle(String key) {
    setState(() {
      if (_selected.contains(key)) {
        _selected.remove(key);
      } else {
        _selected.add(key);
      }
    });
  }

  void _continue(BuildContext context) {
    // Route to first selected intake screen; others will chain
    if (_selected.contains('strip')) {
      context.go('/intake/strip');
    } else if (_selected.contains('symptoms')) {
      context.go('/intake/symptoms');
    } else if (_selected.contains('report')) {
      context.go('/intake/report');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.deepBlue,
      appBar: AppBar(
        backgroundColor: AppColors.deepBlue,
        title: Text("Today's Check-In", style: TextStyle(color: AppColors.white)),
        actions: [
          TextButton(
            onPressed: () => context.go('/history'),
            child: Text('History', style: TextStyle(color: AppColors.waterTeal)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What do you have today?',
              style: theme.textTheme.headlineMedium?.copyWith(color: AppColors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Select all that apply. More data = more accurate recommendation.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 24),

            ..._options.map((opt) {
              final (key, title, subtitle, icon, isPrimary) = opt;
              final isSelected = _selected.contains(key);
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => _toggle(key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.waterTeal.withOpacity(0.12)
                          : AppColors.cardSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppColors.waterTeal : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.waterTeal.withOpacity(0.2)
                                : AppColors.poolBlue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(icon,
                              color: isSelected
                                  ? AppColors.waterTeal
                                  : AppColors.textSecondary,
                              size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(title,
                                      style: const TextStyle(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      )),
                                  if (isPrimary) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.waterTeal.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text('Best',
                                          style: TextStyle(
                                              color: AppColors.waterTeal, fontSize: 10)),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(subtitle,
                                  style: TextStyle(
                                      color: AppColors.textSecondary, fontSize: 12)),
                            ],
                          ),
                        ),
                        Checkbox(
                          value: isSelected,
                          onChanged: (_) => _toggle(key),
                          activeColor: AppColors.waterTeal,
                          checkColor: AppColors.deepBlue,
                          side: BorderSide(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),

            const Spacer(),

            ElevatedButton(
              onPressed: _canContinue ? () => _continue(context) : null,
              child: Text(_selected.isEmpty
                  ? 'Select at least one'
                  : 'Enter ${_selected.length > 1 ? "Details" : _options.firstWhere((o) => o.$1 == _selected.first).$2} →'),
            ),
          ],
        ),
      ),
    );
  }
}
