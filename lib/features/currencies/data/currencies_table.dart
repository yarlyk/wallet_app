import 'package:drift/drift.dart';

class Currencies extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text().withLength(min: 1, max: 8)();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get symbol => text().withLength(min: 0, max: 10).nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get numCode => integer().unique()();
  IntColumn get nominal => integer().withDefault(const Constant(1))();
  TextColumn get country => text().nullable()();
}
