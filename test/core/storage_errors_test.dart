import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_test/core/db/storage_errors.dart';
import 'package:jdonuts_test/core/failure.dart';

void main() {
  test('database stream errors arrive as StorageFailure', () async {
    final stream = Stream<int>.error(Exception('database is locked'));

    expect(stream.withStorageFailures(), emitsError(isA<StorageFailure>()));
  });

  test('values pass through unchanged', () async {
    final stream = Stream.fromIterable([1, 2]);

    expect(stream.withStorageFailures(), emitsInOrder([1, 2, emitsDone]));
  });
}
