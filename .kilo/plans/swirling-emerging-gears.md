# Refactor Post Detail Page: Replace Manual Implementations with Official Flutter Widgets

## Context

`post_detail_page.dart` (1714 lines) contains numerous manual UI implementations that duplicate behavior already provided by Flutter's built-in widget library. This increases code volume, reduces readability, and introduces potential bugs (e.g., the modal `Positioned.fill` inside a `Column` is architecturally wrong). This plan replaces these manual patterns with official Flutter widgets while preserving the existing visual design.

## Changes

### 1. Replace manual modal overlays with `showModalBottomSheet`

**Current:** Three modals (`_buildBidModal`, `_buildCompleteModal`, `_buildReviewModal`) are built as `Positioned.fill` children of a `Column` (lines 451-456). Each uses nested `GestureDetector` for dismiss-on-tap-outside, `BackdropFilter` + `ImageFilter.blur` for backdrop blur, and manual slide-up alignment.

**Change:**
- Replace `Positioned.fill` children in `build()` (lines 451-456) with `showModalBottomSheet()` calls triggered from action handlers
- Delete `_buildBidModal()` (lines 944-1221), `_buildCompleteModal()` (lines 1257-1412), `_buildReviewModal()` (lines 1414-1535)
- Create three `_showBidSheet()`, `_showCompleteSheet()`, `_showReviewSheet()` methods that call `showModalBottomSheet` with:
  - `isScrollControlled: true`
  - `backgroundColor: Colors.transparent` (for glassmorphism)
  - `isDismissible: true` (handles dismiss-on-tap-outside automatically)
  - `enableDrag: true`
  - Inner content wrapped in `ClipRRect` + `BackdropFilter` + container with existing styling
- Remove `_isBidding`, `_showCompleteModal`, `_showReviewModal` boolean state variables since modal state is now managed by Flutter's route system
- Keep `dart:ui` import (line 1) — needed for `ImageFilter.blur` used in `BackdropFilter`

**Impact:** Eliminates ~300 lines of manual modal code, automatically handles barrier overlay, dismiss gestures, animations, and safe area.

### 2. Replace `GestureDetector` + `Container` buttons with Flutter button widgets

**Current:** `_buildActionButton()` (lines 905-939) and all submit buttons in modals use `GestureDetector` + `Container` with manual `BoxDecoration`, padding, and shadow.

**Change:**
- Replace `_buildActionButton()` with helper using `SizedBox(width: double.infinity, child: ElevatedButton(...))`
- For primary/colored buttons (PLACE BID, SUBMIT COMPLETION, RELEASE PAYMENT, ACCEPT INSTANTLY): `ElevatedButton` with custom `styleFrom`
- For ghost/secondary buttons (BID, Down Bid, Match Original, Up Bid): `OutlinedButton` or `TextButton`
- The two empty-state CTA buttons (lines 543-614): `OutlinedButton.icon` with matching styles

**Specific locations:**
- Lines 544-577: "PLACE FIRST BID" → `OutlinedButton.icon`
- Lines 579-614: "WRITE A REPLY" → `OutlinedButton.icon`
- Lines 905-939: `_buildActionButton()` → helper using `ElevatedButton`/`OutlinedButton`
- Lines 1176-1212: "PLACE BID" → `ElevatedButton`
- Lines 1376-1403: "SUBMIT COMPLETION" → `ElevatedButton`
- Lines 1499-1526: "RELEASE PAYMENT" → `ElevatedButton`

### 3. Replace close buttons with `IconButton`

**Current:** Each modal has `GestureDetector` + circular `Container` for close button (lines 981-995, 1293-1308, 1449-1463).

**Change:**
```dart
IconButton(
  onPressed: () => Navigator.pop(context),
  style: IconButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.05)),
  icon: const Icon(PhosphorIconsRegular.x, size: 20, color: AppColors.onSurfaceVariant),
)
```

### 4. Replace back button in header with `IconButton`

**Current:** `_DetailHeader` uses `GestureDetector` + circular `Container` (lines 1567-1581).

**Change:**
```dart
IconButton(
  onPressed: onBack,
  style: IconButton.styleFrom(backgroundColor: Colors.black.withOpacity(0.2)),
  icon: const Icon(PhosphorIconsRegular.arrowLeft, size: 20),
)
```

### 5. Replace type badge with `Chip` widget

**Current:** Manual `Container` with border and padding for the "Task"/"Post" badge (lines 1603-1624).

**Change:** Use `Chip` widget with matching styling, `visualDensity: VisualDensity.compact`, `materialTapTargetSize: MaterialTapTargetSize.shrinkWrap`.

### 6. Replace stepper minus/plus buttons with `IconButton`

**Current:** `GestureDetector` + `Container` with manual sizing (lines 1012-1030, 1091-1107).

**Change:** Use `IconButton` with fixed constraints matching existing 64x64 sizing and rounded corners.

### 7. Replace star rating with `InkWell` for Material ripple

**Current:** `GestureDetector` + `Icon` (lines 1477-1496). Fine structurally but lacks Material feedback.

**Change:** Replace `GestureDetector` with `InkWell` wrapping each star `Icon`.

### 8. Replace quick bid buttons with `ActionChip`

**Current:** `GestureDetector` + `Container` (lines 1228-1254).

**Change:** Use `ActionChip` with avatar for optional icon.

## Files Modified

- `lib/features/feed/pages/post_detail_page.dart` — all changes

## Approach (ordered)

1. Convert three modal methods → `showModalBottomSheet` + extract content widgets
2. Replace `_buildActionButton` and all manual buttons with `ElevatedButton`/`OutlinedButton`
3. Replace close buttons and back button with `IconButton`
4. Replace type badge with `Chip`
5. Replace stepper buttons with `IconButton`
6. Replace quick bid buttons with `ActionChip`
7. Run `flutter analyze` to verify

## Preserved Design

- Glassmorphism: `BackdropFilter` + `ClipRRect` kept inside modal sheets
- Color scheme: All `AppColors` references preserved
- Typography: Inline `TextStyle` preserved (project convention)
- Layout: `CustomScrollView` structure unchanged
- Phosphor icons: No Material icons introduced

## Verification

- Run `flutter analyze` to check for errors
- Visual comparison of before/after modals, buttons, and header
- Confirm dismiss-on-tap-outside works for all three modals
- Confirm bid/complete/review flows still function
