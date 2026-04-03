import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../models/feed_item.dart';
import '../../../../shared/widgets/empty_state.dart';

class EmptyRepliesState extends StatelessWidget {
  final FeedItem item;
  final bool isCreator;
  final VoidCallback? onBidClick;
  final VoidCallback? onFocusReply;

  const EmptyRepliesState({
    super.key,
    required this.item,
    required this.isCreator,
    this.onBidClick,
    this.onFocusReply,
  });

  bool get _isTask => item is TaskData;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: _isTask
          ? PhosphorIconsFill.sparkle
          : PhosphorIconsRegular.chatTeardropDots,
      title: _isTask ? 'No bids yet' : 'Quiet in here...',
      subtitle: _isTask
          ? isCreator
              ? 'Your task is live! Check back soon for bids from interested workers.'
              : 'This task is waiting for a hero. Submit your bid and secure this opportunity!'
          : 'Be the first to share your thoughts and start the conversation.',
      actionLabel: (!isCreator && _isTask)
          ? 'PLACE FIRST BID'
          : (!_isTask ? 'WRITE A REPLY' : null),
      onAction: (!isCreator && _isTask)
          ? onBidClick
          : (!_isTask ? onFocusReply : null),
    );
  }
}
