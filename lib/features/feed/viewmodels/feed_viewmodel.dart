import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/feed_item.dart';
import '../data/sample_data.dart';

part 'feed_viewmodel.freezed.dart';

@freezed
abstract class FeedState with _$FeedState {
  const factory FeedState({
    required List<FeedItem> feedItems,
    @Default(false) bool isLoading,
    int? lastUpdated,
    @Default({}) Map<String, List<FeedItem>> replies,
  }) = _FeedState;
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

  void addFeedItem(FeedItem item) {
    state = state.copyWith(
      feedItems: [item, ...state.feedItems],
      lastUpdated: DateTime.now().millisecondsSinceEpoch,
    );
  }

  void updateFeedItem(String id, FeedItem updated) {
    state = state.copyWith(
      feedItems: state.feedItems.map((item) {
        if (item.id == id) return updated;
        return item;
      }).toList(),
      lastUpdated: DateTime.now().millisecondsSinceEpoch,
    );
  }

  void removeFeedItem(String id) {
    state = state.copyWith(
      feedItems: state.feedItems.where((item) => item.id != id).toList(),
      lastUpdated: DateTime.now().millisecondsSinceEpoch,
    );
  }

  void refreshFeed() {
    state = FeedState(
      feedItems: sampleData,
      isLoading: false,
      lastUpdated: DateTime.now().millisecondsSinceEpoch,
      replies: const {},
    );
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setReplies(String parentId, List<FeedItem> items) {
    final newReplies = Map<String, List<FeedItem>>.from(state.replies);
    newReplies[parentId] = items;
    state = state.copyWith(replies: newReplies);
  }

  void addReply(String parentId, FeedItem item) {
    final newReplies = Map<String, List<FeedItem>>.from(state.replies);
    final existing = newReplies[parentId] ?? [];
    newReplies[parentId] = [item, ...existing];
    state = state.copyWith(replies: newReplies);
  }

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

final feedNotifierProvider = NotifierProvider<FeedNotifier, FeedState>(
  () => FeedNotifier(),
);
