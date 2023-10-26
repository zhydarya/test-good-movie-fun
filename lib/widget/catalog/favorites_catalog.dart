import 'package:flutter/material.dart';
import 'package:good_movie_fan/model/favorites.dart';
import 'package:good_movie_fan/model/movie.dart';
import 'package:good_movie_fan/widget/catalog/movies_catalog_builder.dart';
import 'package:provider/provider.dart';

class FavoritesCatalog extends StatelessWidget with MoviesCatalogBuilder {
  @override
  Widget build(BuildContext context) {
    return buildCatalog(context, context.watch<Favorites>().items);
  }

  @override
  @protected
  Widget customizeMovieTile(
      {@required Widget movieTile,
      @required Movie movie,
      @required BuildContext context}) {
    return Dismissible(
      key: Key(movie.id.toString()),
      onDismissed: (direction) {
        context.read<Favorites>().toggleFavorite(movie);
      },
      child: movieTile,
    );
  }
}
