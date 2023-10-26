import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:good_movie_fan/model/credit.dart';
import 'package:good_movie_fan/model/movie.dart';
import 'package:good_movie_fan/model/person.dart';
import 'package:good_movie_fan/network/key_values.dart';
import 'package:http/http.dart' as http;

Future<void> fetchMovieCredits(Movie movie) async {
  var connectivityState = await Connectivity().checkConnectivity();
  if (connectivityState == ConnectivityResult.none) {
    return;
  }

  final response = await http.get(
    Uri.https(
      Query.authority,
      '3/movie/${movie.id}/credits',
      {
        Query.apiKey: Query.apiKeyVal,
      },
    ),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> parsed = jsonDecode(response.body);

    var parsedCast = parsed[Response.castKey];
    for (var result in parsedCast) {
      movie.addCast(
          Credit.fromMap(result, creditType: CreditType.cast, movie: movie));
    }

    var parsedCrew = parsed[Response.crewKey];
    for (var result in parsedCrew) {
      movie.addCrew(
          Credit.fromMap(result, creditType: CreditType.crew, movie: movie));
    }
  } else {
    //TODO parse error response
    throw Exception("Failed to fetch movie's credits");
  }
}

Future<void> fetchPersonCredits(Person person) async {
  var connectivityState = await Connectivity().checkConnectivity();
  if (connectivityState == ConnectivityResult.none) {
    return;
  }

  final response = await http.get(
    Uri.https(
      Query.authority,
      '3/person/${person.id}/movie_credits',
      {
        Query.apiKey: Query.apiKeyVal,
      },
    ),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> parsed = jsonDecode(response.body);

    var parsedCast = parsed[Response.castKey];
    for (var result in parsedCast) {
      person.addCast(Credit.fromMap(
        result,
        creditType: CreditType.cast,
        person: person,
      ));
    }

    var parsedCrew = parsed[Response.crewKey];
    for (var result in parsedCrew) {
      person.addCrew(Credit.fromMap(
        result,
        creditType: CreditType.crew,
        person: person,
      ));
    }
  } else {
    //TODO parse error response
    throw Exception("Failed to fetch person's credits");
  }
}
