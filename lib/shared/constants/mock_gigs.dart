import 'package:siapaja_flutter_fe/models/gig.dart';
import 'package:siapaja_flutter_fe/models/feed_item.dart';

const gigs = [
  Gig(
    id: 'g1',
    title: 'Minimalist Brand Identity',
    type: GigType.design,
    distance: 'Remote',
    time: '3 days',
    price: '\$850.00',
    description:
        'Create a clean, luxury brand identity for a new boutique hotel. Need logo, color palette, and typography.',
    iconType: TaskIconType.palette,
    tags: ['Branding', 'UI/UX'],
    clientName: 'Aura Hotels',
    clientRating: 4.9,
  ),
  Gig(
    id: 'g2',
    title: 'React Native App Fix',
    type: GigType.dev,
    distance: '2.3 mi',
    time: '1 day',
    price: '\$250.00',
    description:
        'Fix navigation stack issues in our existing React Native delivery app. Navigation hangs on certain screens.',
    iconType: TaskIconType.code,
    tags: ['Mobile', 'Bug Fix'],
    clientName: 'QuickDeliver',
    clientRating: 4.7,
  ),
  Gig(
    id: 'g3',
    title: 'Moving Assistance',
    type: GigType.delivery,
    distance: '1.5 mi',
    time: '4 hours',
    price: '\$120.00',
    description:
        'Need help moving furniture from 2nd floor apartment to storage unit. Heavy lifting required.',
    iconType: TaskIconType.truck,
    tags: ['Moving', 'Labor'],
    clientName: 'Mark T.',
    clientRating: 4.8,
  ),
  Gig(
    id: 'g4',
    title: 'Logo Design Contest',
    type: GigType.design,
    distance: '0.8 mi',
    time: '6 hours',
    price: '\$450.00',
    description:
        'Corporate logo redesign for annual shareholder meeting. Need modern, minimalist approach.',
    iconType: TaskIconType.palette,
    tags: ['Design', 'Logo'],
    clientName: 'Summit Partners',
    clientRating: 5.0,
  ),
  Gig(
    id: 'g5',
    title: 'Blog Content Writing',
    type: GigType.writing,
    distance: 'Remote',
    time: '2 days',
    price: '\$200.00',
    description:
        'Write 4 SEO-optimized blog posts about sustainable fashion trends. 800 words each with keyword research.',
    iconType: TaskIconType.writing,
    tags: ['Content', 'SEO'],
    clientName: 'GreenThreadz',
    clientRating: 4.6,
  ),
];
