import 'package:good_movie_fan/db/database.dart';
import 'package:good_movie_fan/model/person.dart';

mixin TablePeople on DatabaseHolder {
  static const _tableName = 'people';

  String createPeople() {
    return "CREATE TABLE $_tableName("
        "${Person.keyId} INTEGER PRIMARY KEY, "
        "${Person.keyName} TEXT, "
        "${Person.keyProfilePath} TEXT, "
        "${Person.keyBirthday} TEXT, "
        "${Person.keyDeathday} TEXT,"
        "${Person.keyBirthplace} TEXT,"
        "${Person.keyBiography} TEXT,"
        "${Person.keyImdbId} TEXT,"
        "${Person.keyHomepage} TEXT"
        ")";
  }

  //TODO
}
