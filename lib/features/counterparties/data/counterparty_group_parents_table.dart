import 'package:drift/drift.dart';
import 'counterparty_groups_table.dart';

class CounterpartyGroupParents extends Table {
  @ReferenceName('childLinks')
  IntColumn get childId => integer().references(CounterpartyGroups, #id)();

  @ReferenceName('parentLinks')
  IntColumn get parentId => integer().references(CounterpartyGroups, #id)();

  @override
  Set<Column> get primaryKey => {childId, parentId};
}
