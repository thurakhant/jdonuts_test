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
import '../../../../core/result.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/validators/date_of_birth_validator.dart';
import '../providers/registration_flow_provider.dart';
import '../providers/registration_flow_state.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/failure_messages.dart';
import '../widgets/month_field.dart';

const int _dayDigits = 2;
const int _yearDigits = 4;

class DobScreen extends ConsumerStatefulWidget {
  const DobScreen({super.key});

  @override
  ConsumerState<DobScreen> createState() => _DobScreenState();
}

class _DobScreenState extends ConsumerState<DobScreen> {
  late final TextEditingController _day;
  late final TextEditingController _year;
  Failure? _serverFailure;

  @override
  void initState() {
    super.initState();
    final flow = ref.read(registrationFlowProvider);
    _day = TextEditingController(text: flow.day);
    _year = TextEditingController(text: flow.year);
  }

  @override
  void dispose() {
    _day.dispose();
    _year.dispose();
    super.dispose();
  }

  Result<DateTime> _result(RegistrationFlowState flow) => validateDateOfBirth(
    month: flow.month,
    day: int.tryParse(flow.day),
    year: int.tryParse(flow.year),
  );

  void _changed({int? month}) {
    ref
        .read(registrationFlowProvider.notifier)
        .setDob(month: month, day: _day.text, year: _year.text);
    setState(() => _serverFailure = null);
  }

  Future<void> _continue() async {
    final failure = await ref
        .read(registrationFlowProvider.notifier)
        .completeRegistration();
    if (!mounted) return;
    if (failure == null) {
      context.go(AppRoutes.welcome);
    } else {
      setState(() => _serverFailure = failure);
    }
  }

  /// Shows a rule message only once all three parts are filled in.
  Failure? _visibleFailure(RegistrationFlowState flow, Result<DateTime> r) {
    if (_serverFailure != null) return _serverFailure;
    final failure = r.failureOrNull;
    final incomplete =
        failure is InvalidDateOfBirth &&
        failure.problem == DateOfBirthProblem.incomplete;
    return incomplete ? null : failure;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final flow = ref.watch(registrationFlowProvider);
    final result = _result(flow);
    final failure = _visibleFailure(flow, result);
    return AuthScaffold(
      step: AuthStep.dob,
      title: l10n.whatsYourDateOfBirth,
      complete: result.isSuccess,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MonthField(
            month: flow.month,
            onPicked: (m) => _changed(month: m),
          ),
          const SizedBox(height: AppSpacing.md),
          _numberField('dob-day', _day, l10n.day, _dayDigits),
          const SizedBox(height: AppSpacing.md),
          _numberField('dob-year', _year, l10n.year, _yearDigits),
          if (failure != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Text(
                failureMessage(l10n, failure),
                style: AppTypography.caption.copyWith(color: AppColors.error),
              ),
            ),
        ],
      ),
      action: LoadingButton(
        label: l10n.continueLabel,
        onPressed: result.isSuccess ? _continue : null,
      ),
    );
  }

  Widget _numberField(
    String key,
    TextEditingController controller,
    String hint,
    int maxDigits,
  ) {
    return TextField(
      key: ValueKey(key),
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(maxDigits),
      ],
      onChanged: (_) => _changed(),
      decoration: InputDecoration(hintText: hint),
    );
  }
}
