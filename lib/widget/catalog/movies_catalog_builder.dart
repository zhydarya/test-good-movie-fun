import 'package:flutter/material.dart';
import 'package:good_movie_fan/model/movie.dart';
import 'package:good_movie_fan/preferences/layout_type.dart';
import 'package:good_movie_fan/preferences/preferences.dart';
import 'package:good_movie_fan/widget/catalog/movie_tile.dart';
import 'package:provider/provider.dart';

abstract class MoviesCatalogBuilder {
  Widget buildCatalog(BuildContext context, List<Movie> movies) {
    assert(movies != null);

    var currentLayout = context.select<Preferences, LayoutType>(
        (preferences) => preferences.layoutType);
    switch (currentLayout) {
      case LayoutType.list:
        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: movies.length,
          itemBuilder: (context, index) => _itemBuilder(context, index, movies),
        );
      case LayoutType.single:
        return PageView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: movies.length,
          itemBuilder: (context, index) => _itemBuilder(context, index, movies),
        );
      case LayoutType.grid:
        return GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: movies.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 2.0,
            crossAxisSpacing: 2.0,
            childAspectRatio: 9.0 / 16.0,
          ),
          itemBuilder: (context, index) => _itemBuilder(context, index, movies),
        );
      default:
        assert(false, "Unimplemented layout type!");
        return null;
    }
  }

  @protected
  Widget customizeMovieTile(
      {@required Widget movieTile,
      @required Movie movie,
      @required BuildContext context}) {
    return movieTile;
  }

  Widget _itemBuilder(BuildContext context, int index, List<Movie> movies) {
    return customizeMovieTile(
      movieTile: MovieTile(movies[index]),
      movie: movies[index],
      context: context,
    );
  }
}
