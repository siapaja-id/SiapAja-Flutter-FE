import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app_theme.dart';
import '../providers.dart';
import '../widgets/floating_sidebar.dart';
import '../widgets/kanban_column_widget.dart';

class DesktopKanbanLayout extends ConsumerStatefulWidget {
  const DesktopKanbanLayout({super.key});

  @override
  ConsumerState<DesktopKanbanLayout> createState() =>
      _DesktopKanbanLayoutState();
}

class _DesktopKanbanLayoutState extends ConsumerState<DesktopKanbanLayout> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Auto-scroll to end when new columns are added
    ref.listenManual(kanbanProvider, (prev, next) {
      if (next.columns.length > (prev?.columns.length ?? 0)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final columns = ref.watch(kanbanProvider.select((s) => s.columns));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppTheme.backgroundGradient,
                ),
              ),
            ),
          ),
          // Main layout
          Row(
            children: [
              // Floating sidebar
              const FloatingSidebar(),
              // Scrollable columns area
              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        ...columns.asMap().entries.map((entry) {
                          final col = entry.value;
                          final index = entry.key;
                          return KanbanColumnWidget(
                            key: ValueKey(col.id),
                            column: col,
                            index: index,
                            total: columns.length,
                            onCloseRequested: () => ref
                                .read(kanbanProvider.notifier)
                                .closeColumn(col.id),
                          );
                        }),
                        // Add column button — inline after columns (matches React)
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 24),
                          child: _AddColumnButton(
                            onTap: () => ref
                                .read(kanbanProvider.notifier)
                                .openColumn('/'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Add column button — matches React kanban-add-btn exactly
class _AddColumnButton extends StatefulWidget {
  final VoidCallback onTap;

  const _AddColumnButton({required this.onTap});

  @override
  State<_AddColumnButton> createState() => _AddColumnButtonState();
}

class _AddColumnButtonState extends State<_AddColumnButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Material(
        type: MaterialType.circle,
        color: const Color(0xE61F1F1F),
        child: InkWell(
          onTap: widget.onTap,
          customBorder: const CircleBorder(),
          child: Ink(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 20,
                  spreadRadius: -5,
                ),
              ],
            ),
            child: AnimatedRotation(
              turns: _isHovering ? 0.25 : 0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              child: Icon(
                PhosphorIconsRegular.plus,
                size: 24,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
