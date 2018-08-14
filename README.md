# Search_Bar
A materialistic and feature packed search bar with a [Trie implementation][trie] for efficient autocorrect. Made by Christopher Gong and Ankush Vangari.

[trie]: https://github.com/dark-mode/Trie

## Usage

A simple usage example:

    import 'package:search_bar/MaterialSearchBar.dart';

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
        items: ['item one', 'item two'],
        onSubmit: (String value) => print('submitted'),
      );

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/dark-mode/Search_Bar/issues
