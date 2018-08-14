import 'package:flutter/material.dart';
import 'MaterialSearchBarResults.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:trie/trie.dart';

typedef void OnSubmit(String value);

class MaterialSearchBar extends StatefulWidget {
  Color searchBarTextColor,
      searchBarColor,
      searchResultsBackgroundColor,
      searchResultsTextColor;
  String searchBarFont, searchResultsFont;
  double searchBarFontSize, searchResultsFontSize;
  Icon checkmarkIcon;
  FloatingActionButton submitButton, clearButton;
  OnSubmit onSubmit;
  List<String> items;

  static const MethodChannel _channel = const MethodChannel('search_bar');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  _MaterialSearchBarState hP;
  @override
  _MaterialSearchBarState createState() => hP;

  MaterialSearchBar(
      {this.searchBarColor,
      this.searchBarTextColor,
      this.searchBarFontSize,
      this.searchBarFont,
      this.searchResultsBackgroundColor,
      this.searchResultsTextColor,
      this.searchResultsFontSize,
      this.searchResultsFont,
      this.submitButton,
      this.clearButton,
      this.checkmarkIcon,
      this.items,
      this.onSubmit}) {
    hP = _MaterialSearchBarState(
        this.searchBarColor,
        this.searchBarTextColor,
        this.searchBarFontSize,
        this.searchBarFont,
        this.searchResultsBackgroundColor,
        this.searchResultsTextColor,
        this.searchResultsFontSize,
        this.searchResultsFont,
        this.submitButton,
        this.clearButton,
        this.checkmarkIcon,
        this.items,
        this.onSubmit);
  }
}

class _MaterialSearchBarState extends State<MaterialSearchBar> {
  noSuchMethod(Invocation i) => super.noSuchMethod(i);

  Color searchBarTextColor,
      searchBarColor,
      searchResultsBackgroundColor,
      searchResultsTextColor;
  double searchBarFontSize, searchResultsFontSize;
  String searchBarFont, searchResultsFont;
  Icon checkmarkIcon;
  OnSubmit onSubmit;
  FloatingActionButton submitButton, clearButton;

  FocusNode _myFocusNode;

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed
    _myFocusNode.dispose();

    super.dispose();
  }

  double _lat, _lon;

  Set<String> _selectedItems;
  List<String> items;
  Trie _trie;
  Icon _rightIcon;
  TextEditingController _controller;
  _MaterialSearchBarState(
      this.searchBarColor,
      this.searchBarTextColor,
      this.searchBarFontSize,
      this.searchBarFont,
      this.searchResultsBackgroundColor,
      this.searchResultsTextColor,
      this.searchResultsFontSize,
      this.searchResultsFont,
      this.submitButton,
      this.clearButton,
      this.checkmarkIcon,
      this.items,
      this.onSubmit) {
    _controller = new TextEditingController();
    _myFocusNode = FocusNode();
    _selectedItems = Set();
    _rightIcon = new Icon(Icons.search);

    _trie = Trie.list(items);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hungry",
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: searchBarColor,
            title: Row(
              children: <Widget>[
                IconButton(
                  padding: EdgeInsets.only(right: 50.0),
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                Flexible(
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    focusNode: _myFocusNode,
                    style: TextStyle(
                      color: searchBarTextColor,
                      fontSize: searchBarFontSize,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search on Hungry',
                      hintStyle: TextStyle(
                        color: searchBarTextColor,
                        fontSize: searchBarFontSize,
                      ),
                    ),
                    onSubmitted: onSubmit,
                    onChanged: (text) {
                      setState(() {
                        items = _trie.getAllWordsWithPrefix(text);
                      });
                    },
                  ),
                )
              ],
            ),
            actions: _controller.text.length == 0
                ? [
                    new IconButton(
                        icon: new Icon(Icons.search),
                        onPressed: () {
                          if (MediaQuery.of(context).viewInsets.bottom == 0) {
                            //keyboard is not already up
                            setState(() {
                              FocusScope.of(context)
                                  .reparentIfNeeded(_myFocusNode);
                            });
                          }
                        })
                  ]
                : [
                    new IconButton(
                        icon: new Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _controller.clear();
                            items = _trie.getAllWords();
                          });
                        }),
                  ],
          ),
          floatingActionButton: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(bottom: 20.0, right: 22.0),
                  child: clearButton),
              submitButton
            ],
          ),
          body: Container(
              child: MaterialSearchBarResults(
                  items,
                  _selectedItems,
                  this,
                  searchResultsBackgroundColor,
                  searchResultsTextColor,
                  searchResultsFontSize,
                  checkmarkIcon))),
    );
  }
}
