import 'package:flutter/material.dart';
import 'package:good_movie_fan/page/home.dart';
import 'package:good_movie_fan/strings.dart';

class PageEntry {
  ValueKey valueKey;
  Widget page;
  String title;

  PageEntry(this.valueKey, this.page, this.title);
}

class PageStack extends ChangeNotifier {
  List<PageEntry> _pages = [];
  List<PageEntry> get pages => _pages;
  List<void Function()> _onPopCallbacks = [];

  PageStack() {
    push(Home(NavigationPage.home), Strings.home);
  }

  void push(Widget page, String title) {
    _pages.add(PageEntry(ValueKey(page), page, title));
    notifyListeners();
  }

  //route pushed to navigator was not added to the page stack;
  //shouldn't be removed from it on pop()
  //instead, onPopCallback should be called
  void onPushedToNavigator(void Function() onPopCallback) =>
      _onPopCallbacks.add(onPopCallback);

  void pop(BuildContext context) {
    if (_onPopCallbacks.isNotEmpty) {
      _onPopCallbacks.removeLast()();
    } else {
      _pages.removeLast();
      notifyListeners();
    }
  }

  void unwind(int index) {
    _pages.removeRange(index + 1, _pages.length);
    notifyListeners();
  }
}
