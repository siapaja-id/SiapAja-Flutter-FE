import 'package:flutter/material.dart';

/// Extension providing shorthand getters for commonly used opacity values.
///
/// Usage: `Colors.white.w10` instead of `Colors.white.withOpacity(0.1)`.
/// The prefix convention (w/p/e/i/r) adds semantic context when reading:
/// - `w` → white patterns   `Colors.white.w10`
/// - `p` → primary patterns  `AppColors.primary.p20`
/// - `e` → emerald patterns  `AppColors.emerald.e50`
/// - `i` → indigo patterns   `AppColors.indigo.i03`
/// - `r` → red patterns      `AppColors.red.r10`
extension ColorX on Color {
  // ── White opacity variants ──────────────────────────────────────
  Color get w03 => withValues(alpha: 0.03);
  Color get w04 => withValues(alpha: 0.04);
  Color get w05 => withValues(alpha: 0.05);
  Color get w06 => withValues(alpha: 0.06);
  Color get w08 => withValues(alpha: 0.08);
  Color get w10 => withValues(alpha: 0.10);
  Color get w15 => withValues(alpha: 0.15);
  Color get w18 => withValues(alpha: 0.18);
  Color get w20 => withValues(alpha: 0.20);
  Color get w25 => withValues(alpha: 0.25);
  Color get w30 => withValues(alpha: 0.30);
  Color get w40 => withValues(alpha: 0.40);
  Color get w50 => withValues(alpha: 0.50);
  Color get w60 => withValues(alpha: 0.60);
  Color get w65 => withValues(alpha: 0.65);
  Color get w80 => withValues(alpha: 0.80);
  Color get w90 => withValues(alpha: 0.90);

  // ── Primary opacity variants ────────────────────────────────────
  Color get p02 => withValues(alpha: 0.02);
  Color get p03 => withValues(alpha: 0.03);
  Color get p04 => withValues(alpha: 0.04);
  Color get p05 => withValues(alpha: 0.05);
  Color get p06 => withValues(alpha: 0.06);
  Color get p08 => withValues(alpha: 0.08);
  Color get p10 => withValues(alpha: 0.10);
  Color get p20 => withValues(alpha: 0.20);
  Color get p30 => withValues(alpha: 0.30);
  Color get p40 => withValues(alpha: 0.40);
  Color get p50 => withValues(alpha: 0.50);
  Color get p60 => withValues(alpha: 0.60);
  Color get p80 => withValues(alpha: 0.80);

  // ── Emerald opacity variants ────────────────────────────────────
  Color get e02 => withValues(alpha: 0.02);
  Color get e05 => withValues(alpha: 0.05);
  Color get e10 => withValues(alpha: 0.10);
  Color get e12 => withValues(alpha: 0.12);
  Color get e15 => withValues(alpha: 0.15);
  Color get e20 => withValues(alpha: 0.20);
  Color get e50 => withValues(alpha: 0.50);

  // ── Indigo opacity variants ─────────────────────────────────────
  Color get i03 => withValues(alpha: 0.03);
  Color get i04 => withValues(alpha: 0.04);
  Color get i10 => withValues(alpha: 0.10);

  // ── Red opacity variants ────────────────────────────────────────
  Color get r10 => withValues(alpha: 0.10);
  Color get r20 => withValues(alpha: 0.20);

  // ── Black opacity variants ──────────────────────────────────────
  Color get black05 => withValues(alpha: 0.05);
  Color get black20 => withValues(alpha: 0.20);
  Color get black25 => withValues(alpha: 0.25);
  Color get black30 => withValues(alpha: 0.30);
  Color get black40 => withValues(alpha: 0.40);
  Color get black50 => withValues(alpha: 0.50);
  Color get black54 => withValues(alpha: 0.54);
  Color get black60 => withValues(alpha: 0.60);
  Color get black80 => withValues(alpha: 0.80);
  Color get black87 => withValues(alpha: 0.87);

  // ── Generic opacity variants (for onSurfaceVariant, etc.) ───────
  Color get o25 => withValues(alpha: 0.25);
  Color get o30 => withValues(alpha: 0.30);
  Color get o40 => withValues(alpha: 0.40);
  Color get o50 => withValues(alpha: 0.50);
  Color get o60 => withValues(alpha: 0.60);
  Color get o70 => withValues(alpha: 0.70);
  Color get o90 => withValues(alpha: 0.90);
}
