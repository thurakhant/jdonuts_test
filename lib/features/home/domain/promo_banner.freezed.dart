// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'promo_banner.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PromoBanner {

 String get id; String get title; String get imageUrl;/// Short pill label over the title ("New shop"); null when absent.
 String? get badge;
/// Create a copy of PromoBanner
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromoBannerCopyWith<PromoBanner> get copyWith => _$PromoBannerCopyWithImpl<PromoBanner>(this as PromoBanner, _$identity);

  /// Serializes this PromoBanner to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PromoBanner;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromoBanner&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&(identical(other.badge, _this.badge) || other.badge == _this.badge));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PromoBanner;
  return Object.hash(runtimeType,_this.id,_this.title,_this.imageUrl,_this.badge);
}

@override
String toString() {
  final _this = this as PromoBanner;
  return 'PromoBanner(id: ${_this.id}, title: ${_this.title}, imageUrl: ${_this.imageUrl}, badge: ${_this.badge})';
}


}

/// @nodoc
abstract mixin class $PromoBannerCopyWith<$Res>  {
  factory $PromoBannerCopyWith(PromoBanner value, $Res Function(PromoBanner) _then) = _$PromoBannerCopyWithImpl;
@useResult
$Res call({
 String id, String title, String imageUrl, String? badge
});




}
/// @nodoc
class _$PromoBannerCopyWithImpl<$Res>
    implements $PromoBannerCopyWith<$Res> {
  _$PromoBannerCopyWithImpl(this._self, this._then);

  final PromoBanner _self;
  final $Res Function(PromoBanner) _then;

/// Create a copy of PromoBanner
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? imageUrl = null,Object? badge = freezed,}) {
  return _then(PromoBanner(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,badge: freezed == badge ? _self.badge : badge // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PromoBanner].
extension PromoBannerPatterns on PromoBanner {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PromoBanner value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PromoBanner() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PromoBanner value)  $default,){
final _that = this;
switch (_that) {
case _PromoBanner():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PromoBanner value)?  $default,){
final _that = this;
switch (_that) {
case _PromoBanner() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String imageUrl,  String? badge)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PromoBanner() when $default != null:
return $default(_that.id,_that.title,_that.imageUrl,_that.badge);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String imageUrl,  String? badge)  $default,) {final _that = this;
switch (_that) {
case _PromoBanner():
return $default(_that.id,_that.title,_that.imageUrl,_that.badge);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String imageUrl,  String? badge)?  $default,) {final _that = this;
switch (_that) {
case _PromoBanner() when $default != null:
return $default(_that.id,_that.title,_that.imageUrl,_that.badge);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PromoBanner implements PromoBanner {
  const _PromoBanner({required this.id, required this.title, required this.imageUrl, this.badge});
  factory _PromoBanner.fromJson(Map<String, dynamic> json) => _$PromoBannerFromJson(json);

@override final  String id;
@override final  String title;
@override final  String imageUrl;
/// Short pill label over the title ("New shop"); null when absent.
@override final  String? badge;

/// Create a copy of PromoBanner
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromoBannerCopyWith<_PromoBanner> get copyWith => __$PromoBannerCopyWithImpl<_PromoBanner>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PromoBannerToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PromoBanner&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.badge, badge) || other.badge == badge));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,imageUrl,badge);
}

@override
String toString() {
    return 'PromoBanner(id: $id, title: $title, imageUrl: $imageUrl, badge: $badge)';
}


}

/// @nodoc
abstract mixin class _$PromoBannerCopyWith<$Res> implements $PromoBannerCopyWith<$Res> {
  factory _$PromoBannerCopyWith(_PromoBanner value, $Res Function(_PromoBanner) _then) = __$PromoBannerCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String imageUrl, String? badge
});




}
/// @nodoc
class __$PromoBannerCopyWithImpl<$Res>
    implements _$PromoBannerCopyWith<$Res> {
  __$PromoBannerCopyWithImpl(this._self, this._then);

  final _PromoBanner _self;
  final $Res Function(_PromoBanner) _then;

/// Create a copy of PromoBanner
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? imageUrl = null,Object? badge = freezed,}) {
  return _then(_PromoBanner(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,badge: freezed == badge ? _self.badge : badge // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
