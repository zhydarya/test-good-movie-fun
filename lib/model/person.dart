import 'package:flutter/material.dart';
import 'package:good_movie_fan/model/credit.dart';
import 'package:good_movie_fan/model/display_data/person_display_data.dart';
import 'package:good_movie_fan/network/fetch_credits.dart';
import 'package:good_movie_fan/network/fetch_person.dart';

class PersonInnerState {
  final int searchId;
  final String name;
  final String profilePath;
  String birthday = '';
  String deathday = '';
  String birthplace = '';
  String biography = '';
  String imdbId = '';
  String homepage = '';
  String role = '';
  var images = const <String>[];
  final crew = <Credit>[];
  final cast = <Credit>[];

  PersonInnerState(this.searchId, String name, String profilePath, String role)
      : this.name = name ?? '',
        this.profilePath = profilePath ?? '',
        this.role = role ?? '';
}

class Person {
  static const keyId = 'id';
  static const keyName = 'name';
  static const keyProfilePath = 'profile_path';
  static const keyBirthday = 'birthday';
  static const keyDeathday = 'deathday';
  static const keyBirthplace = 'place_of_birth';
  static const keyBiography = 'biography';
  static const keyImdbId = 'imdb_id';
  static const keyHomepage = 'homepage';
  static const keyImagePath = 'file_path';

  final int id;
  final PersonInnerState _innerState;
  Future<void> _creditsFetched;
  Future<void> _detailsFetched;

  Person._internal(
      {@required this.id,
      String name = '',
      String profilePath = '',
      String role = ''})
      : assert(id != null),
        _innerState = PersonInnerState(id, name, profilePath, role);

  factory Person.fromMap(Map<String, dynamic> map, CreditType creditType) {
    return Person._internal(
        id: map[keyId],
        name: map[keyName],
        profilePath: map[keyProfilePath],
        role: map[Credit.roleForType(creditType)]);
  }

  Future<void> fetchDetails() async {
    //TODO process error result
    return _detailsFetched ??= fetchPersonDetails(this);
  }

  Future<void> fetchCredits() async {
    //TODO process error result
    return _creditsFetched ??= fetchPersonCredits(this);
  }

  void fillInDetails(Map<String, dynamic> map) {
    _innerState.birthday = map[keyBirthday] ?? '';
    _innerState.deathday = map[keyDeathday] ?? '';
    _innerState.birthplace = map[keyBirthplace] ?? '';
    _innerState.biography = map[keyBiography] ?? '';
    _innerState.imdbId = map[keyImdbId] ?? '';
    _innerState.homepage = map[keyHomepage] ?? '';
  }

  void fillInImages(List<Map<String, dynamic>> imagesParsed) {
    _innerState.images =
        imagesParsed.map((imageParsed) => imageParsed[keyImagePath]).toList();
  }

  void provideInnerStateTo(PersonDisplayData personDisplayData) {
    personDisplayData.personInnerState = _innerState;
  }

  void addCast(Credit cast) {
    _innerState.cast.add(cast);
  }

  void addCrew(Credit crew) {
    _innerState.crew.add(crew);
  }

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Person && other.id == id;

  @override
  String toString() {
    return 'Person {id: $id}';
  }
}
