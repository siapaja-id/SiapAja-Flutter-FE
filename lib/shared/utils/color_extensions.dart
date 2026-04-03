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
  Color get w03 => withOpacity(0.03);
  Color get w04 => withOpacity(0.04);
  Color get w05 => withOpacity(0.05);
  Color get w06 => withOpacity(0.06);
  Color get w08 => withOpacity(0.08);
  Color get w10 => withOpacity(0.10);
  Color get w15 => withOpacity(0.15);
  Color get w18 => withOpacity(0.18);
  Color get w20 => withOpacity(0.20);
  Color get w25 => withOpacity(0.25);
  Color get w30 => withOpacity(0.30);
  Color get w40 => withOpacity(0.40);
  Color get w50 => withOpacity(0.50);
  Color get w60 => withOpacity(0.60);
  Color get w65 => withOpacity(0.65);
  Color get w80 => withOpacity(0.80);
  Color get w90 => withOpacity(0.90);

  // ── Primary opacity variants ────────────────────────────────────
  Color get p02 => withOpacity(0.02);
  Color get p03 => withOpacity(0.03);
  Color get p04 => withOpacity(0.04);
  Color get p05 => withOpacity(0.05);
  Color get p06 => withOpacity(0.06);
  Color get p08 => withOpacity(0.08);
  Color get p10 => withOpacity(0.10);
  Color get p20 => withOpacity(0.20);
  Color get p30 => withOpacity(0.30);
  Color get p40 => withOpacity(0.40);
  Color get p50 => withOpacity(0.50);
  Color get p60 => withOpacity(0.60);
  Color get p80 => withOpacity(0.80);

  // ── Emerald opacity variants ────────────────────────────────────
  Color get e02 => withOpacity(0.02);
  Color get e05 => withOpacity(0.05);
  Color get e10 => withOpacity(0.10);
  Color get e12 => withOpacity(0.12);
  Color get e15 => withOpacity(0.15);
  Color get e20 => withOpacity(0.20);
  Color get e50 => withOpacity(0.50);

  // ── Indigo opacity variants ─────────────────────────────────────
  Color get i03 => withOpacity(0.03);
  Color get i04 => withOpacity(0.04);
  Color get i10 => withOpacity(0.10);

  // ── Red opacity variants ────────────────────────────────────────
  Color get r10 => withOpacity(0.10);
  Color get r20 => withOpacity(0.20);

  // ── Black opacity variants ──────────────────────────────────────
  Color get black05 => withOpacity(0.05);
  Color get black20 => withOpacity(0.20);
  Color get black25 => withOpacity(0.25);
  Color get black30 => withOpacity(0.30);
  Color get black40 => withOpacity(0.40);
  Color get black50 => withOpacity(0.50);
  Color get black54 => withOpacity(0.54);
  Color get black60 => withOpacity(0.60);
  Color get black80 => withOpacity(0.80);
  Color get black87 => withOpacity(0.87);

  // ── Generic opacity variants (for onSurfaceVariant, etc.) ───────
  Color get o25 => withOpacity(0.25);
  Color get o30 => withOpacity(0.30);
  Color get o40 => withOpacity(0.40);
  Color get o50 => withOpacity(0.50);
  Color get o60 => withOpacity(0.60);
  Color get o70 => withOpacity(0.70);
  Color get o90 => withOpacity(0.90);
}
