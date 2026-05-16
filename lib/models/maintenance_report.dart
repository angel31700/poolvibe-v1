/// MaintenanceReport — what a service company says they did.
/// The app compares this against what should have happened given pool size + readings.

class MaintenanceReportEntry {
  final String chemicalName;
  final double? amountAdded;    // what the report says was added
  final String? unit;           // lbs, oz, gal, etc.
  final String? note;
}

class MaintenanceReport {
  final String id;
  final String poolProfileId;
  final DateTime serviceDate;
  final String? technicianName;
  final String? companyName;

  // What the report says was added
  final List<MaintenanceReportEntry> chemicalsAdded;

  // Pool readings taken by tech (may be partial)
  final double? reportedChlorineppm;
  final double? reportedPh;
  final double? reportedAlkalinityPpm;
  final double? reportedSaltPpm;

  // Original report
  final String? reportPhotoPath;   // photo of the paper report
  final String? reportNotes;       // typed summary if no photo

  // Comparison result (populated after analysis)
  final MaintenanceComparisonResult? comparisonResult;

  const MaintenanceReport({
    required this.id,
    required this.poolProfileId,
    required this.serviceDate,
    this.technicianName,
    this.companyName,
    this.chemicalsAdded = const [],
    this.reportedChlorineppm,
    this.reportedPh,
    this.reportedAlkalinityPpm,
    this.reportedSaltPpm,
    this.reportPhotoPath,
    this.reportNotes,
    this.comparisonResult,
  });
}

enum MaintenanceFlagType {
  likelyUnderdosed,
  chemicalMissing,
  wrongChemicalForPoolType,
  reportIncomplete,
  dosageTooLow,
  dosageUnverifiable,
}

class MaintenanceFlag {
  final MaintenanceFlagType type;
  final String chemicalName;
  final String explanation;
  final String? expectedAmount;
  final String? reportedAmount;

  const MaintenanceFlag({
    required this.type,
    required this.chemicalName,
    required this.explanation,
    this.expectedAmount,
    this.reportedAmount,
  });
}

class MaintenanceComparisonResult {
  final bool appearsReasonable;
  final String summary;              // one-line verdict
  final List<MaintenanceFlag> flags; // specific issues found
  final String? whatShouldHaveHappened; // plain-English expected treatment

  const MaintenanceComparisonResult({
    required this.appearsReasonable,
    required this.summary,
    this.flags = const [],
    this.whatShouldHaveHappened,
  });

  bool get hasFlags => flags.isNotEmpty;
}
