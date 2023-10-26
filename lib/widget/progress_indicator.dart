import 'package:flutter/material.dart';

class SplashProgressIndicator extends StatelessWidget {
  Color _valueColor;

  SplashProgressIndicator(this._valueColor);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 100,
        width: 100,
        child: CircularProgressIndicator(
          strokeWidth: 6,
          valueColor: new AlwaysStoppedAnimation<Color>(_valueColor),
          backgroundColor: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
