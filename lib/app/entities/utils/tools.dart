import 'dart:convert' show json;

import 'package:flutter/material.dart' show Image, FlutterError;
import 'package:flutter/services.dart' show rootBundle;

class Tools {
  static _CountryEmoji countryEmoji = _CountryEmoji();
}

class _CountryEmoji {
  static List<Map<String, dynamic>> _list;

  Image countryCodeToEmoji(String countryCode,
      [double width = 25, double height = 25]) {
    try {
      return Image.asset(
        'images/countries/${countryCode.toLowerCase()}.png',
        width: width,
        height: height,
      );
    } on FlutterError {
      return Image.asset('images/countries/aq.png',
          width: width, height: height);
    }
  }

  Future<List<Map<String, dynamic>>> getAllCountries() async {
    if (_CountryEmoji._list == null || _CountryEmoji._list.isEmpty) {
      var m = await rootBundle.loadString("config/countries.json", cache: true);
      _CountryEmoji._list = List<Map<String, dynamic>>.from(json.decode(m));
    }
    return _CountryEmoji._list;
  }

  Future<Map<String, dynamic>> getCountryByFullPhone(
      String initialPhone) async {
    if (_CountryEmoji._list?.isEmpty ?? true) await getAllCountries();
    Map<String, dynamic> c = _CountryEmoji._list.firstWhere(
        (country) => initialPhone.startsWith(country['dial']),
        orElse: () => null);
    return c != null ? c : null;
  }
}
