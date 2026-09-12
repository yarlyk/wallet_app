import 'package:drift/drift.dart';
import '../../projects/data/projects_table.dart';
import 'accounts_table.dart';

class AccountProjects extends Table {
  IntColumn get accountId => integer().references(Accounts, #id)();
  IntColumn get projectId => integer().references(Projects, #id)();

  @override
  Set<Column> get primaryKey => {accountId, projectId};
}
