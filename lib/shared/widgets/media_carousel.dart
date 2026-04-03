import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../utils/color_extensions.dart';
import '../../app_theme.dart';

/// Media carousel widget for displaying multiple images with snap scrolling
class MediaCarousel extends StatefulWidget {
  final List<String> images;
  final String? aspect; // e.g., "16/9", "4/3", "1/1"

  const MediaCarousel({super.key, required this.images, this.aspect = '16/9'});

  @override
  State<MediaCarousel> createState() => _MediaCarouselState();
}

class _MediaCarouselState extends State<MediaCarousel> {
  int activeIndex = 0;
  bool _isHovering = false;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  double get _aspectRatio {
    final parts = widget.aspect?.split('/') ?? ['16', '9'];
    if (parts.length != 2) return 16 / 9;
    final width = double.tryParse(parts[0]) ?? 16;
    final height = double.tryParse(parts[1]) ?? 9;
    return width / height;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return const SizedBox.shrink();

    return MouseRegion(
      onEnter: (_) {
        if (mounted) setState(() => _isHovering = true);
      },
      onExit: (_) {
        if (mounted) setState(() => _isHovering = false);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderSubtle),
          boxShadow: [
            BoxShadow(color: Colors.black.black05, blurRadius: 8),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: _aspectRatio,
            child: Stack(
              children: [
                // PageView for images
                PageView.builder(
                  controller: _pageController,
                  itemCount: widget.images.length,
                  scrollBehavior: const MaterialScrollBehavior().copyWith(
                    scrollbars: false,
                  ),
                  onPageChanged: (index) {
                    if (mounted) setState(() => activeIndex = index);
                  },
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      imageUrl: widget.images[index],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.surfaceContainer,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.surfaceContainer,
                        child: const Icon(
                          Icons.error,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    );
                  },
                ),
                // Dot indicators
                if (widget.images.length > 1)
                  Positioned(
                    bottom: 8,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.images.length,
                        (index) => GestureDetector(
                          onTap: () {
                            _pageController.animateToPage(
                              index,
                              duration: AppTheme.animSlide,
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            height: 4,
                            width: index == activeIndex ? 8 : 4,
                            decoration: BoxDecoration(
                              color: index == activeIndex
                                  ? Colors.white
                                  : Colors.white.w40,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                // Left arrow — hidden by default, visible on hover (matches React group-hover)
                if (widget.images.length > 1 && activeIndex > 0)
                  Positioned(
                    left: 8,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: AnimatedOpacity(
                        opacity: _isHovering ? 1.0 : 0.0,
                        duration: AppTheme.animFast,
                        child: _ArrowButton(
                          icon: PhosphorIconsRegular.caretLeft,
                          onTap: () {
                            _pageController.previousPage(
                              duration: AppTheme.animSlide,
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                // Right arrow — hidden by default, visible on hover (matches React group-hover)
                if (widget.images.length > 1 &&
                    activeIndex < widget.images.length - 1)
                  Positioned(
                    right: 8,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: AnimatedOpacity(
                        opacity: _isHovering ? 1.0 : 0.0,
                        duration: AppTheme.animFast,
                        child: _ArrowButton(
                          icon: PhosphorIconsRegular.caretRight,
                          onTap: () {
                            _pageController.nextPage(
                              duration: AppTheme.animSlide,
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _ArrowButton — carousel arrow with hover bg (matches React hover:bg-black/60)
// ---------------------------------------------------------------------------

class _ArrowButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ArrowButton({required this.icon, required this.onTap});

  @override
  State<_ArrowButton> createState() => _ArrowButtonState();
}

class _ArrowButtonState extends State<_ArrowButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        if (mounted) setState(() => _hovered = true);
      },
      onExit: (_) {
        if (mounted) setState(() => _hovered = false);
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _hovered
                ? Colors.black.black60
                : Colors.black.black40,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.w10),
          ),
          child: Icon(widget.icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}
