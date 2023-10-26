import 'package:flutter/material.dart';
import 'package:good_movie_fan/model/credit.dart';
import 'package:good_movie_fan/model/display_data/movie_display_data.dart';
import 'package:good_movie_fan/network/fetch_credits.dart';
import 'package:good_movie_fan/network/fetch_movies.dart';
import 'package:good_movie_fan/network/fetch_videos.dart';

class MovieInnerState {
  final String title;
  final String posterPath;
  final String overview;
  final num voteAverage;
  final String releaseDate;
  List<String> genres;
  String imdbId = '';
  String homepage = '';
  int duration = 0;
  var videos = const <String, List<String>>{};
  var productionCountries = const <String>[]; //TODO parse
  final cast = <Credit>[];
  final crew = <Credit>[];

  MovieInnerState(String title, String posterPath, String overview,
      num voteAverage, String releaseDate)
      : this.title = title ?? '',
        this.overview = overview ?? '',
        this.posterPath = posterPath ?? '',
        this.voteAverage = voteAverage ?? .0,
        this.releaseDate = releaseDate ?? '';
}

class Movie {
  static const keyId = 'id';
  static const keyTitle = 'title';
  static const keyPosterPath = 'poster_path';
  static const keyOverview = 'overview';
  static const keyVoteAverage = 'vote_average';
  static const keyReleaseDate = 'release_date';
  static const keyImdbId = 'imdb_id';
  static const keyHomepage = 'homepage';
  static const keyDuration = 'runtime';
  static const keyGenres = 'genres';
  static const keyGenreName = 'name';

  final int id;
  final MovieInnerState _innerState;
  Future<void> _creditsFetched;
  Future<void> _detailsFetched;

  Movie._internal(
      {@required this.id,
      String title = '',
      String posterPath = '',
      String overview = '',
      num voteAverage = .0,
      String releaseDate = ''})
      : assert(id != null), //TODO migrate to null safety
        _innerState = MovieInnerState(
            title, posterPath, overview, voteAverage, releaseDate);

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie._internal(
      id: map[keyId],
      title: map[keyTitle],
      posterPath: map[keyPosterPath],
      overview: map[keyOverview],
      voteAverage: map[keyVoteAverage],
      releaseDate: map[keyReleaseDate],
    ).._fillExtras(map);
  }

  Future<void> fillInDetails(Map<String, dynamic> map) async {
    var genreRes = map[keyGenres];
    if (genreRes != null && genreRes.isNotEmpty) {
      _innerState.genres = List.generate(
          genreRes.length, (index) => genreRes[index][keyGenreName]);
    }

    _innerState.videos = await fetchVideos(id);

    _fillExtras(map);
  }

  void _fillExtras(Map<String, dynamic> map) {
    _innerState.imdbId = map[keyImdbId] ?? '';
    _innerState.homepage = map[keyHomepage] ?? '';
    _innerState.duration = map[keyDuration] ?? 0;
  }

  Map<String, dynamic> toMap() {
    return {
      keyId: id,
      keyTitle: _innerState.title,
      keyPosterPath: _innerState.posterPath,
      keyOverview: _innerState.overview,
      keyVoteAverage: _innerState.voteAverage,
      //TODO other properties
    };
  }

  Future<void> fetchDetails() async {
    //TODO process error result
    return _detailsFetched ??= fetchMovieDetails(this);
  }

  Future<void> fetchCredits() async {
    //TODO process error result
    return _creditsFetched ??= fetchMovieCredits(this);
  }

  void addCast(Credit cast) {
    _innerState.cast.add(cast);
  }

  void addCrew(Credit crew) {
    _innerState.crew.add(crew);
  }

  void provideInnerStateTo(MovieDisplayData movieDisplayData) {
    movieDisplayData.movieInnerState = _innerState;
  }

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Movie && other.id == id;

  @override
  String toString() {
    return 'Movie {id: $id}';
  }
}
