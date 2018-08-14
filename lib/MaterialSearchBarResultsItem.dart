import 'package:flutter/material.dart';

/// Creates one restaurant card
class MaterialSearchResultsItem extends Column {
  Set<String> _selectedItems;
  Icon _checkmark;
  State _state;
  Color _searchResultsBackgroundColor;
  Color _searchResultsTextColor;
  double _searchResultsFontSize;
  MaterialSearchResultsItem(
      String item, double scaleFactor, BuildContext context, this._selectedItems, this._checkmark, this._state, this._searchResultsBackgroundColor, this._searchResultsTextColor, this._searchResultsFontSize) :
              super(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: _searchResultsBackgroundColor
                    ),
                    child: ListTile(
                        trailing: _checkmark,
                        dense: true,
                        onTap: () {
                          if (_selectedItems.contains(item)) {
                            _selectedItems.remove(item);
                          } else {
                            _selectedItems.add(item);
                          }
                          bool dead;
                          _state.setState(() => dead = true);
                        },
                        onLongPress: () => print(item),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 0.0 * scaleFactor,
                        horizontal: 40.0 * scaleFactor),
                    title: new Text(item,
                        textAlign: TextAlign.left,
                        style: new TextStyle(
                          color: _searchResultsTextColor,
                          fontSize: _searchResultsFontSize,
                        )),
                    )
                  ),
                ],
              );
}

