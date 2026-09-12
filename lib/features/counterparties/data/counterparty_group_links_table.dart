import 'package:drift/drift.dart';
import 'counterparties_table.dart';
import 'counterparty_groups_table.dart';

class CounterpartyGroupLinks extends Table {
  IntColumn get counterpartyId =>
      integer().references(Counterparties, #id)();
  IntColumn get groupId => integer().references(CounterpartyGroups, #id)();

  @override
  Set<Column> get primaryKey => {counterpartyId, groupId};
}
