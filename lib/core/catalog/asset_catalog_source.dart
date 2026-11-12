import 'package:flutter/services.dart' show rootBundle;

import '../failure.dart';
import '../result.dart';
import 'catalog_json.dart';
import 'catalog_snapshot.dart';
import 'catalog_source.dart';

const String kSeedAsset = 'assets/seed/catalog.json';

/// The bundled seed JSON acting as the fake remote. [load] is injectable so
/// tests can feed it any string.
class AssetCatalogSource implements CatalogSource {
  AssetCatalogSource({Future<String> Function()? load})
    : _load = load ?? (() => rootBundle.loadString(kSeedAsset));

  final Future<String> Function() _load;

  @override
  Future<Result<CatalogSnapshot>> fetch() async {
    final String text;
    try {
      text = await _load();
    } on Object {
      return const FailureResult(CatalogUnavailable());
    }
    return parseCatalog(text);
  }
}
