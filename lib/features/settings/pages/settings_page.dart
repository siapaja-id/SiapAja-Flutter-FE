import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app_theme.dart';
import '../../../shared/settings_provider.dart';
import '../../../shared/zoom_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final zoom = ref.watch(zoomProvider);
    final textSize = ref.watch(settingsProvider.select((s) => s.textSize));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        PhosphorIconsRegular.arrowLeft,
                        color: AppColors.onSurface,
                      ),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Settings',
                          style: AppTheme.scaled(
                            textSize: textSize,
                            multiplier: AppTheme.m15,
                            weight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                        Text(
                          'Preferences & Appearance',
                          style: AppTheme.scaled(
                            textSize: textSize,
                            multiplier: AppTheme.m1sm,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 96),
              sliver: SliverList(
                delegate: SliverChildListDelegate.fixed([
                  _ThemeColorSection(
                    textSize: textSize,
                    selected: settings.themeColor,
                    onChanged: (color) => ref
                        .read(settingsProvider.notifier)
                        .setThemeColor(color),
                  ),
                  const SizedBox(height: 16),
                  _TextSizeSection(
                    textSize: textSize,
                    selected: settings.textSize,
                    onChanged: (size) =>
                        ref.read(settingsProvider.notifier).setTextSize(size),
                  ),
                  const SizedBox(height: 16),
                  _ZoomSection(
                    textSize: textSize,
                    selected: zoom,
                    onChanged: (value) =>
                        ref.read(zoomProvider.notifier).setZoom(value),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeColorSection extends StatelessWidget {
  final TextSize textSize;
  final ThemeColor selected;
  final ValueChanged<ThemeColor> onChanged;

  const _ThemeColorSection({
    required this.textSize,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 16),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  PhosphorIconsRegular.palette,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Theme Color',
                      style: AppTheme.scaled(
                        textSize: textSize,
                        multiplier: AppTheme.mlg,
                        weight: FontWeight.w900,
                        color: AppColors.onSurface,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      'Choose your primary accent color',
                      style: AppTheme.scaled(
                        textSize: textSize,
                        multiplier: AppTheme.mxs,
                        weight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (final entry in AppColors.themeColors.entries)
                _ColorCircle(
                  color: entry.value,
                  label:
                      AppColors.themeColorLabels[entry.key] ?? entry.key.name,
                  isSelected: selected == entry.key,
                  onTap: () => onChanged(entry.key),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ColorCircle extends StatelessWidget {
  final Color color;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorCircle({
    required this.color,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: isSelected
              ? Icon(
                  PhosphorIconsBold.check,
                  key: const ValueKey('check'),
                  size: 22,
                  color: Colors.white,
                )
              : null,
        ),
      ),
    );
  }
}

class _TextSizeSection extends StatelessWidget {
  final TextSize textSize;
  final TextSize selected;
  final ValueChanged<TextSize> onChanged;

  const _TextSizeSection({
    required this.textSize,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final options = const [
      (TextSize.sm, 'Small'),
      (TextSize.md, 'Medium'),
      (TextSize.lg, 'Large'),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 16),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  PhosphorIconsRegular.textT,
                  size: 20,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Typography Size',
                      style: AppTheme.scaled(
                        textSize: textSize,
                        multiplier: AppTheme.mlg,
                        weight: FontWeight.w900,
                        color: AppColors.onSurface,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      'Adjust the base text scale',
                      style: AppTheme.scaled(
                        textSize: textSize,
                        multiplier: AppTheme.mxs,
                        weight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SegmentedControl(
            textSize: textSize,
            options: options,
            selected: selected,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ZoomSection extends StatelessWidget {
  final TextSize textSize;
  final double selected;
  final ValueChanged<double> onChanged;

  const _ZoomSection({
    required this.textSize,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final options = const [
      (0.9, '90%'),
      (1.0, '100%'),
      (1.1, '110%'),
      (1.2, '120%'),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 16),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  PhosphorIconsRegular.magnifyingGlassPlus,
                  size: 20,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Display Zoom',
                      style: AppTheme.scaled(
                        textSize: textSize,
                        multiplier: AppTheme.mlg,
                        weight: FontWeight.w900,
                        color: AppColors.onSurface,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      'Scale the entire interface',
                      style: AppTheme.scaled(
                        textSize: textSize,
                        multiplier: AppTheme.mxs,
                        weight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SegmentedControl(
            textSize: textSize,
            options: options,
            selected: selected,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _SegmentedControl<T extends Object> extends StatelessWidget {
  final TextSize textSize;
  final List<(T, String)> options;
  final T selected;
  final ValueChanged<T> onChanged;

  const _SegmentedControl({
    required this.textSize,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth / options.length;

        return Stack(
          children: [
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Row(
                children: [
                  for (int i = 0; i < options.length; i++)
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => onChanged(options[i].$1),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            height: 48,
                            alignment: Alignment.center,
                            child: Text(
                              options[i].$2,
                              style: AppTheme.scaled(
                                textSize: textSize,
                                multiplier: AppTheme.mbase,
                                weight: FontWeight.bold,
                                color: selected == options[i].$1
                                    ? AppColors.onSurface
                                    : AppColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              left: options.indexWhere((o) => o.$1 == selected) * itemWidth + 4,
              top: 4,
              bottom: 4,
              width: itemWidth - 8,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
