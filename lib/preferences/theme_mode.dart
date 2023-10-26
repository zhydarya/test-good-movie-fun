import 'package:flutter/material.dart';
import 'package:good_movie_fan/preferences/preference_switcher_data.dart';
import 'package:good_movie_fan/strings.dart';

extension ThemeModeProperties on ThemeMode {
  String get name {
    switch (this) {
      case ThemeMode.light:
        return Strings.light;
      case ThemeMode.dark:
        return Strings.dark;
      case ThemeMode.system:
        return Strings.system;
    }
    assert(false, "Unimplemented name for theme mode: $this");
  }

  String get hint {
    switch (this) {
      case ThemeMode.light:
        return Strings.lightHint;
      case ThemeMode.dark:
        return Strings.darkHint;
      case ThemeMode.system:
        return Strings.systemHint;
    }
    assert(false, "Unimplemented tip for theme mode: $this");
  }

  IconData get icon {
    switch (this) {
      case ThemeMode.light:
        return Icons.analytics_outlined;
      case ThemeMode.dark:
        return Icons.analytics;
      case ThemeMode.system:
        return Icons.settings;
    }
    assert(false, "Unimplemented icon for theme mode: $this");
  }
}

class ThemeModePreferenceSwitcherData implements PreferenceSwitcherData {
  ThemeMode _value;

  ThemeModePreferenceSwitcherData(this._value);

  @override
  int get value => _value.index;
  @override
  String get name => _value.name;
  @override
  String get hint => _value.hint;
  @override
  IconData get icon => _value.icon;
}
