import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import '../../models/affiliate_product.dart';

/// Product recommendations — tied directly to the action plan.
/// Max 2-3 options per need. No random catalog browsing.
class ProductRecommendationsScreen extends StatelessWidget {
  const ProductRecommendationsScreen({super.key});

  static final _mockRecs = [
    ProductRecommendation(
      chemicalActionId: 'step1',
      needLabel: 'You need: pH Down (Muriatic Acid)',
      options: [
        AffiliateProduct(
          id: 'p1',
          name: 'Clorox Pool & Spa pH Down',
          brand: 'Clorox',
          category: ProductCategory.phDown,
          packageSize: '5 lbs',
          strengthPercent: 100,
          estimatedPrice: 12.99,
          affiliateUrl: 'https://amzn.to/poolvibe-phdown', // placeholder
          retailer: 'Amazon',
          whyRecommended:
              'Dry acid granules — safer to handle than liquid muriatic acid. '
              'Lowers pH without affecting alkalinity as much.',
        ),
        AffiliateProduct(
          id: 'p2',
          name: 'Muriatic Acid 20° Baumé',
          brand: 'Klean Strip',
          category: ProductCategory.phDown,
          packageSize: '1 gallon',
          strengthPercent: 31.45,
          estimatedPrice: 9.48,
          affiliateUrl: 'https://www.homedepot.com/poolvibe-acid', // placeholder
          retailer: 'Home Depot',
          whyRecommended:
              'Most cost-effective option. Use gloves and eye protection. '
              'Dilute before adding.',
        ),
      ],
    ),
    ProductRecommendation(
      chemicalActionId: 'step2',
      needLabel: 'You need: Chlorine boost',
      options: [
        AffiliateProduct(
          id: 'p3',
          name: 'In The Swim Liquid Chlorine',
          brand: 'In The Swim',
          category: ProductCategory.liquidChlorine,
          packageSize: '4 x 1 gallon',
          strengthPercent: 12.5,
          estimatedPrice: 29.99,
          affiliateUrl: 'https://amzn.to/poolvibe-liquidcl',
          retailer: 'Amazon',
          whyRecommended:
              'Ready-to-use liquid chlorine — no pre-dissolving needed. '
              'Fast-acting. Best for routine chlorine top-up.',
        ),
        AffiliateProduct(
          id: 'p4',
          name: 'Clorox Pool Shock Xtra Blue',
          brand: 'Clorox',
          category: ProductCategory.calHypoShock,
          packageSize: '12 x 1 lb bags',
          strengthPercent: 68,
          estimatedPrice: 24.97,
          affiliateUrl: 'https://amzn.to/poolvibe-shock',
          retailer: 'Amazon',
          whyRecommended:
              'Cal-Hypo shock — best for severe depletion or algae. '
              'Pre-dissolve each bag before adding. Shock at dusk.',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.deepBlue,
      appBar: AppBar(
        backgroundColor: AppColors.deepBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => context.go('/plan'),
        ),
        title: Text('What to Buy', style: TextStyle(color: AppColors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.waterTeal.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.waterTeal, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Every product here is tied to your specific pool condition. '
                      'Links are affiliate links — PoolVibe earns a small commission at no cost to you.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            ..._mockRecs.map((rec) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.cardSurface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        rec.needLabel,
                        style: TextStyle(
                          color: AppColors.waterTeal,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...rec.options.map((product) => _ProductCard(product: product)),
                    const SizedBox(height: 20),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final AffiliateProduct product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(product.name,
                    style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
              ),
              Text('\$${product.estimatedPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                      color: AppColors.waterTeal,
                      fontWeight: FontWeight.w700,
                      fontSize: 14)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(product.brand,
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              Text(' · ${product.packageSize}',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              if (product.strengthPercent != null)
                Text(' · ${product.strengthPercent}%',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text(product.whyRecommended,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.4)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                final uri = Uri.parse(product.affiliateUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              icon: const Icon(Icons.open_in_new, size: 16),
              label: Text('Buy on ${product.retailer}'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
                textStyle: const TextStyle(fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
