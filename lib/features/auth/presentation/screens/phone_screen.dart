import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/loading_button.dart';
import '../../../../core/failure.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/validators/phone_validator.dart';
import '../providers/registration_flow_provider.dart';
import '../providers/registration_flow_state.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/failure_messages.dart';
import '../widgets/linked_text.dart';

class PhoneScreen extends ConsumerStatefulWidget {
  const PhoneScreen({super.key});

  @override
  ConsumerState<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends ConsumerState<PhoneScreen> {
  late final TextEditingController _controller;
  final FocusNode _focus = FocusNode();
  bool _touched = false;
  Failure? _serverFailure;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(registrationFlowProvider).phoneInput,
    );
    _focus.addListener(() {
      if (!_focus.hasFocus) setState(() => _touched = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  bool get _valid => validateMyanmarPhone(_controller.text).isSuccess;

  void _onChanged(String value) {
    ref.read(registrationFlowProvider.notifier).setPhoneInput(value);
    setState(() => _serverFailure = null);
  }

  Future<void> _continue() async {
    final failure = await ref
        .read(registrationFlowProvider.notifier)
        .submitPhone();
    if (!mounted) return;
    if (failure == null) {
      context.push(AppRoutes.otp);
    } else {
      setState(() => _serverFailure = failure);
    }
  }

  void _switchTo(AuthMode mode) {
    ref.read(registrationFlowProvider.notifier).switchMode(mode);
    setState(() => _serverFailure = null);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AuthScaffold(
      step: AuthStep.phone,
      title: l10n.enterYourPhoneNumber,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            focusNode: _focus,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: _onChanged,
            decoration: InputDecoration(
              prefixText: '${l10n.phonePrefixMm}  ',
              prefixStyle: AppTypography.title.copyWith(
                color: AppColors.textSecondary,
              ),
              errorText: _fieldError(l10n),
              errorMaxLines: 2,
            ),
          ),
          _linkedError(l10n),
        ],
      ),
      action: LoadingButton(
        label: l10n.continueLabel,
        onPressed: _valid ? _continue : null,
      ),
    );
  }

  String? _fieldError(AppLocalizations l10n) {
    if (_serverFailure != null) return null;
    if (_touched && !_valid) return failureMessage(l10n, const InvalidPhone());
    return null;
  }

  Widget _linkedError(AppLocalizations l10n) {
    final style = AppTypography.caption.copyWith(color: AppColors.error);
    final padding = const EdgeInsets.only(top: AppSpacing.sm);
    switch (_serverFailure) {
      case UnknownNumber():
        return Padding(
          padding: padding,
          child: LinkedText(
            template: l10n.errorPhoneUnknown(kLinkMarkers[0]),
            links: [
              LinkSpec(l10n.registerLink, () => _switchTo(AuthMode.register)),
            ],
            style: style,
            textAlign: TextAlign.start,
          ),
        );
      case PhoneAlreadyRegistered():
        return Padding(
          padding: padding,
          child: LinkedText(
            template: l10n.errorPhoneTaken(kLinkMarkers[0]),
            links: [LinkSpec(l10n.logInLink, () => _switchTo(AuthMode.login))],
            style: style,
            textAlign: TextAlign.start,
          ),
        );
      case final Failure other:
        return Padding(
          padding: padding,
          child: Text(failureMessage(l10n, other), style: style),
        );
      case null:
        return const SizedBox.shrink();
    }
  }
}
