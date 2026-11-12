import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_test/core/db/app_database.dart';

void main() {
  test('v3 -> v4 adds tier progress and asks for a seed re-import', () async {
    // A schema-v3 install: members without tier_progress, catalog imported.
    final db = AppDatabase(
      NativeDatabase.memory(
        setup: (raw) {
          raw
            ..execute('''
              CREATE TABLE members (
                id TEXT NOT NULL PRIMARY KEY,
                name TEXT NOT NULL,
                avatar_asset TEXT NOT NULL,
                tier TEXT NOT NULL,
                total_points INTEGER NOT NULL,
                points_to_next_tier INTEGER NOT NULL,
                next_tier TEXT NOT NULL,
                notification_count INTEGER NOT NULL DEFAULT 0
              )''')
            ..execute(
              'CREATE TABLE key_values '
              '(key TEXT NOT NULL PRIMARY KEY, value TEXT NOT NULL)',
            )
            ..execute(
              "INSERT INTO members VALUES "
              "('member-1', 'Hania', 'a.png', 'Silver', 680000, 500, 'Gold', 2)",
            )
            ..execute(
              "INSERT INTO key_values VALUES ('$kCatalogVersionKey', '2')",
            )
            ..execute('PRAGMA user_version = 3');
        },
      ),
    );
    addTearDown(db.close);

    final member = await db.select(db.members).getSingle();
    expect(member.name, 'Hania');
    expect(member.tierProgress, 0);
    final version = await (db.select(
      db.keyValues,
    )..where((t) => t.key.equals(kCatalogVersionKey))).getSingleOrNull();
    expect(version, isNull);
  });
}
