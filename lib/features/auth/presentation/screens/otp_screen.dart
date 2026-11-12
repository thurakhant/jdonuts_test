import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/failure.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/registration_flow_provider.dart';
import '../providers/registration_flow_state.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/failure_messages.dart';
import '../widgets/otp_boxes.dart';
import '../widgets/resend_row.dart';
import '../widgets/shake.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _boxes = GlobalKey<OtpBoxesState>();
  Failure? _failure;
  bool _verifying = false;
  int _shakes = 0;

  bool get _locked => _failure is OtpLocked;

  Future<void> _verify(String code) async {
    if (_verifying) return;
    setState(() => _verifying = true);
    final failure = await ref
        .read(registrationFlowProvider.notifier)
        .verifyOtp(code);
    if (!mounted) return;
    setState(() {
      _verifying = false;
      _failure = failure;
      if (failure != null) _shakes++;
    });
    if (failure == null) {
      _onVerified();
    } else {
      _clearBoxes();
    }
  }

  /// Boxes are disabled while verifying, so clear after the next frame.
  void _clearBoxes() => WidgetsBinding.instance.addPostFrameCallback(
    (_) => _boxes.currentState?.clear(),
  );

  void _onVerified() {
    // Login: the session is now published and the router leaves the flow.
    if (ref.read(registrationFlowProvider).isRegister) {
      context.push(AppRoutes.name);
    }
  }

  Future<void> _resend() async {
    final failure = await ref
        .read(registrationFlowProvider.notifier)
        .resendOtp();
    if (!mounted) return;
    setState(() => _failure = failure);
    _clearBoxes();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final phone = ref.watch(registrationFlowProvider).phone ?? '';
    return AuthScaffold(
      step: AuthStep.otp,
      title: l10n.verifyYourNumber,
      action: const SizedBox.shrink(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.otpSentTo(phone), style: AppTypography.body),
          const SizedBox(height: AppSpacing.lg),
          Shake(
            trigger: _shakes,
            child: OtpBoxes(
              key: _boxes,
              enabled: !_locked && !_verifying,
              hasError: _failure != null,
              onCompleted: _verify,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (_failure case final failure?)
            Text(
              failureMessage(l10n, failure),
              textAlign: TextAlign.center,
              style: AppTypography.caption.copyWith(color: AppColors.error),
            ),
          const SizedBox(height: AppSpacing.lg),
          ResendRow(onResend: _resend),
        ],
      ),
    );
  }
}
