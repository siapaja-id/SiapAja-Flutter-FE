import '../../../models/author.dart';
import '../../../models/feed_item.dart';

/// Mock authors ported from React domain constant
final List<Author> mockAuthors = [
  Author(
    name: 'Alice Smith',
    handle: 'alicesmith',
    avatar: 'https://picsum.photos/seed/alice/100/100',
    verified: false,
    isOnline: true,
  ),
  Author(
    name: 'Bob Jones',
    handle: 'bobjones',
    avatar: 'https://picsum.photos/seed/bob/100/100',
    verified: true,
    isOnline: true,
  ),
  Author(
    name: 'Charlie Day',
    handle: 'charlie_day',
    avatar: 'https://picsum.photos/seed/charlie/100/100',
    verified: false,
    isOnline: false,
  ),
  Author(
    name: 'Diana Prince',
    handle: 'diana',
    avatar: 'https://picsum.photos/seed/diana/100/100',
    verified: true,
    isOnline: true,
  ),
  Author(
    name: 'Evan Wright',
    handle: 'evanw',
    avatar: 'https://picsum.photos/seed/evan/100/100',
    verified: false,
    isOnline: false,
  ),
];

/// Sample feed data ported from React domain constant
final List<FeedItem> sampleData = [
  // ============================================================================
  // FIRST POST / TASK (Special markers for empty states)
  // ============================================================================
  SocialPostData(
    id: 'first-post-1',
    author: mockAuthors[0],
    content:
        '🚀 Excited to announce our new platform features! Check the docs at https://docs.siapaja.com. We\'ve been working hard on making the experience better for everyone. What do you think @bobjones? #updates #newfeatures \n\nP.S. The new secret code is ||launch2025||.',
    timestamp: 'Just now',
    replies: 0,
    reposts: 0,
    shares: 0,
    votes: 0,
    images: ['https://picsum.photos/seed/announcement/600/400'],
    isFirstPost: true,
  ),
  TaskData(
    id: 'task-empty-1',
    author: mockAuthors[1],
    category: 'Design',
    title: 'Need a quick logo animation',
    description:
        'Looking for an After Effects wizard to animate our SVG logo. Just a simple 3-second reveal. Need it by tomorrow! Call me at 555-019-8372 if you have questions.',
    price: '\$100-150',
    timestamp: 'Just now',
    status: TaskStatus.open,
    iconType: TaskIconType.palette,
    replies: 0,
    reposts: 0,
    shares: 0,
    votes: 0,
    isFirstTask: true,
  ),

  // ============================================================================
  // SOCIAL POSTS
  // ============================================================================
  SocialPostData(
    id: 'social-empty-1',
    author: mockAuthors[4],
    content:
        'Taking a break from coding to enjoy this beautiful sunset. Sometimes you just need to step away from the screen! 🌅',
    timestamp: '2m',
    replies: 0,
    reposts: 0,
    shares: 0,
    votes: 5,
  ),
  SocialPostData(
    id: 'thread-1',
    author: mockAuthors[3],
    content:
        'Designing for the future requires rethinking our foundational assumptions. A short thread on my recent learnings. 🧵',
    timestamp: '1h',
    replies: 2,
    reposts: 12,
    shares: 4,
    votes: 340,
    threadCount: 3,
    threadIndex: 1,
  ),
  SocialPostData(
    id: '1',
    author: mockAuthors[0],
    content:
        'Just finished a great coffee session at the new cafe downtown. The atmosphere is amazing!',
    timestamp: '2h',
    replies: 12,
    reposts: 3,
    shares: 1,
    votes: 45,
    images: ['https://picsum.photos/seed/coffee/600/400'],
    replyAvatars: [mockAuthors[1].avatar, mockAuthors[2].avatar],
  ),
  SocialPostData(
    id: '6',
    author: mockAuthors[4],
    content:
        'Just saw this task and it looks like a great opportunity for anyone in the area who knows plumbing!',
    timestamp: '1h',
    replies: 2,
    reposts: 5,
    shares: 1,
    votes: 34,
    quote: TaskData(
      id: '2',
      author: mockAuthors[1],
      category: 'Repair Needed',
      title: 'Fix leaking kitchen faucet',
      description:
          'My kitchen faucet has been dripping for a week. Need someone to fix it ASAP.',
      price: '\$50-80',
      timestamp: '4h',
      status: TaskStatus.open,
      iconType: TaskIconType.repair,
      replies: 5,
      reposts: 1,
      shares: 0,
      votes: 8,
    ),
  ),
  SocialPostData(
    id: '4',
    author: mockAuthors[3],
    content:
        'Anyone know good mechanics in the area? My car needs brake repair.',
    timestamp: '8h',
    replies: 7,
    reposts: 0,
    shares: 2,
    votes: 12,
  ),
  SocialPostData(
    id: 'social-7',
    author: mockAuthors[2],
    content:
        'Just wrapped up a major project! 🎉 Thanks to everyone who supported me along the way. Time to celebrate!',
    timestamp: '3h',
    replies: 24,
    reposts: 8,
    shares: 3,
    votes: 89,
    images: ['https://picsum.photos/seed/celebration/600/400'],
    replyAvatars: [
      mockAuthors[0].avatar,
      mockAuthors[1].avatar,
      mockAuthors[3].avatar,
    ],
  ),
  SocialPostData(
    id: 'social-8',
    author: mockAuthors[1],
    content:
        'Hot take: The best code is no code at all. Simplicity wins every time. 💡',
    timestamp: '5h',
    replies: 45,
    reposts: 23,
    shares: 12,
    votes: 234,
  ),

  // ============================================================================
  // TASKS - OPEN STATUS
  // ============================================================================
  TaskData(
    id: '2',
    author: mockAuthors[3],
    category: 'Ride Hail',
    title: 'Luxury Airport Transfer (T3)',
    description:
        'Looking for a premium sedan for an airport drop-off. Professional attire and clean vehicle required. Route includes highway tolls which are pre-paid.',
    price: '\$45.00',
    timestamp: '15m',
    status: TaskStatus.open,
    iconType: TaskIconType.car,
    details: 'Premium Airport Transfer',
    tags: ['Premium', 'VIP', 'Airport'],
    replies: 5,
    reposts: 1,
    shares: 0,
    votes: 8,
    mapUrl:
        'https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=800&h=400&auto=format&fit=crop',
  ),
  TaskData(
    id: '5',
    author: mockAuthors[0],
    category: 'Delivery',
    title: 'Deliver documents to downtown office',
    description:
        'Need urgent delivery of important documents. Willing to pay for fast service.',
    price: '\$25',
    timestamp: '1d',
    status: TaskStatus.open,
    iconType: TaskIconType.package,
    replies: 2,
    reposts: 0,
    shares: 0,
    votes: 3,
    mapUrl:
        'https://images.unsplash.com/photo-1554310603-d39d43033735?q=80&w=800&h=400&auto=format&fit=crop',
  ),
  TaskData(
    id: 'task-open-1',
    author: mockAuthors[2],
    category: 'Development',
    title: 'Build a React landing page',
    description:
        'Need a modern, responsive landing page for our SaaS product. Should include hero section, features, pricing, and contact form.',
    price: '\$500-800',
    timestamp: '30m',
    status: TaskStatus.open,
    iconType: TaskIconType.code,
    details: 'Frontend Development',
    tags: ['React', 'TypeScript', 'Tailwind'],
    replies: 8,
    reposts: 4,
    shares: 2,
    votes: 15,
  ),
  TaskData(
    id: 'task-open-2',
    author: mockAuthors[4],
    category: 'Writing',
    title: 'Blog post about AI trends',
    description:
        'Looking for a tech writer to create a 1500-word blog post about emerging AI trends in 2025. SEO knowledge preferred.',
    price: '\$200-300',
    timestamp: '2h',
    status: TaskStatus.open,
    iconType: TaskIconType.writing,
    details: 'Content Writing',
    tags: ['SEO', 'AI', 'Tech'],
    replies: 12,
    reposts: 6,
    shares: 3,
    votes: 28,
  ),

  // ============================================================================
  // TASKS - ASSIGNED STATUS
  // ============================================================================
  TaskData(
    id: 'task-assigned-1',
    author: mockAuthors[1],
    category: 'Design',
    title: 'Mobile app UI redesign',
    description:
        'Redesign our existing mobile app with a fresh, modern look. Must follow Material Design principles.',
    price: '\$800-1200',
    timestamp: '4h',
    status: TaskStatus.assigned,
    iconType: TaskIconType.palette,
    details: 'UI/UX Design',
    tags: ['Mobile', 'Figma', 'Material Design'],
    replies: 15,
    reposts: 3,
    shares: 1,
    votes: 42,
    assignedWorker: mockAuthors[3],
    acceptedBidAmount: '\$950',
  ),
  TaskData(
    id: 'task-assigned-2',
    author: mockAuthors[0],
    category: 'Ride Hail',
    title: 'City tour for tourists',
    description:
        'Need a comfortable vehicle for a 4-hour city tour. 3 passengers with camera equipment.',
    price: '\$120',
    timestamp: '6h',
    status: TaskStatus.assigned,
    iconType: TaskIconType.car,
    details: 'Tourism Service',
    tags: ['Tour', 'VIP', 'Photography'],
    replies: 6,
    reposts: 2,
    shares: 0,
    votes: 18,
    assignedWorker: mockAuthors[4],
    acceptedBidAmount: '\$120',
  ),

  // ============================================================================
  // TASKS - IN PROGRESS STATUS
  // ============================================================================
  TaskData(
    id: 'task-progress-1',
    author: mockAuthors[3],
    category: 'Development',
    title: 'E-commerce integration',
    description:
        'Integrate Stripe payment gateway into existing React application. Need proper error handling and receipt generation.',
    price: '\$600-900',
    timestamp: '12h',
    status: TaskStatus.inProgress,
    iconType: TaskIconType.code,
    details: 'Payment Integration',
    tags: ['Stripe', 'React', 'Node.js'],
    replies: 22,
    reposts: 5,
    shares: 2,
    votes: 56,
    assignedWorker: mockAuthors[0],
    acceptedBidAmount: '\$750',
  ),
  TaskData(
    id: 'task-progress-2',
    author: mockAuthors[2],
    category: 'Delivery',
    title: 'Furniture delivery assistance',
    description:
        'Need help delivering a small sofa and two chairs. Van or truck required. Loading help appreciated.',
    price: '\$80',
    timestamp: '1d',
    status: TaskStatus.inProgress,
    iconType: TaskIconType.truck,
    details: 'Furniture Delivery',
    tags: ['Heavy', 'Vehicle Required'],
    replies: 4,
    reposts: 1,
    shares: 0,
    votes: 9,
    assignedWorker: mockAuthors[1],
    acceptedBidAmount: '\$80',
  ),

  // ============================================================================
  // TASKS - COMPLETED STATUS
  // ============================================================================
  TaskData(
    id: 'task-completed-1',
    author: mockAuthors[4],
    category: 'Design',
    title: 'Social media graphics pack',
    description:
        'Created 20 social media templates for Instagram and LinkedIn. Consistent branding across all designs.',
    price: '\$350',
    timestamp: '2d',
    status: TaskStatus.completed,
    iconType: TaskIconType.palette,
    details: 'Graphics Design',
    tags: ['Social Media', 'Templates', 'Branding'],
    replies: 18,
    reposts: 12,
    shares: 8,
    votes: 67,
    assignedWorker: mockAuthors[2],
    acceptedBidAmount: '\$350',
    images: ['https://picsum.photos/seed/graphics/600/400'],
  ),
  TaskData(
    id: 'task-completed-2',
    author: mockAuthors[1],
    category: 'Writing',
    title: 'Product documentation',
    description:
        'Comprehensive API documentation for our developer platform. Includes code examples and integration guides.',
    price: '\$450',
    timestamp: '3d',
    status: TaskStatus.completed,
    iconType: TaskIconType.writing,
    details: 'Technical Writing',
    tags: ['Documentation', 'API', 'Technical'],
    replies: 9,
    reposts: 7,
    shares: 5,
    votes: 45,
    assignedWorker: mockAuthors[3],
    acceptedBidAmount: '\$450',
  ),

  // ============================================================================
  // TASKS - FINISHED STATUS
  // ============================================================================
  TaskData(
    id: 'task-finished-1',
    author: mockAuthors[0],
    category: 'Development',
    title: 'Full website rebuild',
    description:
        'Complete website overhaul with new design system, improved performance, and SEO optimization. Project delivered ahead of schedule!',
    price: '\$2500',
    timestamp: '1w',
    status: TaskStatus.finished,
    iconType: TaskIconType.code,
    details: 'Full Stack Development',
    tags: ['Website', 'Performance', 'SEO'],
    replies: 34,
    reposts: 28,
    shares: 15,
    votes: 156,
    assignedWorker: mockAuthors[4],
    acceptedBidAmount: '\$2500',
    images: ['https://picsum.photos/seed/website/600/400'],
  ),
  TaskData(
    id: 'task-finished-2',
    author: mockAuthors[3],
    category: 'Ride Hail',
    title: 'Weekend wedding transport',
    description:
        'Provided luxury transportation for wedding party. 5-hour service with multiple stops. Everything went smoothly!',
    price: '\$400',
    timestamp: '1w',
    status: TaskStatus.finished,
    iconType: TaskIconType.car,
    details: 'Event Transportation',
    tags: ['Wedding', 'Luxury', 'Event'],
    replies: 21,
    reposts: 15,
    shares: 6,
    votes: 98,
    assignedWorker: mockAuthors[1],
    acceptedBidAmount: '\$400',
  ),

  // ============================================================================
  // EDITORIAL POSTS
  // ============================================================================
  EditorialData(
    id: '3',
    author: mockAuthors[2],
    tag: 'Tech',
    title: 'The Future of Remote Work in 2025',
    excerpt:
        'As companies continue to adapt to hybrid work models, we explore how the landscape is evolving.',
    timestamp: '6h',
    replies: 28,
    reposts: 15,
    shares: 8,
    votes: 156,
  ),
  EditorialData(
    id: 'editorial-1',
    author: mockAuthors[1],
    tag: 'Business',
    title: 'Building a Successful Freelance Career',
    excerpt:
        'Key strategies for transitioning from traditional employment to a thriving freelance business.',
    timestamp: '1d',
    replies: 42,
    reposts: 31,
    shares: 19,
    votes: 203,
  ),
  EditorialData(
    id: 'editorial-2',
    author: mockAuthors[4],
    tag: 'Design',
    title: 'Minimalism in Modern UI Design',
    excerpt:
        'Why less is more when it comes to creating intuitive and beautiful user interfaces.',
    timestamp: '2d',
    replies: 36,
    reposts: 24,
    shares: 14,
    votes: 178,
  ),
];
