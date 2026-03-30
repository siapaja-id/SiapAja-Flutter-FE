import '../../../models/feed_item.dart';
import 'sample_data.dart';

/// Generates mock replies for a given post, matching React getReplies behavior.
/// Tasks automatically get a bid reply as the first reply.
List<FeedItem> getReplies(String parentId, {bool isTask = false}) {
  final replyIdPrefix = 'reply-$parentId';

  final List<FeedItem> replies = [];

  if (isTask) {
    // Auto-generate a mock bid as first reply (matches React: isBid for task + i===0)
    replies.add(
      SocialPostData(
        id: '$replyIdPrefix-bid',
        author: mockAuthors[1],
        content: "I'm available right now! I have 5 years of experience with this exact issue and can fix it in under an hour.",
        timestamp: '2h',
        replies: 0,
        reposts: 0,
        shares: 0,
        votes: 12,
        isBid: true,
        bidAmount: '\$65.00',
        bidStatus: BidStatus.pending,
      ),
    );
  }

  replies.addAll([
    SocialPostData(
      id: '$replyIdPrefix-1',
      author: mockAuthors[2],
      content: 'This is really interesting! Thanks for sharing.',
      timestamp: isTask ? '4h' : '1m',
      replies: 0,
      reposts: 0,
      shares: 0,
      votes: 3,
      images: isTask ? ['https://picsum.photos/seed/${parentId}r0/600/400'] : null,
    ),
    SocialPostData(
      id: '$replyIdPrefix-2',
      author: mockAuthors[3],
      content: 'I had a similar experience last week. The key is to stay consistent and keep pushing forward.',
      timestamp: isTask ? '6h' : '5m',
      replies: 0,
      reposts: 1,
      shares: 0,
      votes: 7,
      voiceNote: isTask ? '0:32' : null,
    ),
    SocialPostData(
      id: '$replyIdPrefix-3',
      author: mockAuthors[4],
      content: 'Could you elaborate more on this? I\'d love to hear your thoughts in detail.',
      timestamp: isTask ? '8h' : '12m',
      replies: 0,
      reposts: 0,
      shares: 0,
      votes: 2,
      video: isTask ? 'https://www.w3schools.com/html/mov_bbb.mp4' : null,
    ),
    SocialPostData(
      id: '$replyIdPrefix-4',
      author: mockAuthors[0],
      content: 'Great point! Totally agree with you on this one.',
      timestamp: isTask ? '10h' : '20m',
      replies: 0,
      reposts: 0,
      shares: 0,
      votes: 5,
    ),
  ]);

  return replies;
}
