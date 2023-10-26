import 'package:flutter/material.dart';
import 'package:good_movie_fan/model/credit.dart';
import 'package:good_movie_fan/model/display_data/movie_display_data.dart';
import 'package:good_movie_fan/model/movie.dart';
import 'package:good_movie_fan/page/credit_list.dart';
import 'package:good_movie_fan/page/details.dart';
import 'package:good_movie_fan/page/movie_credit_list.dart';

class MovieDetails extends Details {
  MovieDetails(Movie movie)
      : super(
          displayData: MovieDisplayData(movie),
          fetchDetails: movie.fetchDetails(),
          fetchCredits: () => movie.fetchCredits(),
        );

  @override
  CreditsList creditListPage(CreditType creditType) {
    return MovieCreditsList(displayData, creditType, fetchCredits());
  }

  Color get pageColor => theme.scaffoldBackgroundColor;
  Color get widgetColor => theme.canvasColor;
}
