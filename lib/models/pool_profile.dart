/// PoolProfile — the core data model for a user's pool.
/// All fields used by gallon estimation, dosing, and maintenance logic.

enum PoolType { saltwater, chlorine }

enum PoolShape {
  rectangle,
  oval,
  kidney,
  lShape,
  freeform,
  round,
}

enum SurfaceType {
  plaster,
  vinyl,
  fiberglass,
  pebbleTec,
  tile,
}

enum ConfidenceLevel { low, medium, high }

class PoolProfile {
  final String id;
  final String name;                   // user-given pool name
  final PoolType poolType;
  final PoolShape shape;
  final SurfaceType surfaceType;

  // Dimensions (in feet)
  final double? lengthFt;
  final double? widthFt;
  final double? shallowDepthFt;
  final double? deepDepthFt;
  final double? averageDepthFt;       // if user provides avg instead of min/max

  // Estimated gallons
  final double? gallonsLow;
  final double? gallonsHigh;
  final ConfidenceLevel gallonsConfidence;

  // Photo paths (local file paths or future URLs)
  final String? fullPoolPhotoPath;
  final String? equipmentPadPhotoPath;
  final String? deepEndPhotoPath;
  final String? shallowEndPhotoPath;

  // Metadata
  final DateTime createdAt;
  final DateTime updatedAt;

  const PoolProfile({
    required this.id,
    required this.name,
    required this.poolType,
    required this.shape,
    required this.surfaceType,
    this.lengthFt,
    this.widthFt,
    this.shallowDepthFt,
    this.deepDepthFt,
    this.averageDepthFt,
    this.gallonsLow,
    this.gallonsHigh,
    this.gallonsConfidence = ConfidenceLevel.low,
    this.fullPoolPhotoPath,
    this.equipmentPadPhotoPath,
    this.deepEndPhotoPath,
    this.shallowEndPhotoPath,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Returns a human-readable gallon range for display.
  String get gallonsDisplay {
    if (gallonsLow == null || gallonsHigh == null) return 'Unknown';
    final low  = gallonsLow!.round();
    final high = gallonsHigh!.round();
    return '${_formatGallons(low)} – ${_formatGallons(high)} gal';
  }

  String _formatGallons(int g) {
    if (g >= 1000) return '${(g / 1000).toStringAsFixed(1)}k';
    return g.toString();
  }

  /// Best single estimate for dosing math.
  double? get gallonsMidpoint {
    if (gallonsLow == null || gallonsHigh == null) return null;
    return (gallonsLow! + gallonsHigh!) / 2;
  }

  PoolProfile copyWith({
    String? name,
    PoolType? poolType,
    PoolShape? shape,
    SurfaceType? surfaceType,
    double? lengthFt,
    double? widthFt,
    double? shallowDepthFt,
    double? deepDepthFt,
    double? averageDepthFt,
    double? gallonsLow,
    double? gallonsHigh,
    ConfidenceLevel? gallonsConfidence,
    String? fullPoolPhotoPath,
    String? equipmentPadPhotoPath,
    String? deepEndPhotoPath,
    String? shallowEndPhotoPath,
  }) {
    return PoolProfile(
      id: id,
      name: name ?? this.name,
      poolType: poolType ?? this.poolType,
      shape: shape ?? this.shape,
      surfaceType: surfaceType ?? this.surfaceType,
      lengthFt: lengthFt ?? this.lengthFt,
      widthFt: widthFt ?? this.widthFt,
      shallowDepthFt: shallowDepthFt ?? this.shallowDepthFt,
      deepDepthFt: deepDepthFt ?? this.deepDepthFt,
      averageDepthFt: averageDepthFt ?? this.averageDepthFt,
      gallonsLow: gallonsLow ?? this.gallonsLow,
      gallonsHigh: gallonsHigh ?? this.gallonsHigh,
      gallonsConfidence: gallonsConfidence ?? this.gallonsConfidence,
      fullPoolPhotoPath: fullPoolPhotoPath ?? this.fullPoolPhotoPath,
      equipmentPadPhotoPath: equipmentPadPhotoPath ?? this.equipmentPadPhotoPath,
      deepEndPhotoPath: deepEndPhotoPath ?? this.deepEndPhotoPath,
      shallowEndPhotoPath: shallowEndPhotoPath ?? this.shallowEndPhotoPath,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
