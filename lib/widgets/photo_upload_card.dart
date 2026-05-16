import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PhotoUploadCard extends StatelessWidget {
  final String label;
  final String sublabel;
  final IconData iconData;
  final String? photoPath;
  final bool required;
  final ValueChanged<String?> onPhotoSelected;

  const PhotoUploadCard({
    super.key,
    required this.label,
    required this.sublabel,
    required this.iconData,
    this.photoPath,
    this.required = false,
    required this.onPhotoSelected,
  });

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoPath != null;

    return GestureDetector(
      onTap: () {
        // TODO: implement image_picker
        onPhotoSelected('/mock/photo_${DateTime.now().millisecondsSinceEpoch}.jpg');
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: hasPhoto
              ? AppColors.waterTeal.withOpacity(0.1)
              : AppColors.cardSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasPhoto
                ? AppColors.waterTeal
                : required
                    ? AppColors.textSecondary.withOpacity(0.5)
                    : Colors.transparent,
            width: hasPhoto ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: hasPhoto
                    ? AppColors.waterTeal.withOpacity(0.15)
                    : AppColors.poolBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: hasPhoto
                  ? Icon(Icons.check, color: AppColors.waterTeal, size: 28)
                  : Icon(iconData, color: AppColors.textSecondary, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(label,
                          style: TextStyle(
                            color: hasPhoto ? AppColors.waterTeal : AppColors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          )),
                      if (required)
                        Text(' *',
                            style: TextStyle(color: AppColors.waterTeal, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    hasPhoto ? 'Photo added — tap to change' : sublabel,
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(
              hasPhoto ? Icons.edit_outlined : Icons.add_a_photo_outlined,
              color: hasPhoto ? AppColors.waterTeal : AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
