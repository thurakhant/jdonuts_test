// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shop.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Shop {

 String get id; String get name; String get address; String get imageUrl;
/// Create a copy of Shop
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShopCopyWith<Shop> get copyWith => _$ShopCopyWithImpl<Shop>(this as Shop, _$identity);

  /// Serializes this Shop to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Shop;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Shop&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Shop;
  return Object.hash(runtimeType,_this.id,_this.name,_this.address,_this.imageUrl);
}

@override
String toString() {
  final _this = this as Shop;
  return 'Shop(id: ${_this.id}, name: ${_this.name}, address: ${_this.address}, imageUrl: ${_this.imageUrl})';
}


}

/// @nodoc
abstract mixin class $ShopCopyWith<$Res>  {
  factory $ShopCopyWith(Shop value, $Res Function(Shop) _then) = _$ShopCopyWithImpl;
@useResult
$Res call({
 String id, String name, String address, String imageUrl
});




}
/// @nodoc
class _$ShopCopyWithImpl<$Res>
    implements $ShopCopyWith<$Res> {
  _$ShopCopyWithImpl(this._self, this._then);

  final Shop _self;
  final $Res Function(Shop) _then;

/// Create a copy of Shop
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? address = null,Object? imageUrl = null,}) {
  return _then(Shop(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Shop].
extension ShopPatterns on Shop {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Shop value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Shop() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Shop value)  $default,){
final _that = this;
switch (_that) {
case _Shop():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Shop value)?  $default,){
final _that = this;
switch (_that) {
case _Shop() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String address,  String imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Shop() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String address,  String imageUrl)  $default,) {final _that = this;
switch (_that) {
case _Shop():
return $default(_that.id,_that.name,_that.address,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String address,  String imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _Shop() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Shop implements Shop {
  const _Shop({required this.id, required this.name, required this.address, required this.imageUrl});
  factory _Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);

@override final  String id;
@override final  String name;
@override final  String address;
@override final  String imageUrl;

/// Create a copy of Shop
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShopCopyWith<_Shop> get copyWith => __$ShopCopyWithImpl<_Shop>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShopToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Shop&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,address,imageUrl);
}

@override
String toString() {
    return 'Shop(id: $id, name: $name, address: $address, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$ShopCopyWith<$Res> implements $ShopCopyWith<$Res> {
  factory _$ShopCopyWith(_Shop value, $Res Function(_Shop) _then) = __$ShopCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String address, String imageUrl
});




}
/// @nodoc
class __$ShopCopyWithImpl<$Res>
    implements _$ShopCopyWith<$Res> {
  __$ShopCopyWithImpl(this._self, this._then);

  final _Shop _self;
  final $Res Function(_Shop) _then;

/// Create a copy of Shop
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? address = null,Object? imageUrl = null,}) {
  return _then(_Shop(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
