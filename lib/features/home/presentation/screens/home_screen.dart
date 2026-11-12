import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/connectivity/connectivity_providers.dart';
import '../../../../core/db/database_providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../product/domain/product.dart';
import '../../application/home_providers.dart';
import '../widgets/banner_carousel.dart';
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
        child: Column(
          children: [
            if (offline) const OfflineBanner(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _refresh(context, ref),
                child: ListView(
                  children: [
                    const MemberHeader(),
                    const BannerCarousel(),
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
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
