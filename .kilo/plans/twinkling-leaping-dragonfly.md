# Glassmorphism Effect Implementation Plan

## Context
The app currently has a `GlassCard` widget that is just a semi-transparent container with no actual blur. No `BackdropFilter` or `ImageFilter.blur` exists anywhere in the codebase. The user wants real, beautiful glassmorphism applied to **all** glass-like UI elements with **medium blur intensity (10-15px)**.

## Design Specification

### Glassmorphism Recipe
- **Blur**: `ImageFilter.blur(sigmaX: 12, sigmaY: 12)` — medium intensity
- **Glass tint**: Semi-transparent dark fill `Color(0x401F1F1F)` (surfaceContainerHigh @ 25%)
- **Glass border**: Subtle white edge `Color(0x29FFFFFF)` (white @ 16%) — simulates glass edge reflection
- **Inner glow**: Top-edge gradient `LinearGradient` from `Color(0x15FFFFFF)` to transparent — simulates light refracting through glass top surface
- **Outer shadow**: Soft black shadow for elevation depth

### Glass Colors (add to `AppColors`)
```dart
static const Color glassTint = Color(0x401F1F1F);
static const Color glassBorder = Color(0x29FFFFFF);
static const Color glassGlow = Color(0x15FFFFFF);
```

---

## Step-by-Step Changes

### Step 1: Add glass colors to `AppColors` in `lib/app_theme.dart`
Add three new color constants: `glassTint`, `glassBorder`, `glassGlow`.

### Step 2: Rewrite `GlassCard` in `lib/features/feed/widgets/glass_card.dart`
Transform from a plain semi-transparent container into a true glassmorphism widget:
- Wrap content in `ClipRRect` → `BackdropFilter` → `ImageFilter.blur(sigma: 12)`
- Apply `glassTint` as background color
- Add inner top-edge glow gradient via `DecoratedBox` with `LinearGradient`
- Use `glassBorder` for the border
- Add subtle black `BoxShadow` for depth

### Step 3: Apply glassmorphism to Feed Header in `lib/features/feed/pages/feed_page.dart`
Replace the `FeedHeader`'s `Container` decoration:
- Wrap header content in `ClipRect` → `BackdropFilter` with blur sigma 12
- Use `glassTint` background
- Use `glassBorder` bottom border instead of `borderSubtle`
- Keep existing animation behavior (AnimatedContainer/AnimatedSlide)

### Step 4: Apply glassmorphism to Bottom Nav Bar in `lib/features/feed/pages/main_shell.dart`
Wrap the `NavigationBar`:
- Add `ClipRRect` → `BackdropFilter` with blur sigma 12
- Change `backgroundColor` to `glassTint`
- Add `glassBorder` top border

### Step 5: Apply glassmorphism to Feed Composer in `lib/features/feed/widgets/feed_composer.dart`
Update the composer `Container` decoration:
- Add `ClipRRect` → `BackdropFilter` with blur sigma 12
- Change `fillColor` from `surfaceContainer` to `glassTint`
- Use `glassBorder` border
- Add inner glow gradient overlay
- Keep existing shadow

### Step 6: Apply glassmorphism to Fullscreen Composer Sheet in `lib/features/feed/widgets/feed_composer.dart`
Update `_FullscreenComposerSheet`:
- Add `BackdropFilter` with blur sigma 12 to the sheet container
- Change background from `surfaceContainerHigh.withOpacity(0.95)` to `glassTint`
- Use `glassBorder` border

### Step 7: Add ambient background colors to scaffold
In `lib/features/feed/pages/main_shell.dart`, add a subtle gradient background to the scaffold body so the glass blur has colorful content to refract:
- Add a `Stack` behind `widget.child` with `Container` containing a `LinearGradient` using subtle primary/emerald/indigo tints
- This ensures the blur effect is visible even when scrolled past images

---

## Files Modified (6 files)
1. `lib/app_theme.dart` — add 3 glass color constants
2. `lib/features/feed/widgets/glass_card.dart` — full rewrite with BackdropFilter
3. `lib/features/feed/pages/feed_page.dart` — glassmorphism on FeedHeader
4. `lib/features/feed/pages/main_shell.dart` — glassmorphism on bottom nav + ambient background
5. `lib/features/feed/widgets/feed_composer.dart` — glassmorphism on composer + fullscreen sheet

## Verification
- Run `flutter analyze` to check for lint errors
- Run `flutter build apk --debug` or `flutter run` to verify rendering
- Visual check: glass elements should show blurred background content, inner glow on top edge, subtle borders
