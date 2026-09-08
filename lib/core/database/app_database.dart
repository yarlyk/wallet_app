import 'package:drift/drift.dart';
import '../../features/currencies/data/currencies_table.dart';
import '../../features/projects/data/projects_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Currencies, Projects])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;
}
