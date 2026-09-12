import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final formatted = formatPhoneRu(newValue.text);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Приводит любой ввод к формату "+7 XXX XXX XX XX".
String formatPhoneRu(String input) {
  var digits = input.replaceAll(RegExp(r'\D'), '');
  if (digits.isNotEmpty && (digits[0] == '8' || digits[0] == '7')) {
    digits = digits.substring(1);
  }
  if (digits.length > 10) digits = digits.substring(0, 10);

  final buffer = StringBuffer('+7');
  if (digits.isNotEmpty) {
    buffer.write(' ');
    buffer.write(digits.substring(0, digits.length >= 3 ? 3 : digits.length));
    if (digits.length > 3) {
      buffer.write(' ');
      buffer.write(digits.substring(3, digits.length >= 6 ? 6 : digits.length));
    }
    if (digits.length > 6) {
      buffer.write(' ');
      buffer.write(digits.substring(6, digits.length >= 8 ? 8 : digits.length));
    }
    if (digits.length > 8) {
      buffer.write(' ');
      buffer.write(digits.substring(8));
    }
  }
  return buffer.toString();
}

/// Простая проверка: телефон либо пустой, либо полный (+7 + 10 цифр).
bool isPhoneComplete(String text) {
  final digits = text.replaceAll(RegExp(r'\D'), '');
  return digits.length == 11;
}
