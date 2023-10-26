import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:good_movie_fan/network/key_values.dart';
import 'package:http/http.dart' as http;

const _idKey = 'key';
const _typeKey = 'type';
const _siteKey = 'site';
const _youtubeSiteValue = 'YouTube';

Future<Map<String, List<String>>> fetchVideos(int movieId) async {
  var connectivityState = await Connectivity().checkConnectivity();
  if (connectivityState == ConnectivityResult.none) {
    return {};
  }

  final response = await http.get(
    Uri.https(
      Query.authority,
      '3/movie/$movieId/videos',
      {
        Query.apiKey: Query.apiKeyVal,
      },
    ),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> parsed = jsonDecode(response.body);
    var results = parsed[Response.resultsKey];

    var videos = Map<String, List<String>>();
    for (var result in results) {
      if (result[_siteKey] != _youtubeSiteValue) {
        continue;
      }
      var videoType = result[_typeKey];
      if (!videos.containsKey(videoType)) {
        videos[videoType] = [];
      }
      videos[videoType].add(result[_idKey]);
    }
    return videos;
  } else {
    //TODO parse error response
    throw Exception('Failed to fetch videos');
  }
}
