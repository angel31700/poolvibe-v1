import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

/// Manual test strip value entry screen.
class StripValuesScreen extends StatefulWidget {
  const StripValuesScreen({super.key});

  @override
  State<StripValuesScreen> createState() => _StripValuesScreenState();
}

class _StripValuesScreenState extends State<StripValuesScreen> {
  final _clFreeCtrl  = TextEditingController();
  final _phCtrl      = TextEditingController();
  final _alkCtrl     = TextEditingController();
  final _cyaCtrl     = TextEditingController();
  final _caCtrl      = TextEditingController();
  final _saltCtrl    = TextEditingController();

  bool get _hasMinData =>
      _clFreeCtrl.text.isNotEmpty || _phCtrl.text.isNotEmpty;

  static const _fields = [
    ('Free Chlorine', 'ppm', '1.0 – 3.0', 'clFree', 'Prevents bacteria and algae'),
    ('pH',            '',    '7.2 – 7.6',  'ph',     'Controls chemical effectiveness'),
    ('Total Alkalinity','ppm','80 – 120',  'alk',    'Buffers pH swings'),
    ('CYA / Stabilizer','ppm','30 – 50',   'cya',    'Protects chlorine from UV'),
    ('Calcium Hardness','ppm','200 – 400', 'ca',     'Protects pool surfaces'),
    ('Salt (saltwater only)','ppm','2700 – 3400', 'salt', 'For saltwater pools only'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controllers = [_clFreeCtrl, _phCtrl, _alkCtrl, _cyaCtrl, _caCtrl, _saltCtrl];

    return Scaffold(
      backgroundColor: AppColors.deepBlue,
      appBar: AppBar(
        backgroundColor: AppColors.deepBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => context.go('/intake'),
        ),
        title: Text('Test Strip Values', style: TextStyle(color: AppColors.white)),
      ),
      body: Column(
        children: [
          // Strip photo prompt
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.cardSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.camera_alt, color: AppColors.waterTeal, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Have a strip photo? Upload it and we\'ll help read the values.',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('Upload', style: TextStyle(color: AppColors.waterTeal)),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter your readings',
                    style: theme.textTheme.titleLarge?.copyWith(color: AppColors.white),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Skip values you didn\'t test — the more you enter, the better the plan.',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 20),

                  ...List.generate(_fields.length, (i) {
                    final (label, unit, target, _, desc) = _fields[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(label,
                                  style: const TextStyle(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14)),
                              Text('Target: $target',
                                  style: TextStyle(
                                      color: AppColors.waterTeal, fontSize: 11)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(desc,
                              style: TextStyle(
                                  color: AppColors.textSecondary, fontSize: 11)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: controllers[i],
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                            ],
                            onChanged: (_) => setState(() {}),
                            style: const TextStyle(color: AppColors.white, fontSize: 16),
                            decoration: InputDecoration(
                              suffixText: unit.isEmpty ? null : unit,
                              suffixStyle: TextStyle(color: AppColors.textSecondary),
                              hintText: 'e.g. ${target.split('–').first.trim()}',
                              hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5)),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _hasMinData ? () => context.go('/plan') : null,
                  child: const Text('Get My Action Plan →'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => context.go('/intake/symptoms'),
                  child: Text('Also add symptoms',
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
