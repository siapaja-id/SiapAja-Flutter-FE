import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../app_theme.dart';
import '../utils/color_extensions.dart';

class CloseButton extends StatelessWidget {
  final VoidCallback onTap;

  const CloseButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.w05,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(
          PhosphorIconsRegular.x,
          size: 20,
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}
