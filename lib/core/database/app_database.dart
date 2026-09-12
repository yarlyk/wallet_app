import 'package:drift/drift.dart';
import '../../features/accounts/data/account_groups_table.dart';
import '../../features/accounts/data/account_projects_table.dart';
import '../../features/accounts/data/accounts_table.dart';
import '../../features/categories/data/categories_table.dart';
import '../../features/categories/data/category_parents_table.dart';
import '../../features/currencies/data/currencies_table.dart';
import '../../features/projects/data/projects_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Currencies,
  Projects,
  AccountGroups,
  Accounts,
  AccountProjects,
  Categories,
  CategoryParents,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          // Добавляем только новые таблицы, существующие данные сохраняем.
          if (from < 4) {
            await m.createTable(categories);
            await m.createTable(categoryParents);
          }
        },
      );
}
