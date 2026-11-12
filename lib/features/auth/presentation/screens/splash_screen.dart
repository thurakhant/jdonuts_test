import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';

/// Shown while the stored session is being restored, so signed-in users
/// never see an Onboarding flash.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.backgroundPink,
      body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
    );
  }
}
