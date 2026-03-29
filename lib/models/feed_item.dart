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
enum BidStatus { pending, accepted, rejected, completed }

/// Task status enum
enum TaskStatus { open, assigned, inProgress, completed, finished }

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

  SocialPostData copyWith({
    String? id,
    Author? author,
    String? timestamp,
    String? content,
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
    int? replies,
    int? reposts,
    int? shares,
    int? votes,
  }) {
    return SocialPostData(
      id: id ?? this.id,
      author: author ?? this.author,
      timestamp: timestamp ?? this.timestamp,
      content: content ?? this.content,
      images: images ?? this.images,
      video: video ?? this.video,
      voiceNote: voiceNote ?? this.voiceNote,
      isBid: isBid ?? this.isBid,
      bidAmount: bidAmount ?? this.bidAmount,
      bidStatus: bidStatus ?? this.bidStatus,
      quote: quote ?? this.quote,
      threadCount: threadCount ?? this.threadCount,
      threadIndex: threadIndex ?? this.threadIndex,
      replyAvatars: replyAvatars ?? this.replyAvatars,
      isFirstPost: isFirstPost ?? this.isFirstPost,
      replies: replies ?? this.replies,
      reposts: reposts ?? this.reposts,
      shares: shares ?? this.shares,
      votes: votes ?? this.votes,
    );
  }
}

/// Task icon types for PhosphorIcons
enum TaskIconType {
  palette, // Design
  code, // Development
  car, // Ride Hail
  truck, // Delivery (large)
  writing, // Writing
  repair, // Repair Needed
  package, // Delivery (small)
  location, // Location based
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

  TaskData copyWith({
    String? id,
    Author? author,
    String? timestamp,
    String? category,
    String? title,
    String? description,
    String? price,
    TaskStatus? status,
    TaskIconType? iconType,
    String? details,
    List<String>? tags,
    String? meta,
    String? mapUrl,
    List<String>? images,
    Author? assignedWorker,
    String? acceptedBidAmount,
    bool? isFirstTask,
    int? replies,
    int? reposts,
    int? shares,
    int? votes,
  }) {
    return TaskData(
      id: id ?? this.id,
      author: author ?? this.author,
      timestamp: timestamp ?? this.timestamp,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      status: status ?? this.status,
      iconType: iconType ?? this.iconType,
      details: details ?? this.details,
      tags: tags ?? this.tags,
      meta: meta ?? this.meta,
      mapUrl: mapUrl ?? this.mapUrl,
      images: images ?? this.images,
      assignedWorker: assignedWorker ?? this.assignedWorker,
      acceptedBidAmount: acceptedBidAmount ?? this.acceptedBidAmount,
      isFirstTask: isFirstTask ?? this.isFirstTask,
      replies: replies ?? this.replies,
      reposts: reposts ?? this.reposts,
      shares: shares ?? this.shares,
      votes: votes ?? this.votes,
    );
  }
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

  EditorialData copyWith({
    String? id,
    Author? author,
    String? timestamp,
    String? tag,
    String? title,
    String? excerpt,
    int? replies,
    int? reposts,
    int? shares,
    int? votes,
  }) {
    return EditorialData(
      id: id ?? this.id,
      author: author ?? this.author,
      timestamp: timestamp ?? this.timestamp,
      tag: tag ?? this.tag,
      title: title ?? this.title,
      excerpt: excerpt ?? this.excerpt,
      replies: replies ?? this.replies,
      reposts: reposts ?? this.reposts,
      shares: shares ?? this.shares,
      votes: votes ?? this.votes,
    );
  }
}
