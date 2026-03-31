# Task Detail Page — UI/UX Regression Fixes

## Goal
Make Flutter `task_main_content.dart` pixel-identical to React `TaskMainContent.Component.tsx`.

## Regressions Found (13 total)

### A. Model-Level Gaps (fix first — `lib/models/feed_item.dart`)

| # | Issue | React | Flutter |
|---|-------|-------|---------|
| A1 | `TaskData` missing `video` field | `video?: string` | Not present |
| A2 | `TaskData` missing `voiceNote` field | `voiceNote?: string` | Not present |
| A3 | `TaskData` missing `isFirstPost` field | `isFirstPost?: boolean` | Only `isFirstTask` exists |

### B. `task_main_content.dart` Visual Regressions

| # | Issue | React | Flutter (current) |
|---|-------|-------|-------------------|
| B1 | Info Pill vertical padding too large | `py-1.5` (6px) | `vertical: 15` (30px) |
| B2 | Tags border radius wrong | `rounded-full` (pill shape) | `circular(4)` (slight rounding) |
| B3 | Description text color too bright | `prose-p:text-on-surface-variant/90` (muted) | `color: AppColors.onSurface` (pure white) |
| B4 | Description expand button text wrong | "Show Full Description" / "Show Less" | "read more" / "show less" |
| B5 | Video media module missing | `<video controls />` | Not rendered |
| B6 | VoiceNote media module missing | Play button + waveform + times | Not rendered |
| B7 | OSRM badge missing pulse animation | `animate-pulse` on emerald dot | Static dot |
| B8 | Avatar missing ring styling | `ring-2 ring-white/10 shadow-2xl` | No ring/shadow |

### C. FirstTaskBadge

| # | Issue | React | Flutter |
|---|-------|-------|---------|
| C1 | Badge dots not animated | `animate-pulse` on inner dot | Static dot |

---

## Implementation Order

### Step 1: Model — add missing fields to `TaskData` (A1, A2, A3)
**File:** `lib/models/feed_item.dart`

Add to `TaskData` class:
- `final String? video;`
- `final String? voiceNote;`
- `final bool? isFirstPost;`

Update constructor, `copyWith`, and any callsites that construct `TaskData`.

### Step 2: Fix B1–B8 in `task_main_content.dart`

**B1** — Line 273: Change `vertical: 15` → `vertical: 6`

**B2** — Line 938: Change `BorderRadius.circular(4)` → `BorderRadius.circular(20)`

**B3** — Line 714: Change `color: AppColors.onSurface` → `color: AppColors.onSurfaceVariant`

**B4** — Update `_buildDescription` to show "Show Full Description" / "Show Less" button text (matching React `text-[10px] uppercase tracking-[0.2em]`).

**B5** — Add `_buildVideoModule()` method and call it in `_buildMediaModules` when `data.video != null`.

**B6** — Add `_buildVoiceNoteModule()` method and call it in `_buildMediaModules` when `data.voiceNote != null`.

**B7** — Wrap OSRM badge dot in `TweenAnimationBuilder` to pulse (opacity 1.0↔0.5, duration 1500ms, repeat).

**B8** — Wrap header `UserAvatar` in a `Container` with `BoxShape.circle`, `Border.all(white/10, width:2)`, and `BoxShadow(blurRadius:16)`.

### Step 3: FirstTaskBadge pulse (C1)
Wrap the dot widget in `_buildFirstTaskBadge` with a `TweenAnimationBuilder` for pulse opacity.

### Step 4: Run `flutter analyze` — confirm 0 errors

---

## Files to Modify
1. `lib/models/feed_item.dart` — add `video`, `voiceNote`, `isFirstPost` to TaskData
2. `lib/features/feed/pages/task_main_content.dart` — fix B1–B8, C1
