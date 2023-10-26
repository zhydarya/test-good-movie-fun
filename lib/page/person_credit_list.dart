import 'package:flutter/material.dart';
import 'package:good_movie_fan/model/credit.dart';
import 'package:good_movie_fan/model/display_data/display_data.dart';
import 'package:good_movie_fan/model/display_data/movie_display_data.dart';
import 'package:good_movie_fan/page/credit_list.dart';
import 'package:good_movie_fan/page/details.dart';
import 'package:good_movie_fan/page/movie_details.dart';

class PersonCreditsList extends CreditsList {
  PersonCreditsList(DisplayData displayData, CreditType creditType,
      Future<void> fetchCreditsFuture)
      : super(displayData, creditType, fetchCreditsFuture);

  Color get pageColor => theme.scaffoldBackgroundColor;
  Color get widgetColor => theme.canvasColor;

  @override
  Details detailsPage(Credit credit) {
    return MovieDetails(credit.movie);
  }

  @override
  DisplayData detailsPageDisplayData(Credit credit) {
    return MovieDisplayData(credit.movie);
  }
}
