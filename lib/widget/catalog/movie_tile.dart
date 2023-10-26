import 'package:flutter/material.dart';
import 'package:good_movie_fan/model/display_data/movie_display_data.dart';
import 'package:good_movie_fan/model/movie.dart';
import 'package:good_movie_fan/navigation/page_stack.dart';
import 'package:good_movie_fan/network/key_values.dart';
import 'package:good_movie_fan/page/movie_details.dart';
import 'package:good_movie_fan/preferences/layout_type.dart';
import 'package:good_movie_fan/preferences/preferences.dart';
import 'package:good_movie_fan/strings.dart';
import 'package:good_movie_fan/widget/catalog/favorite_icon.dart';
import 'package:provider/provider.dart';

@immutable
class MovieTile extends StatelessWidget {
  final Movie _movie;

  MovieTile(this._movie);

  @override
  Widget build(BuildContext context) {
    var movieDisplayData = MovieDisplayData(_movie);

    final theme = Theme.of(context);
    var currentLayout = context.select<Preferences, LayoutType>(
        (preferences) => preferences.layoutType);

    Widget vote = Text(
      movieDisplayData.properties[Strings.voteAverage],
      style: theme.textTheme.subtitle1,
    );

    Widget star = Icon(
      Icons.star,
      color: theme.textTheme.subtitle1.color,
    );

    Widget poster = movieDisplayData.avaPath == ''
        ? _posterPlaceholder(currentLayout, movieDisplayData, theme)
        : Image.network(
            Query.imageUrl + movieDisplayData.avaPath,
            errorBuilder: (context, exception, stackTrace) =>
                _posterPlaceholder(currentLayout, movieDisplayData, theme),
          );

    Widget title = Text(
      movieDisplayData.title,
      style: theme.textTheme.headline6,
    );

    Widget overview = Text(
      movieDisplayData.description,
    );

    Widget favorite = FavoriteIcon(_movie);

    Widget movieTile;

    switch (currentLayout) {
      case LayoutType.list:
        movieTile = _createListTile(poster, title, overview, favorite);
        break;
      case LayoutType.single:
        movieTile =
            _createPageTile(poster, title, overview, vote, star, favorite);
        break;
      case LayoutType.grid:
      default:
        movieTile = _createGridTile(poster, vote, star, favorite);
    }

    return InkWell(
      onTap: () {
        var pageStack = context.read<PageStack>();
        pageStack.push( MovieDetails(_movie), MovieDisplayData(_movie).title);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => MovieDetails(_movie)),
        // );
      },
      child: Card(
        child: movieTile,
      ),
    );
  }

  Widget _posterPlaceholder(
      LayoutType layoutType, MovieDisplayData movie, ThemeData theme) {
    if (layoutType == LayoutType.grid)
      return Center(
        child: Text(
          movie.title,
          style: theme.textTheme.headline5,
          textAlign: TextAlign.center,
        ),
      );
    return const Icon(Icons.movie_rounded);
  }

  Widget _createListTile(
      Widget poster, Widget title, Widget overview, Widget favorite) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
          leading: poster,
          title: title,
          subtitle: overview,
          trailing: favorite),
    );
  }

  Widget _createGridTile(
      Widget poster, Widget vote, Widget star, Widget favorite) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: GridTile(
          header: GridTileBar(
            leading: star,
            title: vote,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: poster,
          ),
          footer: favorite),
    );
  }

  Widget _createPageTile(Widget poster, Widget title, Widget overview,
      Widget vote, Widget star, Widget favorite) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 8.0),
        AspectRatio(
          aspectRatio: 18.0 / 11.0,
          child: poster,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                title,
                const SizedBox(height: 8.0),
                Expanded(
                  child: SingleChildScrollView(
                    child: overview,
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[star, vote],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: favorite,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
