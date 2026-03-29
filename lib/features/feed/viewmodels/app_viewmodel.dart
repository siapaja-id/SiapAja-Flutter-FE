import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/author.dart';

/// App state for managing global UI state (tab, votes, reposts, follows)
class AppState {
  final int activeTab;
  final Author? currentUser;
  final Map<String, int>
  userVotes; // feedItemId -> vote value (1 for up, -1 for down)
  final Set<String> userReposts; // feedItemIds that user has reposted
  final Set<String> followedHandles; // author handles that user follows
  final bool headerVisible;
  final bool bottomNavVisible;

  const AppState({
    this.activeTab = 0,
    this.currentUser,
    this.userVotes = const {},
    this.userReposts = const {},
    this.followedHandles = const {},
    this.headerVisible = true,
    this.bottomNavVisible = true,
  });

  AppState copyWith({
    int? activeTab,
    Author? currentUser,
    Map<String, int>? userVotes,
    Set<String>? userReposts,
    Set<String>? followedHandles,
    bool? headerVisible,
    bool? bottomNavVisible,
  }) {
    return AppState(
      activeTab: activeTab ?? this.activeTab,
      currentUser: currentUser ?? this.currentUser,
      userVotes: userVotes ?? this.userVotes,
      userReposts: userReposts ?? this.userReposts,
      followedHandles: followedHandles ?? this.followedHandles,
      headerVisible: headerVisible ?? this.headerVisible,
      bottomNavVisible: bottomNavVisible ?? this.bottomNavVisible,
    );
  }
}

/// App Notifier - manages global app state
class AppNotifier extends Notifier<AppState> {
  @override
  AppState build() {
    return const AppState(
      activeTab: 0,
      currentUser: null,
      headerVisible: true,
      bottomNavVisible: true,
    );
  }

  /// Set the active tab index
  void setActiveTab(int index) {
    state = state.copyWith(activeTab: index);
  }

  /// Toggle vote on a feed item
  /// Returns the new vote value (0 = no vote, 1 = upvote, -1 = downvote)
  int toggleVote(String feedItemId, bool isUpvote) {
    final currentVote = state.userVotes[feedItemId] ?? 0;
    int newVote;

    if (isUpvote) {
      newVote = currentVote == 1 ? 0 : 1;
    } else {
      newVote = currentVote == -1 ? 0 : -1;
    }

    final newVotes = Map<String, int>.from(state.userVotes);
    if (newVote == 0) {
      newVotes.remove(feedItemId);
    } else {
      newVotes[feedItemId] = newVote;
    }

    state = state.copyWith(userVotes: newVotes);
    return newVote;
  }

  /// Toggle repost on a feed item
  void toggleRepost(String feedItemId) {
    final newReposts = Set<String>.from(state.userReposts);
    if (newReposts.contains(feedItemId)) {
      newReposts.remove(feedItemId);
    } else {
      newReposts.add(feedItemId);
    }
    state = state.copyWith(userReposts: newReposts);
  }

  /// Check if user has reposted a feed item
  bool hasReposted(String feedItemId) {
    return state.userReposts.contains(feedItemId);
  }

  /// Get user's vote on a feed item
  int getUserVote(String feedItemId) {
    return state.userVotes[feedItemId] ?? 0;
  }

  /// Toggle follow on an author
  void toggleFollow(String handle) {
    final newFollowed = Set<String>.from(state.followedHandles);
    if (newFollowed.contains(handle)) {
      newFollowed.remove(handle);
    } else {
      newFollowed.add(handle);
    }
    state = state.copyWith(followedHandles: newFollowed);
  }

  /// Check if user is following an author
  bool isFollowing(String handle) {
    return state.followedHandles.contains(handle);
  }

  /// Set header and bottom nav visibility (for scroll-to-hide behavior)
  void setBarsVisible({required bool header, required bool bottomNav}) {
    state = state.copyWith(headerVisible: header, bottomNavVisible: bottomNav);
  }
}

/// App notifier provider
final appNotifierProvider = NotifierProvider<AppNotifier, AppState>(
  () => AppNotifier(),
);
