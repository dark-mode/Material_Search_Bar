import 'package:flutter/material.dart';
import 'material_search_bar_results.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:trie/trie.dart';
typedef void OnSubmit();
typedef void OnButtonSubmit(String value);

class MaterialSearchBar extends StatefulWidget {

  Color searchBarTextColor, searchBarColor, searchResultsBackgroundColor, searchResultsTextColor;
  String searchBarFont, searchResultsFont;
  double searchBarFontSize, searchResultsFontSize;
  Icon checkmarkIcon;
  FloatingActionButton submitButton, clearButton;
  OnSubmit onSubmit;
  OnButtonSubmit onButtonSubmit;
  List<String> items;


  static const MethodChannel _channel =
  const MethodChannel('search_bar');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  _MaterialSearchBarState hP;
  @override
  _MaterialSearchBarState createState() => hP;

  MaterialSearchBar({
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
    this.onSubmit,
    this.onButtonSubmit
  })
  {
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
        this.onSubmit,
        this.onButtonSubmit
    );

  }
  @override
  void changeOnSubmit(OnSubmit onSubmit) {
    hP.changeOnSubmit(onSubmit);
  }
  void changeOnButtonSubmit(OnButtonSubmit onButtonSubmit) {
    hP.changeOnButtonSubmit(onButtonSubmit);
  }
  get selectedItems => hP.selectedItems;

}

class _MaterialSearchBarState extends State<MaterialSearchBar> {
  noSuchMethod(Invocation i) => super.noSuchMethod(i);

  Color searchBarTextColor, searchBarColor, searchResultsBackgroundColor, searchResultsTextColor;
  double searchBarFontSize, searchResultsFontSize;
  String searchBarFont, searchResultsFont;
  Icon checkmarkIcon;
  OnSubmit onSubmit;
  OnButtonSubmit onButtonSubmit;
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
  get selectedItems => _selectedItems;
  void changeOnSubmit(OnSubmit onSubmit) {
    this.onSubmit = onSubmit;
  }
  void changeOnButtonSubmit(OnButtonSubmit onButtonSubmit) {
    this.onButtonSubmit = onButtonSubmit;
  }
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
      this.onSubmit,
      this.onButtonSubmit
      ) {
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

//    double scaleFactor =
//        MediaQuery.of(context).textScaleFactor / 2.5;

    Icon _rightIcon;

    if (items != null && items.length < 396) { //! oiriginal length!!!
      _rightIcon = Icon(Icons.clear);
      print("change " + items.length.toString());
    } else {
      _rightIcon = Icon(Icons.search);
    }

    return MaterialApp(
      title: "Hungry",
      home: Scaffold(
        //backgroundColor: Theme.of(context).backgroundColor,
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
                      //fontFamily: 'Eczar'
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search on Hungry',
                      hintStyle: TextStyle(
                        color: searchBarTextColor,
                        fontSize: searchBarFontSize,
                        //fontFamily: 'Eczar'
                      ),
                    ),
                    onSubmitted: onButtonSubmit,
                    onChanged: (text) {
                      setState(() {
                        items = _trie.getAllWordsWithPrefix(text);
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
                      items = _trie.getAllWords();
                    });
                  }
              ),
            ],
          ),
          floatingActionButton: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget> [
                    Container(
                        padding: EdgeInsets.only(bottom: searchBarFontSize * 0.6),
                        child: FloatingActionButton(
                          tooltip: "Clear All",
                          backgroundColor: Colors.red,
                          mini: true,
                          heroTag: null,
                          child: Icon(Icons.clear,color: Colors.white,),
                          onPressed: (){
                            setState(() {
                              _controller.clear();
                              items = _trie.getAllWords();
                              _selectedItems = Set<String>();
                            });
                          },
                        )),
                    FloatingActionButton(
                      heroTag: null,
                      tooltip: "Search",
                      child: new Icon(Icons.arrow_forward),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      onPressed: onSubmit,
                    )]
              ),
            ],
          ),
          body: Container(child: MaterialSearchBarResults(items, _selectedItems, this, searchResultsBackgroundColor, searchResultsTextColor, searchResultsFontSize, checkmarkIcon
          ))
      ),
    );
  }
}
