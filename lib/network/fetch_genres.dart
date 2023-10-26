import 'dart:async';
import 'dart:convert';
import 'package:good_movie_fan/network/key_values.dart';
import 'package:http/http.dart' as http;

const _path = '3/genre/movie/list';
const _idKey = 'id';
const _nameKey = 'name';

Future<Map<int, String>> fetchGenres() async {
  final response = await http.get(
    Uri.https(
      Query.authority,
      _path,
      {
        Query.apiKey: Query.apiKeyVal,
      },
    ),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> parsed = jsonDecode(response.body);
    var results = parsed[Response.genresKey];
    return Map.fromIterable(
      results,
      key: (it) => it[_idKey],
      value: (it) => it[_nameKey],
    );
  } else {
    //TODO parse error response
    return null;
  }
}
