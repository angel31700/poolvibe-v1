import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'screens/onboarding/welcome_screen.dart';
import 'screens/profile/pool_type_screen.dart';
import 'screens/profile/pool_shape_screen.dart';
import 'screens/profile/pool_dimensions_screen.dart';
import 'screens/profile/pool_photos_screen.dart';
import 'screens/profile/surface_type_screen.dart';
import 'screens/estimation/gallon_result_screen.dart';
import 'screens/intake/intake_choice_screen.dart';
import 'screens/intake/strip_values_screen.dart';
import 'screens/intake/symptom_screen.dart';
import 'screens/intake/report_upload_screen.dart';
import 'screens/recommendation/action_plan_screen.dart';
import 'screens/affiliate/product_recommendations_screen.dart';
import 'screens/maintenance/report_comparison_screen.dart';
import 'screens/history/history_screen.dart';

final _router = GoRouter(
  initialLocation: '/welcome',
  routes: [
    // ── Onboarding ──────────────────────────────────────────────
    GoRoute(path: '/welcome',       builder: (_, __) => const WelcomeScreen()),

    // ── Pool Profile Setup ───────────────────────────────────────
    GoRoute(path: '/profile/photos',     builder: (_, __) => const PoolPhotosScreen()),
    GoRoute(path: '/profile/type',       builder: (_, __) => const PoolTypeScreen()),
    GoRoute(path: '/profile/shape',      builder: (_, __) => const PoolShapeScreen()),
    GoRoute(path: '/profile/dimensions', builder: (_, __) => const PoolDimensionsScreen()),
    GoRoute(path: '/profile/surface',    builder: (_, __) => const SurfaceTypeScreen()),

    // ── Gallon Estimation ────────────────────────────────────────
    GoRoute(path: '/estimation/result',  builder: (_, __) => const GallonResultScreen()),

    // ── Condition Intake ─────────────────────────────────────────
    GoRoute(path: '/intake',             builder: (_, __) => const IntakeChoiceScreen()),
    GoRoute(path: '/intake/strip',       builder: (_, __) => const StripValuesScreen()),
    GoRoute(path: '/intake/symptoms',    builder: (_, __) => const SymptomScreen()),
    GoRoute(path: '/intake/report',      builder: (_, __) => const ReportUploadScreen()),

    // ── Outputs ──────────────────────────────────────────────────
    GoRoute(path: '/plan',               builder: (_, __) => const ActionPlanScreen()),
    GoRoute(path: '/products',           builder: (_, __) => const ProductRecommendationsScreen()),
    GoRoute(path: '/maintenance',        builder: (_, __) => const ReportComparisonScreen()),

    // ── History ──────────────────────────────────────────────────
    GoRoute(path: '/history',            builder: (_, __) => const HistoryScreen()),
  ],
);

class PoolVibeApp extends ConsumerWidget {
  const PoolVibeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'PoolVibe',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
