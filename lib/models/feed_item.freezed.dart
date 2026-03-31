// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SocialPostData {

 String get id; Author get author; String get timestamp; String get content; List<String>? get images; String? get video; String? get voiceNote; bool? get isBid; String? get bidAmount; BidStatus? get bidStatus; FeedItem? get quote; int? get threadCount; int? get threadIndex; List<String>? get replyAvatars; bool? get isFirstPost; int get replies; int get reposts; int get shares; int get votes;
/// Create a copy of SocialPostData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SocialPostDataCopyWith<SocialPostData> get copyWith => _$SocialPostDataCopyWithImpl<SocialPostData>(this as SocialPostData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SocialPostData&&(identical(other.id, id) || other.id == id)&&(identical(other.author, author) || other.author == author)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other.images, images)&&(identical(other.video, video) || other.video == video)&&(identical(other.voiceNote, voiceNote) || other.voiceNote == voiceNote)&&(identical(other.isBid, isBid) || other.isBid == isBid)&&(identical(other.bidAmount, bidAmount) || other.bidAmount == bidAmount)&&(identical(other.bidStatus, bidStatus) || other.bidStatus == bidStatus)&&(identical(other.quote, quote) || other.quote == quote)&&(identical(other.threadCount, threadCount) || other.threadCount == threadCount)&&(identical(other.threadIndex, threadIndex) || other.threadIndex == threadIndex)&&const DeepCollectionEquality().equals(other.replyAvatars, replyAvatars)&&(identical(other.isFirstPost, isFirstPost) || other.isFirstPost == isFirstPost)&&(identical(other.replies, replies) || other.replies == replies)&&(identical(other.reposts, reposts) || other.reposts == reposts)&&(identical(other.shares, shares) || other.shares == shares)&&(identical(other.votes, votes) || other.votes == votes));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,author,timestamp,content,const DeepCollectionEquality().hash(images),video,voiceNote,isBid,bidAmount,bidStatus,quote,threadCount,threadIndex,const DeepCollectionEquality().hash(replyAvatars),isFirstPost,replies,reposts,shares,votes]);

@override
String toString() {
  return 'SocialPostData(id: $id, author: $author, timestamp: $timestamp, content: $content, images: $images, video: $video, voiceNote: $voiceNote, isBid: $isBid, bidAmount: $bidAmount, bidStatus: $bidStatus, quote: $quote, threadCount: $threadCount, threadIndex: $threadIndex, replyAvatars: $replyAvatars, isFirstPost: $isFirstPost, replies: $replies, reposts: $reposts, shares: $shares, votes: $votes)';
}


}

/// @nodoc
abstract mixin class $SocialPostDataCopyWith<$Res>  {
  factory $SocialPostDataCopyWith(SocialPostData value, $Res Function(SocialPostData) _then) = _$SocialPostDataCopyWithImpl;
@useResult
$Res call({
 String id, Author author, String timestamp, String content, List<String>? images, String? video, String? voiceNote, bool? isBid, String? bidAmount, BidStatus? bidStatus, FeedItem? quote, int? threadCount, int? threadIndex, List<String>? replyAvatars, bool? isFirstPost, int replies, int reposts, int shares, int votes
});


$AuthorCopyWith<$Res> get author;

}
/// @nodoc
class _$SocialPostDataCopyWithImpl<$Res>
    implements $SocialPostDataCopyWith<$Res> {
  _$SocialPostDataCopyWithImpl(this._self, this._then);

  final SocialPostData _self;
  final $Res Function(SocialPostData) _then;

/// Create a copy of SocialPostData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? author = null,Object? timestamp = null,Object? content = null,Object? images = freezed,Object? video = freezed,Object? voiceNote = freezed,Object? isBid = freezed,Object? bidAmount = freezed,Object? bidStatus = freezed,Object? quote = freezed,Object? threadCount = freezed,Object? threadIndex = freezed,Object? replyAvatars = freezed,Object? isFirstPost = freezed,Object? replies = null,Object? reposts = null,Object? shares = null,Object? votes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as Author,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,images: freezed == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>?,video: freezed == video ? _self.video : video // ignore: cast_nullable_to_non_nullable
as String?,voiceNote: freezed == voiceNote ? _self.voiceNote : voiceNote // ignore: cast_nullable_to_non_nullable
as String?,isBid: freezed == isBid ? _self.isBid : isBid // ignore: cast_nullable_to_non_nullable
as bool?,bidAmount: freezed == bidAmount ? _self.bidAmount : bidAmount // ignore: cast_nullable_to_non_nullable
as String?,bidStatus: freezed == bidStatus ? _self.bidStatus : bidStatus // ignore: cast_nullable_to_non_nullable
as BidStatus?,quote: freezed == quote ? _self.quote : quote // ignore: cast_nullable_to_non_nullable
as FeedItem?,threadCount: freezed == threadCount ? _self.threadCount : threadCount // ignore: cast_nullable_to_non_nullable
as int?,threadIndex: freezed == threadIndex ? _self.threadIndex : threadIndex // ignore: cast_nullable_to_non_nullable
as int?,replyAvatars: freezed == replyAvatars ? _self.replyAvatars : replyAvatars // ignore: cast_nullable_to_non_nullable
as List<String>?,isFirstPost: freezed == isFirstPost ? _self.isFirstPost : isFirstPost // ignore: cast_nullable_to_non_nullable
as bool?,replies: null == replies ? _self.replies : replies // ignore: cast_nullable_to_non_nullable
as int,reposts: null == reposts ? _self.reposts : reposts // ignore: cast_nullable_to_non_nullable
as int,shares: null == shares ? _self.shares : shares // ignore: cast_nullable_to_non_nullable
as int,votes: null == votes ? _self.votes : votes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of SocialPostData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthorCopyWith<$Res> get author {
  
  return $AuthorCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}


/// Adds pattern-matching-related methods to [SocialPostData].
extension SocialPostDataPatterns on SocialPostData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SocialPostData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SocialPostData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SocialPostData value)  $default,){
final _that = this;
switch (_that) {
case _SocialPostData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SocialPostData value)?  $default,){
final _that = this;
switch (_that) {
case _SocialPostData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  Author author,  String timestamp,  String content,  List<String>? images,  String? video,  String? voiceNote,  bool? isBid,  String? bidAmount,  BidStatus? bidStatus,  FeedItem? quote,  int? threadCount,  int? threadIndex,  List<String>? replyAvatars,  bool? isFirstPost,  int replies,  int reposts,  int shares,  int votes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SocialPostData() when $default != null:
return $default(_that.id,_that.author,_that.timestamp,_that.content,_that.images,_that.video,_that.voiceNote,_that.isBid,_that.bidAmount,_that.bidStatus,_that.quote,_that.threadCount,_that.threadIndex,_that.replyAvatars,_that.isFirstPost,_that.replies,_that.reposts,_that.shares,_that.votes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  Author author,  String timestamp,  String content,  List<String>? images,  String? video,  String? voiceNote,  bool? isBid,  String? bidAmount,  BidStatus? bidStatus,  FeedItem? quote,  int? threadCount,  int? threadIndex,  List<String>? replyAvatars,  bool? isFirstPost,  int replies,  int reposts,  int shares,  int votes)  $default,) {final _that = this;
switch (_that) {
case _SocialPostData():
return $default(_that.id,_that.author,_that.timestamp,_that.content,_that.images,_that.video,_that.voiceNote,_that.isBid,_that.bidAmount,_that.bidStatus,_that.quote,_that.threadCount,_that.threadIndex,_that.replyAvatars,_that.isFirstPost,_that.replies,_that.reposts,_that.shares,_that.votes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  Author author,  String timestamp,  String content,  List<String>? images,  String? video,  String? voiceNote,  bool? isBid,  String? bidAmount,  BidStatus? bidStatus,  FeedItem? quote,  int? threadCount,  int? threadIndex,  List<String>? replyAvatars,  bool? isFirstPost,  int replies,  int reposts,  int shares,  int votes)?  $default,) {final _that = this;
switch (_that) {
case _SocialPostData() when $default != null:
return $default(_that.id,_that.author,_that.timestamp,_that.content,_that.images,_that.video,_that.voiceNote,_that.isBid,_that.bidAmount,_that.bidStatus,_that.quote,_that.threadCount,_that.threadIndex,_that.replyAvatars,_that.isFirstPost,_that.replies,_that.reposts,_that.shares,_that.votes);case _:
  return null;

}
}

}

/// @nodoc


class _SocialPostData extends SocialPostData {
  const _SocialPostData({required this.id, required this.author, required this.timestamp, required this.content, final  List<String>? images, this.video, this.voiceNote, this.isBid, this.bidAmount, this.bidStatus, this.quote, this.threadCount, this.threadIndex, final  List<String>? replyAvatars, this.isFirstPost, this.replies = 0, this.reposts = 0, this.shares = 0, this.votes = 0}): _images = images,_replyAvatars = replyAvatars,super._();
  

@override final  String id;
@override final  Author author;
@override final  String timestamp;
@override final  String content;
 final  List<String>? _images;
@override List<String>? get images {
  final value = _images;
  if (value == null) return null;
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? video;
@override final  String? voiceNote;
@override final  bool? isBid;
@override final  String? bidAmount;
@override final  BidStatus? bidStatus;
@override final  FeedItem? quote;
@override final  int? threadCount;
@override final  int? threadIndex;
 final  List<String>? _replyAvatars;
@override List<String>? get replyAvatars {
  final value = _replyAvatars;
  if (value == null) return null;
  if (_replyAvatars is EqualUnmodifiableListView) return _replyAvatars;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  bool? isFirstPost;
@override@JsonKey() final  int replies;
@override@JsonKey() final  int reposts;
@override@JsonKey() final  int shares;
@override@JsonKey() final  int votes;

/// Create a copy of SocialPostData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SocialPostDataCopyWith<_SocialPostData> get copyWith => __$SocialPostDataCopyWithImpl<_SocialPostData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SocialPostData&&(identical(other.id, id) || other.id == id)&&(identical(other.author, author) || other.author == author)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other._images, _images)&&(identical(other.video, video) || other.video == video)&&(identical(other.voiceNote, voiceNote) || other.voiceNote == voiceNote)&&(identical(other.isBid, isBid) || other.isBid == isBid)&&(identical(other.bidAmount, bidAmount) || other.bidAmount == bidAmount)&&(identical(other.bidStatus, bidStatus) || other.bidStatus == bidStatus)&&(identical(other.quote, quote) || other.quote == quote)&&(identical(other.threadCount, threadCount) || other.threadCount == threadCount)&&(identical(other.threadIndex, threadIndex) || other.threadIndex == threadIndex)&&const DeepCollectionEquality().equals(other._replyAvatars, _replyAvatars)&&(identical(other.isFirstPost, isFirstPost) || other.isFirstPost == isFirstPost)&&(identical(other.replies, replies) || other.replies == replies)&&(identical(other.reposts, reposts) || other.reposts == reposts)&&(identical(other.shares, shares) || other.shares == shares)&&(identical(other.votes, votes) || other.votes == votes));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,author,timestamp,content,const DeepCollectionEquality().hash(_images),video,voiceNote,isBid,bidAmount,bidStatus,quote,threadCount,threadIndex,const DeepCollectionEquality().hash(_replyAvatars),isFirstPost,replies,reposts,shares,votes]);

@override
String toString() {
  return 'SocialPostData(id: $id, author: $author, timestamp: $timestamp, content: $content, images: $images, video: $video, voiceNote: $voiceNote, isBid: $isBid, bidAmount: $bidAmount, bidStatus: $bidStatus, quote: $quote, threadCount: $threadCount, threadIndex: $threadIndex, replyAvatars: $replyAvatars, isFirstPost: $isFirstPost, replies: $replies, reposts: $reposts, shares: $shares, votes: $votes)';
}


}

/// @nodoc
abstract mixin class _$SocialPostDataCopyWith<$Res> implements $SocialPostDataCopyWith<$Res> {
  factory _$SocialPostDataCopyWith(_SocialPostData value, $Res Function(_SocialPostData) _then) = __$SocialPostDataCopyWithImpl;
@override @useResult
$Res call({
 String id, Author author, String timestamp, String content, List<String>? images, String? video, String? voiceNote, bool? isBid, String? bidAmount, BidStatus? bidStatus, FeedItem? quote, int? threadCount, int? threadIndex, List<String>? replyAvatars, bool? isFirstPost, int replies, int reposts, int shares, int votes
});


@override $AuthorCopyWith<$Res> get author;

}
/// @nodoc
class __$SocialPostDataCopyWithImpl<$Res>
    implements _$SocialPostDataCopyWith<$Res> {
  __$SocialPostDataCopyWithImpl(this._self, this._then);

  final _SocialPostData _self;
  final $Res Function(_SocialPostData) _then;

/// Create a copy of SocialPostData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? author = null,Object? timestamp = null,Object? content = null,Object? images = freezed,Object? video = freezed,Object? voiceNote = freezed,Object? isBid = freezed,Object? bidAmount = freezed,Object? bidStatus = freezed,Object? quote = freezed,Object? threadCount = freezed,Object? threadIndex = freezed,Object? replyAvatars = freezed,Object? isFirstPost = freezed,Object? replies = null,Object? reposts = null,Object? shares = null,Object? votes = null,}) {
  return _then(_SocialPostData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as Author,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,images: freezed == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>?,video: freezed == video ? _self.video : video // ignore: cast_nullable_to_non_nullable
as String?,voiceNote: freezed == voiceNote ? _self.voiceNote : voiceNote // ignore: cast_nullable_to_non_nullable
as String?,isBid: freezed == isBid ? _self.isBid : isBid // ignore: cast_nullable_to_non_nullable
as bool?,bidAmount: freezed == bidAmount ? _self.bidAmount : bidAmount // ignore: cast_nullable_to_non_nullable
as String?,bidStatus: freezed == bidStatus ? _self.bidStatus : bidStatus // ignore: cast_nullable_to_non_nullable
as BidStatus?,quote: freezed == quote ? _self.quote : quote // ignore: cast_nullable_to_non_nullable
as FeedItem?,threadCount: freezed == threadCount ? _self.threadCount : threadCount // ignore: cast_nullable_to_non_nullable
as int?,threadIndex: freezed == threadIndex ? _self.threadIndex : threadIndex // ignore: cast_nullable_to_non_nullable
as int?,replyAvatars: freezed == replyAvatars ? _self._replyAvatars : replyAvatars // ignore: cast_nullable_to_non_nullable
as List<String>?,isFirstPost: freezed == isFirstPost ? _self.isFirstPost : isFirstPost // ignore: cast_nullable_to_non_nullable
as bool?,replies: null == replies ? _self.replies : replies // ignore: cast_nullable_to_non_nullable
as int,reposts: null == reposts ? _self.reposts : reposts // ignore: cast_nullable_to_non_nullable
as int,shares: null == shares ? _self.shares : shares // ignore: cast_nullable_to_non_nullable
as int,votes: null == votes ? _self.votes : votes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of SocialPostData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthorCopyWith<$Res> get author {
  
  return $AuthorCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}

/// @nodoc
mixin _$TaskData {

 String get id; Author get author; String get timestamp; String get category; String get title; String get description; String get price; TaskStatus get status; TaskIconType get iconType; String? get details; List<String>? get tags; String? get meta; String? get mapUrl; List<String>? get images; String? get video; String? get voiceNote; Author? get assignedWorker; String? get acceptedBidAmount; bool? get isFirstTask; bool? get isFirstPost; int get replies; int get reposts; int get shares; int get votes;
/// Create a copy of TaskData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskDataCopyWith<TaskData> get copyWith => _$TaskDataCopyWithImpl<TaskData>(this as TaskData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskData&&(identical(other.id, id) || other.id == id)&&(identical(other.author, author) || other.author == author)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.category, category) || other.category == category)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.status, status) || other.status == status)&&(identical(other.iconType, iconType) || other.iconType == iconType)&&(identical(other.details, details) || other.details == details)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.mapUrl, mapUrl) || other.mapUrl == mapUrl)&&const DeepCollectionEquality().equals(other.images, images)&&(identical(other.video, video) || other.video == video)&&(identical(other.voiceNote, voiceNote) || other.voiceNote == voiceNote)&&(identical(other.assignedWorker, assignedWorker) || other.assignedWorker == assignedWorker)&&(identical(other.acceptedBidAmount, acceptedBidAmount) || other.acceptedBidAmount == acceptedBidAmount)&&(identical(other.isFirstTask, isFirstTask) || other.isFirstTask == isFirstTask)&&(identical(other.isFirstPost, isFirstPost) || other.isFirstPost == isFirstPost)&&(identical(other.replies, replies) || other.replies == replies)&&(identical(other.reposts, reposts) || other.reposts == reposts)&&(identical(other.shares, shares) || other.shares == shares)&&(identical(other.votes, votes) || other.votes == votes));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,author,timestamp,category,title,description,price,status,iconType,details,const DeepCollectionEquality().hash(tags),meta,mapUrl,const DeepCollectionEquality().hash(images),video,voiceNote,assignedWorker,acceptedBidAmount,isFirstTask,isFirstPost,replies,reposts,shares,votes]);

@override
String toString() {
  return 'TaskData(id: $id, author: $author, timestamp: $timestamp, category: $category, title: $title, description: $description, price: $price, status: $status, iconType: $iconType, details: $details, tags: $tags, meta: $meta, mapUrl: $mapUrl, images: $images, video: $video, voiceNote: $voiceNote, assignedWorker: $assignedWorker, acceptedBidAmount: $acceptedBidAmount, isFirstTask: $isFirstTask, isFirstPost: $isFirstPost, replies: $replies, reposts: $reposts, shares: $shares, votes: $votes)';
}


}

/// @nodoc
abstract mixin class $TaskDataCopyWith<$Res>  {
  factory $TaskDataCopyWith(TaskData value, $Res Function(TaskData) _then) = _$TaskDataCopyWithImpl;
@useResult
$Res call({
 String id, Author author, String timestamp, String category, String title, String description, String price, TaskStatus status, TaskIconType iconType, String? details, List<String>? tags, String? meta, String? mapUrl, List<String>? images, String? video, String? voiceNote, Author? assignedWorker, String? acceptedBidAmount, bool? isFirstTask, bool? isFirstPost, int replies, int reposts, int shares, int votes
});


$AuthorCopyWith<$Res> get author;$AuthorCopyWith<$Res>? get assignedWorker;

}
/// @nodoc
class _$TaskDataCopyWithImpl<$Res>
    implements $TaskDataCopyWith<$Res> {
  _$TaskDataCopyWithImpl(this._self, this._then);

  final TaskData _self;
  final $Res Function(TaskData) _then;

/// Create a copy of TaskData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? author = null,Object? timestamp = null,Object? category = null,Object? title = null,Object? description = null,Object? price = null,Object? status = null,Object? iconType = null,Object? details = freezed,Object? tags = freezed,Object? meta = freezed,Object? mapUrl = freezed,Object? images = freezed,Object? video = freezed,Object? voiceNote = freezed,Object? assignedWorker = freezed,Object? acceptedBidAmount = freezed,Object? isFirstTask = freezed,Object? isFirstPost = freezed,Object? replies = null,Object? reposts = null,Object? shares = null,Object? votes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as Author,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,iconType: null == iconType ? _self.iconType : iconType // ignore: cast_nullable_to_non_nullable
as TaskIconType,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,tags: freezed == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as String?,mapUrl: freezed == mapUrl ? _self.mapUrl : mapUrl // ignore: cast_nullable_to_non_nullable
as String?,images: freezed == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>?,video: freezed == video ? _self.video : video // ignore: cast_nullable_to_non_nullable
as String?,voiceNote: freezed == voiceNote ? _self.voiceNote : voiceNote // ignore: cast_nullable_to_non_nullable
as String?,assignedWorker: freezed == assignedWorker ? _self.assignedWorker : assignedWorker // ignore: cast_nullable_to_non_nullable
as Author?,acceptedBidAmount: freezed == acceptedBidAmount ? _self.acceptedBidAmount : acceptedBidAmount // ignore: cast_nullable_to_non_nullable
as String?,isFirstTask: freezed == isFirstTask ? _self.isFirstTask : isFirstTask // ignore: cast_nullable_to_non_nullable
as bool?,isFirstPost: freezed == isFirstPost ? _self.isFirstPost : isFirstPost // ignore: cast_nullable_to_non_nullable
as bool?,replies: null == replies ? _self.replies : replies // ignore: cast_nullable_to_non_nullable
as int,reposts: null == reposts ? _self.reposts : reposts // ignore: cast_nullable_to_non_nullable
as int,shares: null == shares ? _self.shares : shares // ignore: cast_nullable_to_non_nullable
as int,votes: null == votes ? _self.votes : votes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of TaskData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthorCopyWith<$Res> get author {
  
  return $AuthorCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}/// Create a copy of TaskData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthorCopyWith<$Res>? get assignedWorker {
    if (_self.assignedWorker == null) {
    return null;
  }

  return $AuthorCopyWith<$Res>(_self.assignedWorker!, (value) {
    return _then(_self.copyWith(assignedWorker: value));
  });
}
}


/// Adds pattern-matching-related methods to [TaskData].
extension TaskDataPatterns on TaskData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskData value)  $default,){
final _that = this;
switch (_that) {
case _TaskData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskData value)?  $default,){
final _that = this;
switch (_that) {
case _TaskData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  Author author,  String timestamp,  String category,  String title,  String description,  String price,  TaskStatus status,  TaskIconType iconType,  String? details,  List<String>? tags,  String? meta,  String? mapUrl,  List<String>? images,  String? video,  String? voiceNote,  Author? assignedWorker,  String? acceptedBidAmount,  bool? isFirstTask,  bool? isFirstPost,  int replies,  int reposts,  int shares,  int votes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskData() when $default != null:
return $default(_that.id,_that.author,_that.timestamp,_that.category,_that.title,_that.description,_that.price,_that.status,_that.iconType,_that.details,_that.tags,_that.meta,_that.mapUrl,_that.images,_that.video,_that.voiceNote,_that.assignedWorker,_that.acceptedBidAmount,_that.isFirstTask,_that.isFirstPost,_that.replies,_that.reposts,_that.shares,_that.votes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  Author author,  String timestamp,  String category,  String title,  String description,  String price,  TaskStatus status,  TaskIconType iconType,  String? details,  List<String>? tags,  String? meta,  String? mapUrl,  List<String>? images,  String? video,  String? voiceNote,  Author? assignedWorker,  String? acceptedBidAmount,  bool? isFirstTask,  bool? isFirstPost,  int replies,  int reposts,  int shares,  int votes)  $default,) {final _that = this;
switch (_that) {
case _TaskData():
return $default(_that.id,_that.author,_that.timestamp,_that.category,_that.title,_that.description,_that.price,_that.status,_that.iconType,_that.details,_that.tags,_that.meta,_that.mapUrl,_that.images,_that.video,_that.voiceNote,_that.assignedWorker,_that.acceptedBidAmount,_that.isFirstTask,_that.isFirstPost,_that.replies,_that.reposts,_that.shares,_that.votes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  Author author,  String timestamp,  String category,  String title,  String description,  String price,  TaskStatus status,  TaskIconType iconType,  String? details,  List<String>? tags,  String? meta,  String? mapUrl,  List<String>? images,  String? video,  String? voiceNote,  Author? assignedWorker,  String? acceptedBidAmount,  bool? isFirstTask,  bool? isFirstPost,  int replies,  int reposts,  int shares,  int votes)?  $default,) {final _that = this;
switch (_that) {
case _TaskData() when $default != null:
return $default(_that.id,_that.author,_that.timestamp,_that.category,_that.title,_that.description,_that.price,_that.status,_that.iconType,_that.details,_that.tags,_that.meta,_that.mapUrl,_that.images,_that.video,_that.voiceNote,_that.assignedWorker,_that.acceptedBidAmount,_that.isFirstTask,_that.isFirstPost,_that.replies,_that.reposts,_that.shares,_that.votes);case _:
  return null;

}
}

}

/// @nodoc


class _TaskData extends TaskData {
  const _TaskData({required this.id, required this.author, required this.timestamp, required this.category, required this.title, required this.description, required this.price, required this.status, required this.iconType, this.details, final  List<String>? tags, this.meta, this.mapUrl, final  List<String>? images, this.video, this.voiceNote, this.assignedWorker, this.acceptedBidAmount, this.isFirstTask, this.isFirstPost, this.replies = 0, this.reposts = 0, this.shares = 0, this.votes = 0}): _tags = tags,_images = images,super._();
  

@override final  String id;
@override final  Author author;
@override final  String timestamp;
@override final  String category;
@override final  String title;
@override final  String description;
@override final  String price;
@override final  TaskStatus status;
@override final  TaskIconType iconType;
@override final  String? details;
 final  List<String>? _tags;
@override List<String>? get tags {
  final value = _tags;
  if (value == null) return null;
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? meta;
@override final  String? mapUrl;
 final  List<String>? _images;
@override List<String>? get images {
  final value = _images;
  if (value == null) return null;
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? video;
@override final  String? voiceNote;
@override final  Author? assignedWorker;
@override final  String? acceptedBidAmount;
@override final  bool? isFirstTask;
@override final  bool? isFirstPost;
@override@JsonKey() final  int replies;
@override@JsonKey() final  int reposts;
@override@JsonKey() final  int shares;
@override@JsonKey() final  int votes;

/// Create a copy of TaskData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskDataCopyWith<_TaskData> get copyWith => __$TaskDataCopyWithImpl<_TaskData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskData&&(identical(other.id, id) || other.id == id)&&(identical(other.author, author) || other.author == author)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.category, category) || other.category == category)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.status, status) || other.status == status)&&(identical(other.iconType, iconType) || other.iconType == iconType)&&(identical(other.details, details) || other.details == details)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.mapUrl, mapUrl) || other.mapUrl == mapUrl)&&const DeepCollectionEquality().equals(other._images, _images)&&(identical(other.video, video) || other.video == video)&&(identical(other.voiceNote, voiceNote) || other.voiceNote == voiceNote)&&(identical(other.assignedWorker, assignedWorker) || other.assignedWorker == assignedWorker)&&(identical(other.acceptedBidAmount, acceptedBidAmount) || other.acceptedBidAmount == acceptedBidAmount)&&(identical(other.isFirstTask, isFirstTask) || other.isFirstTask == isFirstTask)&&(identical(other.isFirstPost, isFirstPost) || other.isFirstPost == isFirstPost)&&(identical(other.replies, replies) || other.replies == replies)&&(identical(other.reposts, reposts) || other.reposts == reposts)&&(identical(other.shares, shares) || other.shares == shares)&&(identical(other.votes, votes) || other.votes == votes));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,author,timestamp,category,title,description,price,status,iconType,details,const DeepCollectionEquality().hash(_tags),meta,mapUrl,const DeepCollectionEquality().hash(_images),video,voiceNote,assignedWorker,acceptedBidAmount,isFirstTask,isFirstPost,replies,reposts,shares,votes]);

@override
String toString() {
  return 'TaskData(id: $id, author: $author, timestamp: $timestamp, category: $category, title: $title, description: $description, price: $price, status: $status, iconType: $iconType, details: $details, tags: $tags, meta: $meta, mapUrl: $mapUrl, images: $images, video: $video, voiceNote: $voiceNote, assignedWorker: $assignedWorker, acceptedBidAmount: $acceptedBidAmount, isFirstTask: $isFirstTask, isFirstPost: $isFirstPost, replies: $replies, reposts: $reposts, shares: $shares, votes: $votes)';
}


}

/// @nodoc
abstract mixin class _$TaskDataCopyWith<$Res> implements $TaskDataCopyWith<$Res> {
  factory _$TaskDataCopyWith(_TaskData value, $Res Function(_TaskData) _then) = __$TaskDataCopyWithImpl;
@override @useResult
$Res call({
 String id, Author author, String timestamp, String category, String title, String description, String price, TaskStatus status, TaskIconType iconType, String? details, List<String>? tags, String? meta, String? mapUrl, List<String>? images, String? video, String? voiceNote, Author? assignedWorker, String? acceptedBidAmount, bool? isFirstTask, bool? isFirstPost, int replies, int reposts, int shares, int votes
});


@override $AuthorCopyWith<$Res> get author;@override $AuthorCopyWith<$Res>? get assignedWorker;

}
/// @nodoc
class __$TaskDataCopyWithImpl<$Res>
    implements _$TaskDataCopyWith<$Res> {
  __$TaskDataCopyWithImpl(this._self, this._then);

  final _TaskData _self;
  final $Res Function(_TaskData) _then;

/// Create a copy of TaskData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? author = null,Object? timestamp = null,Object? category = null,Object? title = null,Object? description = null,Object? price = null,Object? status = null,Object? iconType = null,Object? details = freezed,Object? tags = freezed,Object? meta = freezed,Object? mapUrl = freezed,Object? images = freezed,Object? video = freezed,Object? voiceNote = freezed,Object? assignedWorker = freezed,Object? acceptedBidAmount = freezed,Object? isFirstTask = freezed,Object? isFirstPost = freezed,Object? replies = null,Object? reposts = null,Object? shares = null,Object? votes = null,}) {
  return _then(_TaskData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as Author,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,iconType: null == iconType ? _self.iconType : iconType // ignore: cast_nullable_to_non_nullable
as TaskIconType,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,tags: freezed == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as String?,mapUrl: freezed == mapUrl ? _self.mapUrl : mapUrl // ignore: cast_nullable_to_non_nullable
as String?,images: freezed == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>?,video: freezed == video ? _self.video : video // ignore: cast_nullable_to_non_nullable
as String?,voiceNote: freezed == voiceNote ? _self.voiceNote : voiceNote // ignore: cast_nullable_to_non_nullable
as String?,assignedWorker: freezed == assignedWorker ? _self.assignedWorker : assignedWorker // ignore: cast_nullable_to_non_nullable
as Author?,acceptedBidAmount: freezed == acceptedBidAmount ? _self.acceptedBidAmount : acceptedBidAmount // ignore: cast_nullable_to_non_nullable
as String?,isFirstTask: freezed == isFirstTask ? _self.isFirstTask : isFirstTask // ignore: cast_nullable_to_non_nullable
as bool?,isFirstPost: freezed == isFirstPost ? _self.isFirstPost : isFirstPost // ignore: cast_nullable_to_non_nullable
as bool?,replies: null == replies ? _self.replies : replies // ignore: cast_nullable_to_non_nullable
as int,reposts: null == reposts ? _self.reposts : reposts // ignore: cast_nullable_to_non_nullable
as int,shares: null == shares ? _self.shares : shares // ignore: cast_nullable_to_non_nullable
as int,votes: null == votes ? _self.votes : votes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of TaskData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthorCopyWith<$Res> get author {
  
  return $AuthorCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}/// Create a copy of TaskData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthorCopyWith<$Res>? get assignedWorker {
    if (_self.assignedWorker == null) {
    return null;
  }

  return $AuthorCopyWith<$Res>(_self.assignedWorker!, (value) {
    return _then(_self.copyWith(assignedWorker: value));
  });
}
}

/// @nodoc
mixin _$EditorialData {

 String get id; Author get author; String get timestamp; String get tag; String get title; String get excerpt; int get replies; int get reposts; int get shares; int get votes;
/// Create a copy of EditorialData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditorialDataCopyWith<EditorialData> get copyWith => _$EditorialDataCopyWithImpl<EditorialData>(this as EditorialData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditorialData&&(identical(other.id, id) || other.id == id)&&(identical(other.author, author) || other.author == author)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.title, title) || other.title == title)&&(identical(other.excerpt, excerpt) || other.excerpt == excerpt)&&(identical(other.replies, replies) || other.replies == replies)&&(identical(other.reposts, reposts) || other.reposts == reposts)&&(identical(other.shares, shares) || other.shares == shares)&&(identical(other.votes, votes) || other.votes == votes));
}


@override
int get hashCode => Object.hash(runtimeType,id,author,timestamp,tag,title,excerpt,replies,reposts,shares,votes);

@override
String toString() {
  return 'EditorialData(id: $id, author: $author, timestamp: $timestamp, tag: $tag, title: $title, excerpt: $excerpt, replies: $replies, reposts: $reposts, shares: $shares, votes: $votes)';
}


}

/// @nodoc
abstract mixin class $EditorialDataCopyWith<$Res>  {
  factory $EditorialDataCopyWith(EditorialData value, $Res Function(EditorialData) _then) = _$EditorialDataCopyWithImpl;
@useResult
$Res call({
 String id, Author author, String timestamp, String tag, String title, String excerpt, int replies, int reposts, int shares, int votes
});


$AuthorCopyWith<$Res> get author;

}
/// @nodoc
class _$EditorialDataCopyWithImpl<$Res>
    implements $EditorialDataCopyWith<$Res> {
  _$EditorialDataCopyWithImpl(this._self, this._then);

  final EditorialData _self;
  final $Res Function(EditorialData) _then;

/// Create a copy of EditorialData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? author = null,Object? timestamp = null,Object? tag = null,Object? title = null,Object? excerpt = null,Object? replies = null,Object? reposts = null,Object? shares = null,Object? votes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as Author,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String,tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,excerpt: null == excerpt ? _self.excerpt : excerpt // ignore: cast_nullable_to_non_nullable
as String,replies: null == replies ? _self.replies : replies // ignore: cast_nullable_to_non_nullable
as int,reposts: null == reposts ? _self.reposts : reposts // ignore: cast_nullable_to_non_nullable
as int,shares: null == shares ? _self.shares : shares // ignore: cast_nullable_to_non_nullable
as int,votes: null == votes ? _self.votes : votes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of EditorialData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthorCopyWith<$Res> get author {
  
  return $AuthorCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}


/// Adds pattern-matching-related methods to [EditorialData].
extension EditorialDataPatterns on EditorialData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditorialData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditorialData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditorialData value)  $default,){
final _that = this;
switch (_that) {
case _EditorialData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditorialData value)?  $default,){
final _that = this;
switch (_that) {
case _EditorialData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  Author author,  String timestamp,  String tag,  String title,  String excerpt,  int replies,  int reposts,  int shares,  int votes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditorialData() when $default != null:
return $default(_that.id,_that.author,_that.timestamp,_that.tag,_that.title,_that.excerpt,_that.replies,_that.reposts,_that.shares,_that.votes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  Author author,  String timestamp,  String tag,  String title,  String excerpt,  int replies,  int reposts,  int shares,  int votes)  $default,) {final _that = this;
switch (_that) {
case _EditorialData():
return $default(_that.id,_that.author,_that.timestamp,_that.tag,_that.title,_that.excerpt,_that.replies,_that.reposts,_that.shares,_that.votes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  Author author,  String timestamp,  String tag,  String title,  String excerpt,  int replies,  int reposts,  int shares,  int votes)?  $default,) {final _that = this;
switch (_that) {
case _EditorialData() when $default != null:
return $default(_that.id,_that.author,_that.timestamp,_that.tag,_that.title,_that.excerpt,_that.replies,_that.reposts,_that.shares,_that.votes);case _:
  return null;

}
}

}

/// @nodoc


class _EditorialData extends EditorialData {
  const _EditorialData({required this.id, required this.author, required this.timestamp, required this.tag, required this.title, required this.excerpt, this.replies = 0, this.reposts = 0, this.shares = 0, this.votes = 0}): super._();
  

@override final  String id;
@override final  Author author;
@override final  String timestamp;
@override final  String tag;
@override final  String title;
@override final  String excerpt;
@override@JsonKey() final  int replies;
@override@JsonKey() final  int reposts;
@override@JsonKey() final  int shares;
@override@JsonKey() final  int votes;

/// Create a copy of EditorialData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditorialDataCopyWith<_EditorialData> get copyWith => __$EditorialDataCopyWithImpl<_EditorialData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditorialData&&(identical(other.id, id) || other.id == id)&&(identical(other.author, author) || other.author == author)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.title, title) || other.title == title)&&(identical(other.excerpt, excerpt) || other.excerpt == excerpt)&&(identical(other.replies, replies) || other.replies == replies)&&(identical(other.reposts, reposts) || other.reposts == reposts)&&(identical(other.shares, shares) || other.shares == shares)&&(identical(other.votes, votes) || other.votes == votes));
}


@override
int get hashCode => Object.hash(runtimeType,id,author,timestamp,tag,title,excerpt,replies,reposts,shares,votes);

@override
String toString() {
  return 'EditorialData(id: $id, author: $author, timestamp: $timestamp, tag: $tag, title: $title, excerpt: $excerpt, replies: $replies, reposts: $reposts, shares: $shares, votes: $votes)';
}


}

/// @nodoc
abstract mixin class _$EditorialDataCopyWith<$Res> implements $EditorialDataCopyWith<$Res> {
  factory _$EditorialDataCopyWith(_EditorialData value, $Res Function(_EditorialData) _then) = __$EditorialDataCopyWithImpl;
@override @useResult
$Res call({
 String id, Author author, String timestamp, String tag, String title, String excerpt, int replies, int reposts, int shares, int votes
});


@override $AuthorCopyWith<$Res> get author;

}
/// @nodoc
class __$EditorialDataCopyWithImpl<$Res>
    implements _$EditorialDataCopyWith<$Res> {
  __$EditorialDataCopyWithImpl(this._self, this._then);

  final _EditorialData _self;
  final $Res Function(_EditorialData) _then;

/// Create a copy of EditorialData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? author = null,Object? timestamp = null,Object? tag = null,Object? title = null,Object? excerpt = null,Object? replies = null,Object? reposts = null,Object? shares = null,Object? votes = null,}) {
  return _then(_EditorialData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as Author,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String,tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,excerpt: null == excerpt ? _self.excerpt : excerpt // ignore: cast_nullable_to_non_nullable
as String,replies: null == replies ? _self.replies : replies // ignore: cast_nullable_to_non_nullable
as int,reposts: null == reposts ? _self.reposts : reposts // ignore: cast_nullable_to_non_nullable
as int,shares: null == shares ? _self.shares : shares // ignore: cast_nullable_to_non_nullable
as int,votes: null == votes ? _self.votes : votes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of EditorialData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthorCopyWith<$Res> get author {
  
  return $AuthorCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}

// dart format on
