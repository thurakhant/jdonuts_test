// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Product {

 String get id; String get code; String get name; int get priceMmk; bool get isNew; int? get discountPercent;/// An `assets/...` path or an http(s) URL; see `JdImage`.
 String get imageUrl; String get description; ProductSection get section;/// Position in its Home list; set from the catalog order, not the JSON.
@JsonKey(includeFromJson: false, includeToJson: false) int get sortOrder;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Product;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.priceMmk, _this.priceMmk) || other.priceMmk == _this.priceMmk)&&(identical(other.isNew, _this.isNew) || other.isNew == _this.isNew)&&(identical(other.discountPercent, _this.discountPercent) || other.discountPercent == _this.discountPercent)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.section, _this.section) || other.section == _this.section)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Product;
  return Object.hash(runtimeType,_this.id,_this.code,_this.name,_this.priceMmk,_this.isNew,_this.discountPercent,_this.imageUrl,_this.description,_this.section,_this.sortOrder);
}

@override
String toString() {
  final _this = this as Product;
  return 'Product(id: ${_this.id}, code: ${_this.code}, name: ${_this.name}, priceMmk: ${_this.priceMmk}, isNew: ${_this.isNew}, discountPercent: ${_this.discountPercent}, imageUrl: ${_this.imageUrl}, description: ${_this.description}, section: ${_this.section}, sortOrder: ${_this.sortOrder})';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 String id, String code, String name, int priceMmk, bool isNew, int? discountPercent, String imageUrl, String description, ProductSection section,@JsonKey(includeFromJson: false, includeToJson: false) int sortOrder
});




}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? priceMmk = null,Object? isNew = null,Object? discountPercent = freezed,Object? imageUrl = null,Object? description = null,Object? section = null,Object? sortOrder = null,}) {
  return _then(Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceMmk: null == priceMmk ? _self.priceMmk : priceMmk // ignore: cast_nullable_to_non_nullable
as int,isNew: null == isNew ? _self.isNew : isNew // ignore: cast_nullable_to_non_nullable
as bool,discountPercent: freezed == discountPercent ? _self.discountPercent : discountPercent // ignore: cast_nullable_to_non_nullable
as int?,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,section: null == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as ProductSection,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String name,  int priceMmk,  bool isNew,  int? discountPercent,  String imageUrl,  String description,  ProductSection section, @JsonKey(includeFromJson: false, includeToJson: false)  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.priceMmk,_that.isNew,_that.discountPercent,_that.imageUrl,_that.description,_that.section,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String name,  int priceMmk,  bool isNew,  int? discountPercent,  String imageUrl,  String description,  ProductSection section, @JsonKey(includeFromJson: false, includeToJson: false)  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.code,_that.name,_that.priceMmk,_that.isNew,_that.discountPercent,_that.imageUrl,_that.description,_that.section,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String name,  int priceMmk,  bool isNew,  int? discountPercent,  String imageUrl,  String description,  ProductSection section, @JsonKey(includeFromJson: false, includeToJson: false)  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.priceMmk,_that.isNew,_that.discountPercent,_that.imageUrl,_that.description,_that.section,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Product implements Product {
  const _Product({required this.id, required this.code, required this.name, required this.priceMmk, required this.isNew, required this.discountPercent, required this.imageUrl, required this.description, required this.section, @JsonKey(includeFromJson: false, includeToJson: false) this.sortOrder = 0});
  factory _Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

@override final  String id;
@override final  String code;
@override final  String name;
@override final  int priceMmk;
@override final  bool isNew;
@override final  int? discountPercent;
/// An `assets/...` path or an http(s) URL; see `JdImage`.
@override final  String imageUrl;
@override final  String description;
@override final  ProductSection section;
/// Position in its Home list; set from the catalog order, not the JSON.
@override@JsonKey(includeFromJson: false, includeToJson: false) final  int sortOrder;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.priceMmk, priceMmk) || other.priceMmk == priceMmk)&&(identical(other.isNew, isNew) || other.isNew == isNew)&&(identical(other.discountPercent, discountPercent) || other.discountPercent == discountPercent)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.section, section) || other.section == section)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,name,priceMmk,isNew,discountPercent,imageUrl,description,section,sortOrder);
}

@override
String toString() {
    return 'Product(id: $id, code: $code, name: $name, priceMmk: $priceMmk, isNew: $isNew, discountPercent: $discountPercent, imageUrl: $imageUrl, description: $description, section: $section, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String name, int priceMmk, bool isNew, int? discountPercent, String imageUrl, String description, ProductSection section,@JsonKey(includeFromJson: false, includeToJson: false) int sortOrder
});




}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? priceMmk = null,Object? isNew = null,Object? discountPercent = freezed,Object? imageUrl = null,Object? description = null,Object? section = null,Object? sortOrder = null,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceMmk: null == priceMmk ? _self.priceMmk : priceMmk // ignore: cast_nullable_to_non_nullable
as int,isNew: null == isNew ? _self.isNew : isNew // ignore: cast_nullable_to_non_nullable
as bool,discountPercent: freezed == discountPercent ? _self.discountPercent : discountPercent // ignore: cast_nullable_to_non_nullable
as int?,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,section: null == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as ProductSection,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
