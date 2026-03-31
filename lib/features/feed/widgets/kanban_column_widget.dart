import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app_theme.dart';
import '../../../app_router.dart';
import '../../../models/kanban_column.dart';
import '../providers.dart';
import '../pages/feed_page.dart';
import '../pages/post_detail_page.dart';

/// InheritedWidget that provides column context to descendants
class KanbanColumnContext extends InheritedWidget {
  final String columnId;
  final String path;
  final Map<String, dynamic>? routeState;

  const KanbanColumnContext({
    super.key,
    required this.columnId,
    required this.path,
    this.routeState,
    required super.child,
  });

  static KanbanColumnContext? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<KanbanColumnContext>();
  }

  @override
  bool updateShouldNotify(KanbanColumnContext oldWidget) {
    return columnId != oldWidget.columnId ||
        path != oldWidget.path ||
        routeState != oldWidget.routeState;
  }
}

/// Column metadata (icon + label) from path — matches React getColumnMeta
class _ColumnMeta {
  final IconData icon;
  final String label;
  const _ColumnMeta(this.icon, this.label);
}

_ColumnMeta _getColumnMeta(String path, Map<String, dynamic>? routeState) {
  if (path == '/') return const _ColumnMeta(PhosphorIconsRegular.house, 'Home');
  if (path == '/explore') {
    return const _ColumnMeta(PhosphorIconsRegular.compass, 'Explore');
  }
  if (path == '/messages') {
    return const _ColumnMeta(PhosphorIconsRegular.chatCircle, 'Messages');
  }
  if (path == '/orders') {
    return const _ColumnMeta(PhosphorIconsRegular.shoppingCart, 'Orders');
  }
  if (path == '/profile') {
    final name = routeState?['user']?['name'] as String?;
    return _ColumnMeta(PhosphorIconsRegular.userCircle, name ?? 'Profile');
  }
  if (path == '/create-post') {
    return const _ColumnMeta(PhosphorIconsRegular.pencilSimple, 'New Post');
  }
  if (path == '/review-order') {
    return const _ColumnMeta(PhosphorIconsRegular.fileText, 'Review Order');
  }
  if (path == '/payment') {
    return const _ColumnMeta(PhosphorIconsRegular.creditCard, 'Payment');
  }
  if (path.startsWith('/post/')) {
    return const _ColumnMeta(PhosphorIconsRegular.fileText, 'Post');
  }
  if (path.startsWith('/task/')) {
    return const _ColumnMeta(PhosphorIconsRegular.clipboardText, 'Task');
  }
  return const _ColumnMeta(PhosphorIconsRegular.magnifyingGlass, 'Column');
}

class KanbanColumnWidget extends ConsumerStatefulWidget {
  final KanbanColumn column;
  final int index;
  final int total;

  const KanbanColumnWidget({
    super.key,
    required this.column,
    required this.index,
    required this.total,
  });

  @override
  ConsumerState<KanbanColumnWidget> createState() => _KanbanColumnWidgetState();
}

class _KanbanColumnWidgetState extends ConsumerState<KanbanColumnWidget> {
  bool _isHovering = false;
  bool _isResizing = false;
  double _resizeStartX = 0;
  double _resizeStartWidth = 0;
  double _localWidth = 0;

  void _startResize(DragStartDetails e) {
    setState(() {
      _isResizing = true;
      _resizeStartX = e.localPosition.dx;
      _resizeStartWidth = widget.column.width;
      _localWidth = widget.column.width;
    });
  }

  void _updateResize(DragUpdateDetails e) {
    final delta = e.localPosition.dx - _resizeStartX;
    final newWidth = (_resizeStartWidth + delta).clamp(320.0, 800.0);
    setState(() => _localWidth = newWidth);
  }

  void _endResize(DragEndDetails e) {
    final finalWidth = _localWidth;
    setState(() => _isResizing = false);
    ref
        .read(kanbanProvider.notifier)
        .setColumnWidth(widget.column.id, finalWidth);
  }

  @override
  Widget build(BuildContext context) {
    final meta = _getColumnMeta(widget.column.path, widget.column.routeState);
    final isFirst = widget.index == 0;
    final canClose = !isFirst;

    return KanbanColumnContext(
      columnId: widget.column.id,
      path: widget.column.path,
      routeState: widget.column.routeState,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: SizedBox(
          width: _isResizing ? _localWidth : widget.column.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Column content — Positioned.fill ensures Container fills the Stack bounds
                Positioned.fill(
                  child: RepaintBoundary(
                    child: AnimatedOpacity(
                      opacity: _isResizing ? 0.8 : 1.0,
                      duration: const Duration(milliseconds: 100),
                      child: AnimatedScale(
                        scale: _isResizing ? 0.98 : 1.0,
                        duration: const Duration(milliseconds: 100),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(36),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                            color: const Color(0x801F1F1F),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 50,
                                spreadRadius: -12,
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(36),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                              child: Column(
                                children: [
                                  // Column Header Bar
                                  _ColumnHeader(
                                    icon: meta.icon,
                                    title:
                                        widget
                                                .column
                                                .routeState?['user']?['name']
                                            as String? ??
                                        meta.label,
                                    index: widget.index,
                                    total: widget.total,
                                    canClose: canClose,
                                    onClose: () => ref
                                        .read(kanbanProvider.notifier)
                                        .closeColumn(widget.column.id),
                                  ),
                                  // Column body
                                  Expanded(
                                    child: _ColumnBody(
                                      path: widget.column.path,
                                      columnId: widget.column.id,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Resizer handle
                if (_isHovering || _isResizing)
                  Positioned(
                    right: -4,
                    top: 0,
                    bottom: 0,
                    width: 8,
                    child: GestureDetector(
                      onPanStart: _startResize,
                      onPanUpdate: _updateResize,
                      onPanEnd: _endResize,
                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 4,
                          height: 64,
                          decoration: BoxDecoration(
                            color: _isResizing
                                ? AppColors.primary
                                : Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Column header bar — matches React kanban-col-header exactly
class _ColumnHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final int index;
  final int total;
  final bool canClose;
  final VoidCallback onClose;

  const _ColumnHeader({
    required this.icon,
    required this.title,
    required this.index,
    required this.total,
    required this.canClose,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.06)),
        ),
      ),
      child: Row(
        children: [
          // Left section
          Expanded(
            child: Row(
              children: [
                // Icon container
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 14,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
                const SizedBox(width: 8),
                // Title
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withOpacity(0.65),
                      letterSpacing: 0.03,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // Right section
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (total > 1)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${index + 1}/$total',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: Colors.white.withOpacity(0.25),
                      letterSpacing: 0.08,
                    ),
                  ),
                ),
              if (canClose) ...[
                const SizedBox(width: 6),
                IconButton(
                  icon: Icon(
                    PhosphorIconsRegular.x,
                    size: 14,
                    color: Colors.white.withOpacity(0.25),
                  ),
                  onPressed: onClose,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 22,
                    height: 22,
                  ),
                  splashRadius: 11,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Column body — renders routes matching the column path
class _ColumnBody extends StatefulWidget {
  final String path;
  final String columnId;

  const _ColumnBody({required this.path, required this.columnId});

  @override
  State<_ColumnBody> createState() => _ColumnBodyState();
}

class _ColumnBodyState extends State<_ColumnBody> {
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final nav = _navKey.currentState;
      if (nav == null) return;
      nav.push(
        MaterialPageRoute(
          builder: (ctx) => _buildPageForRoute(widget.path, ctx),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => _buildPageForRoute(widget.path, context),
        );
      },
    );
  }

  static final _exactRoutes = <String, Widget Function(String)>{
    '/': (colId) => FeedPage(columnId: colId),
    '/feed': (colId) => FeedPage(columnId: colId),
    '/explore': (_) => const ScaffoldPageStub(title: 'Explore'),
    '/messages': (_) => const ScaffoldPageStub(title: 'Messages'),
    '/orders': (_) => const ScaffoldPageStub(title: 'Orders'),
    '/create-post': (_) => const ScaffoldPageStub(title: 'New Post'),
    '/review-order': (_) => const ScaffoldPageStub(title: 'Review Order'),
    '/payment': (_) => const ScaffoldPageStub(title: 'Payment'),
    '/profile': (_) => const ScaffoldPageStub(title: 'Profile'),
  };

  static final _prefixRoutes = <String, Widget Function(String, String)>{
    '/post/': (id, colId) => PostDetailPage(postId: id, inKanban: true),
    '/task/': (id, colId) => PostDetailPage(postId: id, inKanban: true),
  };

  Widget _buildPageForRoute(String path, BuildContext context) {
    final exact = _exactRoutes[path];
    if (exact != null) return exact(widget.columnId);
    for (final entry in _prefixRoutes.entries) {
      if (path.startsWith(entry.key)) {
        return entry.value(path.substring(entry.key.length), widget.columnId);
      }
    }
    return const ScaffoldPageStub(title: 'Column');
  }
}
