import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/loading_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/registration_flow_provider.dart';
import '../providers/registration_flow_state.dart';
import '../widgets/linked_text.dart';
import '../widgets/onboarding_collage.dart';
import '../widgets/placeholder_sheet.dart';
import '../widgets/social_buttons.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  void _start(BuildContext context, WidgetRef ref, AuthMode mode) {
    ref.read(registrationFlowProvider.notifier).start(mode);
    context.push(AppRoutes.phone);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    void sheet() => showPlaceholderSheet(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundPink,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenEdge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Expanded(child: OnboardingCollage()),
              Text(
                l10n.onboardingTitle,
                style: AppTypography.display,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              LoadingButton(
                label: l10n.letsGetStarted,
                onPressed: () async => _start(context, ref, AuthMode.register),
              ),
              const SizedBox(height: AppSpacing.md),
              LinkedText(
                template: '${l10n.alreadyHaveAccount} ${kLinkMarkers[0]}',
                links: [
                  LinkSpec(
                    l10n.logIn,
                    () => _start(context, ref, AuthMode.login),
                  ),
                ],
                style: AppTypography.body,
              ),
              const SizedBox(height: AppSpacing.md),
              const SocialButtons(),
              const SizedBox(height: AppSpacing.md),
              LinkedText(
                template: l10n.legalNotice(kLinkMarkers[0], kLinkMarkers[1]),
                links: [
                  LinkSpec(l10n.termsOfUse, sheet),
                  LinkSpec(l10n.privacyPolicy, sheet),
                ],
                style: AppTypography.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
