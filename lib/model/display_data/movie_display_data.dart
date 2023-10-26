import 'package:good_movie_fan/model/credit.dart';
import 'package:good_movie_fan/model/display_data/display_data.dart';
import 'package:good_movie_fan/model/movie.dart';
import 'package:good_movie_fan/strings.dart';
import 'package:intl/intl.dart';

class MovieDisplayData implements DisplayData {
  static final _voteFormatter = NumberFormat("##.0#");

  MovieInnerState _movieInnerState;

  MovieDisplayData(Movie movie) {
    assert(movie != null); //TODO null safety...
    movie.provideInnerStateTo(this);
  }

  set movieInnerState(MovieInnerState movieInnerState) =>
      _movieInnerState ??= movieInnerState;

  @override
  String get title => _movieInnerState.title;

  @override
  String get header => _movieInnerState.genres?.join(', ') ?? '';

  @override
  String get avaPath => _movieInnerState.posterPath;

  @override
  String get homepagePath => _movieInnerState.homepage;

  @override
  Map<String, String> get properties => {
        if (_movieInnerState.releaseDate.isNotEmpty)
          Strings.releaseDate: _movieInnerState.releaseDate,
        if (_movieInnerState.productionCountries.isNotEmpty)
          Strings.productionCountries:
              _movieInnerState.productionCountries.join(', '),
        if (_movieInnerState.duration > 0)
          Strings.duration:
              "${_movieInnerState.duration.toString()} ${Strings.mins}",
        if (_movieInnerState.imdbId.isNotEmpty)
          Strings.imdbId: _movieInnerState.imdbId,
        Strings.voteAverage: _movieInnerState.voteAverage == 0
            ? '?'
            : _voteFormatter.format(_movieInnerState.voteAverage),
      };

  @override
  String get description => _movieInnerState.overview;

  @override
  List<Credit> get cast => _movieInnerState.cast;

  @override
  List<Credit> get crew => _movieInnerState.crew;

  @override
  Map<String, List<String>> get videos => _movieInnerState.videos;
}
