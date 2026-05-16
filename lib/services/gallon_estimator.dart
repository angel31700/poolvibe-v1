import '../models/pool_profile.dart';

/// GallonEstimator — calculates pool volume from dimensions and shape.
/// Returns a range (low/high) with a confidence level, never a fake-exact number.
///
/// Formulas:
///   Rectangle: L × W × avg_depth × 7.5
///   Oval:      L × W × avg_depth × 5.9
///   Round:     π × r² × avg_depth × 7.5
///   Kidney:    (L × W × 0.85) × avg_depth × 7.5  (0.85 = shape factor)
///   L-shape:   two rectangles combined
///   Freeform:  width approximation, low confidence

class GallonEstimationResult {
  final double gallonsLow;
  final double gallonsHigh;
  final ConfidenceLevel confidence;
  final String confidenceNote;
  final String calculationNote;   // explains the formula used

  const GallonEstimationResult({
    required this.gallonsLow,
    required this.gallonsHigh,
    required this.confidence,
    required this.confidenceNote,
    required this.calculationNote,
  });

  String get displayRange {
    final low  = gallonsLow.round();
    final high = gallonsHigh.round();
    return '${_fmt(low)} – ${_fmt(high)} gallons';
  }

  String _fmt(int g) {
    if (g >= 1000) return '${(g / 1000).toStringAsFixed(1)}k';
    return g.toString();
  }
}

class GallonEstimator {
  /// Main entry — estimate gallons from a PoolProfile.
  static GallonEstimationResult estimate(PoolProfile profile) {
    final avgDepth = _averageDepth(profile);
    if (avgDepth == null) {
      return _noDepthResult(profile);
    }

    final length = profile.lengthFt;
    final width  = profile.widthFt;

    if (length == null || width == null) {
      return _noDimensionsResult(avgDepth, profile.shape);
    }

    return _calculate(profile.shape, length, width, avgDepth);
  }

  static double? _averageDepth(PoolProfile p) {
    if (p.averageDepthFt != null) return p.averageDepthFt;
    if (p.shallowDepthFt != null && p.deepDepthFt != null) {
      return (p.shallowDepthFt! + p.deepDepthFt!) / 2;
    }
    if (p.shallowDepthFt != null) return p.shallowDepthFt! + 1.5; // guess avg
    if (p.deepDepthFt   != null) return p.deepDepthFt!   - 1.5; // guess avg
    return null;
  }

  static GallonEstimationResult _calculate(
    PoolShape shape,
    double length,
    double width,
    double avgDepth,
  ) {
    double base;
    double shapeFactor;
    String shapeNote;

    switch (shape) {
      case PoolShape.rectangle:
        base = length * width * avgDepth * 7.5;
        shapeFactor = 1.0;
        shapeNote = 'Rectangle: L × W × depth × 7.5';
        break;
      case PoolShape.oval:
        base = length * width * avgDepth * 5.9;
        shapeFactor = 1.0;
        shapeNote = 'Oval: L × W × depth × 5.9';
        break;
      case PoolShape.round:
        final radius = (length < width ? length : width) / 2;
        base = 3.14159 * radius * radius * avgDepth * 7.5;
        shapeFactor = 1.0;
        shapeNote = 'Round: π × r² × depth × 7.5';
        break;
      case PoolShape.kidney:
        base = length * width * 0.85 * avgDepth * 7.5;
        shapeFactor = 1.0;
        shapeNote = 'Kidney: L × W × 0.85 × depth × 7.5';
        break;
      case PoolShape.lShape:
        base = length * width * 0.75 * avgDepth * 7.5;
        shapeFactor = 1.0;
        shapeNote = 'L-shape: estimated at 75% rectangle';
        break;
      case PoolShape.freeform:
        base = length * width * 0.70 * avgDepth * 7.5;
        shapeFactor = 1.0;
        shapeNote = 'Freeform: estimated at 70% rectangle';
        break;
    }

    // ± 15% range for measurement uncertainty
    final margin = base * 0.15;
    final low  = (base - margin).roundToDouble();
    final high = (base + margin).roundToDouble();

    // Confidence: high if shape + all dims; medium if avg depth inferred
    final confidence = ConfidenceLevel.medium;
    const confidenceNote =
        'Estimate uses your dimensions and shape. Confidence improves if you '
        'can verify gallons from a pool-builder spec sheet.';

    return GallonEstimationResult(
      gallonsLow:       low,
      gallonsHigh:      high,
      confidence:       confidence,
      confidenceNote:   confidenceNote,
      calculationNote:  shapeNote,
    );
  }

  static GallonEstimationResult _noDepthResult(PoolProfile p) {
    // Wild estimate from shape alone — very low confidence
    final length = p.lengthFt ?? 20;
    final width  = p.widthFt  ?? 10;
    const assumedAvgDepth = 4.5; // average residential pool
    final rough = length * width * assumedAvgDepth * 7.5;
    return GallonEstimationResult(
      gallonsLow:  rough * 0.6,
      gallonsHigh: rough * 1.4,
      confidence:  ConfidenceLevel.low,
      confidenceNote: 'No depth was provided. This is a rough estimate only. '
          'Add your pool depths for a more accurate result.',
      calculationNote: 'Assumed average depth of 4.5 ft.',
    );
  }

  static GallonEstimationResult _noDimensionsResult(double avgDepth, PoolShape shape) {
    // Typical residential ranges by shape
    final (low, high) = _typicalRange(shape);
    return GallonEstimationResult(
      gallonsLow:  low.toDouble(),
      gallonsHigh: high.toDouble(),
      confidence:  ConfidenceLevel.low,
      confidenceNote: 'No length or width was provided. This range is typical for '
          'a residential ${shape.name} pool. Add dimensions for accuracy.',
      calculationNote: 'Used typical residential range for ${shape.name} pool.',
    );
  }

  static (int, int) _typicalRange(PoolShape shape) {
    switch (shape) {
      case PoolShape.rectangle: return (10000, 25000);
      case PoolShape.oval:      return (8000,  20000);
      case PoolShape.round:     return (5000,  15000);
      case PoolShape.kidney:    return (8000,  18000);
      case PoolShape.lShape:    return (12000, 28000);
      case PoolShape.freeform:  return (10000, 22000);
    }
  }
}
