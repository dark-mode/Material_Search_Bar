import 'dart:async';

import 'package:flutter/services.dart';

class SearchBar {
  static const MethodChannel _channel = const MethodChannel('search_bar');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
