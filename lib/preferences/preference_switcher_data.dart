import 'package:flutter/material.dart';

abstract class PreferenceSwitcherData {
  int get value;
  String get name;
  String get hint;
  IconData get icon;
}
