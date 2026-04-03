import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../app_theme.dart';
import '../../../../models/feed_item.dart';
import '../../../../shared/utils/color_extensions.dart';
import '../../../../shared/utils/decorations.dart';
import '../../../../shared/widgets/base_sheet.dart';
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
    BaseSheet.show(
      context: context,
      title: 'Complete Task',
      builder: (_) => CompletionSheet(
        task: task,
        notesCtrl: notesCtrl,
        onComplete: onComplete,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseSheet(
      title: 'Complete Task',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: notesCtrl,
            style: AppTheme.bodyBold,
            decoration: InputDecoration(
              hintText: 'Add completion notes or proof of work...',
              hintStyle: AppTheme.bodyBold.copyWith(color: AppColors.onSurfaceVariant.withOpacity(0.3)),
              filled: true,
              fillColor: Colors.white.w05,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white.w10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white.w10),
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
              side: BorderSide(color: Colors.white.w20),
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
                  style: AppTheme.meta,
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
