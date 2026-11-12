import 'failure.dart';

/// Outcome of an operation: either a value or a typed [Failure].
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;

  /// The value when successful, otherwise null.
  T? get valueOrNull => switch (this) {
    Success<T>(:final value) => value,
    FailureResult<T>() => null,
  };

  /// The failure when unsuccessful, otherwise null.
  Failure? get failureOrNull => switch (this) {
    Success<T>() => null,
    FailureResult<T>(:final failure) => failure,
  };
}

final class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}

final class FailureResult<T> extends Result<T> {
  const FailureResult(this.failure);
  final Failure failure;
}
