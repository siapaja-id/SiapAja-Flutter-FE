import '../../../shared/utils/color_extensions.dart';
import '../../../shared/utils/decorations.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app_theme.dart';
import '../../../models/feed_item.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../pages/create_reply_page.dart';
import 'glass_card.dart';

/// Bottom fixed reply input bar — matches React ReplyInput exactly.
/// Glass container, avatar on left, auto-grow textarea, send button, expand icon.
///
/// This is the single source of truth for reply text composition.
/// When expanded to fullscreen ([CreateReplyPage]), the same [TextEditingController]
/// state carries over so the user sees their draft in the fullscreen view.
class ReplyInput extends StatelessWidget {
  final String handle;
  final String parentId;
  final ValueChanged<String> onSend;
  final String avatarUrl;
  final FeedItem? parentItem;

  const ReplyInput({
    super.key,
    required this.handle,
    required this.parentId,
    required this.onSend,
    this.avatarUrl = 'https://picsum.photos/seed/user/100/100',
    this.parentItem,
  });

  @override
  Widget build(BuildContext context) {
    return _ReplyInputBody(
      handle: handle,
      parentId: parentId,
      onSend: onSend,
      avatarUrl: avatarUrl,
      parentItem: parentItem,
    );
  }
}

class _ReplyInputBody extends StatefulWidget {
  final String handle;
  final String parentId;
  final ValueChanged<String> onSend;
  final String avatarUrl;
  final FeedItem? parentItem;

  const _ReplyInputBody({
    required this.handle,
    required this.parentId,
    required this.onSend,
    required this.avatarUrl,
    this.parentItem,
  });

  @override
  State<_ReplyInputBody> createState() => _ReplyInputBodyState();
}

class _ReplyInputBodyState extends State<_ReplyInputBody> {
  final TextEditingController _controller = TextEditingController();
  static const double _minHeight = 44;
  static const double _maxHeight = 120;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  void _openFullscreen() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            CreateReplyPage(
              parentItem: widget.parentItem,
              onSend: (text) {
                widget.onSend(text);
                _controller.clear();
              },
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.vertical,
              child: child,
            ),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasText = _controller.text.trim().isNotEmpty;

    return GlassCard.slab(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      border: const Border(top: BorderSide(color: AppColors.glassBorder)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.black50,
          blurRadius: 40,
          offset: const Offset(0, -10),
        ),
      ],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar on left
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: UserAvatar(src: widget.avatarUrl, size: AvatarSize.md),
          ),
          const SizedBox(width: 12),
          // Text area in rounded container
          Expanded(
            child: Container(
              constraints: const BoxConstraints(
                minHeight: _minHeight,
                maxHeight: _maxHeight,
              ),
              decoration: BoxDecoration(
                color: Colors.white.w05,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.w10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onChanged: (_) => setState(() {}),
                      onSubmitted: (_) => _handleSend(),
                      style: AppTheme.bodyBold,
                      decoration: borderlessInput.copyWith(
                        hintText: 'Reply to ${widget.handle}...',
                        hintStyle: AppTheme.bodyBold.copyWith(color: AppColors.onSurfaceVariant.withOpacity(0.5)),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      minLines: 1,
                      textInputAction: TextInputAction.send,
                    ),
                  ),
                  // Expand button when empty
                  if (!hasText)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2, right: 2),
                      child: IconButton(
                        onPressed: _openFullscreen,
                        icon: Icon(
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
          ),
          const SizedBox(width: 8),
          // Send Button
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: FilledButton(
              onPressed: hasText ? _handleSend : null,
              style: FilledButton.styleFrom(
                backgroundColor: hasText
                    ? AppColors.primary
                    : AppColors.surfaceContainerHigh,
                foregroundColor: hasText
                    ? AppColors.primaryForeground
                    : AppColors.onSurfaceVariant,
                disabledBackgroundColor: AppColors.surfaceContainerHigh,
                disabledForegroundColor: AppColors.onSurfaceVariant,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Reply',
                style: AppTheme.meta,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
