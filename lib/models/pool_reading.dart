/// Pool test strip / meter reading values.
/// All values are optional — partial data is expected and handled.

class PoolReading {
  final String id;
  final String poolProfileId;
  final DateTime recordedAt;

  // Chemical values (null = not measured)
  final double? chlorineFreeResidualppm;   // Free Cl (target: 1–3 ppm, salt: 1–3)
  final double? chlorineTotalppm;          // Total Cl
  final double? ph;                        // pH (target: 7.2–7.6)
  final double? alkalinityPpm;             // Total alkalinity (target: 80–120 ppm)
  final double? cyanuricAcidPpm;           // CYA / stabilizer (target: 30–50 ppm)
  final double? calciumHardnessPpm;        // Hardness (target: 200–400 ppm)
  final double? saltPpm;                   // Salt (saltwater only, target: 2700–3400 ppm)
  final double? phosphatesPpb;             // Phosphates (ideally < 100 ppb)

  // Visual symptoms
  final bool? cloudyWater;
  final bool? greenAlgae;
  final bool? blackAlgae;
  final bool? staining;
  final bool? scaling;
  final bool? foaming;
  final String? customSymptomNote;

  // Photo evidence
  final String? stripPhotoPath;
  final String? symptomPhotoPath;

  // Source
  final ReadingSource source;

  const PoolReading({
    required this.id,
    required this.poolProfileId,
    required this.recordedAt,
    this.chlorineFreeResidualppm,
    this.chlorineTotalppm,
    this.ph,
    this.alkalinityPpm,
    this.cyanuricAcidPpm,
    this.calciumHardnessPpm,
    this.saltPpm,
    this.phosphatesPpb,
    this.cloudyWater,
    this.greenAlgae,
    this.blackAlgae,
    this.staining,
    this.scaling,
    this.foaming,
    this.customSymptomNote,
    this.stripPhotoPath,
    this.symptomPhotoPath,
    this.source = ReadingSource.manualEntry,
  });

  /// Returns true if at least one chemical value was entered.
  bool get hasChemicalData =>
      chlorineFreeResidualppm != null ||
      ph != null ||
      alkalinityPpm != null ||
      cyanuricAcidPpm != null ||
      calciumHardnessPpm != null ||
      saltPpm != null;

  /// Returns true if any symptom was noted.
  bool get hasSymptoms =>
      (cloudyWater ?? false) ||
      (greenAlgae ?? false) ||
      (blackAlgae ?? false) ||
      (staining ?? false) ||
      (scaling ?? false) ||
      (foaming ?? false) ||
      (customSymptomNote != null && customSymptomNote!.isNotEmpty);
}

enum ReadingSource {
  manualEntry,
  stripPhoto,
  maintenanceReport,
}
