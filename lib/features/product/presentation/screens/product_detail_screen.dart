import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/widgets/failure_text.dart';
import '../../../../core/db/database_providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/product_providers.dart';
import '../../domain/product.dart';
import '../widgets/product_detail_body.dart';

/// `/home/product/:id`. Handles loading, error and "no such product".
class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({required this.productId, this.initial, super.key});

  final String productId;

  /// The product the Home tile already has. Showing it on the first frame
  /// gives the Hero flight a destination; the DB stream takes over after.
  final Product? initial;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final product = ref.watch(productByIdProvider(productId));
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          tooltip: l10n.backLabel,
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(AppRoutes.home),
        ),
      ),
      body: product.when(
        loading: () => initial == null
            ? const ProductDetailSkeleton()
            : ProductDetailBody(product: initial!),
        error: (error, _) => _Message(
          dataErrorMessage(l10n, error),
          onRetry: () {
            ref.invalidate(catalogReadyProvider);
            ref.invalidate(productByIdProvider(productId));
          },
        ),
        data: (p) => p == null
            ? _Message(l10n.productNotFound)
            : ProductDetailBody(product: p),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message(this.text, {this.onRetry});

  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenEdge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, textAlign: TextAlign.center),
            if (onRetry != null)
              TextButton(
                onPressed: onRetry,
                child: Text(AppLocalizations.of(context)!.retry),
              ),
          ],
        ),
      ),
    );
  }
}
