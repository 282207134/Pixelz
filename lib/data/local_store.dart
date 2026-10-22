import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// A versioned snapshot keeps the offline repository small and replaceable.
class LocalStore {
  LocalStore(this.preferences);
  final SharedPreferences preferences;
  static const key = 'pixelz.v1';
  static Future<LocalStore> open() async =>
      LocalStore(await SharedPreferences.getInstance());
  Map<String, dynamic> read() {
    try {
      return jsonDecode(preferences.getString(key) ?? '{}')
          as Map<String, dynamic>;
    } on FormatException {
      return {};
    } on TypeError {
      return {};
    }
  }

  Future<void> write(Map<String, dynamic> value) async {
    if (!await preferences.setString(key, jsonEncode(value))) {
      throw StateError('Could not save your changes. Please try again.');
    }
  }
}
