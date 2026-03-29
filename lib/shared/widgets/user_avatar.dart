import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../app_theme.dart';

/// Avatar size enum
enum AvatarSize {
  sm(24),
  md(32),
  lg(40),
  xl(48);

  final double size;
  const AvatarSize(this.size);

  /// Returns the appropriate avatar size based on card context.
  static AvatarSize forCard({
    required bool isMain,
    required bool isParent,
    required bool isQuote,
  }) => isQuote || isParent
      ? sm
      : isMain
      ? lg
      : md;
}

/// User avatar widget with online indicator
class UserAvatar extends StatelessWidget {
  final String src;
  final String? alt;
  final AvatarSize size;
  final bool isOnline;

  const UserAvatar({
    super.key,
    required this.src,
    this.alt,
    this.size = AvatarSize.md,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.size,
      height: size.size,
      child: Stack(
        children: [
          // Avatar image
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: src,
              width: size.size,
              height: size.size,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppColors.surfaceContainer,
                child: Icon(
                  Icons.person,
                  size: size.size * 0.5,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.surfaceContainer,
                child: Icon(
                  Icons.person,
                  size: size.size * 0.5,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ),
          // Ring
          Positioned.fill(
            child: ClipOval(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border, width: 1),
                ),
              ),
            ),
          ),
          // Online indicator
          if (isOnline)
            Positioned(
              right: size.size * 0.1,
              bottom: size.size * 0.1,
              child: Container(
                width: size.size * 0.25,
                height: size.size * 0.25,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withOpacity(0.4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: size.size * 0.12,
                    height: size.size * 0.12,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const SizedBox(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
