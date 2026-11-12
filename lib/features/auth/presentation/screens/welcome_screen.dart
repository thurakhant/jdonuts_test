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

/// Mock-up collage: two tall tiles on the left, three shorter on the right.
const int _leftTiles = 2;

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

  Widget _tile(int index, {required int flex}) {
    return Expanded(
      flex: flex,
      child: StaggeredEntrance(
        index: index,
        slide: AppMotion.driftSlide,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: ExcludeSemantics(
            child: SizedBox.expand(
              child: Image.asset(
                _tiles[index],
                fit: BoxFit.cover,
                cacheWidth: 500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Column(
            children: [
              _tile(0, flex: 3),
              const SizedBox(height: AppSpacing.sm),
              _tile(1, flex: 4),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            children: [
              for (var i = _leftTiles; i < _tiles.length - 1; i++) ...[
                if (i > _leftTiles) const SizedBox(height: AppSpacing.sm),
                _tile(i, flex: 1),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
