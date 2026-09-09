import 'dart:convert';
import 'package:flutter/services.dart';

class CurrencyJsonItem {
  final String code;
  final int numCode;
  final String name;
  final String? symbol;
  final int nominal;
  final List<String> countries;

  CurrencyJsonItem({
    required this.code,
    required this.numCode,
    required this.name,
    this.symbol,
    required this.nominal,
    required this.countries,
  });

  factory CurrencyJsonItem.fromJson(Map<String, dynamic> json) {
    return CurrencyJsonItem(
      code: json['code'] as String,
      numCode: json['numCode'] as int,
      name: json['name'] as String,
      symbol: json['symbol'] as String?,
      nominal: json['nominal'] as int? ?? 1,
      countries: (json['countries'] as List<dynamic>? ?? []).cast<String>(),
    );
  }
}

Future<List<CurrencyJsonItem>> loadCurrenciesFromJson() async {
  final raw = await rootBundle.loadString('assets/currencies.json');
  final data = json.decode(raw) as List<dynamic>;
  return data.map((e) => CurrencyJsonItem.fromJson(e as Map<String, dynamic>)).toList();
}
