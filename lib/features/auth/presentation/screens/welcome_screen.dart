import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/motion/app_motion.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/entrance.dart';
import '../../../../app/widgets/loading_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/registration_flow_provider.dart';

/// Four tall photo cards in two staggered columns, as in the design
/// screens: left/top/right edges bleed off-screen and the lower cards fade
/// into the page. (left, top, width, height) as fractions of the collage
/// box; width fractions are of the box width, heights of the box height.
const List<(double, double, double, double, String)> _cards = [
  (-0.03, -0.04, 0.56, 0.50, 'assets/images/product_berry_bliss.png'),
  (-0.03, 0.52, 0.56, 0.52, 'assets/images/product_strawberry_sprinkle.png'),
  (0.61, 0.07, 0.48, 0.46, 'assets/images/product_choco_drizzle.png'),
  (0.61, 0.59, 0.48, 0.45, 'assets/images/product_classic_glazed.png'),
];

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  Future<void> _explore(BuildContext context, WidgetRef ref) async {
    await ref.read(registrationFlowProvider.notifier).finish();
    if (context.mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.blushPink,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // No top SafeArea: the cards bleed off the screen edges.
          const Expanded(child: _CardCollage()),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenEdge,
                0,
                AppSpacing.screenEdge,
                AppSpacing.screenEdge,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StaggeredEntrance(
                    index: _cards.length,
                    child: Text(
                      l10n.welcomeTitle,
                      style: AppTypography.display,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  StaggeredEntrance(
                    index: _cards.length + 1,
                    child: LoadingButton(
                      label: l10n.letsExplore,
                      onPressed: () => _explore(context, ref),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardCollage extends StatelessWidget {
  const _CardCollage();

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: LayoutBuilder(
        builder: (context, box) => Stack(
          clipBehavior: Clip.none,
          children: [
            for (final (i, (l, t, w, h, asset)) in _cards.indexed)
              Positioned(
                left: l * box.maxWidth,
                top: t * box.maxHeight,
                width: w * box.maxWidth,
                height: h * box.maxHeight,
                child: StaggeredEntrance(
                  index: i,
                  slide: AppMotion.driftSlide,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    child: ExcludeSemantics(
                      child: Image.asset(
                        asset,
                        fit: BoxFit.cover,
                        cacheWidth: 600,
                      ),
                    ),
                  ),
                ),
              ),
            // Fades the lower cards into the page above the heading.
            const Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x00F9EEF2), AppColors.blushPink],
                      stops: [0.62, 0.99],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
