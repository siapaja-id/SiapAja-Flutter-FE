import 'package:flutter/material.dart';

import '../../app_theme.dart';

/// Expandable text widget with read more/show less functionality
class ExpandableText extends StatefulWidget {
  final String text;
  final int limit;
  final String? className;
  final String? buttonClassName;
  final TextStyle? style;
  final TextStyle? buttonStyle;
  final Widget? suffix;

  const ExpandableText({
    super.key,
    required this.text,
    this.limit = 160,
    this.className,
    this.buttonClassName,
    this.style,
    this.buttonStyle,
    this.suffix,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isLong = widget.text.length > widget.limit;
    final displayText = (!isLong || isExpanded) ? widget.text : widget.text.substring(0, widget.limit);
    final needsEllipsis = isLong && !isExpanded;

    return RichText(
      text: TextSpan(
        style: widget.style ?? const TextStyle(
          color: AppColors.onSurface,
          fontSize: 14,
          height: 1.5,
        ),
        children: [
          TextSpan(
            text: displayText,
          ),
          if (needsEllipsis)
            const TextSpan(text: '...'),
          if (widget.suffix != null)
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: widget.suffix,
              ),
            ),
          if (isLong)
            WidgetSpan(
              child: GestureDetector(
                onTap: () => setState(() => isExpanded = !isExpanded),
                child: Text(
                  isExpanded ? ' show less' : ' read more',
                  style: widget.buttonStyle ?? const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
