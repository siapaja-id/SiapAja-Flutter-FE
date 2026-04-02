import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _keyZoom = 'siapaja-zoom';

/// Zoom state notifier that manages the zoom level.
/// Zoom level ranges from 0.5 (50%) to 3.0 (300%).
class ZoomNotifier extends StateNotifier<double> {
  static const double _minZoom = 0.5;
  static const double _maxZoom = 3.0;
  static const double _step = 0.1;
  static const double _defaultZoom = 1.0;

  ZoomNotifier() : super(_defaultZoom);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getDouble(_keyZoom);
    if (saved != null) {
      state = saved.clamp(_minZoom, _maxZoom);
    }
  }

  /// Zoom in by 0.1 step, capped at max 3.0
  void zoomIn() {
    state = (state + _step).clamp(_minZoom, _maxZoom);
    _persist();
  }

  /// Zoom out by 0.1 step, capped at min 0.5
  void zoomOut() {
    state = (state - _step).clamp(_minZoom, _maxZoom);
    _persist();
  }

  /// Reset zoom to default (1.0)
  void reset() {
    state = _defaultZoom;
    _persist();
  }

  /// Set zoom to a specific value (clamped to valid range)
  void setZoom(double value) {
    state = value.clamp(_minZoom, _maxZoom);
    _persist();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyZoom, state);
  }
}

/// Provider for zoom state management
final zoomProvider = StateNotifierProvider<ZoomNotifier, double>(
  (ref) => ZoomNotifier(),
);
