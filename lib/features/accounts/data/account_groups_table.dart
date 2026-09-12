import 'package:drift/drift.dart';

class AccountGroups extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get icon => text().nullable()();
  IntColumn get parentId => integer().nullable().references(AccountGroups, #id)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
