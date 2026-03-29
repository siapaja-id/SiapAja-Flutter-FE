import 'author.dart';

/// Base sealed class for all feed items
sealed class FeedItem {
  final String id;
  final Author author;
  final String timestamp;
  final int replies;
  final int reposts;
  final int shares;
  final int votes;

  const FeedItem({
    required this.id,
    required this.author,
    required this.timestamp,
    this.replies = 0,
    this.reposts = 0,
    this.shares = 0,
    this.votes = 0,
  });
}

/// Bid status enum
enum BidStatus {
  pending,
  accepted,
  rejected,
  completed,
}

/// Task status enum
enum TaskStatus {
  open,
  assigned,
  inProgress,
  completed,
  finished,
}

/// Social post data
class SocialPostData extends FeedItem {
  final String content;
  final List<String>? images;
  final String? video;
  final String? voiceNote;
  final bool? isBid;
  final String? bidAmount;
  final BidStatus? bidStatus;
  final FeedItem? quote;
  final int? threadCount;
  final int? threadIndex;
  final List<String>? replyAvatars;
  final bool? isFirstPost;

  const SocialPostData({
    required super.id,
    required super.author,
    required super.timestamp,
    required this.content,
    this.images,
    this.video,
    this.voiceNote,
    this.isBid,
    this.bidAmount,
    this.bidStatus,
    this.quote,
    this.threadCount,
    this.threadIndex,
    this.replyAvatars,
    this.isFirstPost,
    super.replies,
    super.reposts,
    super.shares,
    super.votes,
  });

  @override
  String toString() => 'SocialPostData(id: $id, author: ${author.handle})';
}

/// Task icon types for PhosphorIcons
enum TaskIconType {
  palette,    // Design
  code,       // Development
  car,        // Ride Hail
  truck,      // Delivery (large)
  writing,    // Writing
  repair,     // Repair Needed
  package,    // Delivery (small)
  location,   // Location based
}

/// Task data
class TaskData extends FeedItem {
  final String category;
  final String title;
  final String description;
  final String price;
  final TaskStatus status;
  final TaskIconType iconType;
  final String? details;
  final List<String>? tags;
  final String? meta;
  final String? mapUrl;
  final List<String>? images;
  final Author? assignedWorker;
  final String? acceptedBidAmount;
  final bool? isFirstTask;

  const TaskData({
    required super.id,
    required super.author,
    required super.timestamp,
    required this.category,
    required this.title,
    required this.description,
    required this.price,
    required this.status,
    required this.iconType,
    this.details,
    this.tags,
    this.meta,
    this.mapUrl,
    this.images,
    this.assignedWorker,
    this.acceptedBidAmount,
    this.isFirstTask,
    super.replies,
    super.reposts,
    super.shares,
    super.votes,
  });

  @override
  String toString() => 'TaskData(id: $id, title: $title, status: $status)';
}

/// Editorial data
class EditorialData extends FeedItem {
  final String tag;
  final String title;
  final String excerpt;

  const EditorialData({
    required super.id,
    required super.author,
    required super.timestamp,
    required this.tag,
    required this.title,
    required this.excerpt,
    super.replies,
    super.reposts,
    super.shares,
    super.votes,
  });

  @override
  String toString() => 'EditorialData(id: $id, title: $title)';
}
