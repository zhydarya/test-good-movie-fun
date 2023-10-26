import 'package:good_movie_fan/model/credit.dart';
import 'package:good_movie_fan/model/display_data/display_data.dart';
import 'package:good_movie_fan/model/person.dart';
import 'package:good_movie_fan/strings.dart';

class PersonDisplayData implements DisplayData {
  PersonInnerState _personInnerState;

  PersonDisplayData(Person person) {
    assert(person != null); //TODO null safety...
    person.provideInnerStateTo(this);
  }

  set personInnerState(PersonInnerState personInnerState) =>
      _personInnerState ??= personInnerState;

  @override
  String get title => _personInnerState.name;

  @override
  String get header => '';

  @override
  String get avaPath => _personInnerState.profilePath;

  @override
  String get homepagePath => _personInnerState.homepage;

  @override
  Map<String, String> get properties => {
        if (_personInnerState.birthday.isNotEmpty)
          Strings.birthday: _personInnerState.birthday,
        if (_personInnerState.deathday.isNotEmpty)
          Strings.deathday: _personInnerState.deathday,
        if (_personInnerState.birthplace.isNotEmpty)
          Strings.birthplace: _personInnerState.birthplace,
        if (_personInnerState.imdbId.isNotEmpty)
          Strings.imdbId: _personInnerState.imdbId,
        Strings.searchId: _personInnerState.searchId.toString(),
      };

  @override
  String get description => _personInnerState.biography;

  @override
  List<Credit> get cast => _personInnerState.cast;

  @override
  List<Credit> get crew => _personInnerState.crew;

  @override
  Map<String, List<String>> get videos => const {};
}
