import '../../../models/feed_item.dart';
import 'sample_data.dart';

/// Generates mock replies for a given post, matching React getReplies behavior.
/// Tasks automatically get a bid reply as the first reply.
List<FeedItem> getReplies(String parentId, {bool isTask = false}) {
  final p = 'reply-$parentId';
  return [
    if (isTask)
      SocialPostData(
        id: '$p-bid',
        author: mockAuthors[1],
        content: "I'm available right now! I have 5 years of experience with this exact issue and can fix it in under an hour.",
        timestamp: '2h',
        votes: 12,
        isBid: true,
        bidAmount: '\$65.00',
        bidStatus: BidStatus.pending,
      ),
    SocialPostData(
      id: '$p-1',
      author: mockAuthors[2],
      content: 'This is really interesting! Thanks for sharing.',
      timestamp: isTask ? '4h' : '1m',
      votes: 3,
      images: isTask ? ['https://picsum.photos/seed/${parentId}r0/600/400'] : null,
    ),
    SocialPostData(
      id: '$p-2',
      author: mockAuthors[3],
      content: 'I had a similar experience last week. The key is to stay consistent and keep pushing forward.',
      timestamp: isTask ? '6h' : '5m',
      reposts: 1,
      votes: 7,
      voiceNote: isTask ? '0:32' : null,
    ),
    SocialPostData(
      id: '$p-3',
      author: mockAuthors[4],
      content: 'Could you elaborate more on this? I\'d love to hear your thoughts in detail.',
      timestamp: isTask ? '8h' : '12m',
      votes: 2,
      video: isTask ? 'https://www.w3schools.com/html/mov_bbb.mp4' : null,
    ),
    SocialPostData(
      id: '$p-4',
      author: mockAuthors[0],
      content: 'Great point! Totally agree with you on this one.',
      timestamp: isTask ? '10h' : '20m',
      votes: 5,
    ),
  ];
}
