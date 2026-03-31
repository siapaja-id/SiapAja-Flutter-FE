import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app_theme.dart';
import '../../../models/feed_item.dart';

import '../data/reply_generator.dart';
import '../providers.dart';
import '../widgets/feed_item_card.dart';
import '../widgets/reply_input.dart';
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

  // Bid state
  late int _bidAmount;
  int _defaultBid = 50;
  bool _isNegotiable = false;

  final TextEditingController _completionNotesCtrl = TextEditingController();
  final TextEditingController _bidPitchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Initialize postStack with the initial post (React: setPostStack([initialPost]))
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

        // Generate mock replies on first access
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
      _bidAmount = _defaultBid;
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
      Navigator.of(context).pop();
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

    // Auto-scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
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

  // ---- Bid handling (matches React handleAction + handleBidSubmit) ----

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

    // Scroll to bottom to show the bid
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
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
      _bidAmount = _defaultBid;
      _bidPitchCtrl.clear();
    });

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
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

  // ---- Modal sheets using official Flutter showModalBottomSheet ----

  void _showBidSheet(TaskData task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Submit Your Bid',
                          style: TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.05),
                          ),
                          icon: const Icon(
                            PhosphorIconsRegular.x,
                            size: 20,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Stepper
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Minus button
                          InkWell(
                            onTap: () => setModalState(
                              () =>
                                  _bidAmount = (_bidAmount - 5).clamp(1, 99999),
                            ),
                            borderRadius: BorderRadius.circular(20),
                            child: Ink(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                PhosphorIconsRegular.minus,
                                size: 28,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                          // Amount display
                          Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  'YOUR BID',
                                  style: TextStyle(
                                    color: AppColors.onSurfaceVariant,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 3,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '\$',
                                      style: TextStyle(
                                        color: AppColors.emerald,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 112,
                                      child: TextField(
                                        controller: TextEditingController(
                                          text: _bidAmount.toString(),
                                        ),
                                        keyboardType: TextInputType.number,
                                        onChanged: (val) {
                                          final parsed = int.tryParse(val);
                                          if (parsed != null) {
                                            setModalState(
                                              () => _bidAmount = parsed,
                                            );
                                          }
                                        },
                                        style: const TextStyle(
                                          color: AppColors.onSurface,
                                          fontSize: 48,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: -2,
                                        ),
                                        textAlign: TextAlign.center,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          filled: false,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Plus button
                          InkWell(
                            onTap: () => setModalState(
                              () => _bidAmount = _bidAmount + 5,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            child: Ink(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                PhosphorIconsRegular.plus,
                                size: 28,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Quick bid adjustments
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ActionChip(
                          onPressed: () => setModalState(
                            () =>
                                _bidAmount = (_bidAmount - 15).clamp(1, 99999),
                          ),
                          avatar: const Icon(
                            PhosphorIconsRegular.trendDown,
                            size: 14,
                            color: AppColors.onSurface,
                          ),
                          label: const Text('Down Bid'),
                          backgroundColor: Colors.white.withOpacity(0.05),
                          labelStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ActionChip(
                          onPressed: () =>
                              setModalState(() => _bidAmount = _defaultBid),
                          label: const Text('Match Original'),
                          backgroundColor: Colors.white.withOpacity(0.05),
                          labelStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ActionChip(
                          onPressed: () =>
                              setModalState(() => _bidAmount = _bidAmount + 15),
                          avatar: const Icon(
                            PhosphorIconsRegular.trendUp,
                            size: 14,
                            color: AppColors.onSurface,
                          ),
                          label: const Text('Up Bid'),
                          backgroundColor: Colors.white.withOpacity(0.05),
                          labelStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Pitch textarea
                    TextField(
                      controller: _bidPitchCtrl,
                      style: const TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Why should they choose you? (Optional)',
                        hintStyle: TextStyle(
                          color: AppColors.onSurfaceVariant.withOpacity(0.3),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      maxLines: 4,
                      minLines: 4,
                    ),
                    const SizedBox(height: 20),
                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _handleBidSubmit(
                            task,
                            _bidAmount,
                            _bidPitchCtrl.text.trim(),
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.emerald,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          shadowColor: AppColors.emerald.withOpacity(0.2),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(PhosphorIconsRegular.paperPlaneTilt, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'PLACE BID',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showCompleteSheet(TaskData task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Complete Task',
                    style: TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.05),
                    ),
                    icon: const Icon(
                      PhosphorIconsRegular.x,
                      size: 20,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Notes textarea
              TextField(
                controller: _completionNotesCtrl,
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Add completion notes or proof of work...',
                  hintStyle: TextStyle(
                    color: AppColors.onSurfaceVariant.withOpacity(0.3),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                maxLines: 5,
                minLines: 5,
              ),
              const SizedBox(height: 16),
              // Upload proof button
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.onSurfaceVariant,
                  side: BorderSide(color: Colors.white.withOpacity(0.2)),
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      PhosphorIconsRegular.camera,
                      size: 24,
                      color: AppColors.onSurfaceVariant.withOpacity(0.5),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Upload Proof Image',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _handleCompleteTask(task);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emerald,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: AppColors.emerald.withOpacity(0.2),
                  ),
                  child: const Text(
                    'SUBMIT COMPLETION',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showReviewSheet(TaskData task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) {
        int reviewRating = 5;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Review Work',
                        style: TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.05),
                        ),
                        icon: const Icon(
                          PhosphorIconsRegular.x,
                          size: 20,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Rate the worker',
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Star rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      return InkWell(
                        onTap: () => setModalState(() => reviewRating = i + 1),
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            i < reviewRating
                                ? PhosphorIconsFill.star
                                : PhosphorIconsRegular.star,
                            size: 32,
                            color: i < reviewRating
                                ? const Color(0xFFFBBF24)
                                : Colors.white24,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  // Release button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _handleReviewTask(task, reviewRating);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emerald,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        shadowColor: AppColors.emerald.withOpacity(0.2),
                      ),
                      child: const Text(
                        'RELEASE PAYMENT',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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

    // DetailHeader title
    final headerTitle = _postStack.length > 1
        ? 'Thread'
        : currentItem is TaskData
        ? 'Task Details'
        : 'Thread';

    // Subtitle when replying to a parent
    final headerSubtitle = _postStack.length > 1
        ? 'Replying to @${_postStack[_postStack.length - 2].author.handle}'
        : null;

    final isTask = currentItem is TaskData;

    final content = Column(
      children: [
        if (!isTask)
          _DetailHeader(
            title: headerTitle,
            subtitle: headerSubtitle,
            contentType: 'Post',
            onBack: _handleBack,
          ),
        Expanded(
          child: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              if (isTask)
                SliverAppBar(
                  pinned: true,
                  floating: false,
                  expandedHeight: 200,
                  backgroundColor: AppColors.surfaceContainerHigh,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsetsDirectional.only(
                      start: 56,
                      bottom: 14,
                    ),
                    title: Row(
                      children: [
                        Flexible(
                          child: Text(
                            currentItem.title,
                            style: const TextStyle(
                              color: AppColors.onSurface,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.2),
                            ),
                          ),
                          child: Text(
                            currentItem.category.toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.emerald.withOpacity(0.12),
                                AppColors.primary.withOpacity(0.08),
                                AppColors.indigo.withOpacity(0.04),
                                AppColors.surfaceContainerHigh,
                              ],
                              stops: const [0.0, 0.35, 0.65, 1.0],
                            ),
                          ),
                        ),
                        Positioned(
                          top: -20,
                          right: -20,
                          child: Icon(
                            _getIconForTaskType(currentItem.iconType),
                            size: 160,
                            color: Colors.white.withOpacity(0.03),
                          ),
                        ),
                        Positioned(
                          bottom: 56,
                          left: 20,
                          right: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentItem.title,
                                style: const TextStyle(
                                  color: AppColors.onSurface,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  height: 1.2,
                                  letterSpacing: -0.5,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.glassTint,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: AppColors.glassBorder,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _getIconForTaskType(
                                            currentItem.iconType,
                                          ),
                                          size: 12,
                                          color: AppColors.primary,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          currentItem.category.toUpperCase(),
                                          style: const TextStyle(
                                            color: AppColors.onSurfaceVariant,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    currentItem.price,
                                    style: const TextStyle(
                                      color: AppColors.onSurface,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    collapseMode: CollapseMode.pin,
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.glassTint,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.glassBorder),
                          ),
                          child: IconButton(
                            onPressed: _handleBack,
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              PhosphorIconsRegular.arrowLeft,
                              size: 20,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  actions: [_buildTaskStats()],
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
                      style: const TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
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
                  child: _buildEmptyState(currentItem, isCreator),
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

  Widget _buildTaskStats() {
    final views =
        '${10 + widget.postId.hashCode % 90}.${widget.postId.hashCode % 9}k';
    final viewing = 12 + (widget.postId.hashCode % 40).abs();

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.glassTint,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  PhosphorIconsRegular.eye,
                  size: 14,
                  color: AppColors.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  views,
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.emerald,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.emerald.withOpacity(0.6),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '$viewing',
                  style: const TextStyle(
                    color: AppColors.emerald,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForTaskType(TaskIconType type) => switch (type) {
    TaskIconType.palette => PhosphorIconsRegular.palette,
    TaskIconType.code => PhosphorIconsRegular.code,
    TaskIconType.car => PhosphorIconsRegular.car,
    TaskIconType.truck => PhosphorIconsRegular.truck,
    TaskIconType.writing => PhosphorIconsRegular.pencilSimple,
    TaskIconType.repair => PhosphorIconsRegular.wrench,
    TaskIconType.package => PhosphorIconsRegular.package,
    TaskIconType.location => PhosphorIconsRegular.mapPin,
  };

  Widget _buildEmptyState(FeedItem item, bool isCreator) {
    final isTask = item is TaskData;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: Column(
        children: [
          // Glowing circle with icon
          SizedBox(
            width: 96,
            height: 96,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glow
                Container(
                  width: 256,
                  height: 256,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(0.05),
                  ),
                ),
                // Circle
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      isTask
                          ? PhosphorIconsFill.sparkle
                          : PhosphorIconsRegular.chatTeardropDots,
                      size: 36,
                      color: isTask ? AppColors.emerald : AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Title
          Text(
            isTask ? 'No bids yet' : 'Quiet in here...',
            style: const TextStyle(
              color: AppColors.onSurface,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          // Description
          Text(
            isTask
                ? isCreator
                      ? 'Your task is live! Check back soon for bids from interested workers.'
                      : 'This task is waiting for a hero. Submit your bid and secure this opportunity!'
                : 'Be the first to share your thoughts and start the conversation.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          // CTA button
          if (!isCreator && isTask)
            OutlinedButton.icon(
              onPressed: () => _showBidSheet(item),
              icon: const Icon(
                PhosphorIconsFill.sparkle,
                size: 14,
                color: AppColors.emerald,
              ),
              label: const Text(
                'PLACE FIRST BID',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.emerald,
                side: BorderSide(color: AppColors.emerald.withOpacity(0.2)),
                backgroundColor: AppColors.emerald.withOpacity(0.1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            )
          else if (!isTask)
            OutlinedButton.icon(
              onPressed: () {
                // Focus the reply text field
              },
              icon: const Icon(
                PhosphorIconsRegular.chatTeardropDots,
                size: 14,
                color: AppColors.primary,
              ),
              label: const Text(
                'WRITE A REPLY',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary.withOpacity(0.2)),
                backgroundColor: AppColors.primary.withOpacity(0.1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(FeedItem item, bool isCreator, currentUser) {
    if (item is TaskData) {
      final tStatus = item.status;
      final isAssignedToMe = item.assignedWorker?.handle == currentUser?.handle;

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.glassTint,
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.05)),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 40,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Textarea (above action, matches React)
              if (tStatus == TaskStatus.open ||
                  tStatus == TaskStatus.assigned ||
                  tStatus == TaskStatus.inProgress)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (val) => setState(() => _replyText = val),
                          onSubmitted: (_) => _handleReply(item),
                          style: const TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Message or ask a question...',
                            hintStyle: TextStyle(
                              color: AppColors.onSurfaceVariant.withOpacity(
                                0.5,
                              ),
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          maxLines: null,
                          minLines: 1,
                        ),
                      ),
                      if (_replyText.trim().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4, right: 4),
                          child: FilledButton(
                            onPressed: () => _handleReply(item),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.primaryForeground,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Send',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2, right: 2),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              PhosphorIconsRegular.arrowsOutSimple,
                              size: 18,
                              color: AppColors.onSurfaceVariant,
                            ),
                            padding: const EdgeInsets.all(10),
                            constraints: const BoxConstraints(),
                          ),
                        ),
                    ],
                  ),
                ),
              // Action UI
              _buildTaskActionUI(item, isCreator, isAssignedToMe),
            ],
          ),
        ),
      );
    }

    // Social post — use ReplyInput
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

  Widget _buildTaskActionUI(
    TaskData task,
    bool isCreator,
    bool isAssignedToMe,
  ) {
    final tStatus = task.status;

    if (isCreator) {
      // Creator actions (matches React text labels)
      if (tStatus == TaskStatus.open) {
        return _buildActionLabel('WAITING FOR BIDS...');
      } else if (tStatus == TaskStatus.assigned) {
        return _buildActionLabel(
          'AWAITING WORKER TO START',
          color: AppColors.emerald,
          icon: PhosphorIconsRegular.checkCircle,
        );
      } else if (tStatus == TaskStatus.inProgress) {
        return _buildActionLabel(
          'TASK IN PROGRESS',
          color: AppColors.emerald,
          icon: PhosphorIconsFill.sparkle,
        );
      } else if (tStatus == TaskStatus.completed) {
        return _buildActionButton(
          'REVIEW & RELEASE PAYMENT',
          color: AppColors.emerald,
          onTap: () => _showReviewSheet(task),
        );
      } else if (tStatus == TaskStatus.finished) {
        return _buildActionLabel('TASK FINISHED');
      }
    } else {
      // Non-creator actions
      if (tStatus == TaskStatus.open) {
        if (!_isNegotiable) {
          // Fixed price: "Bid" ghost + "Accept Instantly" primary
          return Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'BID',
                  color: Colors.white.withOpacity(0.05),
                  textColor: AppColors.onSurface,
                  borderColor: Colors.white.withOpacity(0.1),
                  onTap: () => _showBidSheet(task),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButton(
                  'ACCEPT INSTANTLY',
                  color: AppColors.primary,
                  onTap: () => _handleAcceptInstantly(task),
                ),
              ),
            ],
          );
        } else {
          // Negotiable: single "Submit Bid"
          return _buildActionButton(
            'SUBMIT BID',
            color: AppColors.primary,
            onTap: () => _showBidSheet(task),
          );
        }
      } else if (tStatus == TaskStatus.assigned) {
        if (isAssignedToMe) {
          return _buildActionButton(
            'START TASK',
            color: AppColors.emerald,
            onTap: () => _handleStartTask(task),
          );
        } else {
          return _buildActionLabel('ASSIGNED TO SOMEONE ELSE');
        }
      } else if (tStatus == TaskStatus.inProgress) {
        if (isAssignedToMe) {
          return _buildActionButton(
            'MARK AS COMPLETED',
            color: AppColors.emerald,
            onTap: () => _showCompleteSheet(task),
          );
        } else {
          return _buildActionLabel('IN PROGRESS BY ANOTHER WORKER');
        }
      } else if (tStatus == TaskStatus.completed) {
        if (isAssignedToMe) {
          return _buildActionLabel(
            'WAITING FOR REVIEW...',
            borderColor: Colors.white.withOpacity(0.1),
          );
        } else {
          return _buildActionLabel('COMPLETED');
        }
      } else if (tStatus == TaskStatus.finished) {
        if (isAssignedToMe) {
          return _buildActionLabel(
            'PAYMENT RECEIVED',
            color: AppColors.emerald,
            icon: PhosphorIconsRegular.checkCircle,
          );
        } else {
          return _buildActionLabel('TASK FINISHED');
        }
      }
    }

    return const SizedBox.shrink();
  }

  Widget _buildActionLabel(
    String text, {
    Color? color,
    IconData? icon,
    Color? borderColor,
  }) {
    final labelColor = color ?? AppColors.onSurfaceVariant;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color != null
            ? color.withOpacity(0.1)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              borderColor ??
              (color != null
                  ? color.withOpacity(0.2)
                  : Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: labelColor),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: TextStyle(
              color: labelColor,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String text, {
    required Color color,
    Color? textColor,
    Color? borderColor,
    required VoidCallback onTap,
  }) {
    final bool isPrimaryColor =
        color == AppColors.primary || color == AppColors.emerald;

    return SizedBox(
      width: double.infinity,
      child: isPrimaryColor
          ? ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: color.withOpacity(0.3),
              ),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            )
          : OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: textColor ?? AppColors.onSurface,
                backgroundColor: color,
                side: borderColor != null
                    ? BorderSide(color: borderColor)
                    : BorderSide.none,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: textColor ?? AppColors.onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ),
    );
  }
}

// ---- DetailHeader matching React exactly ----

class _DetailHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String contentType;
  final VoidCallback onBack;

  const _DetailHeader({
    required this.title,
    this.subtitle,
    required this.contentType,
    required this.onBack,
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
          // Back button
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
          // Title + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Type badge
                    Chip(
                      label: Text(contentType),
                      labelStyle: const TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                      backgroundColor: Colors.white.withOpacity(0.05),
                      side: BorderSide(color: Colors.white.withOpacity(0.1)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 0,
                      ),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          // Stats (view count + currently viewing) — hidden on small screens in React, shown in Flutter
          _buildStats(),
        ],
      ),
    );
  }

  Widget _buildStats() {
    final views =
        '${(10 + title.hashCode % 90).abs()}.${(title.hashCode % 9).abs()}k';
    final viewing = 12 + (title.hashCode % 40).abs();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          const Icon(
            PhosphorIconsRegular.eye,
            size: 14,
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            views,
            style: const TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.emerald,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.emerald.withOpacity(0.6),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '$viewing',
            style: const TextStyle(
              color: AppColors.emerald,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
