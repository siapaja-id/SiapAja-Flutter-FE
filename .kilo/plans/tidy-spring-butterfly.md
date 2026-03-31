# Fix `debugFrameWasSentToEngine` Assertion + Lag

## Root Cause Analysis

### The Core Bug: Frame Deferral Imbalance in `main.dart`

In the `builder` callback of `MaterialApp.router` (line 22), on desktop (width >= 768), the GoRouter's `child` (Navigator) is completely replaced with `DesktopKanbanLayout`:

```dart
// lib/main.dart:22-30 — CURRENT (BROKEN)
builder: (context, child) {
  return LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth >= 768) {
        return const ZoomWrapper(child: DesktopKanbanLayout());
      }
      return ZoomWrapper(child: child!);
    },
  );
},
```

The GoRouter's Navigator (passed as `child`) is created by `MaterialApp.router` and calls `deferFirstFrame()` during initialization (to resolve the initial route). On mobile, the child IS mounted → Navigator eventually calls `allowFirstFrame()` → frame is sent → assertion passes. On desktop, the child is NEVER mounted → `allowFirstFrame()` is NEVER called → `_firstFrameDeferredCount` stays > 0 → `sendFramesToEngine` returns `false` → frame is deferred → timing callback fires for a DIFFERENT frame → `debugFrameWasSentToEngine` is `false` → **assertion failure**.

The assertion repeats because:
1. Each failed drawFrame schedules a new frame
2. The timing callback (registered in each drawFrame) fires for frames sent by OTHER code
3. `_needToReportFirstFrame` stays `true` → cycle repeats

### Secondary Issue: `_PulsingDot` Continuous Animation

`_PulsingDot` was added in the diff (task_main_content.dart:1369-1407). It uses `AnimationController..repeat(reverse: true)` — ticks every frame forever at 60Hz. Each tick rebuilds via `AnimatedBuilder`. This is used in task detail pages and status badges, consuming frame budget continuously.

## Plan: 3 Changes

### Change 1 — Fix frame deferral in `main.dart` (CRITICAL)

**File:** `lib/main.dart:22-30`

Keep the GoRouter child mounted (via `Offstage` + `SizedBox.shrink`) on desktop so the Navigator can complete its frame deferral lifecycle:

```dart
builder: (context, child) {
  return LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth >= 768) {
        return ZoomWrapper(
          child: Stack(
            children: [
              Offstage(child: SizedBox(child: child)),
              const DesktopKanbanLayout(),
            ],
          ),
        );
      }
      return ZoomWrapper(child: child!);
    },
  );
},
```

**Why Offstage + SizedBox:** `Offstage` keeps the child mounted (so Navigator's `allowFirstFrame()` is called), but the child doesn't paint or take up space. `SizedBox` around the child provides a valid layout constraint so the Navigator can resolve its routes without layout errors.

### Change 2 — Remove `_PulsingDot` continuous animation

**File:** `lib/features/feed/pages/task_main_content.dart:1369-1407`

Replace the `AnimationController..repeat(reverse: true)` + `AnimatedBuilder` with a static `Container` dot. This eliminates continuous frame consumption:

```dart
// Before:
class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 1.0,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(opacity: _animation.value, child: child);
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }
}

// After:
class _PulsingDot extends StatelessWidget {
  final Color color;
  final double size;

  const _PulsingDot({required this.color, this.size = 8});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
```

### Change 3 — Guard `setColumnActiveTab` against mid-animation calls

**File:** `lib/features/feed/pages/feed_page.dart:189-193`

The `_onTabChanged` listener fires during TabController's animation frame. It calls `setColumnActiveTab` which mutates provider state during a frame callback. Add a `mounted` guard and `SchedulerBinding.instance.addPostFrameCallback` to defer the state mutation:

```dart
void _onTabChanged() {
  if (!_tabController.indexIsChanging && mounted) {
    final index = _tabController.index;
    // Defer provider mutation to post-frame to avoid frame-scheduling conflict
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(kanbanProvider.notifier).setColumnActiveTab(widget.columnId, index);
      }
    });
  }
}
```

## Files to Modify

| File | Change |
|------|--------|
| `lib/main.dart:22-30` | Wrap child in Offstage + SizedBox on desktop |
| `lib/features/feed/pages/task_main_content.dart:1369-1407` | Remove pulsing animation, make StatelessWidget |
| `lib/features/feed/pages/feed_page.dart:189-193` | Defer setColumnActiveTab to post-frame |

## Expected Result

- `debugFrameWasSentToEngine` assertion eliminated (GoRouter child always mounted)
- Frame budget freed (no more continuous animation)
- No frame-scheduling conflicts from tab changes
- Heavy lag eliminated, smooth interactivity restored
