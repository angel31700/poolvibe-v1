import '../models/pool_profile.dart';
import '../models/pool_reading.dart';
import '../models/recommendation.dart';

/// RecommendationEngine — translates pool profile + readings into an action plan.
///
/// v1 targets:
///   Free Cl:       1–3 ppm (salt: 1–3 ppm)
///   pH:            7.2–7.6
///   Total Alk:     80–120 ppm
///   CYA:           30–50 ppm (salt: 70–80 ppm)
///   Calcium Hard:  200–400 ppm
///   Salt:          2700–3400 ppm (saltwater only)

class RecommendationEngine {
  static Recommendation analyze({
    required PoolProfile profile,
    required PoolReading reading,
  }) {
    final gallons = profile.gallonsMidpoint ?? 15000;
    final actions = <ChemicalAction>[];
    final dataGaps = <String>[];
    final diagnoses = <String>[];
    var step = 1;

    // ── Alkalinity first (affects pH effectiveness) ──────────────
    if (reading.alkalinityPpm != null) {
      final alk = reading.alkalinityPpm!;
      if (alk < 80) {
        final lbsNeeded = _sodaAshLbs(gallons, alk, 100);
        actions.add(ChemicalAction(
          chemicalName: 'Baking Soda (alkalinity increaser)',
          amountLbs: lbsNeeded,
          amountDisplay: '${lbsNeeded.toStringAsFixed(1)} lbs',
          reason: 'Alkalinity is ${alk.round()} ppm (target: 80–120 ppm). '
              'Low alkalinity causes pH bounce and reduces chlorine effectiveness.',
          stepOrder: step++,
          timingNote: 'Add to deep end with pump running. Wait 4 hours before adjusting pH.',
        ));
        diagnoses.add('Low alkalinity (${alk.round()} ppm)');
      } else if (alk > 120) {
        diagnoses.add('High alkalinity (${alk.round()} ppm) — use muriatic acid to lower slowly');
      }
    } else {
      dataGaps.add('Total alkalinity not provided');
    }

    // ── pH ───────────────────────────────────────────────────────
    if (reading.ph != null) {
      final ph = reading.ph!;
      if (ph < 7.2) {
        actions.add(ChemicalAction(
          chemicalName: 'Soda Ash (pH Up)',
          amountLbs: _phUpLbs(gallons, ph, 7.4),
          amountDisplay: '${_phUpLbs(gallons, ph, 7.4).toStringAsFixed(1)} lbs',
          reason: 'pH is ${ph.toStringAsFixed(1)} (target: 7.2–7.6). '
              'Low pH is corrosive to equipment and irritates skin and eyes.',
          stepOrder: step++,
          timingNote: 'Add after alkalinity is adjusted. Wait 2 hours.',
          warningNote: 'Retest before adding more. pH can overshoot.',
        ));
        diagnoses.add('Low pH (${ph.toStringAsFixed(1)})');
      } else if (ph > 7.6) {
        actions.add(ChemicalAction(
          chemicalName: 'Muriatic Acid (pH Down)',
          amountLbs: 0,
          amountOz: _phDownFlOz(gallons, ph, 7.4),
          amountDisplay: '${_phDownFlOz(gallons, ph, 7.4).toStringAsFixed(0)} fl oz',
          reason: 'pH is ${ph.toStringAsFixed(1)} (target: 7.2–7.6). '
              'High pH reduces chlorine effectiveness dramatically.',
          stepOrder: step++,
          timingNote: 'Pour slowly around the perimeter with pump running. Wait 2 hours.',
          warningNote: 'Never mix acid with other chemicals. Use gloves and eye protection.',
        ));
        diagnoses.add('High pH (${ph.toStringAsFixed(1)})');
      }
    } else {
      dataGaps.add('pH not provided');
    }

    // ── Chlorine / Sanitizer ─────────────────────────────────────
    final targetCl = profile.poolType == PoolType.saltwater ? 2.0 : 2.0;
    if (reading.chlorineFreeResidualppm != null) {
      final cl = reading.chlorineFreeResidualppm!;
      if (cl < 1.0) {
        final lbs = _chlorineLbs(gallons, cl, targetCl);
        final isShock = cl < 0.5 || (reading.cloudyWater ?? false) || (reading.greenAlgae ?? false);
        actions.add(ChemicalAction(
          chemicalName: isShock ? 'Calcium Hypochlorite Shock' : 'Liquid Chlorine',
          amountLbs: lbs,
          amountDisplay: isShock
              ? '${lbs.toStringAsFixed(1)} lbs'
              : '${(lbs * 0.75).toStringAsFixed(1)} lbs (liquid equivalent)',
          reason: 'Free chlorine is ${cl.toStringAsFixed(1)} ppm (target: 1–3 ppm). '
              '${isShock ? "Shock treatment recommended for severe depletion." : "Chlorine boost needed."}',
          stepOrder: step++,
          timingNote: isShock
              ? 'Shock at dusk. Do not swim for 24 hours. Retest before use.'
              : 'Add with pump running. Retest in 4 hours.',
          warningNote: isShock ? 'Pre-dissolve shock in a bucket of water before adding.' : null,
        ));
        diagnoses.add('Low chlorine (${cl.toStringAsFixed(1)} ppm)${isShock ? " — shock needed" : ""}');
      }
    } else {
      dataGaps.add('Free chlorine not provided');
    }

    // ── CYA / Stabilizer ─────────────────────────────────────────
    if (reading.cyanuricAcidPpm != null) {
      final cya = reading.cyanuricAcidPpm!;
      final targetCya = profile.poolType == PoolType.saltwater ? 75.0 : 40.0;
      if (cya < (profile.poolType == PoolType.saltwater ? 70 : 30)) {
        final lbs = _cyaLbs(gallons, cya, targetCya);
        actions.add(ChemicalAction(
          chemicalName: 'Cyanuric Acid (Stabilizer / Conditioner)',
          amountLbs: lbs,
          amountDisplay: '${lbs.toStringAsFixed(1)} lbs',
          reason: 'CYA is ${cya.round()} ppm (target: ${profile.poolType == PoolType.saltwater ? "70–80" : "30–50"} ppm). '
              'Low stabilizer allows UV to burn off chlorine rapidly.',
          stepOrder: step++,
          timingNote: 'Add slowly to skimmer with pump running. Levels take 24–48h to register.',
        ));
        diagnoses.add('Low CYA (${cya.round()} ppm)');
      }
    } else {
      dataGaps.add('CYA/Stabilizer not provided');
    }

    // ── Algae symptoms override ───────────────────────────────────
    if ((reading.greenAlgae ?? false) || (reading.cloudyWater ?? false)) {
      if (!diagnoses.any((d) => d.contains('chlorine'))) {
        // If no chlorine data but algae visible, still recommend shock
        actions.add(ChemicalAction(
          chemicalName: 'Calcium Hypochlorite Shock',
          amountLbs: _shockLbsForGallons(gallons),
          amountDisplay: '${_shockLbsForGallons(gallons).toStringAsFixed(1)} lbs',
          reason: 'Visible ${reading.greenAlgae == true ? "algae" : "cloudy water"} detected. '
              'Shock treatment is the first step regardless of strip values.',
          stepOrder: step++,
          timingNote: 'Shock at dusk. Run filter 24 hours. Do not swim.',
          warningNote: 'Brush walls and floor before shocking. Clean filter after.',
        ));
        diagnoses.add(reading.greenAlgae == true ? 'Algae visible' : 'Cloudy water');
      }
    }

    // ── Build confidence ──────────────────────────────────────────
    final confidence = _calcConfidence(reading, dataGaps);
    final confidenceNote = _buildConfidenceNote(confidence, dataGaps, profile);

    final primaryDiagnosis = diagnoses.isEmpty
        ? 'Pool chemistry appears balanced based on available data'
        : diagnoses.join(', ');

    return Recommendation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      poolProfileId: profile.id,
      readingId: reading.id,
      generatedAt: DateTime.now(),
      primaryDiagnosis: primaryDiagnosis,
      diagnosisExplanation: actions.isEmpty
          ? 'All measured values are within target range. Continue weekly testing.'
          : 'Based on your pool size (≈${(profile.gallonsMidpoint ?? 15000).round()} gal) '
            'and current readings, the following treatments are recommended.',
      actions: actions,
      confidence: confidence,
      confidenceNote: confidenceNote,
      dataGaps: dataGaps,
      requiresShock: actions.any((a) => a.chemicalName.contains('Shock')),
      requiresAlgaeTreatment: reading.greenAlgae ?? false,
      urgencyHigh: (reading.chlorineFreeResidualppm ?? 99) < 0.5 ||
                   (reading.greenAlgae ?? false),
    );
  }

  // ── Math helpers ─────────────────────────────────────────────────

  static double _sodaAshLbs(double gallons, double current, double target) {
    // ~1.4 lbs per 10,000 gal raises alk by 10 ppm
    return ((target - current) / 10) * (gallons / 10000) * 1.4;
  }

  static double _phUpLbs(double gallons, double current, double target) {
    // ~6 oz per 10,000 gal raises pH by 0.2
    return ((target - current) / 0.2) * (gallons / 10000) * 0.375;
  }

  static double _phDownFlOz(double gallons, double current, double target) {
    // ~8 fl oz muriatic acid per 10,000 gal lowers pH by 0.2
    return ((current - target) / 0.2) * (gallons / 10000) * 8;
  }

  static double _chlorineLbs(double gallons, double current, double target) {
    // ~1 lb granular Cl per 10,000 gal raises FCl by ~1 ppm
    return (target - current) * (gallons / 10000);
  }

  static double _cyaLbs(double gallons, double current, double target) {
    // ~1.3 lbs per 10,000 gal raises CYA by 10 ppm
    return ((target - current) / 10) * (gallons / 10000) * 1.3;
  }

  static double _shockLbsForGallons(double gallons) {
    // 1 lb Cal-Hypo (73%) per 10,000 gal for shock dose
    return (gallons / 10000).clamp(1.0, 10.0);
  }

  static ConfidenceLevel _calcConfidence(PoolReading r, List<String> gaps) {
    if (gaps.length >= 3) return ConfidenceLevel.low;
    if (gaps.length == 2) return ConfidenceLevel.low;
    if (gaps.length == 1) return ConfidenceLevel.medium;
    return ConfidenceLevel.high;
  }

  static String _buildConfidenceNote(
    ConfidenceLevel level,
    List<String> gaps,
    PoolProfile profile,
  ) {
    final gallonNote = profile.gallonsConfidence == ConfidenceLevel.low
        ? ' Pool gallons are an estimate — add pool dimensions to improve dosing accuracy.'
        : '';

    switch (level) {
      case ConfidenceLevel.high:
        return 'All key values were provided. Dosing is calculated for your pool size.$gallonNote';
      case ConfidenceLevel.medium:
        return 'Most values were provided. Missing: ${gaps.join(", ")}. '
            'Recommendation is good but add missing values for better accuracy.$gallonNote';
      case ConfidenceLevel.low:
        return 'Several values are missing: ${gaps.join(", ")}. '
            'Use this as a starting point only. Test your water fully before acting.$gallonNote';
    }
  }
}
