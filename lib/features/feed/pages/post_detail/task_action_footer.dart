import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../shared/utils/color_extensions.dart';
import '../../../../app_theme.dart';
import '../../../../models/feed_item.dart';
import '../../../../shared/utils/decorations.dart';

class TaskActionFooter extends StatelessWidget {
  final TaskData task;
  final bool isCreator;
  final bool isAssignedToMe;
  final bool isNegotiable;
  final String replyText;
  final ValueChanged<String> onReplyChanged;
  final VoidCallback onSend;
  final VoidCallback onBid;
  final VoidCallback onAccept;
  final VoidCallback onStartTask;
  final VoidCallback onShowComplete;
  final VoidCallback onShowReview;

  const TaskActionFooter({
    super.key,
    required this.task,
    required this.isCreator,
    required this.isAssignedToMe,
    required this.isNegotiable,
    required this.replyText,
    required this.onReplyChanged,
    required this.onSend,
    required this.onBid,
    required this.onAccept,
    required this.onStartTask,
    required this.onShowComplete,
    required this.onShowReview,
  });

  @override
  Widget build(BuildContext context) {
    final tStatus = task.status;
    final showInput =
        tStatus == TaskStatus.open ||
        tStatus == TaskStatus.assigned ||
        tStatus == TaskStatus.inProgress;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.glassTint,
        border: Border(top: BorderSide(color: Colors.white.w05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.black50,
            blurRadius: 40,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showInput)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white.w05,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.w10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: onReplyChanged,
                        onSubmitted: (_) => onSend(),
                        style: AppTheme.bodyBold,
                        decoration: borderlessInput.copyWith(
                          hintText: 'Message or ask a question...',
                          hintStyle: AppTheme.bodyBold.copyWith(color: AppColors.onSurfaceVariant.withOpacity(0.5)),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        maxLines: null,
                        minLines: 1,
                      ),
                    ),
                    if (replyText.trim().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4, right: 4),
                        child: FilledButton(
                          onPressed: onSend,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.primaryForeground,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Send',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2, right: 2),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            PhosphorIconsRegular.arrowsOutSimple,
                            size: 18,
                            color: AppColors.onSurfaceVariant,
                          ),
                          padding: const EdgeInsets.all(10),
                          constraints: const BoxConstraints(),
                        ),
                      ),
                  ],
                ),
              ),
            _buildActionUI(task, tStatus),
          ],
        ),
      ),
    );
  }

  Widget _buildActionUI(TaskData task, TaskStatus tStatus) {
    if (isCreator) {
      if (tStatus == TaskStatus.open) {
        return _buildActionLabel('WAITING FOR BIDS...');
      } else if (tStatus == TaskStatus.assigned) {
        return _buildActionLabel(
          'AWAITING WORKER TO START',
          color: AppColors.emerald,
          icon: PhosphorIconsRegular.checkCircle,
        );
      } else if (tStatus == TaskStatus.inProgress) {
        return _buildActionLabel(
          'TASK IN PROGRESS',
          color: AppColors.emerald,
          icon: PhosphorIconsFill.sparkle,
        );
      } else if (tStatus == TaskStatus.completed) {
        return _buildActionButton(
          'REVIEW & RELEASE PAYMENT',
          color: AppColors.emerald,
          onTap: onShowReview,
        );
      } else if (tStatus == TaskStatus.finished) {
        return _buildActionLabel('TASK FINISHED');
      }
    } else {
      if (tStatus == TaskStatus.open) {
        if (!isNegotiable) {
          return Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'BID',
                  color: Colors.white.w05,
                  textColor: AppColors.onSurface,
                  borderColor: Colors.white.w10,
                  onTap: onBid,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButton(
                  'ACCEPT INSTANTLY',
                  color: AppColors.primary,
                  onTap: onAccept,
                ),
              ),
            ],
          );
        } else {
          return _buildActionButton(
            'SUBMIT BID',
            color: AppColors.primary,
            onTap: onBid,
          );
        }
      } else if (tStatus == TaskStatus.assigned) {
        if (isAssignedToMe) {
          return _buildActionButton(
            'START TASK',
            color: AppColors.emerald,
            onTap: onStartTask,
          );
        } else {
          return _buildActionLabel('ASSIGNED TO SOMEONE ELSE');
        }
      } else if (tStatus == TaskStatus.inProgress) {
        if (isAssignedToMe) {
          return _buildActionButton(
            'MARK AS COMPLETED',
            color: AppColors.emerald,
            onTap: onShowComplete,
          );
        } else {
          return _buildActionLabel('IN PROGRESS BY ANOTHER WORKER');
        }
      } else if (tStatus == TaskStatus.completed) {
        if (isAssignedToMe) {
          return _buildActionLabel(
            'WAITING FOR REVIEW...',
            borderColor: Colors.white.w10,
          );
        } else {
          return _buildActionLabel('COMPLETED');
        }
      } else if (tStatus == TaskStatus.finished) {
        if (isAssignedToMe) {
          return _buildActionLabel(
            'PAYMENT RECEIVED',
            color: AppColors.emerald,
            icon: PhosphorIconsRegular.checkCircle,
          );
        } else {
          return _buildActionLabel('TASK FINISHED');
        }
      }
    }

    return const SizedBox.shrink();
  }

  Widget _buildActionLabel(
    String text, {
    Color? color,
    IconData? icon,
    Color? borderColor,
  }) {
    final labelColor = color ?? AppColors.onSurfaceVariant;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color != null
            ? color.withOpacity(0.1)
            : Colors.white.w05,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              borderColor ??
              (color != null
                  ? color.withOpacity(0.2)
                  : Colors.white.w10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: labelColor),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: AppTheme.caption.copyWith(color: labelColor),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String text, {
    required Color color,
    Color? textColor,
    Color? borderColor,
    required VoidCallback onTap,
  }) {
    final bool isPrimaryColor =
        color == AppColors.primary || color == AppColors.emerald;

    return SizedBox(
      width: double.infinity,
      child: isPrimaryColor
          ? ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: color.withOpacity(0.3),
              ),
              child: Text(
                text,
                style: AppTheme.buttonLabel.copyWith(letterSpacing: 1.5),
              ),
            )
          : OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: textColor ?? AppColors.onSurface,
                backgroundColor: color,
                side: borderColor != null
                    ? BorderSide(color: borderColor)
                    : BorderSide.none,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                text,
                style: AppTheme.buttonLabel.copyWith(letterSpacing: 1.5, color: textColor ?? AppColors.onSurface),
              ),
            ),
    );
  }
}
