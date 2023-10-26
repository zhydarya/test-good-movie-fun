import 'package:good_movie_fan/db/database.dart';
import 'package:good_movie_fan/model/credit.dart';

mixin TableCrew on DatabaseHolder {
  static const _tableName = 'crew';

  String createCrew() {
    return "CREATE TABLE $_tableName("
        "${Credit.keyId} TEXT PRIMARY KEY, "
        "${Credit.keyPersonId} INTEGER, "
        "${Credit.keyMovieId} INTEGER, "
        "${Credit.roleForType(CreditType.crew)} TEXT"
        ")";
  }

//TODO
}
