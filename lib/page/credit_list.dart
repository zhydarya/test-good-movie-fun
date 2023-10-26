import 'package:flutter/material.dart';
import 'package:good_movie_fan/model/credit.dart';
import 'package:good_movie_fan/model/display_data/display_data.dart';
import 'package:good_movie_fan/navigation/page_stack.dart';
import 'package:good_movie_fan/network/key_values.dart';
import 'package:good_movie_fan/page/details.dart';
import 'package:good_movie_fan/widget/navigation_drawer.dart';
import 'package:good_movie_fan/widget/progress_indicator.dart';
import 'package:provider/provider.dart';

abstract class CreditsList extends StatelessWidget {
  final DisplayData _displayData;
  final CreditType _creditType;
  final Future<void> _fetchCreditsFuture;
  Color _pageColor;
  Color _widgetColor;
  @protected
  ThemeData theme;

  CreditsList(
    DisplayData displayData,
    CreditType creditType,
    Future<void> fetchCreditsFuture,
  )   : assert(displayData != null),
        assert(creditType != null),
        assert(fetchCreditsFuture != null),
        _displayData = displayData,
        _creditType = creditType,
        _fetchCreditsFuture = fetchCreditsFuture;

  Color get pageColor;
  Color get widgetColor;

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    _pageColor = pageColor;
    _widgetColor = widgetColor;

    return Scaffold(
      backgroundColor: _pageColor,
      appBar: AppBar(
        title: Text(_displayData.title),
      ),
      body: FutureBuilder<void>(
        future: _fetchCreditsFuture,
        builder: (context, futureResult) {
          if (futureResult.connectionState == ConnectionState.done) {
            var credits = _creditsForType(_creditType, _displayData);

            return ListView.builder(
              itemCount: credits.length,
              itemBuilder: (context, index) {
                var credit = credits[index];
                var creditDisplayData = detailsPageDisplayData(credit);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: InkWell(
                    onTap: () {
                      var pageStack = context.read<PageStack>();
                      pageStack.push(
                          detailsPage(credit), creditDisplayData.title);
                    },
                    child: ListTile(
                      leading: Image.network(
                          Query.imageUrl + creditDisplayData.avaPath),
                      title: Text(creditDisplayData.title),
                      trailing: Text(credit.role),
                    ),
                  ),
                );
              },
            );
          }
          if (futureResult.hasError) {
            //TODO process error
            return Container();
          }
          return SplashProgressIndicator(_widgetColor);
        },
      ),
      drawer: NavigationDrawer(),
    );
  }

  Details detailsPage(Credit credit);
  DisplayData detailsPageDisplayData(Credit credit);

  List<Credit> _creditsForType(CreditType creditType, DisplayData displayData) {
    switch (creditType) {
      case CreditType.cast:
        return displayData.cast;
      case CreditType.crew:
        return displayData.crew;
    }
    assert(false, "Unknown credit type!");
  }
}
