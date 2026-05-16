/// AffiliateProduct — ties a dosing need to a purchasable product with affiliate link.

enum ProductCategory {
  liquidChlorine,
  calHypoShock,
  triChlor,
  diChlor,
  cyanuricAcid,
  phUp,
  phDown,
  alkalinityUp,
  calciumHardnessUp,
  algaecide,
  clarifier,
  saltCells,
  poolSalt,
  phosphateRemover,
}

class AffiliateProduct {
  final String id;
  final String name;               // e.g. "Clorox Pool & Spa Shock Plus"
  final String brand;
  final ProductCategory category;
  final String packageSize;        // e.g. "6 lbs", "1 gallon", "5 lbs"
  final double? strengthPercent;   // active ingredient %
  final double estimatedPrice;     // USD
  final String affiliateUrl;       // Amazon/Home Depot affiliate link
  final String retailer;           // "Amazon", "Home Depot", "Walmart"
  final String? imageUrl;
  final String whyRecommended;     // short explanation tied to pool condition

  const AffiliateProduct({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.packageSize,
    this.strengthPercent,
    required this.estimatedPrice,
    required this.affiliateUrl,
    required this.retailer,
    this.imageUrl,
    required this.whyRecommended,
  });
}

/// Groups products for a single treatment need (max 2-3 options).
class ProductRecommendation {
  final String chemicalActionId;   // matches ChemicalAction it satisfies
  final String needLabel;          // e.g. "You need: Shock treatment"
  final List<AffiliateProduct> options; // 2–3 max

  const ProductRecommendation({
    required this.chemicalActionId,
    required this.needLabel,
    required this.options,
  });
}
