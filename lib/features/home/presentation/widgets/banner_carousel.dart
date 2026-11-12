import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/motion/app_motion.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/jd_image.dart';
import '../../../../app/widgets/skeleton.dart';
import '../../application/home_providers.dart';
import '../../domain/promo_banner.dart';

class BannerCarousel extends ConsumerWidget {
  const BannerCarousel({super.key});

  static const double height = 150;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(bannersProvider)
        .when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
            child: SkeletonBox(height: height, radius: AppRadius.lg),
          ),
          error: (_, _) => const SizedBox.shrink(),
          data: (banners) =>
              banners.isEmpty ? const SizedBox.shrink() : _Pager(banners),
        );
  }
}

class _Pager extends StatefulWidget {
  const _Pager(this.banners);

  final List<PromoBanner> banners;

  @override
  State<_Pager> createState() => _PagerState();
}

class _PagerState extends State<_Pager> {
  final _controller = PageController(viewportFraction: 0.9);
  Timer? _timer;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(AppMotion.bannerAutoAdvance, (_) => _advance());
  }

  void _advance() {
    if (!_controller.hasClients || widget.banners.length < 2) return;
    final next = (_page + 1) % widget.banners.length;
    _controller.animateToPage(
      next,
      duration: AppMotion.effective(context, AppMotion.bannerSlide),
      curve: AppMotion.standard,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: BannerCarousel.height,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.banners.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (_, i) => _BannerTile(widget.banners[i]),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _Dots(count: widget.banners.length, active: _page),
      ],
    );
  }
}

class _BannerTile extends StatelessWidget {
  const _BannerTile(this.banner);

  final PromoBanner banner;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Stack(
          fit: StackFit.expand,
          children: [
            JdImage(banner.imageUrl),
            Positioned(
              left: AppSpacing.md,
              bottom: AppSpacing.sm,
              child: Text(
                banner.title,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textOnPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.active});

  final int count;
  final int active;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: AppMotion.base,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == active ? 18 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i == active ? AppColors.accent : AppColors.skeletonBase,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),
      ],
    );
  }
}
