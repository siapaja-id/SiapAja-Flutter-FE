import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_theme.dart';
import '../settings_provider.dart';

/// Rich text widget — matches React `RichText` + `SpoilerText` + `RichLinkAnchor` + `LinkPreviewNode`
class RichTextWidget extends ConsumerWidget {
  final String text;
  final TextStyle? baseStyle;

  const RichTextWidget({super.key, required this.text, this.baseStyle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textSize = ref.watch(settingsProvider.select((s) => s.textSize));
    final cachedSpans = _parseText(text, textSize);
    return RichText(
      text: TextSpan(
        style:
            baseStyle ??
            Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.onSurface,
              height: 1.5,
            ),
        children: cachedSpans,
      ),
    );
  }

  /// Sequential regex parsing — same order as React `applyRegex`.
  /// Each regex only processes remaining string nodes, so already-parsed
  /// WidgetSpans are left untouched.
  List<InlineSpan> _parseText(String text, TextSize textSize) {
    List<InlineSpan> nodes = [TextSpan(text: text)];

    List<InlineSpan> _applyRegex(
      RegExp regex,
      InlineSpan Function(String) builder,
    ) {
      return nodes.expand((node) {
        if (node is! TextSpan || node.text == null) return [node];
        final parts = node.text!.split(regex);
        if (parts.length == 1) return [node];
        return parts.asMap().entries.map((entry) {
          if (entry.key.isOdd) return builder(entry.value);
          if (entry.value.isEmpty) return const TextSpan();
          return TextSpan(text: entry.value);
        });
      }).toList();
    }

    // 1. Spoilers: ||text||
    nodes = _applyRegex(
      RegExp(r'(\|\|.*?\|\|)'),
      (m) => _buildSpoiler(m.substring(2, m.length - 2)),
    );

    // 2. URLs
    nodes = _applyRegex(RegExp(r'(https?://[^\s]+)'), (url) => _buildLink(url, textSize));

    // 3. @mentions
    nodes = _applyRegex(RegExp(r'(@[a-zA-Z0-9_]+)'), _buildMention);

    // 4. #hashtags
    nodes = _applyRegex(RegExp(r'(#[a-zA-Z0-9_]+)'), _buildHashtag);

    // 5. Phone numbers → redacted
    nodes = _applyRegex(
      RegExp(r'((?:\+?\d{1,3}[\s.-]?)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4})'),
      _buildPhoneRedacted,
    );

    return nodes;
  }

  // -----------------------------------------------------------------------
  // Spoiler — matches React `SpoilerText`: blur-[5px] hover:blur-[3px]
  // bg-white/5 cursor-pointer select-none rounded px-1.5 py-0.5
  // transition-all duration-700 → revealed: text-on-surface
  // -----------------------------------------------------------------------

  InlineSpan _buildSpoiler(String content) {
    return WidgetSpan(
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
      child: _SpoilerText(text: content),
    );
  }

  // -----------------------------------------------------------------------
  // Link — matches React `RichLinkAnchor` pill styling
  // -----------------------------------------------------------------------

  InlineSpan _buildLink(String url, TextSize textSize) {
    final displayUrl = url.replaceFirst(RegExp(r'^https?://'), '');
    return WidgetSpan(
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.link, size: 12, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(
                displayUrl,
                style: AppTheme.scaled(
                  textSize: textSize,
                  multiplier: AppTheme.mxs,
                  weight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -----------------------------------------------------------------------
  // Mention — matches React `text-primary/90 font-black`
  // -----------------------------------------------------------------------

  InlineSpan _buildMention(String handle) {
    return TextSpan(
      text: handle,
      style: const TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  // -----------------------------------------------------------------------
  // Hashtag — matches React `text-emerald-400/90 font-bold`
  // -----------------------------------------------------------------------

  InlineSpan _buildHashtag(String hashtag) {
    return TextSpan(
      text: hashtag,
      style: const TextStyle(
        color: Color(0xFF34D399), // emerald-400
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // -----------------------------------------------------------------------
  // Phone redaction — matches React `bg-red-500/10 text-red-500` pill
  // -----------------------------------------------------------------------

  InlineSpan _buildPhoneRedacted(String phone) {
    return WidgetSpan(
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444).withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.phone_disabled, size: 10, color: Colors.red.shade400),
            const SizedBox(width: 4),
            Text(
              'Redacted',
              style: AppTheme.labelMicro.copyWith(
                color: Colors.red.shade400,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// _SpoilerText — matches React `SpoilerText`
// ===========================================================================

class _SpoilerText extends StatefulWidget {
  final String text;
  const _SpoilerText({required this.text});

  @override
  State<_SpoilerText> createState() => _SpoilerTextState();
}

class _SpoilerTextState extends State<_SpoilerText> {
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_revealed) setState(() => _revealed = true);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: _revealed ? Colors.transparent : AppColors.borderSubtle,
          borderRadius: BorderRadius.circular(4),
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: _revealed
                ? AppColors
                      .onSurface // revealed → text-on-surface
                : AppColors.onSurfaceVariant, // hidden → muted
            letterSpacing: _revealed ? 0 : 1.5,
          ),
          child: Text(
            widget.text,
            style: _revealed
                ? null
                : TextStyle(
                    color: AppColors.onSurfaceVariant.withOpacity(0.25),
                  ),
          ),
        ),
      ),
    );
  }
}
