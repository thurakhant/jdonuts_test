// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CatalogSnapshot {

 int get version; List<Product> get products; List<PromoBanner> get banners; List<Shop> get shops; Member get member;/// Null when the payload has no challenges section (older payloads):
/// saved challenges are kept. An empty list clears them.
 List<Challenge>? get challenges;
/// Create a copy of CatalogSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogSnapshotCopyWith<CatalogSnapshot> get copyWith => _$CatalogSnapshotCopyWithImpl<CatalogSnapshot>(this as CatalogSnapshot, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CatalogSnapshot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogSnapshot&&(identical(other.version, _this.version) || other.version == _this.version)&&const DeepCollectionEquality().equals(other.products, _this.products)&&const DeepCollectionEquality().equals(other.banners, _this.banners)&&const DeepCollectionEquality().equals(other.shops, _this.shops)&&(identical(other.member, _this.member) || other.member == _this.member)&&const DeepCollectionEquality().equals(other.challenges, _this.challenges));
}


@override
int get hashCode {
  final _this = this as CatalogSnapshot;
  return Object.hash(runtimeType,_this.version,const DeepCollectionEquality().hash(_this.products),const DeepCollectionEquality().hash(_this.banners),const DeepCollectionEquality().hash(_this.shops),_this.member,const DeepCollectionEquality().hash(_this.challenges));
}

@override
String toString() {
  final _this = this as CatalogSnapshot;
  return 'CatalogSnapshot(version: ${_this.version}, products: ${_this.products}, banners: ${_this.banners}, shops: ${_this.shops}, member: ${_this.member}, challenges: ${_this.challenges})';
}


}

/// @nodoc
abstract mixin class $CatalogSnapshotCopyWith<$Res>  {
  factory $CatalogSnapshotCopyWith(CatalogSnapshot value, $Res Function(CatalogSnapshot) _then) = _$CatalogSnapshotCopyWithImpl;
@useResult
$Res call({
 int version, List<Product> products, List<PromoBanner> banners, List<Shop> shops, Member member, List<Challenge>? challenges
});


$MemberCopyWith<$Res> get member;

}
/// @nodoc
class _$CatalogSnapshotCopyWithImpl<$Res>
    implements $CatalogSnapshotCopyWith<$Res> {
  _$CatalogSnapshotCopyWithImpl(this._self, this._then);

  final CatalogSnapshot _self;
  final $Res Function(CatalogSnapshot) _then;

/// Create a copy of CatalogSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? products = null,Object? banners = null,Object? shops = null,Object? member = null,Object? challenges = freezed,}) {
  return _then(CatalogSnapshot(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,banners: null == banners ? _self.banners : banners // ignore: cast_nullable_to_non_nullable
as List<PromoBanner>,shops: null == shops ? _self.shops : shops // ignore: cast_nullable_to_non_nullable
as List<Shop>,member: null == member ? _self.member : member // ignore: cast_nullable_to_non_nullable
as Member,challenges: freezed == challenges ? _self.challenges : challenges // ignore: cast_nullable_to_non_nullable
as List<Challenge>?,
  ));
}
/// Create a copy of CatalogSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemberCopyWith<$Res> get member {
  
  return $MemberCopyWith<$Res>(_self.member, (value) {
    return _then(_self.copyWith(member: value));
  });
}
}


/// Adds pattern-matching-related methods to [CatalogSnapshot].
extension CatalogSnapshotPatterns on CatalogSnapshot {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogSnapshot() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _CatalogSnapshot():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogSnapshot() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int version,  List<Product> products,  List<PromoBanner> banners,  List<Shop> shops,  Member member,  List<Challenge>? challenges)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogSnapshot() when $default != null:
return $default(_that.version,_that.products,_that.banners,_that.shops,_that.member,_that.challenges);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int version,  List<Product> products,  List<PromoBanner> banners,  List<Shop> shops,  Member member,  List<Challenge>? challenges)  $default,) {final _that = this;
switch (_that) {
case _CatalogSnapshot():
return $default(_that.version,_that.products,_that.banners,_that.shops,_that.member,_that.challenges);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int version,  List<Product> products,  List<PromoBanner> banners,  List<Shop> shops,  Member member,  List<Challenge>? challenges)?  $default,) {final _that = this;
switch (_that) {
case _CatalogSnapshot() when $default != null:
return $default(_that.version,_that.products,_that.banners,_that.shops,_that.member,_that.challenges);case _:
  return null;

}
}

}

/// @nodoc


class _CatalogSnapshot implements CatalogSnapshot {
  const _CatalogSnapshot({required this.version, required  List<Product> products, required  List<PromoBanner> banners, required  List<Shop> shops, required this.member, required  List<Challenge>? challenges}): _products = products,_banners = banners,_shops = shops,_challenges = challenges;
  

@override final  int version;
 final  List<Product> _products;
@override List<Product> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

 final  List<PromoBanner> _banners;
@override List<PromoBanner> get banners {
  if (_banners is EqualUnmodifiableListView) return _banners;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_banners);
}

 final  List<Shop> _shops;
@override List<Shop> get shops {
  if (_shops is EqualUnmodifiableListView) return _shops;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_shops);
}

@override final  Member member;
/// Null when the payload has no challenges section (older payloads):
/// saved challenges are kept. An empty list clears them.
 final  List<Challenge>? _challenges;
/// Null when the payload has no challenges section (older payloads):
/// saved challenges are kept. An empty list clears them.
@override List<Challenge>? get challenges {
  final value = _challenges;
  if (value == null) return null;
  if (_challenges is EqualUnmodifiableListView) return _challenges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of CatalogSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogSnapshotCopyWith<_CatalogSnapshot> get copyWith => __$CatalogSnapshotCopyWithImpl<_CatalogSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogSnapshot&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.products, _products)&&const DeepCollectionEquality().equals(other.banners, _banners)&&const DeepCollectionEquality().equals(other.shops, _shops)&&(identical(other.member, member) || other.member == member)&&const DeepCollectionEquality().equals(other.challenges, _challenges));
}


@override
int get hashCode {
    return Object.hash(runtimeType,version,const DeepCollectionEquality().hash(_products),const DeepCollectionEquality().hash(_banners),const DeepCollectionEquality().hash(_shops),member,const DeepCollectionEquality().hash(_challenges));
}

@override
String toString() {
    return 'CatalogSnapshot(version: $version, products: $products, banners: $banners, shops: $shops, member: $member, challenges: $challenges)';
}


}

/// @nodoc
abstract mixin class _$CatalogSnapshotCopyWith<$Res> implements $CatalogSnapshotCopyWith<$Res> {
  factory _$CatalogSnapshotCopyWith(_CatalogSnapshot value, $Res Function(_CatalogSnapshot) _then) = __$CatalogSnapshotCopyWithImpl;
@override @useResult
$Res call({
 int version, List<Product> products, List<PromoBanner> banners, List<Shop> shops, Member member, List<Challenge>? challenges
});


@override $MemberCopyWith<$Res> get member;

}
/// @nodoc
class __$CatalogSnapshotCopyWithImpl<$Res>
    implements _$CatalogSnapshotCopyWith<$Res> {
  __$CatalogSnapshotCopyWithImpl(this._self, this._then);

  final _CatalogSnapshot _self;
  final $Res Function(_CatalogSnapshot) _then;

/// Create a copy of CatalogSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? products = null,Object? banners = null,Object? shops = null,Object? member = null,Object? challenges = freezed,}) {
  return _then(_CatalogSnapshot(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,banners: null == banners ? _self._banners : banners // ignore: cast_nullable_to_non_nullable
as List<PromoBanner>,shops: null == shops ? _self._shops : shops // ignore: cast_nullable_to_non_nullable
as List<Shop>,member: null == member ? _self.member : member // ignore: cast_nullable_to_non_nullable
as Member,challenges: freezed == challenges ? _self._challenges : challenges // ignore: cast_nullable_to_non_nullable
as List<Challenge>?,
  ));
}

/// Create a copy of CatalogSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemberCopyWith<$Res> get member {
  
  return $MemberCopyWith<$Res>(_self.member, (value) {
    return _then(_self.copyWith(member: value));
  });
}
}

// dart format on
