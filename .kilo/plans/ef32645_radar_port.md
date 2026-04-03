# Plan: Port Git Commit ef32645 to Flutter

## Context
React commit ef32645 introduces:
1. **Radar Page** - A full-page swipeable card interface (Tinder-like) replacing the GigMatcher popup
2. **Estafet Queue** - Worker queue system for back-to-back jobs (activeGig + queuedGigs)
3. **Auto-Pilot** - Toggle that auto-accepts gigs every 2.5s
4. **Swipe-up Bidding** - Upward swipe triggers BidSheet for counter-offers
5. **Navigation changes** - `/explore` → `/radar` with Zap icon
6. **Type changes** - `matchType: 'instant'` → `'swipe'`, added `autoAccept?: boolean` to OrderData
7. **MatchSuccess updates** - Shows "Up Next!" with ListOrdered icon when queued

## Files to Create (New)

### 1. `lib/models/gig.dart` — Gig model
- Freezed class with: id, title, type (enum), distance, time, price, description, iconType (TaskIconType), meta?, tags, clientName, clientRating
- Reuse existing TaskIconType enum from feed_item.dart

### 2. `lib/shared/constants/mock_gigs.dart` — GIGS constant
- Port the single mock gig from React `mock-gigs.ts`
- `GIGS` list with one Gig entry: "Minimalist Brand Identity" by "Aura Hotels"

### 3. `lib/features/feed/pages/radar_page.dart` — RadarPage
This is the main new page. It replicates React's `Radar.Page.tsx` with identical UI/UX:

**Layout structure:**
- Full-page dark container with max-width constraint
- Estafet banner (animated) at top when activeGig exists — shows current gig title + queued count
- Header with "Radar" label + Auto-Pilot toggle (animated switch)
- Card stack area with three states:
  - **Auto-Pilot active**: Pulsing radar rings animation with Bot icon + "Auto-Pilot Active" text
  - **Cards available**: Stack of animated GigCards (current + next card visible)
  - **Queue empty**: Search icon + "Queue Empty" + "Return Home" button

**GigCard widget:**
- Draggable card with Flutter animations equivalent to framer-motion
- Swipe thresholds: right=accept, left=pass, up=bid
- Visual overlays: "ACCEPT" stamp (green, right swipe), "PASS" stamp (red, left swipe), "BID" stamp (primary color, up swipe)
- Next card scale/opacity animation behind current card
- Action buttons at bottom: X (pass), Bid (up arrow), Check (accept)
- Card content: icon, price, type badge, client name, title, location/time info blocks, project brief

**State management:**
- Uses Riverpod — reads/writes activeGig, queuedGigs, isAutoPilot from app_viewmodel
- Local state: currentIndex, swipeDirection, matchedGig, biddingGig, bidAmount, replyText
- Auto-pilot: Timer that auto-swipes right every 2.5s

**Modals:**
- MatchSuccessSheet overlay when gig is matched/queued
- BidSheet overlay when user swipes up

### 4. `lib/features/feed/widgets/match_success_sheet.dart` — MatchSuccessSheet
- Full-screen overlay with atmospheric radial gradient background
- Particle animation (30 floating emerald dots)
- Radar rings animation (3 expanding circles)
- Central emerald circle with Check icon (match) or ListOrdered icon (queued)
- "It's a Match!" or "Up Next!" heading
- Gig detail card (icon, price, title, time/distance badges)
- Action buttons: "Navigate via Google Maps", "Message client", "Keep Swiping", "Dashboard"

## Files to Modify

### 5. `lib/features/feed/viewmodels/app_viewmodel.dart` — Add Radar state
Add to UiState freezed class:
- `activeGig` (Gig?) — currently active/assigned gig
- `queuedGigs` (List<Gig>) — estafet queue
- `isAutoPilot` (bool) — auto-pilot toggle

Add to UiStateNotifier:
- `setActiveGig(Gig? gig)`
- `addQueuedGig(Gig gig)`
- `setIsAutoPilot(bool isAuto)`

### 6. `lib/app_router.dart` — Route changes
- Replace `/explore` route (ScaffoldPageStub 'Explore') with `/radar` → `RadarPage()`
- Keep all other routes unchanged

### 7. `lib/features/feed/pages/main_shell.dart` — Bottom nav changes
- Replace Explore nav item (magnifyingGlass icon, '/explore') with Radar (lightning/zap icon, '/radar')
- Use `PhosphorIconsRegular.lightning` for the Zap equivalent
- Update `_getSelectedIndex` to handle '/radar' path

### 8. `lib/features/feed/widgets/floating_sidebar.dart` — Desktop sidebar changes
- Replace Explore nav item (magnifyingGlass, '/explore') with Radar (lightning, '/radar')

## Files NOT needing changes
- `lib/main.dart` — No GigMatcher auto-popup exists in Flutter (was removed in React commit)
- ReviewOrder page — Does not exist in Flutter yet, so no matchType change needed
- `lib/models/feed_item.dart` — OrderData doesn't exist as a separate model; matchType changes would apply when OrderData is created

## Implementation Order
1. Create Gig model
2. Create mock GIGS constant
3. Update app_viewmodel with Radar state
4. Create MatchSuccessSheet widget
5. Create RadarPage (largest file)
6. Update app_router.dart
7. Update main_shell.dart
8. Update floating_sidebar.dart

## Key UI/UX Fidelity Points
- Card animations must match React's framer-motion behavior (spring physics, drag elasticity)
- Swipe thresholds identical (100px offset or 500 velocity)
- Auto-Pilot radar ring animation matches React (3 staggered expanding rings)
- MatchSuccess particle effect matches React (30 floating emerald dots)
- Estafet banner animation matches React (height + opacity spring)
- All colors, typography, spacing match the React implementation
- Glass morphism effects consistent with existing Flutter app patterns
