import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../app_theme.dart';
import '../../../../models/feed_item.dart';
import '../../../../shared/settings_provider.dart';
import '../../../../shared/widgets/primary_action_button.dart';

class CompletionSheet extends StatelessWidget {
  final TaskData task;
  final TextEditingController notesCtrl;
  final VoidCallback onComplete;

  const CompletionSheet({
    super.key,
    required this.task,
    required this.notesCtrl,
    required this.onComplete,
  });

  static void show({
    required BuildContext context,
    required TaskData task,
    required TextEditingController notesCtrl,
    required VoidCallback onComplete,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) {
        return CompletionSheet(
          task: task,
          notesCtrl: notesCtrl,
          onComplete: onComplete,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final textSize = ref.watch(settingsProvider.select((s) => s.textSize));
        return _buildContent(context, textSize);
      },
    );
  }

  Widget _buildContent(BuildContext context, TextSize textSize) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Complete Task',
                style: AppTheme.scaled(
                  textSize: textSize,
                  multiplier: AppTheme.m2xl,
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
          TextField(
            controller: notesCtrl,
            style: AppTheme.scaled(
              textSize: textSize,
              multiplier: AppTheme.mbase,
              color: AppColors.onSurface,
            ),
            decoration: InputDecoration(
              hintText: 'Add completion notes or proof of work...',
              hintStyle: AppTheme.scaled(
                textSize: textSize,
                multiplier: AppTheme.mbase,
                color: AppColors.onSurfaceVariant.withOpacity(0.3),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            maxLines: 5,
            minLines: 5,
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.onSurfaceVariant,
              side: BorderSide(color: Colors.white.withOpacity(0.2)),
              padding: const EdgeInsets.symmetric(vertical: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  PhosphorIconsRegular.camera,
                  size: 24,
                  color: AppColors.onSurfaceVariant.withOpacity(0.5),
                ),
                const SizedBox(height: 8),
                Text(
                  'Upload Proof Image',
                  style: AppTheme.scaled(
                    textSize: textSize,
                    multiplier: AppTheme.mxs,
                    weight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          PrimaryActionButton(
            label: 'SUBMIT COMPLETION',
            onTap: () {
              onComplete();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
