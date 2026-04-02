import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app_theme.dart';
import '../../../models/feed_item.dart';
import '../../../shared/utils/scroll_helpers.dart';
import '../../../shared/settings_provider.dart';
import '../../../shared/widgets/tag_pill.dart';
import '../../../shared/widgets/view_stats_badge.dart';

import '../data/reply_generator.dart';
import '../providers.dart';
import '../widgets/feed_item_card.dart';
import '../widgets/kanban_column_widget.dart';
import '../widgets/reply_input.dart';
import 'post_detail/empty_replies_state.dart';
import 'post_detail/bid_sheet.dart';
import 'post_detail/completion_sheet.dart';
import 'post_detail/review_sheet.dart';
import 'post_detail/task_action_footer.dart';
import 'post_detail/task_sliver_app_bar.dart';
import 'task_main_content.dart';

/// Main post detail page — matches React PostDetail.Page.tsx exactly.
class PostDetailPage extends ConsumerStatefulWidget {
  final String postId;
  final bool inKanban;

  const PostDetailPage({
    super.key,
    required this.postId,
    this.inKanban = false,
  });

  @override
  ConsumerState<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends ConsumerState<PostDetailPage> {
  late final ScrollController _scrollController;
  final List<FeedItem> _postStack = [];
  String _replyText = '';

  int _defaultBid = 50;
  bool _isNegotiable = false;

  final TextEditingController _completionNotesCtrl = TextEditingController();
  final TextEditingController _bidPitchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final feedState = ref.read(feedNotifierProvider);
      final initialPost = feedState.feedItems.cast<FeedItem?>().firstWhere(
        (item) => item?.id == widget.postId,
        orElse: () => null,
      );
      if (initialPost != null) {
        setState(() {
          _postStack.add(initialPost);
          _initBidState(initialPost);
        });

        if (!feedState.replies.containsKey(widget.postId)) {
          final isTask = initialPost is TaskData;
          final replies = getReplies(widget.postId, isTask: isTask);
          ref
              .read(feedNotifierProvider.notifier)
              .setReplies(widget.postId, replies);
        }
      }
    });
  }

  void _initBidState(FeedItem post) {
    if (post is TaskData) {
      final priceStr = post.price;
      final parsed = int.tryParse(priceStr.replaceAll(RegExp(r'[^0-9]'), ''));
      _defaultBid = parsed ?? 50;
      _isNegotiable = priceStr.contains('-');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _completionNotesCtrl.dispose();
    _bidPitchCtrl.dispose();
    super.dispose();
  }

  FeedItem get _currentPost =>
      _postStack.isNotEmpty ? _postStack.last : _postStack.first;

  void _pushReply(FeedItem reply) {
    setState(() => _postStack.add(reply));
    final feedState = ref.read(feedNotifierProvider);
    if (!feedState.replies.containsKey(reply.id)) {
      final isTask = reply is TaskData;
      final replies = getReplies(reply.id, isTask: isTask);
      ref.read(feedNotifierProvider.notifier).setReplies(reply.id, replies);
    }
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
    );
  }

  void _handleBack() {
    if (_postStack.length > 1) {
      setState(() => _postStack.removeLast());
    } else if (widget.inKanban) {
      final kanbanCtx = KanbanColumnContext.of(context);
      if (kanbanCtx != null) {
        ref.read(kanbanProvider.notifier).closeColumn(kanbanCtx.columnId);
      } else {
        Navigator.of(context).pop();
      }
    } else {
      context.pop();
    }
  }

  void _handleReply(FeedItem parent) {
    if (_replyText.trim().isEmpty) return;
    final currentUser = ref.read(uiStateProvider).currentUser;
    if (currentUser == null) return;

    final reply = SocialPostData(
      id: 'reply-${DateTime.now().millisecondsSinceEpoch}',
      author: currentUser,
      content: _replyText,
      timestamp: 'Just now',
      replies: 0,
      reposts: 0,
      shares: 0,
      votes: 0,
    );

    ref.read(feedNotifierProvider.notifier).addReply(parent.id, reply);
    _incrementReplyCount(parent);

    setState(() => _replyText = '');

    scrollToBottom(_scrollController);
  }

  void _incrementReplyCount(FeedItem parent) {
    FeedItem? updated;
    if (parent is SocialPostData) {
      updated = parent.copyWith(replies: parent.replies + 1);
    } else if (parent is TaskData) {
      updated = parent.copyWith(replies: parent.replies + 1);
    } else if (parent is EditorialData) {
      updated = parent.copyWith(replies: parent.replies + 1);
    }
    if (updated != null && updated != parent) {
      ref
          .read(feedNotifierProvider.notifier)
          .updateFeedItem(parent.id, updated);
    }
  }

  void _handleAcceptInstantly(TaskData task) {
    final currentUser = ref.read(uiStateProvider).currentUser;
    if (currentUser == null) return;

    final bid = SocialPostData(
      id: 'bid-${DateTime.now().millisecondsSinceEpoch}',
      author: currentUser,
      content: "I'll take it! I'm available to complete this right away.",
      timestamp: 'Just now',
      isBid: true,
      bidAmount: task.price,
      bidStatus: BidStatus.accepted,
      replies: 0,
      reposts: 0,
      shares: 0,
      votes: 0,
    );

    ref.read(feedNotifierProvider.notifier).addReply(task.id, bid);
    final updated = task.copyWith(
      status: TaskStatus.assigned,
      assignedWorker: currentUser,
      acceptedBidAmount: task.price,
    );
    ref.read(feedNotifierProvider.notifier).updateFeedItem(task.id, updated);

    scrollToBottom(_scrollController);
  }

  void _handleBidSubmit(TaskData task, int bidAmount, String pitch) {
    final currentUser = ref.read(uiStateProvider).currentUser;
    if (currentUser == null) return;

    final bid = SocialPostData(
      id: 'bid-${DateTime.now().millisecondsSinceEpoch}',
      author: currentUser,
      content: pitch.isNotEmpty ? pitch : "I can help with this task!",
      timestamp: 'Just now',
      isBid: true,
      bidAmount: '\$${bidAmount.toStringAsFixed(2)}',
      bidStatus: BidStatus.pending,
      replies: 0,
      reposts: 0,
      shares: 0,
      votes: 0,
    );

    ref.read(feedNotifierProvider.notifier).addReply(task.id, bid);
    _incrementReplyCount(task);

    setState(() {
      _replyText = '';
      _bidPitchCtrl.clear();
    });

    scrollToBottom(_scrollController);
  }

  void _handleStartTask(TaskData task) {
    final updated = task.copyWith(status: TaskStatus.inProgress);
    ref.read(feedNotifierProvider.notifier).updateFeedItem(task.id, updated);
  }

  void _handleCompleteTask(TaskData task) {
    final updated = task.copyWith(status: TaskStatus.completed);
    ref.read(feedNotifierProvider.notifier).updateFeedItem(task.id, updated);
  }

  void _handleReviewTask(TaskData task, int rating) {
    final updated = task.copyWith(status: TaskStatus.finished);
    ref.read(feedNotifierProvider.notifier).updateFeedItem(task.id, updated);
  }

  @override
  Widget build(BuildContext context) {
    final textSize = ref.watch(settingsProvider.select((s) => s.textSize));
    final feedState = ref.watch(feedNotifierProvider);
    final currentUser = ref.watch(uiStateProvider).currentUser;

    if (_postStack.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    final currentItem = _currentPost;
    final replies = feedState.replies[currentItem.id] ?? [];
    final isCreator = currentUser?.handle == currentItem.author.handle;

    final headerTitle = _postStack.length > 1
        ? 'Thread'
        : currentItem is TaskData
        ? 'Task Details'
        : 'Thread';

    final headerSubtitle = _postStack.length > 1
        ? 'Replying to @${_postStack[_postStack.length - 2].author.handle}'
        : null;

    final isTask = currentItem is TaskData;

    final viewCount = 10000 + (widget.postId.hashCode % 90000).abs();
    final viewing = 12 + (widget.postId.hashCode % 40).abs();

    final content = Column(
      children: [
        if (!isTask)
          _DetailHeader(
            title: headerTitle,
            subtitle: headerSubtitle,
            contentType: 'Post',
            onBack: _handleBack,
            textSize: textSize,
          ),
        Expanded(
          child: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              if (isTask)
                TaskSliverAppBar(
                  task: currentItem,
                  onBack: _handleBack,
                  viewCount: viewCount,
                  viewingNow: viewing,
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
              if (_postStack.length > 1)
                SliverToBoxAdapter(
                  child: Column(
                    children: _postStack
                        .sublist(0, _postStack.length - 1)
                        .asMap()
                        .entries
                        .map((entry) {
                          return FeedItemCard(
                            item: entry.value,
                            isParent: true,
                            hasLineBelow: true,
                            onClick: () {
                              setState(() {
                                _postStack.removeRange(
                                  entry.key + 1,
                                  _postStack.length,
                                );
                              });
                            },
                          );
                        })
                        .toList(),
                  ),
                ),
              SliverToBoxAdapter(
                child: isTask
                    ? TaskMainContent(data: currentItem)
                    : FeedItemCard(
                        item: currentItem,
                        isMain: true,
                        hasLineBelow: replies.isNotEmpty,
                      ),
              ),
              if (replies.isNotEmpty &&
                  !(currentItem is SocialPostData &&
                      currentItem.threadCount != null &&
                      currentItem.threadCount! > 1))
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.white.withOpacity(0.05)),
                        bottom: BorderSide(
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                    child: Text(
                      currentItem is TaskData ? 'DISCUSSION & BIDS' : 'REPLIES',
                      style: AppTheme.scaled(
                        textSize: textSize,
                        multiplier: AppTheme.mlg,
                        weight: FontWeight.w900,
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                ),
              if (replies.isNotEmpty)
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final reply = replies[index];
                    return FeedItemCard(
                      item: reply,
                      hasLineBelow: index < replies.length - 1,
                      onClick: () => _pushReply(reply),
                    );
                  }, childCount: replies.length),
                )
              else
                SliverToBoxAdapter(
                  child: EmptyRepliesState(
                    item: currentItem,
                    isCreator: isCreator,
                    onBidClick: isTask
                        ? () => BidSheet.show(
                            context: context,
                            task: currentItem,
                            defaultBid: _defaultBid,
                            pitchCtrl: _bidPitchCtrl,
                            onSubmit: (bidAmount, pitch) =>
                                _handleBidSubmit(currentItem, bidAmount, pitch),
                          )
                        : null,
                    onFocusReply: !isTask ? () {} : null,
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 180)),
            ],
          ),
        ),
        _buildBottomBar(currentItem, isCreator, currentUser),
      ],
    );

    if (widget.inKanban) {
      return content;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: Colors.white.withOpacity(0.05)),
            right: BorderSide(color: Colors.white.withOpacity(0.05)),
          ),
        ),
        child: SafeArea(child: content),
      ),
    );
  }

  Widget _buildBottomBar(FeedItem item, bool isCreator, currentUser) {
    if (item is TaskData) {
      final isAssignedToMe = item.assignedWorker?.handle == currentUser?.handle;

      return TaskActionFooter(
        task: item,
        isCreator: isCreator,
        isAssignedToMe: isAssignedToMe,
        isNegotiable: _isNegotiable,
        replyText: _replyText,
        onReplyChanged: (val) => setState(() => _replyText = val),
        onSend: () => _handleReply(item),
        onBid: () => BidSheet.show(
          context: context,
          task: item,
          defaultBid: _defaultBid,
          pitchCtrl: _bidPitchCtrl,
          onSubmit: (bidAmount, pitch) =>
              _handleBidSubmit(item, bidAmount, pitch),
        ),
        onAccept: () => _handleAcceptInstantly(item),
        onStartTask: () => _handleStartTask(item),
        onShowComplete: () => CompletionSheet.show(
          context: context,
          task: item,
          notesCtrl: _completionNotesCtrl,
          onComplete: () => _handleCompleteTask(item),
        ),
        onShowReview: () => ReviewSheet.show(
          context: context,
          task: item,
          onReview: (rating) => _handleReviewTask(item, rating),
        ),
      );
    }

    return ReplyInput(
      handle: item.author.handle,
      parentId: item.id,
      parentItem: item,
      onSend: (text) {
        setState(() => _replyText = text);
        _handleReply(item);
      },
    );
  }
}

class _DetailHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String contentType;
  final VoidCallback onBack;
  final TextSize textSize;

  const _DetailHeader({
    required this.title,
    this.subtitle,
    required this.contentType,
    required this.onBack,
    required this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withOpacity(0.95),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            style: IconButton.styleFrom(
              backgroundColor: Colors.black.withOpacity(0.2),
            ),
            icon: const Icon(
              PhosphorIconsRegular.arrowLeft,
              size: 20,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: AppTheme.scaled(
                          textSize: textSize,
                          multiplier: AppTheme.m15,
                          weight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    TagPill.ghost(
                      label: contentType,
                      fontSize: 9,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 0,
                      ),
                    ),
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: AppTheme.scaled(
                      textSize: textSize,
                      multiplier: AppTheme.mlg,
                      weight: FontWeight.w500,
                      color: AppColors.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          _buildStats(),
        ],
      ),
    );
  }

  Widget _buildStats() {
    final viewCount = 10000 + (title.hashCode % 90000).abs();
    final viewing = 12 + (title.hashCode % 40).abs();

    return ViewStatsBadge(viewCount: viewCount, viewingNow: viewing);
  }
}
