import 'package:flutter/services.dart';

/// Маска телефона +7 9xx xxx xx xx.
/// Принимает ввод цифр, а также 7, 8 или 9 в начале — нормализует к +7.
/// Возвращает строку формата "+7 XXX XXX XX XX" по мере ввода.
class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final raw = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Нормализуем начало: 8/7 -> 7.
    String digits = raw;
    if (digits.isNotEmpty && (digits[0] == '8' || digits[0] == '7')) {
      digits = digits.substring(1);
    }
    if (digits.length > 10) digits = digits.substring(0, 10);

    final buffer = StringBuffer('+7');
    if (digits.isNotEmpty) {
      buffer.write(' ');
      final p1 = digits.substring(0, digits.length >= 3 ? 3 : digits.length);
      buffer.write(p1);
      if (digits.length > 3) {
        buffer.write(' ');
        final p2 =
            digits.substring(3, digits.length >= 6 ? 6 : digits.length);
        buffer.write(p2);
      }
      if (digits.length > 6) {
        buffer.write(' ');
        final p3 =
            digits.substring(6, digits.length >= 8 ? 8 : digits.length);
        buffer.write(p3);
      }
      if (digits.length > 8) {
        buffer.write(' ');
        buffer.write(digits.substring(8));
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Простая проверка: телефон либо пустой, либо полный (+7 + 10 цифр).
bool isPhoneComplete(String text) {
  final digits = text.replaceAll(RegExp(r'\D'), '');
  return digits.length == 11;
}
