import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:good_movie_fan/model/person.dart';
import 'package:good_movie_fan/network/key_values.dart';
import 'package:http/http.dart' as http;

const _path = '3/person/';

Future<void> fetchPersonDetails(Person person) async {
  var connectivityState = await Connectivity().checkConnectivity();
  if (connectivityState == ConnectivityResult.none) {
    return;
  }

  final response = await http.get(
    Uri.https(
      Query.authority,
      '$_path${person.id}',
      {
        Query.apiKey: Query.apiKeyVal,
      },
    ),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> parsed = jsonDecode(response.body);
    person.fillInDetails(parsed);
  } else {
    //TODO parse error response
    throw Exception('Failed to fetch person details');
  }
}

Future<void> fetchPersonImages(Person person) async {
  var connectivityState = await Connectivity().checkConnectivity();
  if (connectivityState == ConnectivityResult.none) {
    return;
  }

  final response = await http.get(
    Uri.https(
      Query.authority,
      '$_path${person.id}/images',
      {
        Query.apiKey: Query.apiKeyVal,
      },
    ),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> parsed = jsonDecode(response.body);
    var parsedProfiles = parsed[Response.profilesKey];
    person.fillInImages(parsedProfiles);
  } else {
    //TODO parse error response
    throw Exception('Failed to fetch person images');
  }
}
