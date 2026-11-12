import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../providers/registration_flow_state.dart';
import 'step_ring.dart';

/// Shared frame for Phone, OTP, Name and DOB: back circle top-left,
/// progress ring top-right, title, body and a bottom action.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    required this.step,
    required this.title,
    required this.body,
    required this.action,
    this.complete = false,
    super.key,
  });

  final AuthStep step;
  final String title;
  final Widget body;
  final Widget action;
  final bool complete;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPink,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenEdge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _BackCircle(),
                  StepRing(step: step, complete: complete),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(title, style: AppTypography.display),
              const SizedBox(height: AppSpacing.lg),
              Expanded(child: SingleChildScrollView(child: body)),
              action,
            ],
          ),
        ),
      ),
    );
  }
}

class _BackCircle extends StatelessWidget {
  const _BackCircle();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: const CircleBorder(),
      child: IconButton(
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => context.canPop() ? context.pop() : null,
      ),
    );
  }
}
