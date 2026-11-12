import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('domain layers import no Flutter, UI, theme or localization code', () {
    final domainFiles = Directory('lib/features')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.contains('/domain/') && f.path.endsWith('.dart'));
    final forbidden = RegExp(
      r"^import '(package:flutter|package:material_ui|.*/app/|.*/l10n/)",
      multiLine: true,
    );
    final offenders = [
      for (final file in domainFiles)
        if (forbidden.hasMatch(file.readAsStringSync())) file.path,
    ];
    expect(domainFiles, isNotEmpty);
    expect(offenders, isEmpty);
  });
}
