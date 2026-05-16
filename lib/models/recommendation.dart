/// Recommendation — the output of the v1 decision engine.

enum ConfidenceLevel { low, medium, high }

class ChemicalAction {
  final String chemicalName;       // e.g. "Chlorine (liquid)"
  final double amountLbs;          // weight in lbs
  final double? amountOz;          // oz for small amounts
  final double? amountGallons;     // gallons for liquids
  final String amountDisplay;      // human-readable: "2 lbs" / "32 oz" / "0.5 gal"
  final String reason;             // why this is needed
  final int stepOrder;             // 1-based order to add chemicals
  final String? timingNote;        // "Wait 4 hrs before adding next chemical"
  final String? warningNote;       // "Do not add with chlorine simultaneously"

  const ChemicalAction({
    required this.chemicalName,
    required this.amountLbs,
    this.amountOz,
    this.amountGallons,
    required this.amountDisplay,
    required this.reason,
    required this.stepOrder,
    this.timingNote,
    this.warningNote,
  });
}

class Recommendation {
  final String id;
  final String poolProfileId;
  final String readingId;
  final DateTime generatedAt;

  // Diagnosis
  final String primaryDiagnosis;         // e.g. "Low chlorine + high pH"
  final String diagnosisExplanation;

  // Action plan (ordered)
  final List<ChemicalAction> actions;

  // Confidence
  final ConfidenceLevel confidence;
  final String confidenceNote;           // explains why confidence is low/med/high
  final List<String> dataGaps;           // missing values that would improve accuracy

  // Flags
  final bool requiresShock;
  final bool requiresAlgaeTreatment;
  final bool urgencyHigh;                // "Do this today"

  const Recommendation({
    required this.id,
    required this.poolProfileId,
    required this.readingId,
    required this.generatedAt,
    required this.primaryDiagnosis,
    required this.diagnosisExplanation,
    required this.actions,
    required this.confidence,
    required this.confidenceNote,
    this.dataGaps = const [],
    this.requiresShock = false,
    this.requiresAlgaeTreatment = false,
    this.urgencyHigh = false,
  });

  bool get hasActions => actions.isNotEmpty;
  List<ChemicalAction> get orderedActions =>
      List.of(actions)..sort((a, b) => a.stepOrder.compareTo(b.stepOrder));
}
