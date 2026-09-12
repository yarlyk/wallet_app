import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';

class CounterpartyWithGroups {
  final Counterparty counterparty;
  final List<int> groupIds;
  CounterpartyWithGroups(this.counterparty, this.groupIds);
}

class CounterpartyRepository {
  CounterpartyRepository(this._db);
  final AppDatabase _db;

  // Контрагенты
  Stream<List<Counterparty>> watchActiveCounterparties() {
    return (_db.select(_db.counterparties)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<int> addCounterparty(CounterpartiesCompanion entry) =>
      _db.into(_db.counterparties).insert(entry);

  Future<void> updateCounterparty(int id, CounterpartiesCompanion entry) =>
      (_db.update(_db.counterparties)..where((t) => t.id.equals(id))).write(entry);

  Future<void> deleteCounterparty(int id) =>
      (_db.update(_db.counterparties)..where((t) => t.id.equals(id)))
          .write(const CounterpartiesCompanion(isActive: Value(false)));

  // Группы
  Stream<List<CounterpartyGroup>> watchActiveGroups() {
    return (_db.select(_db.counterpartyGroups)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<int> addGroup(CounterpartyGroupsCompanion entry) =>
      _db.into(_db.counterpartyGroups).insert(entry);

  Future<void> updateGroup(int id, CounterpartyGroupsCompanion entry) =>
      (_db.update(_db.counterpartyGroups)..where((t) => t.id.equals(id)))
          .write(entry);

  Future<void> deleteGroup(int id) =>
      (_db.update(_db.counterpartyGroups)..where((t) => t.id.equals(id)))
          .write(const CounterpartyGroupsCompanion(isActive: Value(false)));

  Future<List<int>> getParentIdsForGroup(int groupId) async {
    final rows = await (_db.select(_db.counterpartyGroupParents)
          ..where((t) => t.childId.equals(groupId)))
        .get();
    return rows.map((r) => r.parentId).toList();
  }

  Future<void> setParentIdsForGroup(int groupId, List<int> parentIds) async {
    await _db.transaction(() async {
      await (_db.delete(_db.counterpartyGroupParents)
            ..where((t) => t.childId.equals(groupId)))
          .go();
      for (final pid in parentIds) {
        if (pid == groupId) continue;
        await _db.into(_db.counterpartyGroupParents).insert(
              CounterpartyGroupParentsCompanion.insert(
                childId: groupId,
                parentId: pid,
              ),
            );
      }
    });
  }

  // Связь контрагент ↔ группы
  Future<List<int>> getGroupIdsForCounterparty(int counterpartyId) async {
    final rows = await (_db.select(_db.counterpartyGroupLinks)
          ..where((t) => t.counterpartyId.equals(counterpartyId)))
        .get();
    return rows.map((r) => r.groupId).toList();
  }

  Future<void> setGroupIdsForCounterparty(
      int counterpartyId, List<int> groupIds) async {
    await _db.transaction(() async {
      await (_db.delete(_db.counterpartyGroupLinks)
            ..where((t) => t.counterpartyId.equals(counterpartyId)))
          .go();
      for (final gid in groupIds) {
        await _db.into(_db.counterpartyGroupLinks).insert(
              CounterpartyGroupLinksCompanion.insert(
                counterpartyId: counterpartyId,
                groupId: gid,
              ),
            );
      }
    });
  }

  // Связь контрагент ↔ проекты
  Future<List<int>> getProjectIdsForCounterparty(int counterpartyId) async {
    final rows = await (_db.select(_db.counterpartyProjects)
          ..where((t) => t.counterpartyId.equals(counterpartyId)))
        .get();
    return rows.map((r) => r.projectId).toList();
  }

  Future<void> setProjectIdsForCounterparty(
      int counterpartyId, List<int> projectIds) async {
    await _db.transaction(() async {
      await (_db.delete(_db.counterpartyProjects)
            ..where((t) => t.counterpartyId.equals(counterpartyId)))
          .go();
      for (final pid in projectIds) {
        await _db.into(_db.counterpartyProjects).insert(
              CounterpartyProjectsCompanion.insert(
                counterpartyId: counterpartyId,
                projectId: pid,
              ),
            );
      }
    });
  }
}
