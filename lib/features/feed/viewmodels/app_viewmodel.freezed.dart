// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UiState {

 int get activeTab; Author? get currentUser; bool get headerVisible; bool get bottomNavVisible; Gig? get activeGig; List<Gig> get queuedGigs; bool get isAutoPilot;
/// Create a copy of UiState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UiStateCopyWith<UiState> get copyWith => _$UiStateCopyWithImpl<UiState>(this as UiState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UiState&&(identical(other.activeTab, activeTab) || other.activeTab == activeTab)&&(identical(other.currentUser, currentUser) || other.currentUser == currentUser)&&(identical(other.headerVisible, headerVisible) || other.headerVisible == headerVisible)&&(identical(other.bottomNavVisible, bottomNavVisible) || other.bottomNavVisible == bottomNavVisible)&&(identical(other.activeGig, activeGig) || other.activeGig == activeGig)&&const DeepCollectionEquality().equals(other.queuedGigs, queuedGigs)&&(identical(other.isAutoPilot, isAutoPilot) || other.isAutoPilot == isAutoPilot));
}


@override
int get hashCode => Object.hash(runtimeType,activeTab,currentUser,headerVisible,bottomNavVisible,activeGig,const DeepCollectionEquality().hash(queuedGigs),isAutoPilot);

@override
String toString() {
  return 'UiState(activeTab: $activeTab, currentUser: $currentUser, headerVisible: $headerVisible, bottomNavVisible: $bottomNavVisible, activeGig: $activeGig, queuedGigs: $queuedGigs, isAutoPilot: $isAutoPilot)';
}


}

/// @nodoc
abstract mixin class $UiStateCopyWith<$Res>  {
  factory $UiStateCopyWith(UiState value, $Res Function(UiState) _then) = _$UiStateCopyWithImpl;
@useResult
$Res call({
 int activeTab, Author? currentUser, bool headerVisible, bool bottomNavVisible, Gig? activeGig, List<Gig> queuedGigs, bool isAutoPilot
});


$AuthorCopyWith<$Res>? get currentUser;$GigCopyWith<$Res>? get activeGig;

}
/// @nodoc
class _$UiStateCopyWithImpl<$Res>
    implements $UiStateCopyWith<$Res> {
  _$UiStateCopyWithImpl(this._self, this._then);

  final UiState _self;
  final $Res Function(UiState) _then;

/// Create a copy of UiState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activeTab = null,Object? currentUser = freezed,Object? headerVisible = null,Object? bottomNavVisible = null,Object? activeGig = freezed,Object? queuedGigs = null,Object? isAutoPilot = null,}) {
  return _then(_self.copyWith(
activeTab: null == activeTab ? _self.activeTab : activeTab // ignore: cast_nullable_to_non_nullable
as int,currentUser: freezed == currentUser ? _self.currentUser : currentUser // ignore: cast_nullable_to_non_nullable
as Author?,headerVisible: null == headerVisible ? _self.headerVisible : headerVisible // ignore: cast_nullable_to_non_nullable
as bool,bottomNavVisible: null == bottomNavVisible ? _self.bottomNavVisible : bottomNavVisible // ignore: cast_nullable_to_non_nullable
as bool,activeGig: freezed == activeGig ? _self.activeGig : activeGig // ignore: cast_nullable_to_non_nullable
as Gig?,queuedGigs: null == queuedGigs ? _self.queuedGigs : queuedGigs // ignore: cast_nullable_to_non_nullable
as List<Gig>,isAutoPilot: null == isAutoPilot ? _self.isAutoPilot : isAutoPilot // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of UiState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthorCopyWith<$Res>? get currentUser {
    if (_self.currentUser == null) {
    return null;
  }

  return $AuthorCopyWith<$Res>(_self.currentUser!, (value) {
    return _then(_self.copyWith(currentUser: value));
  });
}/// Create a copy of UiState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GigCopyWith<$Res>? get activeGig {
    if (_self.activeGig == null) {
    return null;
  }

  return $GigCopyWith<$Res>(_self.activeGig!, (value) {
    return _then(_self.copyWith(activeGig: value));
  });
}
}


/// Adds pattern-matching-related methods to [UiState].
extension UiStatePatterns on UiState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UiState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UiState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UiState value)  $default,){
final _that = this;
switch (_that) {
case _UiState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UiState value)?  $default,){
final _that = this;
switch (_that) {
case _UiState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int activeTab,  Author? currentUser,  bool headerVisible,  bool bottomNavVisible,  Gig? activeGig,  List<Gig> queuedGigs,  bool isAutoPilot)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UiState() when $default != null:
return $default(_that.activeTab,_that.currentUser,_that.headerVisible,_that.bottomNavVisible,_that.activeGig,_that.queuedGigs,_that.isAutoPilot);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int activeTab,  Author? currentUser,  bool headerVisible,  bool bottomNavVisible,  Gig? activeGig,  List<Gig> queuedGigs,  bool isAutoPilot)  $default,) {final _that = this;
switch (_that) {
case _UiState():
return $default(_that.activeTab,_that.currentUser,_that.headerVisible,_that.bottomNavVisible,_that.activeGig,_that.queuedGigs,_that.isAutoPilot);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int activeTab,  Author? currentUser,  bool headerVisible,  bool bottomNavVisible,  Gig? activeGig,  List<Gig> queuedGigs,  bool isAutoPilot)?  $default,) {final _that = this;
switch (_that) {
case _UiState() when $default != null:
return $default(_that.activeTab,_that.currentUser,_that.headerVisible,_that.bottomNavVisible,_that.activeGig,_that.queuedGigs,_that.isAutoPilot);case _:
  return null;

}
}

}

/// @nodoc


class _UiState implements UiState {
  const _UiState({this.activeTab = 0, this.currentUser, this.headerVisible = true, this.bottomNavVisible = true, this.activeGig, final  List<Gig> queuedGigs = const [], this.isAutoPilot = false}): _queuedGigs = queuedGigs;
  

@override@JsonKey() final  int activeTab;
@override final  Author? currentUser;
@override@JsonKey() final  bool headerVisible;
@override@JsonKey() final  bool bottomNavVisible;
@override final  Gig? activeGig;
 final  List<Gig> _queuedGigs;
@override@JsonKey() List<Gig> get queuedGigs {
  if (_queuedGigs is EqualUnmodifiableListView) return _queuedGigs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_queuedGigs);
}

@override@JsonKey() final  bool isAutoPilot;

/// Create a copy of UiState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UiStateCopyWith<_UiState> get copyWith => __$UiStateCopyWithImpl<_UiState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UiState&&(identical(other.activeTab, activeTab) || other.activeTab == activeTab)&&(identical(other.currentUser, currentUser) || other.currentUser == currentUser)&&(identical(other.headerVisible, headerVisible) || other.headerVisible == headerVisible)&&(identical(other.bottomNavVisible, bottomNavVisible) || other.bottomNavVisible == bottomNavVisible)&&(identical(other.activeGig, activeGig) || other.activeGig == activeGig)&&const DeepCollectionEquality().equals(other._queuedGigs, _queuedGigs)&&(identical(other.isAutoPilot, isAutoPilot) || other.isAutoPilot == isAutoPilot));
}


@override
int get hashCode => Object.hash(runtimeType,activeTab,currentUser,headerVisible,bottomNavVisible,activeGig,const DeepCollectionEquality().hash(_queuedGigs),isAutoPilot);

@override
String toString() {
  return 'UiState(activeTab: $activeTab, currentUser: $currentUser, headerVisible: $headerVisible, bottomNavVisible: $bottomNavVisible, activeGig: $activeGig, queuedGigs: $queuedGigs, isAutoPilot: $isAutoPilot)';
}


}

/// @nodoc
abstract mixin class _$UiStateCopyWith<$Res> implements $UiStateCopyWith<$Res> {
  factory _$UiStateCopyWith(_UiState value, $Res Function(_UiState) _then) = __$UiStateCopyWithImpl;
@override @useResult
$Res call({
 int activeTab, Author? currentUser, bool headerVisible, bool bottomNavVisible, Gig? activeGig, List<Gig> queuedGigs, bool isAutoPilot
});


@override $AuthorCopyWith<$Res>? get currentUser;@override $GigCopyWith<$Res>? get activeGig;

}
/// @nodoc
class __$UiStateCopyWithImpl<$Res>
    implements _$UiStateCopyWith<$Res> {
  __$UiStateCopyWithImpl(this._self, this._then);

  final _UiState _self;
  final $Res Function(_UiState) _then;

/// Create a copy of UiState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activeTab = null,Object? currentUser = freezed,Object? headerVisible = null,Object? bottomNavVisible = null,Object? activeGig = freezed,Object? queuedGigs = null,Object? isAutoPilot = null,}) {
  return _then(_UiState(
activeTab: null == activeTab ? _self.activeTab : activeTab // ignore: cast_nullable_to_non_nullable
as int,currentUser: freezed == currentUser ? _self.currentUser : currentUser // ignore: cast_nullable_to_non_nullable
as Author?,headerVisible: null == headerVisible ? _self.headerVisible : headerVisible // ignore: cast_nullable_to_non_nullable
as bool,bottomNavVisible: null == bottomNavVisible ? _self.bottomNavVisible : bottomNavVisible // ignore: cast_nullable_to_non_nullable
as bool,activeGig: freezed == activeGig ? _self.activeGig : activeGig // ignore: cast_nullable_to_non_nullable
as Gig?,queuedGigs: null == queuedGigs ? _self._queuedGigs : queuedGigs // ignore: cast_nullable_to_non_nullable
as List<Gig>,isAutoPilot: null == isAutoPilot ? _self.isAutoPilot : isAutoPilot // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of UiState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthorCopyWith<$Res>? get currentUser {
    if (_self.currentUser == null) {
    return null;
  }

  return $AuthorCopyWith<$Res>(_self.currentUser!, (value) {
    return _then(_self.copyWith(currentUser: value));
  });
}/// Create a copy of UiState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GigCopyWith<$Res>? get activeGig {
    if (_self.activeGig == null) {
    return null;
  }

  return $GigCopyWith<$Res>(_self.activeGig!, (value) {
    return _then(_self.copyWith(activeGig: value));
  });
}
}

// dart format on
