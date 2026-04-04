import '../../../shared/utils/color_extensions.dart';
import '../../../shared/utils/decorations.dart';
import '../../../shared/utils/app_buttons.dart';

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app_theme.dart';
import '../../../shared/widgets/user_avatar.dart';
import 'glass_card.dart';

// ---------------------------------------------------------------------------
// Shared types & helpers
// ---------------------------------------------------------------------------

enum _AttachmentType { image, video, voice, file }

class _Attachment {
  final _AttachmentType type;
  final String url;
  _Attachment({required this.type, required this.url});
}

const _mockAttachmentUrls = {
  _AttachmentType.image: 'https://picsum.photos/seed/post/400/300',
  _AttachmentType.video: 'video',
  _AttachmentType.voice: '0:15',
  _AttachmentType.file: 'document.pdf',
};

Widget _buildAttachmentPreview(_Attachment attachment) {
  switch (attachment.type) {
    case _AttachmentType.image:
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          attachment.url,
          fit: BoxFit.cover,
          width: 80,
          height: 80,
        ),
      );
    case _AttachmentType.video:
      return const Icon(
        PhosphorIconsRegular.filmStrip,
        color: AppColors.onSurfaceVariant,
        size: 24,
      );
    case _AttachmentType.voice:
      return const Icon(
        PhosphorIconsRegular.microphone,
        color: AppColors.primary,
        size: 24,
      );
    case _AttachmentType.file:
      return const Icon(
        PhosphorIconsRegular.paperclip,
        color: AppColors.onSurfaceVariant,
        size: 24,
      );
  }
}

IconButton _attachmentIconButton({
  required VoidCallback onPressed,
  required IconData icon,
  Color iconColor = AppColors.primary,
  bool tinted = true,
}) => IconButton(
  onPressed: onPressed,
  style: IconButton.styleFrom(
    backgroundColor: tinted ? AppColors.primary.p10 : null,
    padding: const EdgeInsets.all(8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
  icon: Icon(icon, size: 18, color: iconColor),
);

// ---------------------------------------------------------------------------
// Shared attachment grid & toolbar (used by both FeedComposer & FullscreenComposerSheet)
// ---------------------------------------------------------------------------

Widget _attachmentGrid({
  required List<_Attachment> attachments,
  required void Function(int) onRemove,
  required VoidCallback onAdd,
}) {
  return Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      ...List.generate(attachments.length, (index) {
        final attachment = attachments[index];
        return Stack(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: _buildAttachmentPreview(attachment),
            ),
            Positioned(
              top: -4,
              right: -4,
              child: GestureDetector(
                onTap: () => onRemove(index),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    PhosphorIconsRegular.x,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
      GestureDetector(
        onTap: onAdd,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(PhosphorIconsRegular.plus, color: AppColors.onSurfaceVariant),
              const SizedBox(height: 4),
              Text(
                'Add More',
                style: AppTheme.labelTiny.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _attachmentToolbar({
  required void Function(_AttachmentType) onAdd,
  bool showExpand = false,
  VoidCallback? onExpand,
}) {
  return Row(
    children: [
      _attachmentIconButton(
        icon: PhosphorIconsRegular.image,
        onPressed: () => onAdd(_AttachmentType.image),
      ),
      _attachmentIconButton(
        icon: PhosphorIconsRegular.filmStrip,
        onPressed: () => onAdd(_AttachmentType.video),
      ),
      _attachmentIconButton(
        icon: PhosphorIconsRegular.microphone,
        onPressed: () => onAdd(_AttachmentType.voice),
      ),
      _attachmentIconButton(
        icon: PhosphorIconsRegular.paperclip,
        onPressed: () => onAdd(_AttachmentType.file),
      ),
      if (showExpand && onExpand != null)
        _attachmentIconButton(
          icon: PhosphorIconsRegular.arrowsOutCardinal,
          iconColor: AppColors.onSurfaceVariant,
          tinted: false,
          onPressed: onExpand,
        ),
    ],
  );
}

// ---------------------------------------------------------------------------
// FeedComposer
// ---------------------------------------------------------------------------

class FeedComposer extends StatefulWidget {
  const FeedComposer({super.key});

  @override
  State<FeedComposer> createState() => _FeedComposerState();
}

class _FeedComposerState extends State<FeedComposer> {
  final TextEditingController _textController = TextEditingController();
  bool _isFocused = false;
  final List<_Attachment> _attachments = [];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_textController.text.trim().isEmpty && _attachments.isEmpty) return;
    _textController.clear();
    _attachments.clear();
    _isFocused = false;
  }

  void _addMockAttachment(_AttachmentType type) {
    setState(() {
      _attachments.add(
        _Attachment(type: type, url: _mockAttachmentUrls[type]!),
      );
      _isFocused = true;
    });
  }

  void _removeAttachment(int index) {
    setState(() {
      _attachments.removeAt(index);
    });
  }

  void _openFullscreenComposer() {
    final textController = TextEditingController(text: _textController.text);
    final List<_Attachment> sheetAttachments = List.from(_attachments);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FullscreenComposerSheet(
        textController: textController,
        attachments: sheetAttachments,
        onAddAttachment: (type) {
          sheetAttachments.add(
            _Attachment(type: type, url: _mockAttachmentUrls[type]!),
          );
        },
        onRemoveAttachment: (index) {
          sheetAttachments.removeAt(index);
        },
        onSubmit: () {
          if (textController.text.trim().isNotEmpty ||
              sheetAttachments.isNotEmpty) {
            _textController.text = textController.text;
            setState(() {
              _attachments
                ..clear()
                ..addAll(sheetAttachments);
            });
            _handleSubmit();
          }
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasContent =
        _isFocused ||
        _textController.text.isNotEmpty ||
        _attachments.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GlassCard(
        borderRadius: 28,
        padding: EdgeInsets.zero,
        showGlow: false,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 4, right: 12),
                      child: UserAvatar(
                        src: 'https://picsum.photos/seed/user/100/100',
                        size: AvatarSize.md,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _textController,
                            maxLines: null,
                            decoration: borderlessInput,
                            style: TextStyle(fontSize: 14 * AppTheme.m2xl, color: AppColors.onSurface, height: 1.8),
                            onTap: () => setState(() => _isFocused = true),
                          ),
                          AnimatedSize(
                            duration: AppTheme.animNormal,
                            curve: AppTheme.curveOut,
                            child: _attachments.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: _attachmentGrid(
                                      attachments: _attachments,
                                      onRemove: _removeAttachment,
                                      onAdd: () => _addMockAttachment(
                                        _AttachmentType.image,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedSize(
                duration: AppTheme.animNormal,
                curve: AppTheme.curveOut,
                child: hasContent
                    ? Container(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _attachmentToolbar(
                              onAdd: (type) => _addMockAttachment(type),
                              showExpand: true,
                              onExpand: _openFullscreenComposer,
                            ),
                            ElevatedButton(
                              onPressed: _textController.text.isEmpty
                                  ? null
                                  : _handleSubmit,
                              style: primaryButtonStyle,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Next',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: AppColors.primaryForeground,
                                        ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    PhosphorIconsRegular.caretRight,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );
  }
}

// ---------------------------------------------------------------------------
// Fullscreen Composer Bottom Sheet
// ---------------------------------------------------------------------------

class _FullscreenComposerSheet extends StatefulWidget {
  final TextEditingController textController;
  final List<_Attachment> attachments;
  final void Function(_AttachmentType) onAddAttachment;
  final void Function(int) onRemoveAttachment;
  final VoidCallback onSubmit;

  const _FullscreenComposerSheet({
    required this.textController,
    required this.attachments,
    required this.onAddAttachment,
    required this.onRemoveAttachment,
    required this.onSubmit,
  });

  @override
  State<_FullscreenComposerSheet> createState() =>
      _FullscreenComposerSheetState();
}

class _FullscreenComposerSheetState extends State<_FullscreenComposerSheet> {
  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    return GlassCard(
      customBorderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      showGlow: false,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    PhosphorIconsRegular.x,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                Text(
                  'CREATE TASK',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.onSurface,
                    letterSpacing: 2,
                  ),
                ),
                ElevatedButton(
                  onPressed: widget.textController.text.isEmpty
                      ? null
                      : widget.onSubmit,
                  style: primaryButtonStyle,
                  child: Text(
                    'Continue',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(color: AppColors.primaryForeground),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: UserAvatar(
                    src: 'https://picsum.photos/seed/user/100/100',
                    size: AvatarSize.md,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current User',
                        style: Theme.of(context).textTheme.titleLarge
                            ?.copyWith(color: AppColors.onSurface),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: widget.textController,
                        maxLines: null,
                        decoration: borderlessInput.copyWith(
                          hintText:
                              'What do you need help with? Describe your task in detail...',
                          hintStyle: TextStyle(fontSize: 14 * AppTheme.m2xl, color: AppColors.onSurfaceVariant.withValues(alpha: 0.4)),
                        ),
                        style: TextStyle(fontSize: 14 * AppTheme.m2xl, color: AppColors.onSurface, height: 1.8),
                        autofocus: true,
                      ),
                      if (widget.attachments.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: _attachmentGrid(
                            attachments: widget.attachments,
                            onRemove: (index) => setState(() {
                              widget.onRemoveAttachment(index);
                            }),
                            onAdd: () => setState(() {
                              widget.onAddAttachment(_AttachmentType.image);
                            }),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: _attachmentToolbar(
              onAdd: (type) => setState(() {
                widget.onAddAttachment(type);
              }),
            ),
          ),
        ],
      ),
    );
  }
}
