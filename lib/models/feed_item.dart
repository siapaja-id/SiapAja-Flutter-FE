import 'package:freezed_annotation/freezed_annotation.dart';

import 'author.dart';

part 'feed_item.freezed.dart';

/// Base interface for all feed items
abstract class FeedItem {
  String get id;
  Author get author;
  String get timestamp;
  int get replies;
  int get reposts;
  int get shares;
  int get votes;

  const FeedItem();
}

/// Bid status enum
enum BidStatus { pending, accepted, rejected, completed }

/// Task status enum
enum TaskStatus { open, assigned, inProgress, completed, finished }

/// Task icon types for PhosphorIcons
enum TaskIconType {
  palette,
  code,
  car,
  truck,
  writing,
  repair,
  package,
  location,
}

@freezed
abstract class SocialPostData with _$SocialPostData implements FeedItem {
  const SocialPostData._();

  const factory SocialPostData({
    required String id,
    required Author author,
    required String timestamp,
    required String content,
    List<String>? images,
    String? video,
    String? voiceNote,
    bool? isBid,
    String? bidAmount,
    BidStatus? bidStatus,
    FeedItem? quote,
    int? threadCount,
    int? threadIndex,
    List<String>? replyAvatars,
    bool? isFirstPost,
    @Default(0) int replies,
    @Default(0) int reposts,
    @Default(0) int shares,
    @Default(0) int votes,
  }) = _SocialPostData;
}

@freezed
abstract class TaskData with _$TaskData implements FeedItem {
  const TaskData._();

  const factory TaskData({
    required String id,
    required Author author,
    required String timestamp,
    required String category,
    required String title,
    required String description,
    required String price,
    required TaskStatus status,
    required TaskIconType iconType,
    String? details,
    List<String>? tags,
    String? meta,
    String? mapUrl,
    List<String>? images,
    String? video,
    String? voiceNote,
    Author? assignedWorker,
    String? acceptedBidAmount,
    bool? isFirstTask,
    bool? isFirstPost,
    @Default(0) int replies,
    @Default(0) int reposts,
    @Default(0) int shares,
    @Default(0) int votes,
  }) = _TaskData;
}

@freezed
abstract class EditorialData with _$EditorialData implements FeedItem {
  const EditorialData._();

  const factory EditorialData({
    required String id,
    required Author author,
    required String timestamp,
    required String tag,
    required String title,
    required String excerpt,
    @Default(0) int replies,
    @Default(0) int reposts,
    @Default(0) int shares,
    @Default(0) int votes,
  }) = _EditorialData;
}
