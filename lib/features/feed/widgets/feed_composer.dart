import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app_theme.dart';
import '../../../shared/widgets/user_avatar.dart';

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

/// Shared icon-button style for attachment toolbar actions
IconButton _attachmentIconButton({
  required VoidCallback onPressed,
  required IconData icon,
  Color iconColor = AppColors.primary,
  bool tinted = true,
}) => IconButton(
  onPressed: onPressed,
  style: IconButton.styleFrom(
    backgroundColor: tinted ? AppColors.primary.withOpacity(0.1) : null,
    padding: const EdgeInsets.all(8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
  icon: Icon(icon, size: 18, color: iconColor),
);

// ---------------------------------------------------------------------------
// FeedComposer
// ---------------------------------------------------------------------------

class FeedComposer extends ConsumerStatefulWidget {
  const FeedComposer({super.key});

  @override
  ConsumerState<FeedComposer> createState() => _FeedComposerState();
}

class _FeedComposerState extends ConsumerState<FeedComposer> {
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

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.glassTint,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.glassBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
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
                            decoration: const InputDecoration(
                              hintText: '',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: AppColors.onSurface,
                                  height: 1.5,
                                ),
                            onTap: () => setState(() => _isFocused = true),
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutCubic,
                            child: _attachments.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        ...List.generate(_attachments.length, (
                                          index,
                                        ) {
                                          final attachment =
                                              _attachments[index];
                                          return Stack(
                                            children: [
                                              Container(
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  color: AppColors
                                                      .surfaceContainerHigh,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: AppColors.border,
                                                  ),
                                                ),
                                                child: _buildAttachmentPreview(
                                                  attachment,
                                                ),
                                              ),
                                              Positioned(
                                                top: -4,
                                                right: -4,
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      _removeAttachment(index),
                                                  child: Container(
                                                    width: 24,
                                                    height: 24,
                                                    decoration:
                                                        const BoxDecoration(
                                                          color:
                                                              AppColors.primary,
                                                          shape:
                                                              BoxShape.circle,
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
                                          onTap: () => _addMockAttachment(
                                            _AttachmentType.image,
                                          ),
                                          child: Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: AppColors.border,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  PhosphorIconsRegular.plus,
                                                  color: AppColors
                                                      .onSurfaceVariant,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Add More',
                                                  style: AppTheme.labelTiny
                                                      .copyWith(
                                                        color: AppColors
                                                            .onSurfaceVariant,
                                                      ),
                                                ),
                                              ],
                                            ),
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
                  ],
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                child: hasContent
                    ? Container(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                _attachmentIconButton(
                                  icon: PhosphorIconsRegular.image,
                                  onPressed: () =>
                                      _addMockAttachment(_AttachmentType.image),
                                ),
                                _attachmentIconButton(
                                  icon: PhosphorIconsRegular.filmStrip,
                                  onPressed: () =>
                                      _addMockAttachment(_AttachmentType.video),
                                ),
                                _attachmentIconButton(
                                  icon: PhosphorIconsRegular.microphone,
                                  onPressed: () =>
                                      _addMockAttachment(_AttachmentType.voice),
                                ),
                                _attachmentIconButton(
                                  icon: PhosphorIconsRegular.paperclip,
                                  onPressed: () =>
                                      _addMockAttachment(_AttachmentType.file),
                                ),
                                _attachmentIconButton(
                                  icon: PhosphorIconsRegular.arrowsOutCardinal,
                                  iconColor: AppColors.onSurfaceVariant,
                                  tinted: false,
                                  onPressed: _openFullscreenComposer,
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: _textController.text.isEmpty
                                  ? null
                                  : _handleSubmit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.primaryForeground,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                elevation: 0,
                              ),
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
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Fullscreen Composer Bottom Sheet
// ---------------------------------------------------------------------------
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
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.glassTint,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border.all(color: AppColors.glassBorder),
          ),
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.primaryForeground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
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
                            decoration: InputDecoration(
                              hintText:
                                  'What do you need help with? Describe your task in detail...',
                              hintStyle: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: AppColors.onSurfaceVariant
                                        .withOpacity(0.4),
                                    fontSize: 20,
                                  ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: AppColors.onSurface,
                                  height: 1.8,
                                  fontSize: 20,
                                ),
                            autofocus: true,
                          ),
                          if (widget.attachments.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  ...List.generate(widget.attachments.length, (
                                    index,
                                  ) {
                                    final attachment =
                                        widget.attachments[index];
                                    return Stack(
                                      children: [
                                        Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color:
                                                AppColors.surfaceContainerHigh,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: AppColors.border,
                                            ),
                                          ),
                                          child: _buildAttachmentPreview(
                                            attachment,
                                          ),
                                        ),
                                        Positioned(
                                          top: -4,
                                          right: -4,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                widget.onRemoveAttachment(
                                                  index,
                                                );
                                              });
                                            },
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
                                    onTap: () {
                                      setState(() {
                                        widget.onAddAttachment(
                                          _AttachmentType.image,
                                        );
                                      });
                                    },
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.border,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            PhosphorIconsRegular.plus,
                                            color: AppColors.onSurfaceVariant,
                                          ),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _attachmentIconButton(
                          icon: PhosphorIconsRegular.image,
                          onPressed: () {
                            setState(() {
                              widget.onAddAttachment(_AttachmentType.image);
                            });
                          },
                        ),
                        _attachmentIconButton(
                          icon: PhosphorIconsRegular.filmStrip,
                          onPressed: () {
                            setState(() {
                              widget.onAddAttachment(_AttachmentType.video);
                            });
                          },
                        ),
                        _attachmentIconButton(
                          icon: PhosphorIconsRegular.microphone,
                          onPressed: () {
                            setState(() {
                              widget.onAddAttachment(_AttachmentType.voice);
                            });
                          },
                        ),
                        _attachmentIconButton(
                          icon: PhosphorIconsRegular.paperclip,
                          onPressed: () {
                            setState(() {
                              widget.onAddAttachment(_AttachmentType.file);
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
