import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app_theme.dart';
import '../../../models/feed_item.dart';
import '../../../shared/widgets/user_avatar.dart';

const int _maxChars = 280;

/// Fullscreen reply composition — matches React CreatePostPage exactly.
///
/// React: motion.div slide-up from bottom, fixed inset, glass header,
/// reply context with avatar + vertical line, multi-thread, toolbar,
/// circular char counter, "Everyone can reply" footer.
class CreateReplyPage extends StatefulWidget {
  final FeedItem? parentItem;

  const CreateReplyPage({super.key, this.parentItem});

  @override
  State<CreateReplyPage> createState() => _CreateReplyPageState();
}

class _CreateReplyPageState extends State<CreateReplyPage>
    with SingleTickerProviderStateMixin {
  final List<_ThreadData> _threads = [_ThreadData()];
  int _activeIndex = 0;
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    // React: damping 25, stiffness 200 — approximated with easeOutCubic
    _slideAnim = Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
        );
    _fadeAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    for (final t in _threads) {
      t.controller.dispose();
    }
    _scrollController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onBack() {
    _animController.reverse().then((_) {
      if (mounted) Navigator.of(context).pop();
    });
  }

  void _addThread() {
    setState(() {
      _threads.add(_ThreadData());
      _activeIndex = _threads.length - 1;
    });
    // Scroll to bottom after frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _removeThread(int index) {
    if (_threads.length <= 1) return;
    setState(() {
      _threads[index].controller.dispose();
      _threads.removeAt(index);
      if (_activeIndex >= _threads.length) {
        _activeIndex = _threads.length - 1;
      }
    });
  }

  void _handlePost() {
    final content = _threads
        .map((t) => t.controller.text.trim())
        .where((s) => s.isNotEmpty)
        .join('\n\n');
    if (content.isEmpty) return;
    Navigator.of(context).pop(content);
  }

  double _calculateProgress(String text) {
    return (text.length / _maxChars * 100).clamp(0.0, 100.0);
  }

  // ---------------------------------------------------------------------------
  // Reply context (parent item shown above thread area)
  // ---------------------------------------------------------------------------

  String _getReplyContextContent() {
    final item = widget.parentItem;
    if (item is SocialPostData) return item.content;
    if (item is TaskData) return item.description ?? item.title;
    if (item is EditorialData) return item.title;
    return '';
  }

  String _getReplyContextType() {
    final item = widget.parentItem;
    if (item is TaskData) return 'task';
    if (item is EditorialData) return 'editorial';
    return 'social';
  }

  String? _getTaskTitle() {
    final item = widget.parentItem;
    if (item is TaskData) return item.title;
    return null;
  }

  String? _getTaskPrice() {
    final item = widget.parentItem;
    if (item is TaskData) return item.price;
    return null;
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final item = widget.parentItem;
    final hasContext = item != null;

    return AnimatedBuilder(
      animation: _animController,
      builder: (context, _) {
        return SlideTransition(
          position: _slideAnim,
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Scaffold(
              backgroundColor: AppColors.background,
              // React: max-w-2xl mx-auto border-x border-white/5
              body: Container(
                constraints: const BoxConstraints(maxWidth: 672), // max-w-2xl
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(color: AppColors.border),
                    right: BorderSide(color: AppColors.border),
                  ),
                ),
                child: Column(
                  children: [
                    // ---- HEADER ----
                    _buildHeader(),
                    // ---- CONTENT (scrollable) ----
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 160),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 672),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Reply context
                                if (hasContext) _buildReplyContext(item),
                                // Thread blocks
                                for (int i = 0; i < _threads.length; i++)
                                  _buildThreadBlock(i),
                                // "Add to thread" trigger
                                if (_threads.last.controller.text.isNotEmpty &&
                                    _activeIndex != _threads.length - 1)
                                  _buildAddThreadTrigger(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // ---- FLOATING FOOTER ----
              floatingActionButton: _buildFloatingFooter(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------------------------
  // React: <header className="flex items-center justify-between px-4 h-16
  //   border-b border-white/5 glass sticky top-0 z-20">

  Widget _buildHeader() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.glassTint,
        border: const Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          // Close button — React: <X size={24} />
          GestureDetector(
            onTap: _onBack,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                PhosphorIconsRegular.x,
                size: 24,
                color: AppColors.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 4),
          // Title — React: text-sm font-bold uppercase tracking-widest opacity-50
          Expanded(
            child: Text(
              widget.parentItem != null ? 'REPLY' : 'NEW THREAD',
              style: const TextStyle(
                color: AppColors.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 3.0, // tracking-widest
                height: 1.0,
              ),
            ),
          ),
          // Drafts — React: text-primary font-bold text-sm px-3 py-1.5 rounded-full
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Drafts',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Post / Reply button — React: bg-primary rounded-full shadow-lg
          //   font-black text-sm uppercase tracking-widest
          _buildPostButton(),
        ],
      ),
    );
  }

  Widget _buildPostButton() {
    final hasText = _threads.any((t) => t.controller.text.trim().isNotEmpty);
    final label = widget.parentItem != null ? 'Reply' : 'Post';

    return GestureDetector(
      onTap: hasText ? _handlePost : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: hasText ? AppColors.primary : AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(20),
          boxShadow: hasText
              ? [
                  const BoxShadow(
                    color: AppColors.primary,
                    blurRadius: 16,
                    spreadRadius: -2,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: hasText
                    ? AppColors.primaryForeground
                    : AppColors.onSurfaceVariant,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              PhosphorIconsRegular.sparkle,
              size: 16,
              color: hasText
                  ? AppColors.primaryForeground
                  : AppColors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // REPLY CONTEXT (parent card)
  // ---------------------------------------------------------------------------
  // React:
  // <div className="flex gap-4 mb-2">
  //   <div className="flex flex-col items-center pt-1">
  //     <UserAvatar ... />
  //     <div className="w-[2px] flex-grow bg-white/10 my-2 rounded-full min-h-[40px]" />
  //   </div>
  //   <div className="flex-grow pb-6 pt-1">
  //     handle + task price badge
  //     taskTitle card (for tasks) or plain text
  //   </div>
  // </div>

  Widget _buildReplyContext(FeedItem item) {
    final type = _getReplyContextType();
    final content = _getReplyContextContent();
    final taskTitle = _getTaskTitle();
    final taskPrice = _getTaskPrice();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left rail: avatar + vertical line
          SizedBox(
            width: 48,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: UserAvatar(
                    src: item.author.avatar,
                    size: AvatarSize.lg,
                  ),
                ),
                const SizedBox(height: 8),
                // Vertical line — React: w-[2px] flex-grow bg-white/10 my-2 rounded-full min-h-[40px]
                Container(
                  width: 2,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Right content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle + price badge
                  Row(
                    children: [
                      Text(
                        '@${item.author.handle}',
                        style: const TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (type == 'task' && taskPrice != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.emerald.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: AppColors.emerald.withOpacity(0.2),
                            ),
                          ),
                          child: Text(
                            taskPrice,
                            style: const TextStyle(
                              color: AppColors.emerald,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Content
                  if (type == 'task' && taskTitle != null)
                    // Task card — React: bg-surface-container-low border border-white/10 rounded-xl p-3 mt-2 shadow-inner
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            taskTitle,
                            style: const TextStyle(
                              color: AppColors.onSurface,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                            ),
                          ),
                          if (content.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              content,
                              style: const TextStyle(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 12,
                                height: 1.5,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    )
                  else
                    Text(
                      content,
                      style: const TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 16,
                        height: 1.5,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // THREAD BLOCK
  // ---------------------------------------------------------------------------
  // React: flex gap-4 group
  //   Left: UserAvatar + vertical line between blocks
  //   Right: "You" + delete button + AutoResizeTextarea + toolbar + char counter

  Widget _buildThreadBlock(int index) {
    final thread = _threads[index];
    final isActive = index == _activeIndex;
    final isLast = index == _threads.length - 1;
    final showDelete = _threads.length > 1;
    final progress = _calculateProgress(thread.controller.text);
    final isOverLimit = thread.controller.text.length > _maxChars;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left rail: avatar + line
          SizedBox(
            width: 48,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: UserAvatar(
                    src: '', // current user — empty triggers fallback
                    size: AvatarSize.lg,
                  ),
                ),
                if (!isLast) ...[
                  const SizedBox(height: 8),
                  // Gradient line — React: bg-gradient-to-b from-white/20 to-white/5
                  Container(
                    width: 2,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.2),
                          Colors.white.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Right content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "You" + delete button
                  Row(
                    children: [
                      const Text(
                        'You',
                        style: TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      if (showDelete)
                        GestureDetector(
                          onTap: () => _removeThread(index),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              PhosphorIconsRegular.trash,
                              size: 16,
                              color: AppColors.onSurfaceVariant.withOpacity(
                                0.4,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Auto-resize text field
                  TextField(
                    controller: thread.controller,
                    focusNode: thread.focusNode,
                    onChanged: (_) => setState(() {}),
                    onTap: () => setState(() => _activeIndex = index),
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 18,
                      height: 1.5,
                    ),
                    decoration: InputDecoration(
                      hintText: index == 0
                          ? "What's happening?"
                          : 'Add another thought...',
                      hintStyle: TextStyle(
                        color: AppColors.onSurfaceVariant.withOpacity(0.4),
                        fontSize: 18,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                    ),
                    maxLines: null,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                  ),
                  // Toolbar + character counter (active thread only)
                  if (isActive) _buildToolbar(index, progress, isOverLimit),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TOOLBAR + CHARACTER COUNTER
  // ---------------------------------------------------------------------------
  // React:
  // <div className="flex items-center justify-between mt-3 pt-3 border-t border-white/5">
  //   <div className="flex items-center gap-1 text-primary">
  //     [ImageIcon, Film, BarChart2, Smile]
  //   </div>
  //   <div> circular progress + separator + plus button </div>
  // </div>

  Widget _buildToolbar(int index, double progress, bool isOverLimit) {
    final hasText = _threads[index].controller.text.isNotEmpty;
    final canAddThread = index == _threads.length - 1 && hasText;

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.only(top: 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          // Media icons — React: flex items-center gap-1 text-primary
          ...[
            PhosphorIconsRegular.image,
            PhosphorIconsRegular.filmStrip,
            PhosphorIconsRegular.chartBar,
            PhosphorIconsRegular.smiley,
          ].map(
            (icon) => Padding(
              padding: const EdgeInsets.only(right: 4),
              child: IconButton(
                onPressed: () {},
                icon: Icon(icon, size: 18, color: AppColors.primary),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                splashRadius: 17,
              ),
            ),
          ),
          const Spacer(),
          // Right side: char counter + plus
          if (hasText)
            Row(
              children: [
                // Circular progress — React: SVG with rotated circle
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CustomPaint(
                    painter: _CharProgressPainter(
                      progress: progress,
                      isOverLimit: isOverLimit,
                      isWarning: progress > 80,
                    ),
                  ),
                ),
                if (isOverLimit)
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Text(
                      '${_maxChars - _threads[index].controller.text.length}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                // Separator
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  width: 1,
                  height: 24,
                  color: Colors.white.withOpacity(0.1),
                ),
                // Add thread button — React: w-6 h-6 rounded-full bg-primary/10
                if (canAddThread)
                  GestureDetector(
                    onTap: _addThread,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        PhosphorIconsRegular.plus,
                        size: 14,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ADD THREAD TRIGGER
  // ---------------------------------------------------------------------------
  // React: dashed border avatar + "Add to thread" text

  Widget _buildAddThreadTrigger() {
    return GestureDetector(
      onTap: _addThread,
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        child: Row(
          children: [
            SizedBox(
              width: 48,
              child: Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      style: BorderStyle.solid,
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    PhosphorIconsRegular.plus,
                    size: 20,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Text(
              'Add to thread',
              style: TextStyle(
                color: AppColors.onSurfaceVariant,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FLOATING FOOTER — "Everyone can reply"
  // ---------------------------------------------------------------------------
  // React:
  // <div className="fixed bottom-6 left-0 right-0 flex justify-center pointer-events-none z-20">
  //   <motion.div ... className="... rounded-full text-xs font-bold text-primary
  //     uppercase tracking-widest shadow-2xl border border-white/10 ...">
  //     <Globe size={14} /> <span>Everyone can reply</span>
  //   </motion.div>
  // </div>

  Widget _buildFloatingFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(PhosphorIconsRegular.globe, size: 14, color: AppColors.primary),
          const SizedBox(width: 8),
          const Text(
            'Everyone can reply',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Thread data holder
// ---------------------------------------------------------------------------

class _ThreadData {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
}

// ---------------------------------------------------------------------------
// Circular character progress painter
// ---------------------------------------------------------------------------
// React SVG:
// <circle cx="12" cy="12" r="10" fill="none" className="stroke-white/10" strokeWidth="2" />
// <circle cx="12" cy="12" r="10" fill="none"
//   className={isOverLimit ? 'stroke-red-500' : progress > 80 ? 'stroke-yellow-500' : 'stroke-primary'}
//   strokeWidth="2" strokeDasharray={`${progress * 0.628} 62.8`} />

class _CharProgressPainter extends CustomPainter {
  final double progress;
  final bool isOverLimit;
  final bool isWarning;

  _CharProgressPainter({
    required this.progress,
    required this.isOverLimit,
    required this.isWarning,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1;
    const strokeWidth = 2.0;

    // Background circle
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    if (progress > 0) {
      Color arcColor;
      if (isOverLimit) {
        arcColor = Colors.red;
      } else if (isWarning) {
        arcColor = Colors.yellow;
      } else {
        arcColor = AppColors.primary;
      }

      final arcPaint = Paint()
        ..color = arcColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      // React: strokeDasharray with 2πr=62.8 for r=10
      final sweepAngle = (progress / 100) * 2 * 3.14159;
      // Start from top (-π/2) like SVG default
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -3.14159 / 2,
        sweepAngle,
        false,
        arcPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_CharProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isOverLimit != isOverLimit ||
        oldDelegate.isWarning != isWarning;
  }
}
