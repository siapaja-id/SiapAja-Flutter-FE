import 'dart:ui';

import 'package:flutter/material.dart';

import '../../app_theme.dart';

class GlassHeader extends StatelessWidget {
  final double height;
  final Widget child;
  final bool useGradient;

  const GlassHeader({
    super.key,
    this.height = 64,
    required this.child,
    this.useGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.glassTint,
            border: const Border(
              bottom: BorderSide(color: AppColors.glassBorder),
            ),
            gradient: useGradient
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.glassGlow, AppColors.glassTint],
                  )
                : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
