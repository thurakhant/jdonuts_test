import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../../../../app/motion/app_motion.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';

/// "Didn't receive the code?" plus a pink countdown that becomes a Resend
/// link at 0:00. [onResend] returns once the new code is sent; the timer
/// then restarts.
class ResendRow extends StatefulWidget {
  const ResendRow({required this.onResend, super.key});

  final Future<void> Function() onResend;

  @override
  State<ResendRow> createState() => _ResendRowState();
}

class _ResendRowState extends State<ResendRow> {
  Duration _left = AppMotion.resendCountdown;
  Timer? _timer;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _left = AppMotion.resendCountdown);
    _timer = Timer.periodic(AppMotion.resendTick, (t) {
      if (_left <= AppMotion.resendTick) {
        t.cancel();
        setState(() => _left = Duration.zero);
      } else {
        setState(() => _left -= AppMotion.resendTick);
      }
    });
  }

  Future<void> _resend() async {
    if (_sending) return;
    setState(() => _sending = true);
    await widget.onResend();
    if (!mounted) return;
    setState(() => _sending = false);
    _startTimer();
  }

  String get _clock {
    final m = _left.inMinutes;
    final s = (_left.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const link = TextStyle(
      color: AppColors.accent,
      fontWeight: FontWeight.w700,
    );
    return Column(
      children: [
        Text(l10n.didntReceiveCode, style: AppTypography.body),
        if (_left > Duration.zero)
          Text(l10n.resendIn(_clock), style: AppTypography.body.merge(link))
        else
          TextButton(
            onPressed: _sending ? null : _resend,
            child: Text(l10n.resendActive, style: link),
          ),
      ],
    );
  }
}
