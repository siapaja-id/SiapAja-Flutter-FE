import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/feed_item.dart';
import '../data/sample_data.dart';

/// Feed state for managing feed items list
class FeedState {
  final List<FeedItem> feedItems;
  final bool isLoading;
  final int? lastUpdated;

  const FeedState({
    required this.feedItems,
    this.isLoading = false,
    this.lastUpdated,
  });

  FeedState copyWith({
    List<FeedItem>? feedItems,
    bool? isLoading,
    int? lastUpdated,
  }) {
    return FeedState(
      feedItems: feedItems ?? this.feedItems,
      isLoading: isLoading ?? this.isLoading,
      lastUpdated: lastUpdated ?? this.lastUpdated,
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
    );
  }

  /// Add a new feed item
  void addFeedItem(FeedItem item) {
    state = state.copyWith(
      feedItems: [item, ...state.feedItems],
      lastUpdated: DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Update a feed item
  void updateFeedItem<T extends FeedItem>(String id, Map<String, dynamic> updates) {
    state = state.copyWith(
      feedItems: state.feedItems.map((item) {
        if (item.id == id) {
          // Note: In a real app, we'd use a proper copyWith method
          // For now, we just return the item as-is
          return item;
        }
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
    );
  }

  /// Set loading state
  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }
}

/// Feed notifier provider
final feedNotifierProvider = NotifierProvider<FeedNotifier, FeedState>(() => FeedNotifier());
