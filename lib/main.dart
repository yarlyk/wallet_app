import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'core/theme/app_theme.dart';
import 'core/widgets/app_scaffold.dart';
import 'core/database/app_database.dart';
import 'core/database/database_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbDir = await getApplicationDocumentsDirectory();
  final dbFile = p.join(dbDir.path, 'wallet_app.sqlite');
  final db = AppDatabase(NativeDatabase(File(dbFile)));
  runApp(ProviderScope(
    overrides: [appDatabaseProvider.overrideWithValue(db)],
    child: const WalletApp(),
  ));
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
