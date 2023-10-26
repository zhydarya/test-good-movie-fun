import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:good_movie_fan/model/movie.dart';
import 'package:good_movie_fan/network/fetch_genres.dart';
import 'package:good_movie_fan/network/fetch_movies.dart';
import 'package:good_movie_fan/network/key_values.dart';
import 'package:good_movie_fan/strings.dart';

class SearchCriteria {
  int filterYear;
  int filterVote;
  String filterCastList;
  bool filterByYear;
  bool filterByVote;
  bool filterByCast;
  //TODO asc/desc
  String sortBy;

  SearchCriteria(
      {this.filterYear,
      this.filterVote,
      this.filterCastList,
      this.filterByYear = false,
      this.filterByVote = false,
      this.filterByCast = false,
      String sortBy = Strings.popularitySortBy})
      : this.sortBy = _mapToQuery(sortBy);

  static String _mapToQuery(String sortBy) {
    switch (sortBy) {
      case Strings.popularitySortBy:
        return Query.sortByPopularity;
      case Strings.voteAverageSortBy:
        return Query.sortByVote;
      case Strings.titleSortBy:
        return Query.sortByTitle;
      case Strings.releaseDateSortBy:
        return Query.sortByRelease;
      default:
        assert(false, "Unknown sort by value");
        return Query.sortByPopularity;
    }
  }
}

class FetchedMovies {
  List<Movie> movies;
  int totalPages;
  int currentPage;

  FetchedMovies(
      {this.movies = const [], this.totalPages = 0, this.currentPage = 0});
}

class Catalog extends ChangeNotifier {
  static Map<int, String> _genres = {};
  var movies = const <Movie>[];
  int _totalPages = 0;
  int _currentPage = 0;
  var _searchCriteria = SearchCriteria();

  static Future<Map<int, String>> get genres async {
    if (_genres.isEmpty) {
      //TODO
      // var db = MoviesDatabase.instance();
      // var hasGenres = await db.hasGenres();
      // if (hasGenres) {
      //   _genres = await db.genres();
      // } else {
      _genres = await fetchGenres();
      // }
    }

    return _genres;
  }

  set searchCriteria(SearchCriteria searchCriteria) {
    _searchCriteria = searchCriteria;
    _currentPage = 0;
    _totalPages = 0;
    scheduleRefresh();
  }

  void scheduleRefresh() {
    Connectivity().checkConnectivity().then((result) {
     if (result != ConnectivityResult.none) {
       movies = const [];
       notifyListeners();
     }
    });
  }

  Future<void> refreshItems() async {
    //TODO watch connectivity change in widgets
    var connectivityState = await Connectivity().checkConnectivity();
    if (connectivityState == ConnectivityResult.none) {
      return;
    }

    if (_currentPage != 0) {
      _currentPage = _currentPage % _totalPages + 1;
    }
    var fetchedMovies = await fetchMovies(_currentPage, _searchCriteria);
    movies = fetchedMovies.movies;
    _currentPage = fetchedMovies.currentPage;
    _totalPages = fetchedMovies.totalPages;
  }
}
