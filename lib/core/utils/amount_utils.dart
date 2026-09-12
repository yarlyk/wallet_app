import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

final _amountFormatter = NumberFormat('#,##0.00', 'ru');

/// Форматирует число в строку с разделителями разрядов и двумя знаками
/// после запятой. Пример: 1234.5 -> "1 234,50".
String formatAmount(double value) {
  return _amountFormatter.format(value).replaceAll('\u00A0', ' ');
}

/// Парсит строку, введённую пользователем, в double. Понимает пробелы,
/// неразрывные пробелы, запятую и точку в качестве десятичного разделителя.
double parseAmount(String text) {
  if (text.isEmpty) return 0;
  final cleaned = text
      .replaceAll(' ', '')
      .replaceAll('\u00A0', '')
      .replaceAll(',', '.');
  return double.tryParse(cleaned) ?? 0;
}

/// TextInputFormatter: разрешает ввод цифр, одного десятичного разделителя
/// (точка или запятая), не более двух знаков после него; автоматически
/// расставляет пробелы между разрядами целой части.
class AmountInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final raw = newValue.text;
    if (raw.isEmpty) return newValue;

    // Убираем пробелы (обычные и неразрывные), оставляем цифры, точку и запятую.
    final noSpaces = raw.replaceAll(' ', '').replaceAll('\u00A0', '');
    final firstDot = noSpaces.indexOf('.');
    final firstComma = noSpaces.indexOf(',');

    String intPart;
    String decPart;
    bool hasSeparator = false;

    if (firstDot != -1) {
      hasSeparator = true;
      intPart = noSpaces.substring(0, firstDot);
      decPart = noSpaces.substring(firstDot + 1);
    } else if (firstComma != -1) {
      hasSeparator = true;
      intPart = noSpaces.substring(0, firstComma);
      decPart = noSpaces.substring(firstComma + 1);
    } else {
      intPart = noSpaces;
      decPart = '';
    }

    intPart = intPart.replaceAll(RegExp(r'\D'), '');
    decPart = decPart.replaceAll(RegExp(r'\D'), '');

    if (intPart.length > 15) intPart = intPart.substring(0, 15);
    if (decPart.length > 2) decPart = decPart.substring(0, 2);

    final buffer = StringBuffer();
    for (int i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) buffer.write(' ');
      buffer.write(intPart[i]);
    }

    String formatted = buffer.toString();
    if (hasSeparator) {
      formatted = '$formatted,$decPart';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
