import 'package:flutter/material.dart';
import 'package:good_movie_fan/preferences/preference_switcher_data.dart';
import 'package:good_movie_fan/strings.dart';

enum LayoutType { grid, list, single }

extension LayoutTypeProperties on LayoutType {
  String get name {
    switch (this) {
      case LayoutType.grid:
        return Strings.grid;
      case LayoutType.list:
        return Strings.list;
      case LayoutType.single:
        return Strings.singlePage;
    }
    assert(false, "Unimplemented name for layout type: $this");
  }

  String get hint {
    switch (this) {
      case LayoutType.grid:
        return Strings.gridHint;
      case LayoutType.list:
        return Strings.listHint;
      case LayoutType.single:
        return Strings.singlePageHint;
    }
    assert(false, "Unimplemented hint for layout type: $this");
  }

  IconData get icon {
    switch (this) {
      case LayoutType.grid:
        return Icons.grid_view;
      case LayoutType.list:
        return Icons.list;
      case LayoutType.single:
        return Icons.crop_square;
    }
    assert(false, "Unimplemented icon for layout type: $this");
  }
}

class LayoutTypePreferenceSwitcherData implements PreferenceSwitcherData {
  LayoutType _value;

  LayoutTypePreferenceSwitcherData(this._value);

  @override
  int get value => _value.index;
  @override
  String get name => _value.name;
  @override
  String get hint => _value.hint;
  @override
  IconData get icon => _value.icon;
}
