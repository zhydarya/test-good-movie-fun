import 'package:good_movie_fan/db/database.dart';
import 'package:good_movie_fan/model/credit.dart';

mixin TableCast on DatabaseHolder {
  static const _tableName = 'cast';

  String createCast() {
    return "CREATE TABLE $_tableName("
        "${Credit.keyId} TEXT PRIMARY KEY, "
        "${Credit.keyPersonId} INTEGER, "
        "${Credit.keyMovieId} INTEGER, "
        "${Credit.roleForType(CreditType.cast)} TEXT"
        ")";
  }

  //TODO
}
