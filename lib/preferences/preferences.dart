import 'package:flutter/material.dart';
import 'package:good_movie_fan/preferences/layout_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences extends ChangeNotifier {
  static const _layoutKey = 'layout';
  static const _themeKey = 'theme';

  SharedPreferences _sharedPreferences;
  final _unsynchronizedInt = Map<String, int>();

  set sharedPreferences(SharedPreferences sharedPreferences) {
    _sharedPreferences = sharedPreferences;
    _synchronize();
    notifyListeners();
  }

  get layoutType {
    return LayoutType.values[_sharedPreferences?.getInt(_layoutKey) ??
        _unsynchronizedInt[_layoutKey] ??
        0];
  }

  set layoutType(LayoutType layoutType) =>
      _setInt(_layoutKey, layoutType.index);

  get themeMode {
    return ThemeMode.values[_sharedPreferences?.getInt(_themeKey) ??
        _unsynchronizedInt[_themeKey] ??
        0];
  }

  set themeMode(ThemeMode themeMode) => _setInt(_themeKey, themeMode.index);

  void _setInt(String key, int value) {
    if (_sharedPreferences == null) {
      _unsynchronizedInt[key] = value;
    } else {
      _sharedPreferences.setInt(key, value);
    }
    notifyListeners();
  }

  void _synchronize() {
    _unsynchronizedInt
        .forEach((key, value) => _sharedPreferences.setInt(key, value));
    _unsynchronizedInt.clear();
  }
}
