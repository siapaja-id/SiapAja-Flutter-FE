// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FeedState {

 List<FeedItem> get feedItems; bool get isLoading; int? get lastUpdated; Map<String, List<FeedItem>> get replies;
/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedStateCopyWith<FeedState> get copyWith => _$FeedStateCopyWithImpl<FeedState>(this as FeedState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedState&&const DeepCollectionEquality().equals(other.feedItems, feedItems)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&const DeepCollectionEquality().equals(other.replies, replies));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(feedItems),isLoading,lastUpdated,const DeepCollectionEquality().hash(replies));

@override
String toString() {
  return 'FeedState(feedItems: $feedItems, isLoading: $isLoading, lastUpdated: $lastUpdated, replies: $replies)';
}


}

/// @nodoc
abstract mixin class $FeedStateCopyWith<$Res>  {
  factory $FeedStateCopyWith(FeedState value, $Res Function(FeedState) _then) = _$FeedStateCopyWithImpl;
@useResult
$Res call({
 List<FeedItem> feedItems, bool isLoading, int? lastUpdated, Map<String, List<FeedItem>> replies
});




}
/// @nodoc
class _$FeedStateCopyWithImpl<$Res>
    implements $FeedStateCopyWith<$Res> {
  _$FeedStateCopyWithImpl(this._self, this._then);

  final FeedState _self;
  final $Res Function(FeedState) _then;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? feedItems = null,Object? isLoading = null,Object? lastUpdated = freezed,Object? replies = null,}) {
  return _then(_self.copyWith(
feedItems: null == feedItems ? _self.feedItems : feedItems // ignore: cast_nullable_to_non_nullable
as List<FeedItem>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as int?,replies: null == replies ? _self.replies : replies // ignore: cast_nullable_to_non_nullable
as Map<String, List<FeedItem>>,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedState].
extension FeedStatePatterns on FeedState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedState value)  $default,){
final _that = this;
switch (_that) {
case _FeedState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedState value)?  $default,){
final _that = this;
switch (_that) {
case _FeedState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<FeedItem> feedItems,  bool isLoading,  int? lastUpdated,  Map<String, List<FeedItem>> replies)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedState() when $default != null:
return $default(_that.feedItems,_that.isLoading,_that.lastUpdated,_that.replies);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<FeedItem> feedItems,  bool isLoading,  int? lastUpdated,  Map<String, List<FeedItem>> replies)  $default,) {final _that = this;
switch (_that) {
case _FeedState():
return $default(_that.feedItems,_that.isLoading,_that.lastUpdated,_that.replies);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<FeedItem> feedItems,  bool isLoading,  int? lastUpdated,  Map<String, List<FeedItem>> replies)?  $default,) {final _that = this;
switch (_that) {
case _FeedState() when $default != null:
return $default(_that.feedItems,_that.isLoading,_that.lastUpdated,_that.replies);case _:
  return null;

}
}

}

/// @nodoc


class _FeedState implements FeedState {
  const _FeedState({required final  List<FeedItem> feedItems, this.isLoading = false, this.lastUpdated, final  Map<String, List<FeedItem>> replies = const {}}): _feedItems = feedItems,_replies = replies;
  

 final  List<FeedItem> _feedItems;
@override List<FeedItem> get feedItems {
  if (_feedItems is EqualUnmodifiableListView) return _feedItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_feedItems);
}

@override@JsonKey() final  bool isLoading;
@override final  int? lastUpdated;
 final  Map<String, List<FeedItem>> _replies;
@override@JsonKey() Map<String, List<FeedItem>> get replies {
  if (_replies is EqualUnmodifiableMapView) return _replies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_replies);
}


/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedStateCopyWith<_FeedState> get copyWith => __$FeedStateCopyWithImpl<_FeedState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedState&&const DeepCollectionEquality().equals(other._feedItems, _feedItems)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&const DeepCollectionEquality().equals(other._replies, _replies));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_feedItems),isLoading,lastUpdated,const DeepCollectionEquality().hash(_replies));

@override
String toString() {
  return 'FeedState(feedItems: $feedItems, isLoading: $isLoading, lastUpdated: $lastUpdated, replies: $replies)';
}


}

/// @nodoc
abstract mixin class _$FeedStateCopyWith<$Res> implements $FeedStateCopyWith<$Res> {
  factory _$FeedStateCopyWith(_FeedState value, $Res Function(_FeedState) _then) = __$FeedStateCopyWithImpl;
@override @useResult
$Res call({
 List<FeedItem> feedItems, bool isLoading, int? lastUpdated, Map<String, List<FeedItem>> replies
});




}
/// @nodoc
class __$FeedStateCopyWithImpl<$Res>
    implements _$FeedStateCopyWith<$Res> {
  __$FeedStateCopyWithImpl(this._self, this._then);

  final _FeedState _self;
  final $Res Function(_FeedState) _then;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? feedItems = null,Object? isLoading = null,Object? lastUpdated = freezed,Object? replies = null,}) {
  return _then(_FeedState(
feedItems: null == feedItems ? _self._feedItems : feedItems // ignore: cast_nullable_to_non_nullable
as List<FeedItem>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as int?,replies: null == replies ? _self._replies : replies // ignore: cast_nullable_to_non_nullable
as Map<String, List<FeedItem>>,
  ));
}


}

// dart format on
