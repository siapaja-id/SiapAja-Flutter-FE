import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app_theme.dart';
import '../../../models/feed_item.dart';
import '../../../shared/utils/decorations.dart';
import '../../../shared/widgets/user_avatar.dart';

const int _maxChars = 280;

class CreateReplyPage extends StatefulWidget {
  final FeedItem? parentItem;
  final ValueChanged<String>? onSend;

  const CreateReplyPage({super.key, this.parentItem, this.onSend});

  @override
  State<CreateReplyPage> createState() => _CreateReplyPageState();
}

class _CreateReplyPageState extends State<CreateReplyPage> {
  final List<_ThreadData> _threads = [_ThreadData()];
  int _activeIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    for (final t in _threads) {
      t.controller.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  void _onBack() => Navigator.of(context).pop();

  void _addThread() {
    setState(() {
      _threads.add(_ThreadData());
      _activeIndex = _threads.length - 1;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: AppTheme.animFast,
          curve: AppTheme.curveOutQuart,
        );
      }
    });
  }

  void _removeThread(int index) {
    if (_threads.length <= 1) return;
    setState(() {
      _threads[index].controller.dispose();
      _threads.removeAt(index);
      if (_activeIndex >= _threads.length) _activeIndex = _threads.length - 1;
    });
  }

  void _handlePost() {
    final content = _threads
        .map((t) => t.controller.text.trim())
        .where((s) => s.isNotEmpty)
        .join('\n\n');
    if (content.isEmpty) return;
    if (widget.onSend != null) widget.onSend!(content);
    Navigator.of(context).pop();
  }

  double _calculateProgress(String text) =>
      (text.length / _maxChars * 100).clamp(0.0, 100.0);

  String _getReplyContextContent() {
    final item = widget.parentItem;
    if (item is SocialPostData) return item.content;
    if (item is TaskData) return item.description;
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

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    final item = widget.parentItem;
    final hasContext = item != null;
    final route = ModalRoute.of(context)!;

    return SharedAxisTransition(
      animation: route.animation!,
      secondaryAnimation: route.secondaryAnimation!,
      transitionType: SharedAxisTransitionType.vertical,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Container(
          constraints: const BoxConstraints(maxWidth: 672),
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(color: AppColors.border),
              right: BorderSide(color: AppColors.border),
            ),
          ),
          child: Column(
            children: [
              _buildHeader(),
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
                          if (hasContext) _buildReplyContext(item),
                          for (int i = 0; i < _threads.length; i++)
                            _buildThreadBlock(i),
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
        floatingActionButton: _buildFloatingFooter(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

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
          Expanded(
            child: Text(
              widget.parentItem != null ? 'REPLY' : 'NEW THREAD',
              style: AppTheme.bodyBold.copyWith(letterSpacing: 3.0),
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Drafts',
              style: AppTheme.bodyBold,
            ),
          ),
          const SizedBox(width: 8),
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
        duration: AppTheme.animFast,
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
              style: AppTheme.actionLabel.copyWith(color: hasText
                    ? AppColors.primaryForeground
                    : AppColors.onSurfaceVariant),
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
                Container(
                  width: 2,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '@${item.author.handle}',
                        style: AppTheme.bodyBold,
                      ),
                      if (type == 'task' && taskPrice != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: tintedDecorHalf(color: AppColors.emerald, radius: 4),
                          child: Text(
                            taskPrice,
                            style: AppTheme.smallLabel.copyWith(color: AppColors.emerald),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (type == 'task' && taskTitle != null)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            taskTitle,
                            style: AppTheme.bodyBold,
                          ),
                          if (content.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              content,
                              style: AppTheme.bodyMeta,
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
                      style: AppTheme.subtitle,
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
          SizedBox(
            width: 48,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: UserAvatar(src: '', size: AvatarSize.lg),
                ),
                if (!isLast) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: 2,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0.2),
                          Colors.white.withValues(alpha: 0.05),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'You',
                        style: AppTheme.bodyBold,
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
                              color: AppColors.onSurfaceVariant.withValues(alpha: 
                                0.4,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: thread.controller,
                    focusNode: thread.focusNode,
                    onChanged: (_) => setState(() {}),
                    onTap: () => setState(() => _activeIndex = index),
                    style: AppTheme.bodyLarge,
                    decoration: borderlessInput.copyWith(
                      hintText: index == 0
                          ? "What's happening?"
                          : 'Add another thought...',
                      hintStyle: AppTheme.bodyLarge.copyWith(color: AppColors.onSurfaceVariant.withValues(alpha: 0.4)),
                    ),
                    maxLines: null,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                  ),
                  if (isActive) _buildToolbar(index, progress, isOverLimit),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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
          if (hasText)
            Row(
              children: [
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
                      style: TextStyle(fontSize: 14 * AppTheme.m3xs, fontWeight: FontWeight.w700, color: Colors.red),
                    ),
                  ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  width: 1,
                  height: 24,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                if (canAddThread)
                  GestureDetector(
                    onTap: _addThread,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
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
                    color: Colors.white.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
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
            Text(
              'Add to thread',
              style: AppTheme.bodyBold,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          shadowBlack(opacity: 0.4, blur: 24),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(PhosphorIconsRegular.globe, size: 14, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            'Everyone can reply',
            style: AppTheme.meta.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _ThreadData {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
}

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

    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

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

      final sweepAngle = (progress / 100) * 2 * 3.14159;
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
