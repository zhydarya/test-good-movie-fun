import 'package:good_movie_fan/db/database.dart';
import 'package:good_movie_fan/model/movie.dart';
import 'package:sqflite/sqflite.dart';

mixin TableFavorites on DatabaseHolder {
  static const _tableName = 'favorites';

  String createFavorites() {
    return "CREATE TABLE $_tableName("
        "${Movie.keyId} INTEGER PRIMARY KEY, "
        "${Movie.keyTitle} TEXT, "
        "${Movie.keyPosterPath} TEXT, "
        "${Movie.keyOverview} TEXT, "
        "${Movie.keyVoteAverage} REAL"
        ")";

    //TODO other data
  }

  Future<List<Movie>> favorites() async {
    final Database db = await database;

    final List<Map<String, dynamic>> result = await db.query(_tableName);
    return List.generate(result.length, (i) => Movie.fromMap(result[i]));
  }

  Future<void> insertFavorite(Movie favorite) async {
    assert(favorite != null); //TODO migrate to null safety

    final Database db = await database;

    await db.insert(
      _tableName,
      favorite.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteFavorite(int id) async {
    assert(id != null); //TODO migrate to null safety

    final Database db = await database;

    return await db.delete(
      _tableName,
      where: '${Movie.keyId} = ?',
      whereArgs: [id],
    );
  }

  //TODO use in WorkManager task
  //TODO update dependencies
  Future<void> updateFavorites(List<Movie> favorites) async {
    final Database db = await database;

    Batch batch = db.batch();
    for (var favorite in favorites) {
      batch.update(
        _tableName,
        favorite.toMap()..remove(Movie.keyId),
        where: '$Movie.key_id = ?',
        whereArgs: [favorite.id],
      );
    }
    await batch.commit(noResult: true);
  }
}
