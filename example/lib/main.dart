import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:search_bar/material_search_bar.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await MaterialSearchBar.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialSearchBar(
      searchBarColor: Colors.white,
      searchBarTextColor: Colors.black,
      searchBarFontSize: 20.0,
      searchResultsBackgroundColor: Colors.white,
      searchResultsTextColor: Colors.black,
      searchResultsFontSize: 20.0,
      checkmarkIcon: Icon(Icons.check, color: Colors.teal[400]),
      submitButton: FloatingActionButton(),
      clearButton: FloatingActionButton(),
      items: ['apple', 'banana'],
      onSubmit: (String value) => print('hi'),
    );
  }
}
