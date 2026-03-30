import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/author.dart';

// ---------------------------------------------------------------------------
// Mock current user
// ---------------------------------------------------------------------------

const _mockCurrentUser = Author(
  name: 'You',
  handle: 'currentuser',
  avatar: 'https://picsum.photos/seed/currentuser/100/100',
  verified: true,
  karma: 98,
  isOnline: true,
);

// ---------------------------------------------------------------------------
// UI State — active tab, current user, bar visibility
// ---------------------------------------------------------------------------

class UiState {
  final int activeTab;
  final Author? currentUser;
  final bool headerVisible;
  final bool bottomNavVisible;

  const UiState({
    this.activeTab = 0,
    this.currentUser,
    this.headerVisible = true,
    this.bottomNavVisible = true,
  });

  UiState copyWith({
    int? activeTab,
    Author? currentUser,
    bool? headerVisible,
    bool? bottomNavVisible,
  }) {
    return UiState(
      activeTab: activeTab ?? this.activeTab,
      currentUser: currentUser ?? this.currentUser,
      headerVisible: headerVisible ?? this.headerVisible,
      bottomNavVisible: bottomNavVisible ?? this.bottomNavVisible,
    );
  }
}

class UiStateNotifier extends Notifier<UiState> {
  @override
  UiState build() {
    return const UiState(
      activeTab: 0,
      currentUser: _mockCurrentUser,
      headerVisible: true,
      bottomNavVisible: true,
    );
  }

  void setActiveTab(int index) {
    state = state.copyWith(activeTab: index);
  }

  void setBarsVisible({required bool header, required bool bottomNav}) {
    state = state.copyWith(headerVisible: header, bottomNavVisible: bottomNav);
  }
}

final uiStateProvider = NotifierProvider<UiStateNotifier, UiState>(
  () => UiStateNotifier(),
);

// ---------------------------------------------------------------------------
// User Votes — feedItemId -> vote value (1 for up, -1 for down)
// ---------------------------------------------------------------------------

class UserVotesNotifier extends Notifier<Map<String, int>> {
  @override
  Map<String, int> build() => {};

  int toggle(String feedItemId, bool isUpvote) {
    final currentVote = state[feedItemId] ?? 0;
    int newVote;

    if (isUpvote) {
      newVote = currentVote == 1 ? 0 : 1;
    } else {
      newVote = currentVote == -1 ? 0 : -1;
    }

    final newVotes = Map<String, int>.from(state);
    if (newVote == 0) {
      newVotes.remove(feedItemId);
    } else {
      newVotes[feedItemId] = newVote;
    }
    state = newVotes;
    return newVote;
  }
}

final userVotesProvider = NotifierProvider<UserVotesNotifier, Map<String, int>>(
  () => UserVotesNotifier(),
);

// ---------------------------------------------------------------------------
// User Reposts — set of feedItemIds that user has reposted
// ---------------------------------------------------------------------------

class UserRepostsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void toggle(String feedItemId) {
    final newReposts = Set<String>.from(state);
    if (newReposts.contains(feedItemId)) {
      newReposts.remove(feedItemId);
    } else {
      newReposts.add(feedItemId);
    }
    state = newReposts;
  }

  bool hasReposted(String feedItemId) => state.contains(feedItemId);
}

final userRepostsProvider = NotifierProvider<UserRepostsNotifier, Set<String>>(
  () => UserRepostsNotifier(),
);

// ---------------------------------------------------------------------------
// Followed Handles — set of author handles that user follows
// ---------------------------------------------------------------------------

class FollowedHandlesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void toggle(String handle) {
    final newFollowed = Set<String>.from(state);
    if (newFollowed.contains(handle)) {
      newFollowed.remove(handle);
    } else {
      newFollowed.add(handle);
    }
    state = newFollowed;
  }

  bool isFollowing(String handle) => state.contains(handle);
}

final followedHandlesProvider =
    NotifierProvider<FollowedHandlesNotifier, Set<String>>(
      () => FollowedHandlesNotifier(),
    );
