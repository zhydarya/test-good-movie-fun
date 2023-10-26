import 'dart:io';
import 'package:flutter/material.dart';
import 'package:good_movie_fan/strings.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Webpage extends StatefulWidget {
  final String url;
  final String title;

  Webpage(this.url, this.title);

  @override
  WebpageState createState() => WebpageState();
}

class WebpageState extends State<Webpage> {
  bool _error = false;
  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _error
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  Strings.errorWebpage,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            )
          : WebView(
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebResourceError: (_) => setState(() => _error = true),
            ),
    );
  }
}
