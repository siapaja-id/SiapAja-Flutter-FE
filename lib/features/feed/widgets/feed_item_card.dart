import 'package:flutter/material.dart';

import '../../../models/feed_item.dart';
import 'social_post_card.dart';
import 'task_card.dart';
import 'editorial_card.dart';

/// Polymorphic feed item card dispatcher
/// Renders the appropriate card based on the feed item type
class FeedItemCard extends StatelessWidget {
  final FeedItem item;
  final bool isMain;
  final bool isParent;
  final bool isQuote;
  final bool hasLineBelow;
  final VoidCallback? onClick;

  const FeedItemCard({
    super.key,
    required this.item,
    this.isMain = false,
    this.isParent = false,
    this.isQuote = false,
    this.hasLineBelow = false,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    if (item is SocialPostData) {
      return SocialPostCard(
        data: item as SocialPostData,
        isMain: isMain,
        isParent: isParent,
        isQuote: isQuote,
        hasLineBelow: hasLineBelow,
        onClick: onClick,
      );
    } else if (item is TaskData) {
      return TaskCard(
        data: item as TaskData,
        isMain: isMain,
        isParent: isParent,
        isQuote: isQuote,
        hasLineBelow: hasLineBelow,
        onClick: onClick,
      );
    } else if (item is EditorialData) {
      return EditorialCard(
        data: item as EditorialData,
        isMain: isMain,
        isParent: isParent,
        isQuote: isQuote,
        hasLineBelow: hasLineBelow,
        onClick: onClick,
      );
    }
    return const SizedBox.shrink();
  }
}
