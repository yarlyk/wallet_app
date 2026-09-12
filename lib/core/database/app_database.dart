import 'package:drift/drift.dart';
import '../../features/accounts/data/account_groups_table.dart';
import '../../features/accounts/data/account_projects_table.dart';
import '../../features/accounts/data/accounts_table.dart';
import '../../features/currencies/data/currencies_table.dart';
import '../../features/projects/data/projects_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Currencies, Projects, AccountGroups, Accounts, AccountProjects])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 3;
}
