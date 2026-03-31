/// Kanban column model for desktop layout
class KanbanColumn {
  final String id;
  final String path;
  final double width;
  final Map<String, dynamic>? routeState;
  final int? activeTab;

  const KanbanColumn({
    required this.id,
    required this.path,
    this.width = 420,
    this.routeState,
    this.activeTab,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KanbanColumn &&
          id == other.id &&
          path == other.path &&
          width == other.width &&
          activeTab == other.activeTab &&
          identical(routeState, other.routeState);

  @override
  int get hashCode => Object.hash(id, path, width, activeTab, routeState);

  KanbanColumn copyWith({
    String? id,
    String? path,
    double? width,
    Map<String, dynamic>? routeState,
    int? activeTab,
  }) {
    return KanbanColumn(
      id: id ?? this.id,
      path: path ?? this.path,
      width: width ?? this.width,
      routeState: routeState ?? this.routeState,
      activeTab: activeTab ?? this.activeTab,
    );
  }
}
