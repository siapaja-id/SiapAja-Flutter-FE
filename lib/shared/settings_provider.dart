import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeColor { red, blue, emerald, violet, amber }

enum TextSize { sm, md, lg }

const _keyThemeColor = 'siapaja-theme-color';
const _keyTextSize = 'siapaja-text-size';

class AppSettings {
  final ThemeColor themeColor;
  final TextSize textSize;

  const AppSettings({
    this.themeColor = ThemeColor.red,
    this.textSize = TextSize.md,
  });

  AppSettings copyWith({ThemeColor? themeColor, TextSize? textSize}) {
    return AppSettings(
      themeColor: themeColor ?? this.themeColor,
      textSize: textSize ?? this.textSize,
    );
  }
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  SharedPreferences? _prefs;

  SettingsNotifier([AppSettings? initial])
    : super(initial ?? const AppSettings());

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final rawColor = _prefs!.getString(_keyThemeColor);
    final rawSize = _prefs!.getString(_keyTextSize);
    state = AppSettings(
      themeColor: _parseThemeColor(rawColor),
      textSize: _parseTextSize(rawSize),
    );
  }

  Future<void> setThemeColor(ThemeColor color) async {
    state = state.copyWith(themeColor: color);
    await _prefs?.setString(_keyThemeColor, color.name);
  }

  Future<void> setTextSize(TextSize size) async {
    state = state.copyWith(textSize: size);
    await _prefs?.setString(_keyTextSize, size.name);
  }

  static ThemeColor _parseThemeColor(String? value) {
    return ThemeColor.values.byName(value ?? 'red');
  }

  static TextSize _parseTextSize(String? value) {
    return TextSize.values.byName(value ?? 'md');
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>(
  (ref) => SettingsNotifier(),
);
