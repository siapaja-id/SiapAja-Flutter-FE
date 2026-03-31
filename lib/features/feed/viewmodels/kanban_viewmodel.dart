import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../models/kanban_column.dart';

part 'kanban_viewmodel.freezed.dart';

@freezed
abstract class KanbanState with _$KanbanState {
  const factory KanbanState({
    required List<KanbanColumn> columns,
    @Default(false) bool isDesktop,
  }) = _KanbanState;
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

  void closeColumn(String id) {
    final index = state.columns.indexWhere((c) => c.id == id);
    if (index == 0) return;
    state = state.copyWith(
      columns: state.columns.where((c) => c.id != id).toList(),
    );
  }

  void setColumnWidth(String id, double width) {
    final clamped = width.clamp(320.0, 800.0);
    state = state.copyWith(
      columns: state.columns.map((c) {
        if (c.id == id) return c.copyWith(width: clamped);
        return c;
      }).toList(),
    );
  }

  void setIsDesktop(bool isDesktop) {
    state = state.copyWith(isDesktop: isDesktop);
  }

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

final kanbanProvider = NotifierProvider<KanbanNotifier, KanbanState>(
  () => KanbanNotifier(),
);
