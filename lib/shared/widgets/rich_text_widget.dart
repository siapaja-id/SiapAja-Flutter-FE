import 'package:flutter/material.dart';

import '../../app_theme.dart';

class RichTextWidget extends StatelessWidget {
  final String text;
  final TextStyle? baseStyle;

  const RichTextWidget({super.key, required this.text, this.baseStyle});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style:
            baseStyle ??
            Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.onSurface,
              height: 1.5,
            ),
        children: _parseText(text),
      ),
    );
  }

  List<InlineSpan> _parseText(String text) {
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

    nodes = _applyRegex(
      RegExp(r'(\|\|.*?\|\|)'),
      (m) => _buildSpoiler(m.substring(2, m.length - 2)),
    );

    nodes = _applyRegex(RegExp(r'(https?://[^\s]+)'), (url) => _buildLink(url));

    nodes = _applyRegex(RegExp(r'(@[a-zA-Z0-9_]+)'), _buildMention);

    nodes = _applyRegex(RegExp(r'(#[a-zA-Z0-9_]+)'), _buildHashtag);

    nodes = _applyRegex(
      RegExp(r'((?:\+?\d{1,3}[\s.-]?)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4})'),
      _buildPhoneRedacted,
    );

    return nodes;
  }

  InlineSpan _buildSpoiler(String content) {
    return WidgetSpan(
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
      child: _SpoilerText(text: content),
    );
  }

  InlineSpan _buildLink(String url) {
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
                style: AppTheme.meta,
              ),
            ],
          ),
        ),
      ),
    );
  }

  InlineSpan _buildMention(String handle) {
    return TextSpan(
      text: handle,
      style: const TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  InlineSpan _buildHashtag(String hashtag) {
    return TextSpan(
      text: hashtag,
      style: const TextStyle(
        color: Color(0xFF34D399),
        fontWeight: FontWeight.bold,
      ),
    );
  }

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
            color: _revealed ? AppColors.onSurface : AppColors.onSurfaceVariant,
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
