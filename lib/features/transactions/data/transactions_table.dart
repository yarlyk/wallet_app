import 'package:drift/drift.dart';
import '../../accounts/data/accounts_table.dart';
import '../../categories/data/categories_table.dart';
import '../../counterparties/data/counterparties_table.dart';
import '../../projects/data/projects_table.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text().withLength(min: 1, max: 20)(); // expense | income | transfer
  RealColumn get amount => real()();

  @ReferenceName('transactionsFromAccount')
  IntColumn get accountId => integer().references(Accounts, #id)();

  @ReferenceName('transactionsToAccount')
  IntColumn get toAccountId =>
      integer().nullable().references(Accounts, #id)();

  IntColumn get categoryId =>
      integer().nullable().references(Categories, #id)();
  IntColumn get projectId =>
      integer().nullable().references(Projects, #id)();
  IntColumn get counterpartyId =>
      integer().nullable().references(Counterparties, #id)();
  TextColumn get comment => text().nullable()();

  DateTimeColumn get occurredAt => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  RealColumn get rate => real().nullable()();
  RealColumn get toAmount => real().nullable()();
  RealColumn get cbrRate => real().nullable()();
  BoolColumn get isDraft => boolean().withDefault(const Constant(true))();
}
