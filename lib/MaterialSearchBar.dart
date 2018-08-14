import 'package:flutter/material.dart';
import 'MaterialSearchBarResults.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:trie/trie.dart';
typedef void OnTap(String value);

class MaterialSearchBar extends StatefulWidget {

  Color _searchBarTextColor, _searchBarColor, _searchResultsBackgroundColor, _searchResultsTextColor;
  String _searchBarFont, _searchResultsFont;
  double _searchBarFontSize, _searchResultsFontSize;
  Icon _searchIcon;
  FloatingActionButton _submitButton, _clearButton;

  static const MethodChannel _channel =
  const MethodChannel('search_bar');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  _MaterialSearchBarState hP;
  @override
  _MaterialSearchBarState createState() => hP;

  MaterialSearchBar(
      this._searchBarColor,
      this._searchBarTextColor,
      this._searchBarFontSize,
      this._searchBarFont,
      this._searchIcon,
      this._searchResultsBackgroundColor,
      this._searchResultsTextColor,
      this._searchResultsFontSize,
      this._searchResultsFont,
      this._submitButton,
      this._clearButton,
      ) {
    hP = _MaterialSearchBarState(
              this._searchBarColor,
              this._searchBarTextColor,
              this._searchBarFontSize,
              this._searchBarFont,
              this._searchIcon,
              this._searchResultsBackgroundColor,
              this._searchResultsTextColor,
              this._searchResultsFontSize,
              this._searchResultsFont,
              this._submitButton,
              this._clearButton,
            );
  }

}

class _MaterialSearchBarState extends State<MaterialSearchBar> {
  noSuchMethod(Invocation i) => super.noSuchMethod(i);

  Color _searchBarTextColor, _searchBarColor, _searchResultsBackgroundColor, _searchResultsTextColor;
  double _searchBarFontSize, _searchResultsFontSize;
  String _searchBarFont, _searchResultsFont;
  Icon _searchIcon;
  FloatingActionButton _submitButton, _clearButton;

  FocusNode _myFocusNode;

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed
    _myFocusNode.dispose();

    super.dispose();
  }

  double _lat, _lon;

  Set<String> _selectedItems;
  List<String> _items;
  Trie _trie;
  Icon _rightIcon;
  TextEditingController _controller;
  _MaterialSearchBarState(
      this._searchBarColor,
      this._searchBarTextColor,
      this._searchBarFontSize,
      this._searchBarFont,
      this._searchIcon,
      this._searchResultsBackgroundColor,
      this._searchResultsTextColor,
      this._searchResultsFontSize,
      this._searchResultsFont,
      this._submitButton,
      this._clearButton,
      ) {
    _controller = new TextEditingController();
    _myFocusNode = FocusNode();
    _selectedItems = Set();
    _rightIcon = new Icon(Icons.search);

    _trie = Trie.list(_items);
  }

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    double scaleFactor =
        MediaQuery.of(context).textScaleFactor / 2.5;

    Icon _rightIcon;

    if (_items.length < 396) { //! oiriginal length!!!
      _rightIcon = new Icon(Icons.clear);
      print("change " + _items.length.toString());
    } else {
      _rightIcon = new Icon(Icons.search);
    }

    return MaterialApp(
      title: "Hungry",
      home: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
            backgroundColor: Theme
                .of(context)
                .primaryColor,
            title: Row(
              children: <Widget>[
              IconButton(
                padding: EdgeInsets.only(right: 50.0 * scaleFactor),
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
              ),
              Flexible(
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  focusNode: _myFocusNode,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 60.0 * scaleFactor,
                      fontFamily: 'Eczar'
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search on Hungry',
                    hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 60.0 * scaleFactor,
                        fontFamily: 'Eczar'
                    ),
                  ),
                  onSubmitted: (text) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResultsPage.items(_lat, _lon, _selectedItems, _user)),
                    );
                  },
                  onChanged: (text) {
                    setState(() {
                      _items = _trie.getAllWordsWithPrefix(text);
                    });
                  },
                ),
              )
              ],
            ),
            actions: _controller.text.length == 0 ? [
              new IconButton(
                  icon: new Icon(Icons.search),
                  onPressed: () {
                    if (MediaQuery.of(context).viewInsets.bottom == 0) {//keyboard is not already up
                      setState(() {
                        FocusScope.of(context).reparentIfNeeded(_myFocusNode);
                      });
                    }
                  }
              )
            ] : [
            new IconButton(
            icon: new Icon(Icons.clear),
          onPressed: () {
            setState(() {
              _controller.clear();
              _items = _trie.getAllWords();
            });
          }
      ),
      ],
        ),
        floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 20.0 * scaleFactor, right: 22.0 * scaleFactor),
              child: FloatingActionButton(
                tooltip: "Clear All",
                backgroundColor: Colors.red,
                mini: true,
                heroTag: null,
                child: Icon(Icons.clear,color: Colors.white,),
                onPressed: (){
                  setState(() {
                    _controller.clear();
                    _items = _trie.getAllWords();
                    _selectedItems = Set<String>();
                  });
                },
              ),
            ),
            FloatingActionButton(
                heroTag: null,
                tooltip: "Search",
                child: new Icon(Icons.arrow_forward),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                onPressed: (),
          ],
        ),
        body: Container(child: MaterialSearchResults(_items, _selectedItems, this))
      ),
    );
  }
}
