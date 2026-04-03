// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gig.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Gig {

 String get id; String get title; GigType get type; String get distance; String get time; String get price; String get description; TaskIconType get iconType; String? get meta; List<String> get tags; String get clientName; double get clientRating;
/// Create a copy of Gig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GigCopyWith<Gig> get copyWith => _$GigCopyWithImpl<Gig>(this as Gig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Gig&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.time, time) || other.time == time)&&(identical(other.price, price) || other.price == price)&&(identical(other.description, description) || other.description == description)&&(identical(other.iconType, iconType) || other.iconType == iconType)&&(identical(other.meta, meta) || other.meta == meta)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.clientRating, clientRating) || other.clientRating == clientRating));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,type,distance,time,price,description,iconType,meta,const DeepCollectionEquality().hash(tags),clientName,clientRating);

@override
String toString() {
  return 'Gig(id: $id, title: $title, type: $type, distance: $distance, time: $time, price: $price, description: $description, iconType: $iconType, meta: $meta, tags: $tags, clientName: $clientName, clientRating: $clientRating)';
}


}

/// @nodoc
abstract mixin class $GigCopyWith<$Res>  {
  factory $GigCopyWith(Gig value, $Res Function(Gig) _then) = _$GigCopyWithImpl;
@useResult
$Res call({
 String id, String title, GigType type, String distance, String time, String price, String description, TaskIconType iconType, String? meta, List<String> tags, String clientName, double clientRating
});




}
/// @nodoc
class _$GigCopyWithImpl<$Res>
    implements $GigCopyWith<$Res> {
  _$GigCopyWithImpl(this._self, this._then);

  final Gig _self;
  final $Res Function(Gig) _then;

/// Create a copy of Gig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? type = null,Object? distance = null,Object? time = null,Object? price = null,Object? description = null,Object? iconType = null,Object? meta = freezed,Object? tags = null,Object? clientName = null,Object? clientRating = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as GigType,distance: null == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,iconType: null == iconType ? _self.iconType : iconType // ignore: cast_nullable_to_non_nullable
as TaskIconType,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,clientName: null == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String,clientRating: null == clientRating ? _self.clientRating : clientRating // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [Gig].
extension GigPatterns on Gig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Gig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Gig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Gig value)  $default,){
final _that = this;
switch (_that) {
case _Gig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Gig value)?  $default,){
final _that = this;
switch (_that) {
case _Gig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  GigType type,  String distance,  String time,  String price,  String description,  TaskIconType iconType,  String? meta,  List<String> tags,  String clientName,  double clientRating)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Gig() when $default != null:
return $default(_that.id,_that.title,_that.type,_that.distance,_that.time,_that.price,_that.description,_that.iconType,_that.meta,_that.tags,_that.clientName,_that.clientRating);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  GigType type,  String distance,  String time,  String price,  String description,  TaskIconType iconType,  String? meta,  List<String> tags,  String clientName,  double clientRating)  $default,) {final _that = this;
switch (_that) {
case _Gig():
return $default(_that.id,_that.title,_that.type,_that.distance,_that.time,_that.price,_that.description,_that.iconType,_that.meta,_that.tags,_that.clientName,_that.clientRating);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  GigType type,  String distance,  String time,  String price,  String description,  TaskIconType iconType,  String? meta,  List<String> tags,  String clientName,  double clientRating)?  $default,) {final _that = this;
switch (_that) {
case _Gig() when $default != null:
return $default(_that.id,_that.title,_that.type,_that.distance,_that.time,_that.price,_that.description,_that.iconType,_that.meta,_that.tags,_that.clientName,_that.clientRating);case _:
  return null;

}
}

}

/// @nodoc


class _Gig implements Gig {
  const _Gig({required this.id, required this.title, required this.type, required this.distance, required this.time, required this.price, required this.description, required this.iconType, this.meta, required final  List<String> tags, required this.clientName, required this.clientRating}): _tags = tags;
  

@override final  String id;
@override final  String title;
@override final  GigType type;
@override final  String distance;
@override final  String time;
@override final  String price;
@override final  String description;
@override final  TaskIconType iconType;
@override final  String? meta;
 final  List<String> _tags;
@override List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  String clientName;
@override final  double clientRating;

/// Create a copy of Gig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GigCopyWith<_Gig> get copyWith => __$GigCopyWithImpl<_Gig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Gig&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.time, time) || other.time == time)&&(identical(other.price, price) || other.price == price)&&(identical(other.description, description) || other.description == description)&&(identical(other.iconType, iconType) || other.iconType == iconType)&&(identical(other.meta, meta) || other.meta == meta)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.clientRating, clientRating) || other.clientRating == clientRating));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,type,distance,time,price,description,iconType,meta,const DeepCollectionEquality().hash(_tags),clientName,clientRating);

@override
String toString() {
  return 'Gig(id: $id, title: $title, type: $type, distance: $distance, time: $time, price: $price, description: $description, iconType: $iconType, meta: $meta, tags: $tags, clientName: $clientName, clientRating: $clientRating)';
}


}

/// @nodoc
abstract mixin class _$GigCopyWith<$Res> implements $GigCopyWith<$Res> {
  factory _$GigCopyWith(_Gig value, $Res Function(_Gig) _then) = __$GigCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, GigType type, String distance, String time, String price, String description, TaskIconType iconType, String? meta, List<String> tags, String clientName, double clientRating
});




}
/// @nodoc
class __$GigCopyWithImpl<$Res>
    implements _$GigCopyWith<$Res> {
  __$GigCopyWithImpl(this._self, this._then);

  final _Gig _self;
  final $Res Function(_Gig) _then;

/// Create a copy of Gig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? type = null,Object? distance = null,Object? time = null,Object? price = null,Object? description = null,Object? iconType = null,Object? meta = freezed,Object? tags = null,Object? clientName = null,Object? clientRating = null,}) {
  return _then(_Gig(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as GigType,distance: null == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,iconType: null == iconType ? _self.iconType : iconType // ignore: cast_nullable_to_non_nullable
as TaskIconType,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,clientName: null == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String,clientRating: null == clientRating ? _self.clientRating : clientRating // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
