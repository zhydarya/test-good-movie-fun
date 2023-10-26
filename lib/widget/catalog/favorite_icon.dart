import 'package:flutter/material.dart';
import 'package:good_movie_fan/model/favorites.dart';
import 'package:good_movie_fan/model/movie.dart';
import 'package:provider/provider.dart';

class FavoriteIcon extends StatelessWidget {
  final Movie _movie;

  FavoriteIcon(this._movie);

  @override
  Widget build(BuildContext context) {
    var isFavorite = context
        .select<Favorites, bool>((favorites) => favorites.isFavorite(_movie));
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      ),
      onPressed: () {
        context.read<Favorites>().toggleFavorite(_movie);
      },
    );
  }
}
