import 'package:flutter/material.dart';
import 'package:good_movie_fan/model/catalog.dart';
import 'package:good_movie_fan/model/favorites.dart';
import 'package:good_movie_fan/navigation/page_stack.dart';
import 'package:good_movie_fan/preferences/layout_type.dart';
import 'package:good_movie_fan/preferences/preferences.dart';
import 'package:good_movie_fan/preferences/theme_mode.dart';
import 'package:good_movie_fan/strings.dart';
import 'package:good_movie_fan/widget/catalog/favorites_catalog.dart';
import 'package:good_movie_fan/widget/fab.dart';
import 'package:good_movie_fan/widget/catalog/search_movies_catalog.dart';
import 'package:good_movie_fan/widget/preference_multiswitcher.dart';
import 'package:good_movie_fan/widget/progress_indicator.dart';
import 'package:provider/provider.dart';

enum NavigationPage { home, favorites }

class Home extends StatefulWidget {
  NavigationPage navigationPage;

  Home(this.navigationPage) : assert(navigationPage != null);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _fabClosed = true;
  ThemeData _theme;

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    return ChangeNotifierProvider(
      create: (context) => Favorites(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _buildAppBar(),
        body: _buildBody(),
        endDrawer: _buildDrawer(),
        bottomNavigationBar: _buildBottomNavigationBar(context),
        floatingActionButton: _buildFab(),
      ),
    );
  }

  Widget _buildDrawer() {
    return Container(
      width: 250.0,
      color: _theme.dialogBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _layoutPreference(),
          _themePreference(),
        ],
      ),
    );
  }

  Widget _layoutPreference() {
    return PreferenceMultiSwitcher(
      title: Strings.layoutSwitcher,
      preferenceSelector: (BuildContext buildContext) =>
          buildContext.select<Preferences, LayoutTypePreferenceSwitcherData>(
              (preferences) =>
                  LayoutTypePreferenceSwitcherData(preferences.layoutType)),
      preferenceReader: (BuildContext context) {
        var prefs = context.read<Preferences>();
        return LayoutTypePreferenceSwitcherData(prefs.layoutType);
      },
      preferenceSetter: (index) =>
          context.read<Preferences>().layoutType = LayoutType.values[index],
      values: LayoutType.values
          .map((layoutType) => LayoutTypePreferenceSwitcherData(layoutType))
          .toList(),
    );
  }

  Widget _themePreference() {
    return PreferenceMultiSwitcher(
      title: Strings.themeSwitcher,
      preferenceSelector: (BuildContext context) => context
          .select<Preferences, ThemeModePreferenceSwitcherData>((preferences) =>
              ThemeModePreferenceSwitcherData(preferences.themeMode)),
      preferenceReader: (BuildContext context) {
        var prefs = context.read<Preferences>();
        return ThemeModePreferenceSwitcherData(prefs.themeMode);
      },
      preferenceSetter: (index) =>
          context.read<Preferences>().themeMode = ThemeMode.values[index],
      values: ThemeMode.values
          .map((themeMode) => ThemeModePreferenceSwitcherData(themeMode))
          .toList(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: const Text(Strings.appTitle),
      actions: widget.navigationPage == NavigationPage.home
          ? <Widget>[
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
                onPressed: () {
                  context.read<Catalog>().scheduleRefresh();
                },
              ),
              IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    if (_fabClosed) {
                      _scaffoldKey.currentState.openEndDrawer();
                    }
                  }),
            ]
          : null,
    );
  }

  Widget _buildBody() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _catalog(),
      ),
    );
  }

  Widget _catalog() {
    switch (widget.navigationPage) {
      case NavigationPage.home:
        var movies = context.select((Catalog catalog) => catalog.movies);
        return movies.isEmpty
            ? _fetchSearchMoviesCatalog()
            : SearchMoviesCatalog(movies);
      case NavigationPage.favorites:
        return FavoritesCatalog();
      default:
        assert(false, "Unimplemented Navigation item selected");
    }
  }

  Widget _fetchSearchMoviesCatalog() {
    var catalog = context.watch<Catalog>();

    return FutureBuilder<void>(
      future: catalog.refreshItems(),
      builder: (context, futureResult) {
        if (futureResult.connectionState == ConnectionState.done) {
          return SearchMoviesCatalog(catalog.movies);
        }
        if (futureResult.hasError) {
          //TODO process error
          return Container();
        }
        return SplashProgressIndicator(_theme.dialogBackgroundColor);
      },
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: Strings.home,
          backgroundColor: _theme.accentColor,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.favorite_rounded),
          label: Strings.favorites,
          backgroundColor: _theme.bottomNavigationBarTheme.backgroundColor,
        ),
      ],
      currentIndex: widget.navigationPage.index,
      onTap: _onNavigate,
    );
  }

  void _onNavigate(int index) {
    if (index == widget.navigationPage.index) {
      return;
    }
    var newPage = NavigationPage.values[index];
    var pageStack = context.read<PageStack>();

    switch (newPage) {
      case NavigationPage.favorites:
        pageStack.push(Home(NavigationPage.favorites), Strings.favorites);
        break;
      case NavigationPage.home:
        pageStack.pop(context);
        break;
      default:
        assert(false, "Unimplemented Navigation item selected");
    }
  }

  Widget _buildFab() {
    return widget.navigationPage == NavigationPage.home
        ? Fab((fabClosed) {
            _fabClosed = fabClosed;
          })
        : null;
  }
}
