import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/kanban_column.dart';

/// Kanban state for desktop layout
class KanbanState {
  final List<KanbanColumn> columns;
  final bool isDesktop;

  const KanbanState({required this.columns, this.isDesktop = false});

  KanbanState copyWith({List<KanbanColumn>? columns, bool? isDesktop}) {
    return KanbanState(
      columns: columns ?? this.columns,
      isDesktop: isDesktop ?? this.isDesktop,
    );
  }
}

/// Kanban Notifier — manages desktop kanban columns
class KanbanNotifier extends Notifier<KanbanState> {
  @override
  KanbanState build() {
    return const KanbanState(
      columns: [
        KanbanColumn(id: 'main-col', path: '/', width: 420, activeTab: 0),
      ],
      isDesktop: false,
    );
  }

  /// Open a new column. If sourceId is provided, inserts after that column.
  void openColumn(
    String path, {
    String? sourceId,
    Map<String, dynamic>? routeState,
  }) {
    final id = 'col-${_randomId()}';
    final newCol = KanbanColumn(
      id: id,
      path: path,
      width: 420,
      routeState: routeState,
      activeTab: path == '/' ? 0 : null,
    );

    if (sourceId != null) {
      final index = state.columns.indexWhere((c) => c.id == sourceId);
      if (index != -1) {
        final newCols = List<KanbanColumn>.from(state.columns);
        newCols.insert(index + 1, newCol);
        state = state.copyWith(columns: newCols);
        return;
      }
    }
    state = state.copyWith(columns: [...state.columns, newCol]);
  }

  /// Close a column by id. First column (index 0) cannot be removed.
  void closeColumn(String id) {
    final index = state.columns.indexWhere((c) => c.id == id);
    if (index == 0) return;
    state = state.copyWith(
      columns: state.columns.where((c) => c.id != id).toList(),
    );
  }

  /// Set column width, clamped to [320, 800].
  void setColumnWidth(String id, double width) {
    final clamped = width.clamp(320.0, 800.0);
    state = state.copyWith(
      columns: state.columns.map((c) {
        if (c.id == id) return c.copyWith(width: clamped);
        return c;
      }).toList(),
    );
  }

  /// Update desktop flag.
  void setIsDesktop(bool isDesktop) {
    state = state.copyWith(isDesktop: isDesktop);
  }

  /// Set per-column active tab.
  void setColumnActiveTab(String columnId, int tab) {
    state = state.copyWith(
      columns: state.columns.map((c) {
        if (c.id == columnId) return c.copyWith(activeTab: tab);
        return c;
      }).toList(),
    );
  }

  String _randomId() {
    final rng = Random();
    return rng.nextInt(0xFFFFFF).toRadixString(36).padLeft(6, '0');
  }
}

/// Kanban provider
final kanbanProvider = NotifierProvider<KanbanNotifier, KanbanState>(
  () => KanbanNotifier(),
);
