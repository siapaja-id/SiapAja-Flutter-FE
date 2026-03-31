// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kanban_column.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$KanbanColumn {

 String get id; String get path; double get width; Map<String, dynamic>? get routeState; int? get activeTab;
/// Create a copy of KanbanColumn
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanbanColumnCopyWith<KanbanColumn> get copyWith => _$KanbanColumnCopyWithImpl<KanbanColumn>(this as KanbanColumn, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanbanColumn&&(identical(other.id, id) || other.id == id)&&(identical(other.path, path) || other.path == path)&&(identical(other.width, width) || other.width == width)&&const DeepCollectionEquality().equals(other.routeState, routeState)&&(identical(other.activeTab, activeTab) || other.activeTab == activeTab));
}


@override
int get hashCode => Object.hash(runtimeType,id,path,width,const DeepCollectionEquality().hash(routeState),activeTab);

@override
String toString() {
  return 'KanbanColumn(id: $id, path: $path, width: $width, routeState: $routeState, activeTab: $activeTab)';
}


}

/// @nodoc
abstract mixin class $KanbanColumnCopyWith<$Res>  {
  factory $KanbanColumnCopyWith(KanbanColumn value, $Res Function(KanbanColumn) _then) = _$KanbanColumnCopyWithImpl;
@useResult
$Res call({
 String id, String path, double width, Map<String, dynamic>? routeState, int? activeTab
});




}
/// @nodoc
class _$KanbanColumnCopyWithImpl<$Res>
    implements $KanbanColumnCopyWith<$Res> {
  _$KanbanColumnCopyWithImpl(this._self, this._then);

  final KanbanColumn _self;
  final $Res Function(KanbanColumn) _then;

/// Create a copy of KanbanColumn
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? path = null,Object? width = null,Object? routeState = freezed,Object? activeTab = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,routeState: freezed == routeState ? _self.routeState : routeState // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,activeTab: freezed == activeTab ? _self.activeTab : activeTab // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [KanbanColumn].
extension KanbanColumnPatterns on KanbanColumn {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanbanColumn value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanbanColumn() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanbanColumn value)  $default,){
final _that = this;
switch (_that) {
case _KanbanColumn():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanbanColumn value)?  $default,){
final _that = this;
switch (_that) {
case _KanbanColumn() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String path,  double width,  Map<String, dynamic>? routeState,  int? activeTab)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KanbanColumn() when $default != null:
return $default(_that.id,_that.path,_that.width,_that.routeState,_that.activeTab);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String path,  double width,  Map<String, dynamic>? routeState,  int? activeTab)  $default,) {final _that = this;
switch (_that) {
case _KanbanColumn():
return $default(_that.id,_that.path,_that.width,_that.routeState,_that.activeTab);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String path,  double width,  Map<String, dynamic>? routeState,  int? activeTab)?  $default,) {final _that = this;
switch (_that) {
case _KanbanColumn() when $default != null:
return $default(_that.id,_that.path,_that.width,_that.routeState,_that.activeTab);case _:
  return null;

}
}

}

/// @nodoc


class _KanbanColumn implements KanbanColumn {
  const _KanbanColumn({required this.id, required this.path, this.width = 420, final  Map<String, dynamic>? routeState, this.activeTab}): _routeState = routeState;
  

@override final  String id;
@override final  String path;
@override@JsonKey() final  double width;
 final  Map<String, dynamic>? _routeState;
@override Map<String, dynamic>? get routeState {
  final value = _routeState;
  if (value == null) return null;
  if (_routeState is EqualUnmodifiableMapView) return _routeState;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  int? activeTab;

/// Create a copy of KanbanColumn
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanbanColumnCopyWith<_KanbanColumn> get copyWith => __$KanbanColumnCopyWithImpl<_KanbanColumn>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanbanColumn&&(identical(other.id, id) || other.id == id)&&(identical(other.path, path) || other.path == path)&&(identical(other.width, width) || other.width == width)&&const DeepCollectionEquality().equals(other._routeState, _routeState)&&(identical(other.activeTab, activeTab) || other.activeTab == activeTab));
}


@override
int get hashCode => Object.hash(runtimeType,id,path,width,const DeepCollectionEquality().hash(_routeState),activeTab);

@override
String toString() {
  return 'KanbanColumn(id: $id, path: $path, width: $width, routeState: $routeState, activeTab: $activeTab)';
}


}

/// @nodoc
abstract mixin class _$KanbanColumnCopyWith<$Res> implements $KanbanColumnCopyWith<$Res> {
  factory _$KanbanColumnCopyWith(_KanbanColumn value, $Res Function(_KanbanColumn) _then) = __$KanbanColumnCopyWithImpl;
@override @useResult
$Res call({
 String id, String path, double width, Map<String, dynamic>? routeState, int? activeTab
});




}
/// @nodoc
class __$KanbanColumnCopyWithImpl<$Res>
    implements _$KanbanColumnCopyWith<$Res> {
  __$KanbanColumnCopyWithImpl(this._self, this._then);

  final _KanbanColumn _self;
  final $Res Function(_KanbanColumn) _then;

/// Create a copy of KanbanColumn
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? path = null,Object? width = null,Object? routeState = freezed,Object? activeTab = freezed,}) {
  return _then(_KanbanColumn(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,routeState: freezed == routeState ? _self._routeState : routeState // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,activeTab: freezed == activeTab ? _self.activeTab : activeTab // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
