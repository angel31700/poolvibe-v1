import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/step_progress.dart';

/// Step 4: Pool dimensions — length, width, depth.
class PoolDimensionsScreen extends StatefulWidget {
  const PoolDimensionsScreen({super.key});

  @override
  State<PoolDimensionsScreen> createState() => _PoolDimensionsScreenState();
}

class _PoolDimensionsScreenState extends State<PoolDimensionsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _lengthCtrl   = TextEditingController();
  final _widthCtrl    = TextEditingController();
  final _shallowCtrl  = TextEditingController();
  final _deepCtrl     = TextEditingController();
  final _avgCtrl      = TextEditingController();

  bool _useAvgDepth = false;

  bool get _hasEnoughData {
    final hasLW = _lengthCtrl.text.isNotEmpty && _widthCtrl.text.isNotEmpty;
    final hasDepth = _useAvgDepth
        ? _avgCtrl.text.isNotEmpty
        : (_shallowCtrl.text.isNotEmpty || _deepCtrl.text.isNotEmpty);
    return hasLW && hasDepth;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.deepBlue,
      appBar: AppBar(
        backgroundColor: AppColors.deepBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => context.go('/profile/shape'),
        ),
        title: Text('Pool Profile', style: TextStyle(color: AppColors.white)),
      ),
      body: Column(
        children: [
          StepProgress(currentStep: 4, totalSteps: 5, label: 'Dimensions'),
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pool dimensions',
                      style: theme.textTheme.headlineMedium?.copyWith(color: AppColors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Approximate measurements are fine — don't let this stop you. "
                      'We\'ll account for uncertainty in the estimate.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                    const SizedBox(height: 28),

                    _SectionLabel('Length & Width (feet)'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _NumberField(
                            controller: _lengthCtrl,
                            label: 'Length',
                            hint: 'e.g. 30',
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _NumberField(
                            controller: _widthCtrl,
                            label: 'Width',
                            hint: 'e.g. 15',
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    _SectionLabel('Depth (feet)'),
                    const SizedBox(height: 8),

                    // Toggle: separate shallow/deep vs average
                    Row(
                      children: [
                        Switch(
                          value: _useAvgDepth,
                          onChanged: (v) => setState(() => _useAvgDepth = v),
                          activeColor: AppColors.waterTeal,
                        ),
                        Text(
                          _useAvgDepth
                              ? 'I know the average depth'
                              : 'I know shallow and deep depth',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (!_useAvgDepth) ...[
                      Row(
                        children: [
                          Expanded(
                            child: _NumberField(
                              controller: _shallowCtrl,
                              label: 'Shallow end',
                              hint: 'e.g. 3.5',
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _NumberField(
                              controller: _deepCtrl,
                              label: 'Deep end',
                              hint: 'e.g. 6',
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      _NumberField(
                        controller: _avgCtrl,
                        label: 'Average depth',
                        hint: 'e.g. 4.5',
                        onChanged: (_) => setState(() {}),
                      ),
                    ],

                    const SizedBox(height: 16),
                    _HelpText(
                      "Tip: Check your pool builder's manual or quote for exact specs. "
                      "If you're guessing, that's OK — add ±20% for safety.",
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: _hasEnoughData ? () => context.go('/profile/surface') : null,
              child: const Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),
      );
}

class _NumberField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final ValueChanged<String>? onChanged;

  const _NumberField({
    required this.controller,
    required this.label,
    required this.hint,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      ],
      onChanged: onChanged,
      style: const TextStyle(color: AppColors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.inputFill,
        suffixText: 'ft',
        suffixStyle: const TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}

class _HelpText extends StatelessWidget {
  final String text;
  const _HelpText(this.text);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.waterTeal.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline, color: AppColors.waterTeal, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.4),
              ),
            ),
          ],
        ),
      );
}
