import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../app_theme.dart';
import '../../../../models/feed_item.dart';
import '../../../../shared/widgets/primary_action_button.dart';

class ReviewSheet extends StatefulWidget {
  final TaskData task;
  final void Function(int rating) onReview;

  const ReviewSheet({super.key, required this.task, required this.onReview});

  static void show({
    required BuildContext context,
    required TaskData task,
    required void Function(int rating) onReview,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) {
        return ReviewSheet(task: task, onReview: onReview);
      },
    );
  }

  @override
  State<ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends State<ReviewSheet> {
  int _rating = 5;

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Review Work',
                style: AppTheme.scaled(multiplier: AppTheme.m2xl,
                  weight: FontWeight.w900,
                  color: AppColors.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.05),
                ),
                icon: const Icon(
                  PhosphorIconsRegular.x,
                  size: 20,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Rate the worker',
            style: AppTheme.scaled(multiplier: AppTheme.mbase,
              weight: FontWeight.w700,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              return InkWell(
                onTap: () => setState(() => _rating = i + 1),
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    i < _rating
                        ? PhosphorIconsFill.star
                        : PhosphorIconsRegular.star,
                    size: 32,
                    color: i < _rating
                        ? const Color(0xFFFBBF24)
                        : Colors.white24,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          PrimaryActionButton(
            label: 'RELEASE PAYMENT',
            onTap: () {
              widget.onReview(_rating);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
