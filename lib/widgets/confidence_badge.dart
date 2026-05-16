import 'package:flutter/material.dart';
import '../models/pool_profile.dart';
import '../theme/app_theme.dart';

class ConfidenceBadge extends StatelessWidget {
  final ConfidenceLevel level;

  const ConfidenceBadge({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = switch (level) {
      ConfidenceLevel.high   => ('High Confidence',   AppColors.successGreen, Icons.check_circle),
      ConfidenceLevel.medium => ('Medium Confidence', AppColors.sunYellow,    Icons.info),
      ConfidenceLevel.low    => ('Low Confidence',    AppColors.alertRed,     Icons.warning),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              )),
        ],
      ),
    );
  }
}
