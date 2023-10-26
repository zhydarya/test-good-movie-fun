import 'package:flutter/material.dart';
import 'package:good_movie_fan/model/credit.dart';
import 'package:good_movie_fan/model/display_data/person_display_data.dart';
import 'package:good_movie_fan/model/person.dart';
import 'package:good_movie_fan/page/credit_list.dart';
import 'package:good_movie_fan/page/details.dart';
import 'package:good_movie_fan/page/person_credit_list.dart';

class PersonDetails extends Details {
  PersonDetails(Person person)
      : super(
            displayData: PersonDisplayData(person),
            fetchDetails: person.fetchDetails(),
            fetchCredits: () => person.fetchCredits());

  @override
  CreditsList creditListPage(CreditType creditType) {
    return PersonCreditsList(displayData, creditType, fetchCredits());
  }

  Color get pageColor => theme.canvasColor;
  Color get widgetColor => theme.scaffoldBackgroundColor;
}
