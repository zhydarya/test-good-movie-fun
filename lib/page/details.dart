import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:good_movie_fan/model/credit.dart';
import 'package:good_movie_fan/model/display_data/display_data.dart';
import 'package:good_movie_fan/navigation/page_stack.dart';
import 'package:good_movie_fan/network/key_values.dart';
import 'package:good_movie_fan/page/credit_list.dart';
import 'package:good_movie_fan/page/videos.dart';
import 'package:good_movie_fan/page/webpage.dart';
import 'package:good_movie_fan/strings.dart';
import 'package:good_movie_fan/widget/navigation_drawer.dart';
import 'package:good_movie_fan/widget/progress_indicator.dart';
import 'package:provider/provider.dart';

abstract class Details extends StatelessWidget {
  static const _creditBtnSize = 70.0;
  static const _videoBtnConstraint = 200.0;

  @protected
  final DisplayData displayData;
  @protected
  final Future<void> Function() fetchCredits;
  final Future<void> _fetchDetails;
  Color _pageColor;
  Color _widgetColor;
  @protected
  ThemeData theme;

  Details(
      {@required this.displayData,
      @required Future<void> fetchDetails,
      @required this.fetchCredits})
      : assert(displayData != null),
        assert(fetchDetails != null),
        assert(fetchCredits != null),
        _fetchDetails = fetchDetails;

  Color get pageColor;
  Color get widgetColor;

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    _pageColor = pageColor;
    _widgetColor = widgetColor;

    return FutureBuilder<void>(
      future: _fetchDetails,
      builder: (context, futureResult) {
        if (futureResult.connectionState == ConnectionState.done) {
          return Scaffold(
            backgroundColor: _pageColor,
            appBar: _appBar(context),
            body: _body(context),
            persistentFooterButtons: _footerButtons(),
            drawer: NavigationDrawer(),
          );
        }
        if (futureResult.hasError) {
          //TODO process error
          return Container();
        }
        return Container(
          color: _pageColor,
          child: SplashProgressIndicator(_widgetColor),
        );
      },
    );
  }

  Widget _appBar(BuildContext context) {
    return AppBar(
      title: Text(displayData.title),
      actions: <Widget>[
        if (displayData.homepagePath.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.web),
            tooltip: Strings.homepage,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Webpage(displayData.homepagePath, displayData.title),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (displayData.header.isNotEmpty) _header(),
            const SizedBox(height: 10.0),
            _information(context),
            const SizedBox(height: 10.0),
            if (displayData.description.isNotEmpty)
              Expanded(child: _description(context)),
            const SizedBox(height: 10.0),
            SizedBox(height: _creditBtnSize, child: _credit(context)),
          ],
        ),
      ),
    );
  }

  List<Widget> _footerButtons() {
    return [
      IconButton(
        icon: const Icon(Icons.share),
        //TODO share
        onPressed: null,
      ),
      IconButton(
        icon: const Icon(Icons.star),
        //TODO create guest session for posting rate
        onPressed: null,
      ),
      IconButton(
        icon: const Icon(Icons.favorite_rounded),
        //TODO toggle favorite
        onPressed: null,
      ),
    ];
  }

  Widget _header() {
    return Text(
      displayData.header,
      style: theme.textTheme.subtitle2,
    );
  }

  Widget _information(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (displayData.avaPath.isNotEmpty)
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Material(
                elevation: 4.0,
                child: Image.network(Query.imageUrl + displayData.avaPath),
              ),
            ),
          ),
        Flexible(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) => _property(context,
                    propertyName: displayData.properties.keys.elementAt(index),
                    propertyValue:
                        displayData.properties.values.elementAt(index)),
                itemCount: displayData.properties.length,
              ),
              if (displayData.videos.isNotEmpty) _video(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _property(BuildContext context,
      {@required String propertyName, @required String propertyValue}) {
    Widget valueText = Text(
      propertyValue,
      style:
          TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(propertyName, style: theme.textTheme.bodyText1),
          Container(
            width: 80.0,
            child: SingleChildScrollView(child: valueText),
          ),
        ],
      ),
    );
  }

  Widget _description(BuildContext context) {
    return Card(
      shape: BeveledRectangleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Text(
            displayData.description,
          ),
        ),
      ),
    );
  }

  Widget _credit(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _creditContainer(Strings.cast, CreditType.cast, context),
        const SizedBox(width: 4.0),
        _creditContainer(Strings.crew, CreditType.crew, context),
      ],
    );
  }

  Widget _creditContainer(
      String title, CreditType creditType, BuildContext context) {
    return InkWell(
      onTap: () {
        var pageStack = context.read<PageStack>();
        pageStack.push(creditListPage(creditType),
            "${displayData.title} ${creditType.name}");
      },
      child: new Container(
        width: _creditBtnSize,
        height: _creditBtnSize,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: _widgetColor,
        ),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(fontSize: 10.0),
          ),
          subtitle: const Icon(Icons.people_alt_outlined),
        ),
      ),
    );
  }

  Widget _video(BuildContext context) {
    CloseContainerActionCallback videoCloseCallback;
    return Container(
      constraints:
          BoxConstraints.loose(Size(_videoBtnConstraint, _videoBtnConstraint)),
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            childAspectRatio: 2.0 / 1.0,
          ),
          itemCount: displayData.videos.length,
          itemBuilder: (_, index) => Padding(
            padding: const EdgeInsets.all(1.0),
            child: OpenContainer(
              openBuilder: (context, closeContainer) {
                videoCloseCallback = closeContainer;
                return Videos(
                  displayData.videos.values.elementAt(index),
                  displayData.videos.keys.elementAt(index),
                );
              },
              closedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(15.0),
                  right: Radius.circular(40.0),
                ),
              ),
              closedColor: theme.buttonColor,
              closedBuilder: (context, openContainer) {
                return Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: InkWell(
                    onTap: () {
                      context
                          .read<PageStack>()
                          .onPushedToNavigator(videoCloseCallback);
                      openContainer();
                    },
                    child: GridTile(
                      child: Text(
                        displayData.videos.keys.elementAt(index),
                        style: const TextStyle(fontSize: 10.0),
                      ),
                      footer: const Icon(Icons.videocam),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  CreditsList creditListPage(CreditType creditType);
}
