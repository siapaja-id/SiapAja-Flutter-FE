# Post Detail Page Implementation Plan

## Overview
Port the React `PostDetailPage` and `TaskMainContent` components to the Flutter app. The React page handles both social posts and task posts with different layouts, reply threads, bidding system, and task lifecycle management.

## Files to Create

### 1. `lib/features/feed/pages/post_detail_page.dart`
**Purpose:** Main post detail page — the core page being ported.

**Responsibilities:**
- Accept `postId` via route parameter
- Look up the post from `feedNotifierProvider` state
- Maintain a `postStack` for thread navigation (clicking a reply pushes it)
- Render task-specific layout (`TaskMainContent`) or social post layout (`FeedItemCard` with `isMain=true`)
- Bottom action bar that changes based on post type and task status
- Reply input with text field
- Bid submission bottom sheet modal (for tasks)
- Completion modal (for workers to submit proof)
- Review modal (for creators to rate workers and release payment)

**Key State:**
- `postStack: List<FeedItem>` — for nested reply navigation
- `replyText: String` — reply input text
- `_scrollController` — for auto-scroll to bottom on new reply

### 2. `lib/features/feed/pages/task_main_content.dart`
**Purpose:** Full task detail view shown when viewing a task post (instead of the compact `TaskCard`).

**UI Sections:**
- Author header with avatar (xl), name, handle, verified badge, price on right
- First post / first task badges
- Info pill: category icon, category name, timestamp
- Glassmorphism trust card: requester rating (hardcoded 4.9 stars), payment verified
- Status tracker: visual progress bar with 5 steps (Open → Assigned → In Progress → Completed → Finished)
- Assigned worker display with agreed price (when applicable)
- Description text with expand/collapse (>500 chars)
- Media modules: map preview, image carousel, video placeholder, voice note placeholder
- Tags display
- PostActions (votes, replies, reposts, shares)

### 3. `lib/features/feed/widgets/reply_input.dart`
**Purpose:** Bottom fixed reply input bar for social posts.

**UI:**
- TextField with placeholder "Reply to @handle..."
- Send button (when text is non-empty) or expand button (when empty)
- Expand button opens `CreateReplyPage` as fullscreen overlay

### 4. `lib/features/feed/pages/create_reply_page.dart`
**Purpose:** Fullscreen reply composition overlay (ported from React `CreatePostPage`).

**UI:**
- Top: parent post context card (author avatar, handle, content preview)
- Middle: large text area for composing reply
- Bottom: Post button
- Back/close button in app bar

### 5. Update `lib/features/feed/viewmodels/feed_viewmodel.dart`
**Changes:**
- Add `replies: Map<String, List<FeedItem>>` to `FeedState`
- Add methods: `addReply(parentId, item)`, `setReplies(parentId, items)`, `updateReply(parentId, replyId, updates)`
- Fix `updateFeedItem` to actually use `copyWith` on the items
- Add `getItemById(id)` helper

### 5. Update `lib/features/feed/viewmodels/app_viewmodel.dart`
**Changes:**
- Initialize `currentUser` with a mock user (currently null)

### 6. Update `lib/app_router.dart`
**Changes:**
- Wire `/post/:id` to `PostDetailPage`
- Wire `/task/:id` to `PostDetailPage`

### 7. `lib/features/feed/data/reply_generator.dart` (or inline in post_detail_page.dart)
**Purpose:** `getReplies()` helper that generates mock replies for a post.

## Implementation Order

1. **Feed state extensions** — add replies map, fix updateFeedItem, add currentUser
2. **Reply input widget** — bottom reply bar with expand support
3. **Create reply page** — fullscreen reply overlay
4. **Task main content** — detailed task view widget
5. **Post detail page** — the main page composing everything
6. **Router wiring** — connect routes to the new page

## Ported React → Flutter Mappings

| React | Flutter |
|-------|---------|
| `useParams()` | `GoRouterState.of(context).pathParameters['id']` |
| `location.state?.post` | Lookup from `feedNotifierProvider` by ID |
| `useState` | `StatefulWidget` state fields |
| `useRef` | `ScrollController` |
| `AnimatePresence` | `showModalBottomSheet` |
| `motion.div` | `AnimatedContainer` |
| `ReplyInput` | Inline `TextField` + send button |
| `AutoResizeTextarea` | `TextField` with `maxLines: null` |
| `DetailHeader` | `AppBar` with back button and title |
| `CreatePostPage` (fullscreen reply) | `CreateReplyPage` shown via `Navigator.push` as fullscreen route |
| `PageSlide` | Standard `MaterialPageRoute` transition |

## Out of Scope (future)
- Actual API integration (still using mock data)
- Video/audio player (placeholders only)
- Multi-thread post creation (thread composer)
