import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_test/features/auth/presentation/widgets/otp_boxes.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('a pasted 6-digit code fills all boxes and completes once', (
    tester,
  ) async {
    final completed = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: OtpBoxes(onCompleted: completed.add)),
      ),
    );
    await tester.enterText(find.byKey(const ValueKey('otp-box-0')), '987654');
    await tester.pump();
    final digits = [
      for (var i = 0; i < 6; i++)
        tester
            .widget<TextField>(find.byKey(ValueKey('otp-box-$i')))
            .controller!
            .text,
    ];
    expect(digits, ['9', '8', '7', '6', '5', '4']);
    expect(completed, ['987654']);
  });
}
