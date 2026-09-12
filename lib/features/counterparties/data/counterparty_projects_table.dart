import 'package:drift/drift.dart';
import '../../projects/data/projects_table.dart';
import 'counterparties_table.dart';

class CounterpartyProjects extends Table {
  IntColumn get counterpartyId =>
      integer().references(Counterparties, #id)();
  IntColumn get projectId => integer().references(Projects, #id)();

  @override
  Set<Column> get primaryKey => {counterpartyId, projectId};
}
