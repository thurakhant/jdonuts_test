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

const List<String> _tiles = [
  'assets/images/product_berry_bliss.png',
  'assets/images/product_choco_drizzle.png',
  'assets/images/product_classic_glazed.png',
  'assets/images/product_coconut.png',
  'assets/images/product_strawberry_sprinkle.png',
  'assets/images/product_santa_cookies.png',
];

const int _gridColumns = 3;

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
      backgroundColor: AppColors.backgroundPink,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenEdge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Expanded(child: _TileGrid()),
              const SizedBox(height: AppSpacing.lg),
              StaggeredEntrance(
                index: _tiles.length,
                child: Text(
                  l10n.welcomeTitle,
                  style: AppTypography.display,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              StaggeredEntrance(
                index: _tiles.length + 1,
                child: LoadingButton(
                  label: l10n.letsExplore,
                  onPressed: () => _explore(context, ref),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TileGrid extends StatelessWidget {
  const _TileGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: _gridColumns,
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (final (i, asset) in _tiles.indexed)
          StaggeredEntrance(
            index: i,
            slide: AppMotion.driftSlide,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: ExcludeSemantics(
                child: Image.asset(asset, fit: BoxFit.cover, cacheWidth: 300),
              ),
            ),
          ),
      ],
    );
  }
}
