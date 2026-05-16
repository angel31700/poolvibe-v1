import 'package:flutter/material.dart';
import '../models/recommendation.dart';
import '../theme/app_theme.dart';

class ChemicalCard extends StatelessWidget {
  final ChemicalAction action;

  const ChemicalCard({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step number
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.waterTeal,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${action.stepOrder}',
                    style: const TextStyle(
                      color: AppColors.deepBlue,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(action.chemicalName,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        )),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.waterTeal.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Add: ${action.amountDisplay}',
                        style: const TextStyle(
                          color: AppColors.waterTeal,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          Text(action.reason,
              style: TextStyle(
                  color: AppColors.textSecondary, fontSize: 13, height: 1.4)),

          if (action.timingNote != null) ...[
            const SizedBox(height: 8),
            _NoteRow(
              icon: Icons.access_time,
              color: AppColors.sunYellow,
              text: action.timingNote!,
            ),
          ],

          if (action.warningNote != null) ...[
            const SizedBox(height: 6),
            _NoteRow(
              icon: Icons.warning_amber,
              color: AppColors.alertRed,
              text: action.warningNote!,
            ),
          ],
        ],
      ),
    );
  }
}

class _NoteRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _NoteRow({required this.icon, required this.color, required this.text});

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text,
                style: TextStyle(color: color.withOpacity(0.9), fontSize: 12, height: 1.4)),
          ),
        ],
      );
}
