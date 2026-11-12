import '../result.dart';
import 'catalog_snapshot.dart';

/// Where catalog data comes from. Today: the bundled seed JSON, playing the
/// part of a remote. Swapping in an HTTP source means implementing this one
/// method; nothing above the data layer changes.
abstract interface class CatalogSource {
  Future<Result<CatalogSnapshot>> fetch();
}
