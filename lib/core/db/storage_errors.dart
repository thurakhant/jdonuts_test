import 'dart:async';

import '../failure.dart';

extension StorageErrors<T> on Stream<T> {
  /// Database errors reach the UI as a typed [StorageFailure], so every
  /// section's error state shows the storage message.
  Stream<T> withStorageFailures() => transform(
    StreamTransformer<T, T>.fromHandlers(
      handleError: (_, stackTrace, sink) =>
          sink.addError(const StorageFailure(), stackTrace),
    ),
  );
}
