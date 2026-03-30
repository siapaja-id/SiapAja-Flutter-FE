import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/feed_item.dart';
import '../data/sample_data.dart';

/// Feed state for managing feed items list
class FeedState {
  final List<FeedItem> feedItems;
  final bool isLoading;
  final int? lastUpdated;
  final Map<String, List<FeedItem>> replies;

  const FeedState({
    required this.feedItems,
    this.isLoading = false,
    this.lastUpdated,
    this.replies = const {},
  });

  FeedState copyWith({
    List<FeedItem>? feedItems,
    bool? isLoading,
    int? lastUpdated,
    Map<String, List<FeedItem>>? replies,
  }) {
    return FeedState(
      feedItems: feedItems ?? this.feedItems,
      isLoading: isLoading ?? this.isLoading,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      replies: replies ?? this.replies,
    );
  }
}

/// Feed Notifier - manages feed items state
class FeedNotifier extends Notifier<FeedState> {
  @override
  FeedState build() {
    return FeedState(
      feedItems: sampleData,
      isLoading: false,
      lastUpdated: DateTime.now().millisecondsSinceEpoch,
      replies: const {},
    );
  }

  /// Get a feed item by id from the main list or replies
  FeedItem? getItemById(String id) {
    for (final item in state.feedItems) {
      if (item.id == id) return item;
    }
    for (final replyList in state.replies.values) {
      for (final reply in replyList) {
        if (reply.id == id) return reply;
      }
    }
    return null;
  }

  /// Add a new feed item
  void addFeedItem(FeedItem item) {
    state = state.copyWith(
      feedItems: [item, ...state.feedItems],
      lastUpdated: DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Update a feed item using copyWith
  void updateFeedItem(String id, FeedItem updated) {
    state = state.copyWith(
      feedItems: state.feedItems.map((item) {
        if (item.id == id) return updated;
        return item;
      }).toList(),
      lastUpdated: DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Remove a feed item
  void removeFeedItem(String id) {
    state = state.copyWith(
      feedItems: state.feedItems.where((item) => item.id != id).toList(),
      lastUpdated: DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Refresh the feed
  void refreshFeed() {
    state = FeedState(
      feedItems: sampleData,
      isLoading: false,
      lastUpdated: DateTime.now().millisecondsSinceEpoch,
      replies: const {},
    );
  }

  /// Set loading state
  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  /// Set replies for a parent post
  void setReplies(String parentId, List<FeedItem> items) {
    final newReplies = Map<String, List<FeedItem>>.from(state.replies);
    newReplies[parentId] = items;
    state = state.copyWith(replies: newReplies);
  }

  /// Add a reply to a parent post
  void addReply(String parentId, FeedItem item) {
    final newReplies = Map<String, List<FeedItem>>.from(state.replies);
    final existing = newReplies[parentId] ?? [];
    newReplies[parentId] = [item, ...existing];
    state = state.copyWith(replies: newReplies);
  }

  /// Update a reply within a parent's reply list
  void updateReply(String parentId, String replyId, FeedItem updated) {
    final newReplies = Map<String, List<FeedItem>>.from(state.replies);
    final existing = newReplies[parentId];
    if (existing == null) return;
    newReplies[parentId] = existing.map((r) {
      if (r.id == replyId) return updated;
      return r;
    }).toList();
    state = state.copyWith(replies: newReplies);
  }
}

/// Feed notifier provider
final feedNotifierProvider = NotifierProvider<FeedNotifier, FeedState>(
  () => FeedNotifier(),
);
