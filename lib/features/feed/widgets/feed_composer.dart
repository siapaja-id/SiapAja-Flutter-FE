import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app_theme.dart';
import '../../../shared/widgets/user_avatar.dart';

/// Feed composer widget for creating new posts
class FeedComposer extends ConsumerStatefulWidget {
  const FeedComposer({super.key});

  @override
  ConsumerState<FeedComposer> createState() => _FeedComposerState();
}

class _FeedComposerState extends ConsumerState<FeedComposer> {
  final TextEditingController _textController = TextEditingController();
  bool _isFocused = false;
  bool _isFullscreen = false;
  final List<_Attachment> _attachments = [];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_textController.text.trim().isEmpty && _attachments.isEmpty) return;
    // TODO: Navigate to create post screen
    _textController.clear();
    _attachments.clear();
    _isFocused = false;
    _isFullscreen = false;
  }

  void _addMockAttachment(_AttachmentType type) {
    final urls = {
      _AttachmentType.image: 'https://picsum.photos/seed/post/400/300',
      _AttachmentType.video: 'video',
      _AttachmentType.voice: '0:15',
      _AttachmentType.file: 'document.pdf',
    };
    setState(() {
      _attachments.add(_Attachment(type: type, url: urls[type]!));
      _isFocused = true;
    });
  }

  void _removeAttachment(int index) {
    setState(() {
      _attachments.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasContent =
        _isFocused ||
        _isFullscreen ||
        _textController.text.isNotEmpty ||
        _attachments.isNotEmpty;

    return Stack(
      children: [
        // Fullscreen backdrop — matches React AnimatePresence + motion.div overlay
        AnimatedOpacity(
          opacity: _isFullscreen ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          child: IgnorePointer(
            ignoring: !_isFullscreen,
            child: Container(color: Colors.black.withOpacity(0.8)),
          ),
        ),
        // Composer container
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          margin: _isFullscreen
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: _isFullscreen
              ? null
              : BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0x1AFFFFFF)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                    ),
                  ],
                ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Fullscreen header — AnimatedOpacity matches React AnimatePresence
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                child: AnimatedOpacity(
                  opacity: _isFullscreen ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: _isFullscreen
                      ? Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0x1AFFFFFF)),
                            color: AppColors.surfaceContainerHigh.withOpacity(
                              0.3,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () =>
                                    setState(() => _isFullscreen = false),
                                icon: const Icon(
                                  PhosphorIconsRegular.x,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              const Text(
                                'CREATE TASK',
                                style: TextStyle(
                                  color: AppColors.onSurface,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
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
                                ),
                                child: const Text(
                                  'Continue',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              // Content area
              Padding(
                padding: _isFullscreen
                    ? const EdgeInsets.fromLTRB(24, 24, 24, 8)
                    : const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    if (!_isFullscreen)
                      const Padding(
                        padding: EdgeInsets.only(top: 4, right: 12),
                        child: UserAvatar(
                          src: 'https://picsum.photos/seed/user/100/100',
                          size: AvatarSize.md,
                        ),
                      ),
                    // Text field and attachments
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User info for fullscreen mode
                          if (_isFullscreen) ...[
                            Row(
                              children: [
                                const UserAvatar(
                                  src:
                                      'https://picsum.photos/seed/user/100/100',
                                  size: AvatarSize.md,
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Current User',
                                  style: TextStyle(
                                    color: AppColors.onSurface,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                          // Text input
                          TextField(
                            controller: _textController,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: _isFullscreen
                                  ? 'What do you need help with? Describe your task in detail...'
                                  : '',
                              hintStyle: TextStyle(
                                color: AppColors.onSurfaceVariant.withOpacity(
                                  0.4,
                                ),
                                fontSize: _isFullscreen ? 20 : 15,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: TextStyle(
                              color: AppColors.onSurface,
                              fontSize: _isFullscreen ? 20 : 15,
                              height: _isFullscreen ? 1.8 : 1.5,
                            ),
                            onTap: () => setState(() => _isFocused = true),
                          ),
                          // Attachment previews — AnimatedOpacity + Slide matches React AnimatePresence
                          AnimatedSize(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutCubic,
                            child: AnimatedOpacity(
                              opacity: _attachments.isNotEmpty ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 200),
                              child: _attachments.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: [
                                          ...List.generate(
                                            _attachments.length,
                                            (index) {
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
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                      border: Border.all(
                                                        color: const Color(
                                                          0x1AFFFFFF,
                                                        ),
                                                      ),
                                                    ),
                                                    child:
                                                        _buildAttachmentPreview(
                                                          attachment,
                                                        ),
                                                  ),
                                                  Positioned(
                                                    top: -4,
                                                    right: -4,
                                                    child: GestureDetector(
                                                      onTap: () =>
                                                          _removeAttachment(
                                                            index,
                                                          ),
                                                      child: Container(
                                                        width: 24,
                                                        height: 24,
                                                        decoration:
                                                            const BoxDecoration(
                                                              color: Color(
                                                                0xFFDC2626,
                                                              ),
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                        child: const Icon(
                                                          PhosphorIconsRegular
                                                              .x,
                                                          size: 14,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                          GestureDetector(
                                            onTap: () => _addMockAttachment(
                                              _AttachmentType.image,
                                            ),
                                            child: Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: const Color(
                                                    0x1AFFFFFF,
                                                  ),
                                                  style: BorderStyle.solid,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: const Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    PhosphorIconsRegular.plus,
                                                    color: AppColors
                                                        .onSurfaceVariant,
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    'Add More',
                                                    style: TextStyle(
                                                      color: AppColors
                                                          .onSurfaceVariant,
                                                      fontSize: 10,
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Action bar — AnimatedSize + AnimatedOpacity matches React motion layout + AnimatePresence
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                child: AnimatedOpacity(
                  opacity: hasContent ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: hasContent
                      ? AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: _isFullscreen
                              ? const EdgeInsets.all(24)
                              : const EdgeInsets.fromLTRB(16, 12, 16, 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0x1AFFFFFF)),
                            color: _isFullscreen
                                ? AppColors.surfaceContainerHigh.withOpacity(
                                    0.3,
                                  )
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Attachment buttons
                              Row(
                                children: [
                                  _AttachmentButton(
                                    icon: PhosphorIconsRegular.image,
                                    onTap: () => _addMockAttachment(
                                      _AttachmentType.image,
                                    ),
                                  ),
                                  _AttachmentButton(
                                    icon: PhosphorIconsRegular.filmStrip,
                                    onTap: () => _addMockAttachment(
                                      _AttachmentType.video,
                                    ),
                                  ),
                                  _AttachmentButton(
                                    icon: PhosphorIconsRegular.microphone,
                                    onTap: () => _addMockAttachment(
                                      _AttachmentType.voice,
                                    ),
                                  ),
                                  _AttachmentButton(
                                    icon: PhosphorIconsRegular.paperclip,
                                    onTap: () => _addMockAttachment(
                                      _AttachmentType.file,
                                    ),
                                  ),
                                  if (!_isFullscreen)
                                    _AttachmentButton(
                                      icon: PhosphorIconsRegular
                                          .arrowsOutCardinal,
                                      onTap: () =>
                                          setState(() => _isFullscreen = true),
                                      isVariant: true,
                                    ),
                                ],
                              ),
                              // Submit button
                              if (!_isFullscreen)
                                ElevatedButton(
                                  onPressed: _textController.text.isEmpty
                                      ? null
                                      : _handleSubmit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor:
                                        AppColors.primaryForeground,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Next',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(
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
              ),
            ],
          ),
        ),
      ],
    );
  }

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
}

enum _AttachmentType { image, video, voice, file }

class _Attachment {
  final _AttachmentType type;
  final String url;

  _Attachment({required this.type, required this.url});
}

class _AttachmentButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isVariant;

  const _AttachmentButton({
    required this.icon,
    required this.onTap,
    this.isVariant = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isVariant
              ? Colors.transparent
              : AppColors.primary.withOpacity(0.1),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isVariant ? AppColors.onSurfaceVariant : AppColors.primary,
        ),
      ),
    );
  }
}
