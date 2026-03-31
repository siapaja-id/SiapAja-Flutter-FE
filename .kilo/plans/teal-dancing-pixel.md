# Replace Manual Animations with `animations` 2.1.2

## Context

The project already has `animations: ^2.1.2` in `pubspec.yaml` and uses `FadeScaleTransition` in `kanban_column_widget.dart`. However, several files still have manual `AnimationController` + `Tween` + `CurvedAnimation` + `SlideTransition`/`FadeTransition` boilerplate that can be replaced with `SharedAxisTransition` from the `animations` package — which combines fade + directional slide in a single widget.

## Changes

### 1. `lib/features/feed/widgets/kanban_column_widget.dart`

**Lines 200-212** — Replace `FadeScaleTransition` + manual `SlideTransition` with `SharedAxisTransition`:

```dart
// BEFORE (12 lines):
FadeScaleTransition(
  animation: _entranceController,
  child: SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(0.08, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeOutCubic,
      ),
    ),
    child: AnimatedBuilder(...),

// AFTER (5 lines):
SharedAxisTransition(
  animation: _entranceController,
  secondaryAnimation: kAlwaysDismissedAnimation,
  transitionType: SharedAxisTransitionType.horizontal,
  child: AnimatedBuilder(...),
```

- The `_entranceController` and hover logic stays as-is (hover is a custom effect, not a page transition)

### 2. `lib/features/feed/pages/create_reply_page.dart`

**Remove manual animation entirely** — replace `SlideTransition` + `FadeTransition` with `SharedAxisTransition`:

- Remove `SingleTickerProviderStateMixin` from the State class
- Remove fields: `_animController`, `_fadeAnim`, `_slideAnim`
- Remove `initState` animation setup (lines 41-54)
- Remove `_animController.dispose()` from `dispose()`
- In `_onBack()` (line 68): simplify to just `Navigator.of(context).pop()` — the route transition handles animation
- In `_handlePost()` (line 111): simplify to just `Navigator.of(context).pop()`
- In `build()` (lines 162-165): replace `SlideTransition` + `FadeTransition` wrapper with `SharedAxisTransition`:

```dart
// BEFORE:
return SlideTransition(
  position: _slideAnim,
  child: FadeTransition(
    opacity: _fadeAnim,
    child: Scaffold(...),
  ),
);

// AFTER:
return SharedAxisTransition(
  animation: ModalRoute.of(context)!.animation!,
  secondaryAnimation: ModalRoute.of(context)!.secondaryAnimation,
  transitionType: SharedAxisTransitionType.vertical,
  child: Scaffold(...),
);
```

### 3. `lib/features/feed/widgets/reply_input.dart`

**Lines 82-104** — Replace `PageRouteBuilder` with manual `SlideTransition` tween using `SharedAxisTransition`:

```dart
// BEFORE (23 lines):
Navigator.of(context).push(
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        CreateReplyPage(...),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 350),
  ),
);

// AFTER (11 lines):
Navigator.of(context).push(
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        CreateReplyPage(...),
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.vertical,
          child: child,
        ),
    transitionDuration: const Duration(milliseconds: 350),
  ),
);
```

### 4. `lib/features/feed/pages/feed_page.dart` — NO CHANGES

- `TabController` / `_TabBar`'s `AnimationController` for sliding underline indicator: `animations` package has no replacement for custom element animations
- `AnimatedSlide`, `AnimatedDefaultTextStyle`: already Flutter implicit animations (appropriate)
- `ScrollController.animateTo()`: scroll behavior, not transitions

## Verification

Run after changes:
```bash
flutter analyze
```
