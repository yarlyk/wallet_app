import 'package:flutter/material.dart';

/// Снимает фокус с текущего поля и убирает клавиатуру.
void dismissKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}
