import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_test/core/catalog/catalog_snapshot.dart';
import 'package:jdonuts_test/core/catalog/catalog_source.dart';
import 'package:jdonuts_test/core/result.dart';
import 'package:jdonuts_test/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

import 'data_overrides.dart';

/// A source that counts fetches and can be told to fail or hang.
class CountingSource implements CatalogSource {
  CountingSource(this.inner);

  final CatalogSource inner;
  int fetches = 0;

  @override
  Future<Result<CatalogSnapshot>> fetch() {
    fetches++;
    return inner.fetch();
  }
}

/// Pumps [home] inside a localized MaterialApp on a tall test surface.
Future<ProviderContainer> pumpScreen(
  WidgetTester tester,
  Widget home, {
  Stream<bool>? online,
  CatalogSource? source,
}) async {
  tester.view.physicalSize = const Size(1200, 4000);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  final overrides = dataOverrides(online: online, source: source);
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: home,
      ),
    ),
  );
  return ProviderScope.containerOf(tester.element(find.byType(MaterialApp)));
}
