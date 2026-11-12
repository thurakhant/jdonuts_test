import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/widgets/loading_button.dart';
import '../../../../core/result.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/validators/name_validator.dart';
import '../providers/registration_flow_provider.dart';
import '../providers/registration_flow_state.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/failure_messages.dart';

class NameScreen extends ConsumerStatefulWidget {
  const NameScreen({super.key});

  @override
  ConsumerState<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends ConsumerState<NameScreen> {
  late final TextEditingController _first;
  late final TextEditingController _last;
  final FocusNode _firstFocus = FocusNode();
  final FocusNode _lastFocus = FocusNode();
  bool _firstTouched = false;
  bool _lastTouched = false;

  @override
  void initState() {
    super.initState();
    final flow = ref.read(registrationFlowProvider);
    _first = TextEditingController(text: flow.firstName);
    _last = TextEditingController(text: flow.lastName);
    _firstFocus.addListener(() {
      if (!_firstFocus.hasFocus) setState(() => _firstTouched = true);
    });
    _lastFocus.addListener(() {
      if (!_lastFocus.hasFocus) setState(() => _lastTouched = true);
    });
  }

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    _firstFocus.dispose();
    _lastFocus.dispose();
    super.dispose();
  }

  Result<String> get _firstResult => validateFirstName(_first.text);
  Result<String> get _lastResult => validateLastName(_last.text);
  bool get _valid => _firstResult.isSuccess && _lastResult.isSuccess;

  void _onChanged(String _) {
    ref
        .read(registrationFlowProvider.notifier)
        .setName(first: _first.text, last: _last.text);
    setState(() {});
  }

  Future<void> _continue() async => context.push(AppRoutes.dob);

  String? _error(AppLocalizations l10n, bool touched, Result<String> r) {
    final failure = r.failureOrNull;
    return touched && failure != null ? failureMessage(l10n, failure) : null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final saved = ref.watch(registrationFlowProvider).accountCreated;
    return AuthScaffold(
      step: AuthStep.name,
      title: l10n.whatsYourName,
      body: Column(
        children: [
          if (saved) Text(l10n.registrationSavedRetry),
          TextField(
            key: const ValueKey('first-name'),
            readOnly: saved,
            controller: _first,
            focusNode: _firstFocus,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            onChanged: _onChanged,
            decoration: InputDecoration(
              hintText: l10n.firstName,
              errorText: _error(l10n, _firstTouched, _firstResult),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            key: const ValueKey('last-name'),
            readOnly: saved,
            controller: _last,
            focusNode: _lastFocus,
            textCapitalization: TextCapitalization.words,
            onChanged: _onChanged,
            decoration: InputDecoration(
              hintText: l10n.lastName,
              errorText: _error(l10n, _lastTouched, _lastResult),
            ),
          ),
        ],
      ),
      action: LoadingButton(
        label: l10n.continueLabel,
        onPressed: _valid ? _continue : null,
      ),
    );
  }
}
