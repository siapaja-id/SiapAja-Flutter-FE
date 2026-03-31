# Plan: Port React Kanban Desktop Layout to Flutter (Zero UI/UX Regressions)

## Context

The React project has two commits implementing a desktop kanban layout:
- **3658bcb**: Desktop kanban with horizontal columns, floating sidebar, column spawning on clicks
- **5ba6060**: Glass bar column headers with icon, title, position badge, close button

The Flutter project currently uses mobile-only bottom navigation. This plan adds responsive behavior: width < 768 keeps existing mobile layout **100% unchanged**, width >= 768 shows kanban layout.

---

## REGRESSION GUARANTEE

The mobile path remains completely untouched:
- `MainShell` (bottom nav) — unchanged
- `FeedPage` (header, tabs, karma) — unchanged
- `AppRouter` (GoRouter config) — unchanged
- `PostDetailPage` with `context.pop()` — unchanged
- All existing animations (scroll-hide bars, `AnimatedSlide`, `AnimatedScale`, `AnimatedContainer`, `InteractiveFeedCard` hover/glow) — unchanged
- `ZoomWrapper` with `FittedBox` — wraps both layouts identically

The `main.dart` builder switches between mobile router and desktop kanban based on width. Mobile path is identical to current.

---

## Architecture Decision: Responsive Entry Point

```
main.dart
  └── MaterialApp.builder
        ├── if width < 768: ZoomWrapper(child: RouterOutlet)  ← existing mobile path
        └── if width >= 768: ZoomWrapper(child: DesktopKanbanLayout)  ← new desktop path
```

Both paths share the same Riverpod providers. The `kanbanProvider` is always available but only the desktop layout uses it. Mobile path's `GoRouter` navigation is completely independent.

---

## Files to Create

### 1. `lib/models/kanban_column.dart`

```dart
class KanbanColumn {
  final String id;
  final String path;
  final double width;
  final Map<String, dynamic>? routeState;
  final int? activeTab; // per-column tab state for Home feed
}
```

- `copyWith` method for immutable updates
- Used by the kanban viewmodel to track open columns

---

### 2. `lib/features/feed/viewmodels/kanban_viewmodel.dart`

**State:**
```dart
class KanbanState {
  final List<KanbanColumn> columns;
  final bool isDesktop;
}
```

**Notifier methods:**
- `openColumn(String path, {String? sourceId, Map<String, dynamic>? routeState})`
  - Creates new column with random ID, default width 420
  - If `sourceId` provided, inserts after the source column (React behavior)
  - Otherwise appends to end
- `closeColumn(String id)` — removes column, never removes first (index 0)
- `setColumnWidth(String id, double width)` — clamps to [320, 800]
- `setIsDesktop(bool)` — updates desktop flag
- `setColumnActiveTab(String columnId, int tab)` — per-column tab

**Initial state:** `[{ id: 'main-col', path: '/', width: 420, activeTab: 0 }]`

**Provider:** `kanbanProvider = NotifierProvider<KanbanNotifier, KanbanState>`

---

### 3. `lib/features/feed/widgets/floating_sidebar.dart`

**Layout:**
- Fixed left, full height, z-index above columns
- `AnimatedContainer` width: 80px collapsed ↔ 240px expanded (300ms ease)
- Glassmorphism: `BackdropFilter(blur: 12)`, `glassTint` bg, `glassBorder` right edge
- Shadow: `BoxShadow(blur: 40, color: black54)`

**Content (top to bottom):**
1. Toggle button: `PanelLeftOpen` / `PanelLeftClose` icon (Phosphor `sidebar`/`sidebarSimple` equivalents)
   - When collapsed: centered in sidebar
   - When expanded: aligned to right edge with padding
2. Nav items column (centered):
   - Home (`house`), Explore (`magnifyingGlass`), Create (`plus` — primary bg), Messages (`chatCircle`), Orders (`clipboardText`), Profile (`user`)
   - Create button: primary bg, shadow, no column spawning (opens create modal via `ref.read`)
   - Other items: `openColumn(item.route)` on tap
   - When expanded: icon + label text with `AnimatedOpacity`/`AnimatedSlide` for label reveal
   - When collapsed: icon only, centered
3. Spacer
4. User card at bottom:
   - Avatar with online indicator
   - When expanded: name + karma text
   - When collapsed: avatar only, centered
   - Tap: `openColumn('/profile', routeState: {user: currentUser})`

**Animation details:**
- Sidebar expand/collapse: `AnimatedContainer(duration: 300ms, curve: easeOutCubic)`
- Label text appear: `AnimatedOpacity(duration: 200ms)` + `AnimatedSlide(offset: (-0.2, 0), duration: 250ms)`
- Nav item hover: `MouseRegion` → subtle white overlay on hover

---

### 4. `lib/features/feed/widgets/kanban_column_widget.dart`

**Layout (vertical):**
1. Column header bar (36px height)
2. Column content (expanded)
3. Resizer handle (right edge)

**Column Header Bar:**
- Height: 36px, `minHeight: 36px`
- Background: `Colors.white.withOpacity(0.03)`
- Border bottom: `Colors.white.withOpacity(0.06)`
- `Row` with three sections:

**Left section:**
- Icon container: 24×24, rounded 8px, `Colors.white.withOpacity(0.06)` bg, 50% white icon
- Title text: 11px, weight 700, 65% white, letter-spacing 0.03em, ellipsis overflow
- Title mapping from path:
  - `/` → `Home` (icon: `house`)
  - `/explore` → `Explore` (icon: `compass`)
  - `/messages` → `Messages` (icon: `chatCircle`)
  - `/orders` → `Orders` (icon: `shoppingCart`)
  - `/profile` → user name from `routeState.user.name`, fallback `Profile` (icon: `userCircle`)
  - `/create-post` → `New Post` (icon: `pencilSimple`)
  - `/review-order` → `Review Order` (icon: `fileText`)
  - `/payment` → `Payment` (icon: `creditCard`)
  - `/post/*` → `Post` (icon: `fileText`)
  - `/task/*` → `Task` (icon: `clipboardText`)
  - default → `Column` (icon: `magnifyingGlass`)

**Right section:**
- Position badge: `"$index/$total"` — 9px, weight 800, 25% white, `Colors.white.withOpacity(0.04)` bg, rounded 6px — only shown when `total > 1`
- Close button: 22×22, rounded 7px, transparent bg, 25% white icon
  - Hover: `Colors.red.withOpacity(0.15)` bg, `#f87171` color
  - Press: scale 0.9 via `AnimatedScale`
  - Hidden for first column (index 0)

**Column Body:**
- `Navigator` widget with `key: ValueKey(col.id)` 
- `onGenerateRoute` handles all routes matching `AppRouter` paths
- Uses `MaterialPageRoute` for transitions (preserves existing page transition animations)

**Resizer:**
- Positioned right edge, vertical center, 4px wide, 64px tall
- Visible on column hover (`MouseRegion` on column wrapper)
- Background: `Colors.white.withOpacity(0.2)`, rounded
- `GestureDetector.onHorizontalDragUpdate` → `setColumnWidth`
- Active state: red background

**Container styling:**
- Rounded corners: 36px (all sides)
- Border: `Colors.white.withOpacity(0.1)`
- Background: `Color(0x801F1F1F)` (50% opacity dark) with `BackdropFilter(blur: 40px)`
- Shadow: `BoxShadow(blur: 50, spread: -12, color: black54)`

---

### 5. `lib/features/feed/pages/desktop_kanban_layout.dart`

**Layout structure:**
```
SizedBox(width: screenWidth, height: screenHeight)
  └── Row
        ├── FloatingSidebar (fixed 80/240px)
        └── Expanded
              └── Stack
                    ├── Scrollable columns area
                    └── Add column button (right edge)
```

**Scrollable columns area:**
- `SingleChildScrollView` with `ScrollController`, horizontal scroll
- `Row` of `KanbanColumnWidget` instances
- `scroll-snap-type: x mandatory` equivalent via `PageScrollPhysics` or custom
- Padding: left 0 (sidebar handles spacing), right 80px (room for add button)

**Column management with animation:**
- Track per-column `AnimationController` in a `Map<String, AnimationController>`
- On column add: create controller, `forward()` with spring-like curve
- On column remove: `reverse()`, then remove from state
- Wrap each column in `AnimatedBuilder` with slide + scale transition:
  ```dart
  // Enter: slide from right + scale from 0.95 to 1.0
  Tween(begin: Offset(1.0, 0.0), end: Offset.zero) + Tween(begin: 0.95, end: 1.0)
  // Curve: Curves.easeOutCubic (matches React spring damping 25)
  // Duration: 350ms
  ```
  ```dart
  // Exit: scale from 1.0 to 0.9 + fade out
  Tween(begin: 1.0, end: 0.9) + Tween(begin: 1.0, end: 0.0)
  // Duration: 250ms, curve: Curves.easeInCubic
  ```

**Auto-scroll:**
- When `columns.length` changes (new column added), auto-scroll to end
- `WidgetsBinding.instance.addPostFrameCallback` → `scrollController.animateTo(scrollController.position.maxScrollExtent, duration: 350ms, curve: easeOutCubic)`

**Add column button:**
- Fixed at right edge, vertically centered
- 56×56 circle, glass bg, border, shadow
- `Plus` icon with rotate-on-hover animation
- `onTap: openColumn('/')`

**Background gradient:**
- Same as `MainShell`: primary→indigo→emerald→transparent gradient behind content

---

## Files to Modify

### 6. `lib/main.dart` — Responsive layout switching

**Changes:**
- Replace `MaterialApp.router` with `MaterialApp` using a `LayoutBuilder` in `builder`
- The builder checks `constraints.maxWidth`:
  - `< 768`: returns `MaterialApp.router(routerConfig: AppRouter.router)` wrapped in `ZoomWrapper`
  - `>= 768`: returns `DesktopKanbanLayout` wrapped in `ZoomWrapper`

**Implementation approach:**
```dart
// Use MaterialApp with manual routing for responsive support
MaterialApp(
  builder: (context, child) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 768) {
          return ZoomWrapper(child: DesktopKanbanLayout());
        }
        // For mobile, use GoRouter
        return ZoomWrapper(child: child!);
      },
    );
  },
  routerConfig: AppRouter.router, // only used when width < 768
)
```

**Edge case:** On window resize crossing 768 boundary, the widget tree rebuilds. Mobile state (GoRouter navigation stack) is lost, and desktop starts with default column. This is acceptable — same behavior as React.

---

### 7. `lib/features/feed/pages/feed_page.dart` — Inline header for kanban

**Add optional parameter:** `String? columnId`

**When `columnId != null` (kanban mode):**
- Show `FeedHeader` (avatar, tabs, karma) as the first item in the `ListView` (not as floating overlay)
- The header uses `columnId` to call `kanbanProvider.setColumnActiveTab(columnId, tab)` for per-column tab state
- Avatar tap: `kanbanProvider.openColumn('/profile', sourceId: columnId)`
- Karma tap: `kanbanProvider.openColumn('/profile', sourceId: columnId)`

**When `columnId == null` (mobile mode):**
- Existing floating header behavior — unchanged

**No changes to:** scroll controller, `_onScroll` hide/show bars logic, `RefreshIndicator`, `FeedComposer`

---

### 8. `lib/features/feed/widgets/base_feed_card.dart` — Column-aware navigation

**Add optional parameter:** `String? columnId`

**When `columnId != null` (desktop kanban):**
- Card tap: `ref.read(kanbanProvider.notifier).openColumn(path, sourceId: columnId)` instead of `context.go(path)`
  - Path is `/post/${data.id}` or `/task/${data.id}` based on type
- User name/avatar tap: `ref.read(kanbanProvider.notifier).openColumn('/profile', sourceId: columnId, routeState: {'user': data.author.toMap()})`
- Quote taps: remain as-is (they're inside the same column, no new column)

**When `columnId == null` (mobile):**
- Existing `context.go(path)` behavior — unchanged

**Implementation:** Read `KanbanColumnContext` from widget tree (see step 9). If it exists, use kanban navigation. Otherwise use GoRouter.

---

### 9. Add `KanbanColumnContext` InheritedWidget

**Create in `kanban_column_widget.dart`:**
```dart
class KanbanColumnContext extends InheritedWidget {
  final String columnId;
  final String path;
  // ...
}
```

Placed at the column level so all descendants can access `columnId` for spawning new columns. Accessed via `context.dependOnInheritedWidgetOfExactType<KanbanColumnContext>()`.

---

### 10. `lib/features/feed/widgets/social_post_card.dart` — Column-aware quote taps

**Change:** In the quote `GestureDetector.onTap`, check for `KanbanColumnContext`. If present and `isMain`, use `kanbanProvider.openColumn('/post/${quote.id}', sourceId: columnId)`.

**All other behavior unchanged.**

---

### 11. `lib/features/feed/widgets/task_card.dart` — Column-aware task taps

**Change:** In `BaseFeedCard.onClick`, the card tap already routes through `BaseFeedCard`. No changes needed here since `BaseFeedCard` handles the navigation.

**Actually:** The `TaskCard` passes `onClick` to `BaseFeedCard`. When null, `BaseFeedCard` handles routing. When not null, it calls the override. Currently `TaskCard` passes `onClick` through — no change needed.

---

### 12. `lib/features/feed/pages/post_detail_page.dart` — Dual-mode support

**Add optional parameter:** `bool inKanban`

**When `inKanban == true`:**
- Remove outer `Scaffold` — just render the `Column` content directly
- Replace `context.pop()` with a callback or column-level navigation
- The `_DetailHeader` back button should pop within the column's Navigator
- Remove the `Container` with left/right borders (column container already has borders)

**When `inKanban == false`:**
- Existing `Scaffold` wrapper — unchanged

**Route generation in kanban column:**
```dart
onGenerateRoute: (settings) {
  return MaterialPageRoute(
    builder: (context) {
      // Parse route, return appropriate widget with inKanban: true
    },
  );
}
```

---

### 13. `lib/features/feed/providers.dart` — Export kanban provider

Add: `export 'viewmodels/kanban_viewmodel.dart';`

---

## Animation Specifications

### Column Enter Animation
| Property | From | To | Duration | Curve |
|---|---|---|---|---|
| Offset X | 50px right | 0 | 350ms | `Curves.easeOutCubic` |
| Scale | 0.95 | 1.0 | 350ms | `Curves.easeOutCubic` |
| Opacity | 0.0 | 1.0 | 300ms | `Curves.easeOut` |

Equivalent to React: `initial={{ opacity: 0, x: 50, scale: 0.95 }} animate={{ opacity: 1, x: 0, scale: 1 }} transition={{ type: "spring", stiffness: 300, damping: 25 }}`

### Column Exit Animation
| Property | From | To | Duration | Curve |
|---|---|---|---|---|
| Scale | 1.0 | 0.9 | 250ms | `Curves.easeInCubic` |
| Opacity | 1.0 | 0.0 | 200ms | `Curves.easeIn` |

Equivalent to React: `exit={{ opacity: 0, scale: 0.9 }}`

### Sidebar Toggle
| Property | From | To | Duration | Curve |
|---|---|---|---|---|
| Width | 80 | 240 (or reverse) | 300ms | `Curves.easeOutCubic` |

### Auto-scroll to New Column
| Property | Duration | Curve |
|---|---|---|
| Scroll position | 350ms | `Curves.easeOutCubic` |

### Add Button Icon Rotation
| Property | From | To | Duration | Curve |
|---|---|---|---|---|
| Rotation | 0° | 90° | 300ms | `Curves.easeOutCubic` |

On hover via `MouseRegion`.

### Close Button Press
| Property | Value | Duration | Curve |
|---|---|---|---|
| Scale | 0.9 | 100ms | `Curves.easeInOut` |

### Column Resizer
- Appears on column hover with `AnimatedOpacity(duration: 200ms)`
- Turns red when actively dragging (`AnimatedContainer` color transition)

---

## Column Navigator Route Map

Each column's `Navigator` handles these routes:
- `/` → `FeedPage(columnId: colId)`
- `/explore` → `ScaffoldPageStub(title: 'Explore')`
- `/messages` → `ScaffoldPageStub(title: 'Messages')`
- `/orders` → `ScaffoldPageStub(title: 'Orders')`
- `/profile` → `ProfilePage(user: routeState?['user'])` (new profile page needed, or reuse existing)
- `/post/:id` → `PostDetailPage(postId: id, inKanban: true)`
- `/task/:id` → `PostDetailPage(postId: id, inKanban: true)`
- `/create-post` → `ScaffoldPageStub(title: 'New Post')`
- `/review-order` → `ScaffoldPageStub(title: 'Review Order')`
- `/payment` → `ScaffoldPageStub(title: 'Payment')`

---

## Edge Cases & Interactions Preserved

1. **Feed scroll hide/show bars**: Only applies to `FeedPage` in mobile mode. In kanban, each column scrolls independently, no bar hiding.

2. **ReplyInput fullscreen expansion**: Uses `Navigator.of(context).push(PageRouteBuilder(...))`. In kanban, this pushes to the column's Navigator — works correctly, the fullscreen reply opens within the column.

3. **PostDetailPage thread navigation**: Uses `_postStack` list for internal push/pop. Works identically in both modes.

4. **Modal bottom sheets** (bid, complete, review): Use `showModalBottomSheet` which uses root Navigator. These will overlay the entire screen — acceptable behavior.

5. **ZoomWrapper**: Wraps both mobile and desktop layouts identically. Desktop kanban with zoom: sidebar stays fixed, columns scale via FittedBox.

6. **RefreshIndicator in feed**: Works within the column's scrollable area. Pull-to-refresh triggers `feedNotifierProvider.refreshFeed()` — shared state, all columns update.

7. **Vote/repost state**: Shared via Riverpod providers. Changes in one column reflect in all columns showing the same post.

8. **InteractiveFeedCard hover/glow**: Works in both modes. MouseRegion hover detection works inside kanban columns.

---

## Implementation Order

1. `lib/models/kanban_column.dart` — data model
2. `lib/features/feed/viewmodels/kanban_viewmodel.dart` — state management
3. `lib/features/feed/providers.dart` — export new provider
4. `lib/features/feed/widgets/floating_sidebar.dart` — sidebar widget
5. `lib/features/feed/widgets/kanban_column_widget.dart` — column + header + KanbanColumnContext
6. `lib/features/feed/pages/desktop_kanban_layout.dart` — main layout composing sidebar + columns
7. `lib/main.dart` — responsive switching
8. `lib/features/feed/pages/feed_page.dart` — column-aware inline header
9. `lib/features/feed/widgets/base_feed_card.dart` — column-aware navigation
10. `lib/features/feed/widgets/social_post_card.dart` — column-aware quote taps
11. `lib/features/feed/pages/post_detail_page.dart` — inKanban mode
12. `flutter analyze` — verify no errors
13. Visual + interaction testing

---

## Verification Checklist

- [ ] `flutter analyze` — 0 errors, 0 warnings
- [ ] Mobile: bottom nav shows, feed header floats, scroll hides bars
- [ ] Mobile: card tap → PostDetailPage with back navigation
- [ ] Mobile: reply fullscreen expansion works
- [ ] Mobile: all modals (bid, complete, review) work
- [ ] Desktop: floating sidebar shows, expandable
- [ ] Desktop: kanban columns render with glass headers
- [ ] Desktop: column header shows correct icon + title + badge
- [ ] Desktop: card tap opens new column (slide+scale animation)
- [ ] Desktop: close button removes column (fade+scale animation)
- [ ] Desktop: column resizer drag works (320-800px range)
- [ ] Desktop: auto-scroll to new column
- [ ] Desktop: add button opens new column
- [ ] Desktop: profile column shows user name in header
- [ ] Desktop: reply input works within columns
- [ ] Desktop: thread navigation works within columns
- [ ] Zoom: both layouts scale correctly with Ctrl+scroll
