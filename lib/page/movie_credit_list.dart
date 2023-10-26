import 'package:flutter/material.dart';
import 'package:good_movie_fan/model/credit.dart';
import 'package:good_movie_fan/model/display_data/display_data.dart';
import 'package:good_movie_fan/model/display_data/person_display_data.dart';
import 'package:good_movie_fan/page/credit_list.dart';
import 'package:good_movie_fan/page/details.dart';
import 'package:good_movie_fan/page/person_details.dart';

class MovieCreditsList extends CreditsList {
  MovieCreditsList(DisplayData movieDisplayData, CreditType creditType,
      Future<void> fetchCreditsFuture)
      : super(movieDisplayData, creditType, fetchCreditsFuture);

  Color get pageColor => theme.canvasColor;
  Color get widgetColor => theme.scaffoldBackgroundColor;

  @override
  Details detailsPage(Credit credit) {
    return PersonDetails(credit.person);
  }

  @override
  DisplayData detailsPageDisplayData(Credit credit) {
    return PersonDisplayData(credit.person);
  }
}
