import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:good_movie_fan/model/catalog.dart';
import 'package:good_movie_fan/model/movie.dart';
import 'package:good_movie_fan/network/key_values.dart';
import 'package:http/http.dart' as http;

const _pathMovies = '3/discover/movie';
const _pathMovieDetails = '3/movie/';

Future<FetchedMovies> fetchMovies(
    int page, SearchCriteria searchCriteria) async {
  assert(page >= 0);
  assert(searchCriteria != null); //TODO null safety
  assert(!searchCriteria.filterByVote || searchCriteria.filterVote != null);
  assert(!searchCriteria.filterByYear || searchCriteria.filterYear != null);
  assert(!searchCriteria.filterByCast || searchCriteria.filterCastList != null);

  final response = await http.get(
    Uri.https(
      Query.authority,
      _pathMovies,
      {
        Query.apiKey: Query.apiKeyVal,
        if (page != 0) Query.pageKey: page.toString(),
        if (searchCriteria.filterByVote)
          Query.voteKey: searchCriteria.filterVote.toString(),
        if (searchCriteria.filterByYear)
          Query.yearKey: searchCriteria.filterYear.toString(),
        if (searchCriteria.filterByCast)
          Query.castKey: searchCriteria.filterCastList,
        Query.sortByKey: searchCriteria.sortBy
      },
    ),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> parsed = jsonDecode(response.body);
    var results = parsed[Response.resultsKey];
    var totalPages = parsed[Response.totalPagesKey];
    var page = parsed[Response.pageKey];
    List<Movie> movies =
        List.generate(results.length, (index) => Movie.fromMap(results[index]));

    return FetchedMovies(
        movies: movies, totalPages: totalPages, currentPage: page);
  } else {
    //TODO parse error response
    throw Exception('Failed to fetch movies');
  }
}

Future<void> fetchMovieDetails(Movie movie) async {
  var connectivityState = await Connectivity().checkConnectivity();
  if (connectivityState == ConnectivityResult.none) {
    return;
  }

  final response = await http.get(
    Uri.https(
      Query.authority,
      '$_pathMovieDetails${movie.id}',
      {
        Query.apiKey: Query.apiKeyVal,
      },
    ),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> parsed = jsonDecode(response.body);
    await movie.fillInDetails(parsed);
  } else {
    //TODO parse error response
    throw Exception('Failed to fetch movies');
  }
}
