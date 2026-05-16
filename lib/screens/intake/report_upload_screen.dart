import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

/// Maintenance report upload — photo or typed summary.
class ReportUploadScreen extends StatefulWidget {
  const ReportUploadScreen({super.key});

  @override
  State<ReportUploadScreen> createState() => _ReportUploadScreenState();
}

class _ReportUploadScreenState extends State<ReportUploadScreen> {
  String? _photoPath;
  final _notesCtrl = TextEditingController();
  final _techCtrl  = TextEditingController();
  final _dateCtrl  = TextEditingController();
  bool _hasContent = false;

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
        title: Text('Maintenance Report', style: TextStyle(color: AppColors.white)),
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
                    'Upload your service report',
                    style: theme.textTheme.headlineMedium?.copyWith(color: AppColors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "We'll check if what your service company did matches your pool size and current condition.",
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                  const SizedBox(height: 24),

                  // Photo upload area
                  GestureDetector(
                    onTap: () {
                      // TODO: image_picker
                      setState(() {
                        _photoPath = '/mock/report.jpg';
                        _hasContent = true;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 140,
                      decoration: BoxDecoration(
                        color: _photoPath != null
                            ? AppColors.waterTeal.withOpacity(0.1)
                            : AppColors.cardSurface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _photoPath != null
                              ? AppColors.waterTeal
                              : AppColors.textSecondary.withOpacity(0.3),
                        ),
                      ),
                      child: Center(
                        child: _photoPath != null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle,
                                      color: AppColors.waterTeal, size: 36),
                                  const SizedBox(height: 8),
                                  Text('Report photo added',
                                      style: TextStyle(
                                          color: AppColors.waterTeal,
                                          fontWeight: FontWeight.w600)),
                                  TextButton(
                                    onPressed: () => setState(() => _photoPath = null),
                                    child: Text('Remove',
                                        style: TextStyle(color: AppColors.textSecondary)),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt,
                                      color: AppColors.textSecondary, size: 32),
                                  const SizedBox(height: 8),
                                  Text('Tap to photo the report',
                                      style: TextStyle(color: AppColors.textSecondary)),
                                  Text('Works with paper reports, door hangers, and apps',
                                      style: TextStyle(
                                          color: AppColors.textSecondary.withOpacity(0.6),
                                          fontSize: 11)),
                                ],
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const _Divider('OR type a summary'),
                  const SizedBox(height: 16),

                  _LabeledField(
                    label: 'Service company / technician',
                    controller: _techCtrl,
                    hint: 'e.g. "Blue Waters Pool Service"',
                  ),
                  const SizedBox(height: 12),
                  _LabeledField(
                    label: 'Service date',
                    controller: _dateCtrl,
                    hint: 'e.g. "May 15, 2026"',
                  ),
                  const SizedBox(height: 12),
                  _LabeledField(
                    label: 'What they say they added',
                    controller: _notesCtrl,
                    hint: 'e.g. "1 lb shock, 4 tablets, algaecide" or paste the full report',
                    maxLines: 5,
                    onChanged: (v) => setState(() => _hasContent = v.isNotEmpty),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: (_photoPath != null || _hasContent)
                      ? () => context.go('/maintenance')
                      : null,
                  child: const Text('Analyze This Report →'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => context.go('/plan'),
                  child: Text('Skip — just get action plan',
                      style: TextStyle(color: AppColors.textSecondary)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final String label;
  const _Divider(this.label);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(child: Divider(color: AppColors.textSecondary.withOpacity(0.3))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(label,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ),
          Expanded(child: Divider(color: AppColors.textSecondary.withOpacity(0.3))),
        ],
      );
}

class _LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  const _LabeledField({
    required this.label,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8)),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            onChanged: onChanged,
            style: const TextStyle(color: AppColors.white),
            decoration: InputDecoration(hintText: hint),
          ),
        ],
      );
}
