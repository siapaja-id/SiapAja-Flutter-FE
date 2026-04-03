import '../../../shared/utils/color_extensions.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app_theme.dart';
import '../../../app_router.dart';
import '../../../models/kanban_column.dart';
import '../../../features/settings/pages/settings_page.dart';
import '../providers.dart';
import '../pages/feed_page.dart';
import '../pages/post_detail_page.dart';
import 'glass_card.dart';

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
  if (path == '/settings') {
    return const _ColumnMeta(PhosphorIconsRegular.gear, 'Settings');
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
  final AnimationController? enterController;
  final VoidCallback? onCloseRequested;

  const KanbanColumnWidget({
    super.key,
    required this.column,
    required this.index,
    required this.total,
    this.enterController,
    this.onCloseRequested,
  });

  @override
  ConsumerState<KanbanColumnWidget> createState() => _KanbanColumnWidgetState();
}

class _KanbanColumnWidgetState extends ConsumerState<KanbanColumnWidget>
    with TickerProviderStateMixin {
  bool _isHovering = false;
  bool _isResizing = false;
  double _resizeStartX = 0;
  double _resizeStartWidth = 0;
  double _localWidth = 0;

  late final AnimationController _entranceController;
  late final AnimationController _hoverController;
  late final Animation<double> _hoverAnimation;

  @override
  void initState() {
    super.initState();
    _entranceController =
        widget.enterController ??
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 350),
        );
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _hoverAnimation = CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOutCubic,
    );

    if (widget.enterController == null) {
      final delay = widget.index * 80;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          if (delay > 0) {
            Future.delayed(Duration(milliseconds: delay), () {
              if (mounted) _entranceController.forward();
            });
          } else {
            _entranceController.forward();
          }
        }
      });
    }
  }

  @override
  void dispose() {
    if (widget.enterController == null) {
      _entranceController.dispose();
    }
    _hoverController.dispose();
    super.dispose();
  }

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

    void handleClose() {
      _entranceController.reverse().then((_) {
        if (mounted) {
          widget.onCloseRequested?.call();
        }
      });
    }

    return KanbanColumnContext(
      columnId: widget.column.id,
      path: widget.column.path,
      routeState: widget.column.routeState,
      child: SharedAxisTransition(
        animation: _entranceController,
        secondaryAnimation: kAlwaysDismissedAnimation,
        transitionType: SharedAxisTransitionType.horizontal,
        child: AnimatedBuilder(
          animation: _hoverAnimation,
          builder: (context, child) {
            return Transform(
              transform: Matrix4.translationValues(
                0,
                -_hoverAnimation.value * 2.0,
                0,
              ),
              child: child,
            );
          },
          child: MouseRegion(
            onEnter: (_) {
              setState(() => _isHovering = true);
              _hoverController.forward();
            },
            onExit: (_) {
              setState(() => _isHovering = false);
              _hoverController.reverse();
            },
            child: SizedBox(
              width: _isResizing ? _localWidth : widget.column.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 12,
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: RepaintBoundary(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(36),
                            border: Border.all(
                              color: _isHovering
                                  ? Colors.white.w18
                                  : Colors.white.w10,
                            ),
                            color: _isResizing
                                ? const Color(0x661F1F1F)
                                : const Color(0x801F1F1F),
                            boxShadow: [
                              BoxShadow(
                                color: _isHovering
                                    ? Colors.black87
                                    : Colors.black54,
                                blurRadius: _isHovering ? 60 : 50,
                                spreadRadius: _isHovering ? -8 : -12,
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: GlassCard(
                            borderRadius: 36,
                            blurSigma: 40,
                            tint: Colors.transparent,
                            border: Border.none,
                            boxShadow: const [],
                            padding: EdgeInsets.zero,
                            showGlow: false,
                            child: Column(
                                children: [
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
                                    onClose: handleClose,
                                  ),
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
                                    : Colors.white.w20,
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
        color: Colors.white.w03,
        border: Border(
          bottom: BorderSide(color: Colors.white.w06),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white.w06,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 14,
                    color: Colors.white.w50,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: AppTheme.scaled(
                      multiplier: AppTheme.m1sm,
                      weight: FontWeight.w700,
                      color: Colors.white.w65,
                      letterSpacing: 0.03,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
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
                    color: Colors.white.w04,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${index + 1}/$total',
                    style: AppTheme.scaled(
                      multiplier: AppTheme.m2xs,
                      weight: FontWeight.w800,
                      color: Colors.white.w25,
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
                    color: Colors.white.w25,
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
class _ColumnBody extends StatelessWidget {
  final String path;
  final String columnId;

  const _ColumnBody({required this.path, required this.columnId});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: ValueKey(columnId),
      initialRoute: path,
      onGenerateInitialRoutes: (navState, initialRouteName) {
        return [
          MaterialPageRoute(
            settings: RouteSettings(name: initialRouteName),
            builder: (ctx) => _buildPageForRoute(initialRouteName, ctx),
          ),
        ];
      },
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (ctx) => _buildPageForRoute(settings.name ?? path, ctx),
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
    '/settings': (_) => const SettingsPage(),
    '/profile': (_) => const ScaffoldPageStub(title: 'Profile'),
  };

  static final _prefixRoutes = <String, Widget Function(String, String)>{
    '/post/': (id, colId) => PostDetailPage(postId: id, inKanban: true),
    '/task/': (id, colId) => PostDetailPage(postId: id, inKanban: true),
  };

  Widget _buildPageForRoute(String path, BuildContext context) {
    final exact = _exactRoutes[path];
    if (exact != null) return exact(columnId);
    for (final entry in _prefixRoutes.entries) {
      if (path.startsWith(entry.key)) {
        return entry.value(path.substring(entry.key.length), columnId);
      }
    }
    return const ScaffoldPageStub(title: 'Column');
  }
}
