import 'package:flutter/material.dart';
import 'package:good_movie_fan/db/database.dart';
import 'package:good_movie_fan/model/movie.dart';

class Favorites extends ChangeNotifier {
  final _db = MoviesDatabase.instance();
  var _items = <Movie>[];

  Favorites() {
    _db.favorites().then((value) {
      _items = value;
      notifyListeners();
    });
  }

  get items => _items;

  bool isFavorite(Movie movie) => _items.contains(movie);

  toggleFavorite(Movie movie) {
    assert(movie != null); //TODO null safety
    if (_items.contains(movie)) {
      _items.remove(movie);
      _db.deleteFavorite(movie.id); //TODO delete dependencies
    } else {
      //TODO
      // on favorite action,
      // fetch related data, movie and credits (up to 5?) details and store in DB
      // just in case favorite details are opened offline
      // since user favorited the movie, there is a big chance he might open the details...
      _items.add(movie);
      _db.insertFavorite(movie);
    }

    notifyListeners();
  }
}
