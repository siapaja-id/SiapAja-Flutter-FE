// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kanban_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$KanbanState {

 List<KanbanColumn> get columns; bool get isDesktop;
/// Create a copy of KanbanState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanbanStateCopyWith<KanbanState> get copyWith => _$KanbanStateCopyWithImpl<KanbanState>(this as KanbanState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanbanState&&const DeepCollectionEquality().equals(other.columns, columns)&&(identical(other.isDesktop, isDesktop) || other.isDesktop == isDesktop));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(columns),isDesktop);

@override
String toString() {
  return 'KanbanState(columns: $columns, isDesktop: $isDesktop)';
}


}

/// @nodoc
abstract mixin class $KanbanStateCopyWith<$Res>  {
  factory $KanbanStateCopyWith(KanbanState value, $Res Function(KanbanState) _then) = _$KanbanStateCopyWithImpl;
@useResult
$Res call({
 List<KanbanColumn> columns, bool isDesktop
});




}
/// @nodoc
class _$KanbanStateCopyWithImpl<$Res>
    implements $KanbanStateCopyWith<$Res> {
  _$KanbanStateCopyWithImpl(this._self, this._then);

  final KanbanState _self;
  final $Res Function(KanbanState) _then;

/// Create a copy of KanbanState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? columns = null,Object? isDesktop = null,}) {
  return _then(_self.copyWith(
columns: null == columns ? _self.columns : columns // ignore: cast_nullable_to_non_nullable
as List<KanbanColumn>,isDesktop: null == isDesktop ? _self.isDesktop : isDesktop // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [KanbanState].
extension KanbanStatePatterns on KanbanState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanbanState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanbanState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanbanState value)  $default,){
final _that = this;
switch (_that) {
case _KanbanState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanbanState value)?  $default,){
final _that = this;
switch (_that) {
case _KanbanState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<KanbanColumn> columns,  bool isDesktop)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KanbanState() when $default != null:
return $default(_that.columns,_that.isDesktop);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<KanbanColumn> columns,  bool isDesktop)  $default,) {final _that = this;
switch (_that) {
case _KanbanState():
return $default(_that.columns,_that.isDesktop);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<KanbanColumn> columns,  bool isDesktop)?  $default,) {final _that = this;
switch (_that) {
case _KanbanState() when $default != null:
return $default(_that.columns,_that.isDesktop);case _:
  return null;

}
}

}

/// @nodoc


class _KanbanState implements KanbanState {
  const _KanbanState({required final  List<KanbanColumn> columns, this.isDesktop = false}): _columns = columns;
  

 final  List<KanbanColumn> _columns;
@override List<KanbanColumn> get columns {
  if (_columns is EqualUnmodifiableListView) return _columns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_columns);
}

@override@JsonKey() final  bool isDesktop;

/// Create a copy of KanbanState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanbanStateCopyWith<_KanbanState> get copyWith => __$KanbanStateCopyWithImpl<_KanbanState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanbanState&&const DeepCollectionEquality().equals(other._columns, _columns)&&(identical(other.isDesktop, isDesktop) || other.isDesktop == isDesktop));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_columns),isDesktop);

@override
String toString() {
  return 'KanbanState(columns: $columns, isDesktop: $isDesktop)';
}


}

/// @nodoc
abstract mixin class _$KanbanStateCopyWith<$Res> implements $KanbanStateCopyWith<$Res> {
  factory _$KanbanStateCopyWith(_KanbanState value, $Res Function(_KanbanState) _then) = __$KanbanStateCopyWithImpl;
@override @useResult
$Res call({
 List<KanbanColumn> columns, bool isDesktop
});




}
/// @nodoc
class __$KanbanStateCopyWithImpl<$Res>
    implements _$KanbanStateCopyWith<$Res> {
  __$KanbanStateCopyWithImpl(this._self, this._then);

  final _KanbanState _self;
  final $Res Function(_KanbanState) _then;

/// Create a copy of KanbanState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? columns = null,Object? isDesktop = null,}) {
  return _then(_KanbanState(
columns: null == columns ? _self._columns : columns // ignore: cast_nullable_to_non_nullable
as List<KanbanColumn>,isDesktop: null == isDesktop ? _self.isDesktop : isDesktop // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
