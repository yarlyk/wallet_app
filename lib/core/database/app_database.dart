import 'package:drift/drift.dart';
import '../../features/accounts/data/account_groups_table.dart';
import '../../features/accounts/data/account_projects_table.dart';
import '../../features/accounts/data/accounts_table.dart';
import '../../features/categories/data/categories_table.dart';
import '../../features/categories/data/category_parents_table.dart';
import '../../features/counterparties/data/counterparties_table.dart';
import '../../features/counterparties/data/counterparty_group_links_table.dart';
import '../../features/counterparties/data/counterparty_group_parents_table.dart';
import '../../features/counterparties/data/counterparty_groups_table.dart';
import '../../features/counterparties/data/counterparty_projects_table.dart';
import '../../features/currencies/data/currencies_table.dart';
import '../../features/projects/data/projects_table.dart';
import '../../features/transactions/data/transactions_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Currencies,
  Projects,
  AccountGroups,
  Accounts,
  AccountProjects,
  Categories,
  CategoryParents,
  Counterparties,
  CounterpartyGroups,
  CounterpartyGroupParents,
  CounterpartyGroupLinks,
  CounterpartyProjects,
  Transactions,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 4) {
            await m.createTable(categories);
            await m.createTable(categoryParents);
          }
          if (from < 5) {
            await m.createTable(counterparties);
            await m.createTable(counterpartyGroups);
            await m.createTable(counterpartyGroupParents);
            await m.createTable(counterpartyGroupLinks);
            await m.createTable(counterpartyProjects);
          }
          if (from < 6) {
            await m.createTable(transactions);
          }
          if (from < 7) {
            await m.addColumn(transactions, transactions.counterpartyId);
          }
          if (from < 8) {
            // Делаем projectId nullable — пересоздаём таблицу.
            await m.deleteTable('transactions');
            await m.createTable(transactions);
          }
        },
      );
}
