import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/photo_upload_card.dart';
import '../../widgets/step_progress.dart';

/// Step 1 of pool profile setup: upload pool photos.
class PoolPhotosScreen extends StatefulWidget {
  const PoolPhotosScreen({super.key});

  @override
  State<PoolPhotosScreen> createState() => _PoolPhotosScreenState();
}

class _PoolPhotosScreenState extends State<PoolPhotosScreen> {
  String? _fullPoolPhoto;
  String? _equipmentPhoto;
  String? _deepEndPhoto;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canContinue = _fullPoolPhoto != null; // only full pool required

    return Scaffold(
      backgroundColor: AppColors.deepBlue,
      appBar: AppBar(
        backgroundColor: AppColors.deepBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => context.go('/welcome'),
        ),
        title: Text('Pool Profile', style: TextStyle(color: AppColors.white)),
      ),
      body: Column(
        children: [
          StepProgress(currentStep: 1, totalSteps: 5, label: 'Add Photos'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add photos of your pool',
                    style: theme.textTheme.headlineMedium?.copyWith(color: AppColors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Photos help us understand your pool setup. '
                    'Only the full pool photo is required.',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                  const SizedBox(height: 28),

                  PhotoUploadCard(
                    label: 'Full Pool Photo *',
                    sublabel: 'Standing at one corner, capture the whole pool',
                    iconData: Icons.pool,
                    photoPath: _fullPoolPhoto,
                    required: true,
                    onPhotoSelected: (path) => setState(() => _fullPoolPhoto = path),
                  ),
                  const SizedBox(height: 16),

                  PhotoUploadCard(
                    label: 'Equipment Pad',
                    sublabel: 'Pump, filter, salt cell or chlorinator (optional)',
                    iconData: Icons.settings,
                    photoPath: _equipmentPhoto,
                    onPhotoSelected: (path) => setState(() => _equipmentPhoto = path),
                  ),
                  const SizedBox(height: 16),

                  PhotoUploadCard(
                    label: 'Deep End View',
                    sublabel: 'Helps confirm depth and water clarity (optional)',
                    iconData: Icons.water,
                    photoPath: _deepEndPhoto,
                    onPhotoSelected: (path) => setState(() => _deepEndPhoto = path),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: canContinue ? () => context.go('/profile/type') : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canContinue ? AppColors.waterTeal : AppColors.poolBlue,
              ),
              child: const Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }
}
