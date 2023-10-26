import 'package:flutter/material.dart';
import 'package:good_movie_fan/navigation/page_stack.dart';
import 'package:provider/provider.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _pageStack = context.watch<PageStack>();
    return Container(
      width: 250.0,
      color: Theme.of(context).dialogBackgroundColor,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _pageStack.pages.length,
        itemBuilder: (_, index) => ListTile(
          title: Text(_pageStack.pages[index].title),
          trailing: IconButton(
            icon: Icon(Icons.open_in_new),
            onPressed: () {
              Navigator.pop(context);
              _pageStack.unwind(index);
            }
          ),
        ),
      ),
    );
  }
}
