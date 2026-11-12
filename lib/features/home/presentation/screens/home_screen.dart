import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/widgets/entrance.dart';
import '../../../../core/connectivity/connectivity_providers.dart';
import '../../../../core/db/database_providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../product/domain/product.dart';
import '../../application/home_providers.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/header_shield.dart';
import '../widgets/member_header.dart';
import '../widgets/offline_banner.dart';
import '../widgets/product_section.dart';
import '../widgets/shops_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(reconnectRefreshProvider);
    final offline = ref.watch(onlineProvider).value == false;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        // The peach header panel paints behind the status bar itself.
        top: false,
        bottom: false,
        child: Column(
          children: [
            if (offline) const SafeArea(bottom: false, child: OfflineBanner()),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _refresh(context, ref),
                child: ListView(
                  // Zero padding: the shops landscape owns the bottom inset
                  // so it runs under the nav bar, as in the design screens.
                  padding: EdgeInsets.zero,
                  children: [
                    for (final (i, section) in _sections(l10n).indexed)
                      StaggeredEntrance(index: i, child: section),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _sections(AppLocalizations l10n) => [
    const _HeaderPanel(),
    ProductSectionView(
      section: ProductSection.seasonal,
      title: l10n.seasonalSpecials,
    ),
    ProductSectionView(
      section: ProductSection.popular,
      title: l10n.popularSection,
    ),
    ProductSectionView(
      section: ProductSection.orderAgain,
      title: l10n.orderAgain,
    ),
    const ShopsSection(),
  ];

  /// Pull-to-refresh: re-reads the (fake) remote; failures keep saved data.
  Future<void> _refresh(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final message = AppLocalizations.of(context)!.refreshFailed;
    final result = await ref.read(catalogSyncProvider).refresh();
    if (!result.isSuccess) {
      messenger.showSnackBar(SnackBar(content: Text(message)));
    }
  }
}

/// Peach panel behind the member header and banners, with the soft shield
/// watermark on the right, as in the design screens.
class _HeaderPanel extends StatelessWidget {
  const _HeaderPanel();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.headerPeach,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppRadius.navBarTop),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(AppRadius.navBarTop),
        ),
        child: Stack(
          children: [
            const Positioned(
              top: 40,
              right: -36,
              child: HeaderShield(size: 230),
            ),
            Column(
              children: [
                SizedBox(height: MediaQuery.paddingOf(context).top),
                const MemberHeader(),
                const BannerCarousel(),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
