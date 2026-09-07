import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/app_scaffold.dart';

void main() {
  runApp(const WalletApp());
}

class WalletApp extends StatelessWidget {
  const WalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Кошелёк',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const AppScaffold(),
    );
  }
}
