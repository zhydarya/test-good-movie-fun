import 'dart:async';
import 'package:flutter/material.dart';
import 'package:good_movie_fan/db/table_cast.dart';
import 'package:good_movie_fan/db/table_crew.dart';
import 'package:good_movie_fan/db/table_favorites.dart';
import 'package:good_movie_fan/db/table_people.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

abstract class DatabaseHolder {
  @protected
  Future<Database> database;
}

class MoviesDatabase extends DatabaseHolder
    with TableFavorites, TablePeople, TableCrew, TableCast {
  static MoviesDatabase _instance;
  static const _dbFileName = 'movies_database.db';
  static const _dbVersion = 1;

  MoviesDatabase._internal() {
    //TODO process error scenarios
    database = _openDatabase();
  }

  //assuming Dart is single-threaded
  //and not intending to call this from Isolate - is there a way to annotate/control this somehow?
  //DB may not be used in some scenarios (e.g. on Home page offline),
  //so I'd prefer to initialize it lazily
  factory MoviesDatabase.instance() {
    return _instance ??= MoviesDatabase._internal();
  }

  Future<Database> _openDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbFileName),
      onCreate: (db, version) {
        Batch batch = db.batch();
        batch.execute(createFavorites());
        batch.execute(createPeople());
        batch.execute(createCrew());
        batch.execute(createCast());

        //TODO process result
        batch.commit(noResult: true);
      },
      version: _dbVersion,
    );
  }
}
