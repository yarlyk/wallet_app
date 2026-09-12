import 'package:drift/drift.dart';
import '../../currencies/data/currencies_table.dart';
import 'account_groups_table.dart';

class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get groupId => integer().nullable().references(AccountGroups, #id)();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get icon => text().nullable()();
  TextColumn get type => text().withLength(min: 1, max: 20)(); // cash, card, bank, crypto, stocks
  IntColumn get currencyId => integer().references(Currencies, #id)();
  RealColumn get initialBalance => real().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isCreditCard => boolean().withDefault(const Constant(false))();
  RealColumn get creditLimit => real().nullable()();
  TextColumn get paymentDueDate => text().nullable()(); // ISO-8601
  IntColumn get gracePeriodDays => integer().nullable()();
  TextColumn get cardLast4Digits => text().nullable()();
  TextColumn get accountLast4Digits => text().nullable()();
  TextColumn get smsSenderName => text().nullable()();
}
