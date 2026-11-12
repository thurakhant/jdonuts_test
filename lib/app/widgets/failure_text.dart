import '../../core/failure.dart';
import '../../l10n/app_localizations.dart';

/// Friendly sentence for a data-layer error (or anything unexpected).
String dataErrorMessage(AppLocalizations l10n, Object error) {
  return switch (error) {
    MalformedCatalog() => l10n.errorCatalogMalformed,
    CatalogUnavailable() => l10n.errorCatalogUnavailable,
    StorageFailure() => l10n.errorStorage,
    _ => l10n.errorGeneric,
  };
}
