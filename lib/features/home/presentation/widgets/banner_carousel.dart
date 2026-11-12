import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/motion/app_motion.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/failure_text.dart';
import '../../../../app/widgets/jd_image.dart';
import '../../../../app/widgets/orange_badge.dart';
import '../../../../app/widgets/section_message.dart';
import '../../../../app/widgets/skeleton.dart';
import '../../../../core/db/database_providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/home_providers.dart';
import '../../domain/promo_banner.dart';

class BannerCarousel extends ConsumerWidget {
  const BannerCarousel({super.key});

  static const double height = 215;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return ref
        .watch(bannersProvider)
        .when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
            child: SkeletonBox(height: height, radius: AppRadius.lg),
          ),
          error: (error, _) => SectionMessage(
            message: '${l10n.sectionError} ${dataErrorMessage(l10n, error)}',
            onRetry: () {
              ref.invalidate(catalogReadyProvider);
              ref.invalidate(bannersProvider);
            },
          ),
          data: (banners) => banners.isEmpty
              ? SectionMessage(message: l10n.sectionEmpty)
              : _BannerPager(banners),
        );
  }
}

class _BannerPager extends StatefulWidget {
  const _BannerPager(this.banners);

  final List<PromoBanner> banners;

  @override
  State<_BannerPager> createState() => _BannerPagerState();
}

class _BannerPagerState extends State<_BannerPager> {
  // Narrow enough that a slice of the next card shows, as in the design.
  final _controller = PageController(viewportFraction: 0.78);
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
            padEnds: false,
            itemCount: widget.banners.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (_, i) => _BannerTile(widget.banners[i], index: i),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _PageIndicators(count: widget.banners.length, active: _page),
      ],
    );
  }
}

/// Composed promo card from the design screens: colored background with dash
/// doodles, badge pill, centered white title, and the photo inset at the
/// bottom with a small round shop logo overlapping its top edge.
class _BannerTile extends StatelessWidget {
  const _BannerTile(this.banner, {required this.index});

  final PromoBanner banner;
  final int index;

  static const _palette = [
    AppColors.bannerPurple,
    AppColors.primary,
    AppColors.accent,
  ];

  @override
  Widget build(BuildContext context) {
    final badge = banner.badge;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: ClipRRect(
        // Square bottom-left corner, as in the design screens.
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppRadius.lg),
          topRight: Radius.circular(AppRadius.lg),
          bottomRight: Radius.circular(AppRadius.lg),
        ),
        child: ColoredBox(
          color: _palette[index % _palette.length],
          child: Stack(
            fit: StackFit.expand,
            children: [
              ExcludeSemantics(
                child: CustomPaint(painter: _DoodlePainter(seed: index)),
              ),
              Column(
                children: [
                  const SizedBox(height: AppSpacing.sm),
                  if (badge != null) OrangeBadge(badge),
                  const SizedBox(height: AppSpacing.xs),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl + AppSpacing.md,
                    ),
                    child: Text(
                      banner.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.headline.copyWith(
                        color: AppColors.textOnPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 21,
                        height: 1.25,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xxl,
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(AppRadius.md),
                              ),
                              child: JdImage(
                                banner.imageUrl,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          const Positioned(
                            top: -14,
                            left: 0,
                            right: 0,
                            child: Center(child: _LogoChip()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small white circle with the shop mark, overlapping the photo's top edge.
class _LogoChip extends StatelessWidget {
  const _LogoChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.storefront, size: 16, color: AppColors.accent),
    );
  }
}

/// Rounded dash doodles behind the banner text, like the mock's sprinkles.
/// Deterministic per banner so pages don't shimmer.
class _DoodlePainter extends CustomPainter {
  const _DoodlePainter({required this.seed});

  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textOnPrimary.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 16; i++) {
      final n = (seed * 7 + i * 13) % 17;
      final x = size.width * ((n * 5 + i * 23) % 97) / 97;
      final y = size.height * ((n * 11 + i * 41) % 89) / 89;
      final angle = (n % 4) * 0.7 - 1.0;
      final length = 11.0 + (n % 3) * 7;
      if (i.isEven) {
        // Long straight dash.
        final d = Offset.fromDirection(angle, length);
        canvas.drawLine(Offset(x, y) - d, Offset(x, y) + d, paint);
      } else {
        // Gently curved dash, like the mock's macaroni strokes.
        canvas.drawArc(
          Rect.fromCircle(center: Offset(x, y), radius: length),
          angle,
          1.1,
          false,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_DoodlePainter oldDelegate) => oldDelegate.seed != seed;
}

class _PageIndicators extends StatelessWidget {
  const _PageIndicators({required this.count, required this.active});

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
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.dotGap),
            width: i == active ? AppSpacing.dotActiveWidth : AppSpacing.dotSize,
            height: AppSpacing.dotSize,
            decoration: BoxDecoration(
              color: i == active ? AppColors.accent : AppColors.skeletonBase,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),
      ],
    );
  }
}
