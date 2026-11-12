import 'package:drift/drift.dart';

/// Table definitions. Row classes get a `Row` suffix so the domain models
/// (`Product`, `Shop`, ...) keep the clean names.
@DataClassName('ProductRow')
class Products extends Table {
  TextColumn get id => text()();
  TextColumn get code => text()();
  TextColumn get name => text()();
  IntColumn get priceMmk => integer()();
  BoolColumn get isNew => boolean().withDefault(const Constant(false))();
  IntColumn get discountPercent => integer().nullable()();
  TextColumn get imageUrl => text()();
  TextColumn get description => text()();

  /// `seasonal`, `popular` or `orderAgain`. One section per product so a
  /// product image Hero tag is unique on the Home screen.
  TextColumn get section => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('BannerRow')
class Banners extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get imageUrl => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ShopRow')
class Shops extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get address => text()();
  TextColumn get imageUrl => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// The single member record shared by Home and Rewards.
@DataClassName('MemberRow')
class Members extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get avatarAsset => text()();
  TextColumn get tier => text()();
  IntColumn get totalPoints => integer()();
  IntColumn get pointsToNextTier => integer()();
  TextColumn get nextTier => text()();
  IntColumn get notificationCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Small key/value store for data metadata (e.g. the imported catalog version).
@DataClassName('KeyValueRow')
class KeyValues extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
