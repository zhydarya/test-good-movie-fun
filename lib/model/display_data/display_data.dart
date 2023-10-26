import 'package:good_movie_fan/model/credit.dart';

abstract class DisplayData {
  String get title;
  String get header;
  String get avaPath;
  String get homepagePath;
  Map<String, String> get properties;
  String get description;
  List<Credit> get cast;
  List<Credit> get crew;
  Map<String, List<String>> get videos;
}
