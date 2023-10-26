import 'package:flutter/material.dart';

class MoviePage extends Page {
  final Widget _child;

  MoviePage(ValueKey key, this._child) : super(key: key);

  Route createRoute(BuildContext context) {
    //TODO animation
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return _child;
      },
    );
  }
}
