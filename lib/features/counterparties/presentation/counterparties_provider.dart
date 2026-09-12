import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../data/counterparty_repository.dart';

final counterpartyRepositoryProvider =
    Provider<CounterpartyRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return CounterpartyRepository(db);
});

class CounterpartiesState {
  final List<Counterparty> counterparties;
  final List<CounterpartyGroup> groups;
  final Map<int, List<int>> groupParentIds; // для групп: childId -> parentIds
  final Map<int, List<int>> counterpartyGroupIds; // контрагент -> группы

  CounterpartiesState({
    required this.counterparties,
    required this.groups,
    required this.groupParentIds,
    required this.counterpartyGroupIds,
  });
}

class CounterpartiesNotifier extends AsyncNotifier<CounterpartiesState> {
  @override
  Future<CounterpartiesState> build() async {
    final repo = ref.watch(counterpartyRepositoryProvider);
    final counterparties = await repo.watchActiveCounterparties().first;
    final groups = await repo.watchActiveGroups().first;

    final groupParentMap = <int, List<int>>{};
    for (final g in groups) {
      groupParentMap[g.id] = await repo.getParentIdsForGroup(g.id);
    }

    final cpGroupMap = <int, List<int>>{};
    for (final c in counterparties) {
      cpGroupMap[c.id] = await repo.getGroupIdsForCounterparty(c.id);
    }

    return CounterpartiesState(
      counterparties: counterparties,
      groups: groups,
      groupParentIds: groupParentMap,
      counterpartyGroupIds: cpGroupMap,
    );
  }

  // Контрагенты
  Future<int> addCounterparty(
    CounterpartiesCompanion entry,
    List<int> groupIds,
    List<int> projectIds,
  ) async {
    final repo = ref.read(counterpartyRepositoryProvider);
    final id = await repo.addCounterparty(entry);
    if (groupIds.isNotEmpty) {
      await repo.setGroupIdsForCounterparty(id, groupIds);
    }
    if (projectIds.isNotEmpty) {
      await repo.setProjectIdsForCounterparty(id, projectIds);
    }
    ref.invalidateSelf();
    return id;
  }

  Future<void> updateCounterparty(
    int id,
    CounterpartiesCompanion entry,
    List<int> groupIds,
    List<int> projectIds,
  ) async {
    final repo = ref.read(counterpartyRepositoryProvider);
    await repo.updateCounterparty(id, entry);
    await repo.setGroupIdsForCounterparty(id, groupIds);
    await repo.setProjectIdsForCounterparty(id, projectIds);
    ref.invalidateSelf();
  }

  Future<void> deleteCounterparty(int id) async {
    final repo = ref.read(counterpartyRepositoryProvider);
    await repo.deleteCounterparty(id);
    ref.invalidateSelf();
  }

  Future<List<int>> getGroupIds(int counterpartyId) async {
    final repo = ref.read(counterpartyRepositoryProvider);
    return repo.getGroupIdsForCounterparty(counterpartyId);
  }

  Future<List<int>> getProjectIds(int counterpartyId) async {
    final repo = ref.read(counterpartyRepositoryProvider);
    return repo.getProjectIdsForCounterparty(counterpartyId);
  }

  // Группы
  Future<int> addGroup(String name, String? icon, List<int> parentIds) async {
    final repo = ref.read(counterpartyRepositoryProvider);
    final id = await repo.addGroup(CounterpartyGroupsCompanion.insert(
      name: name,
      icon: Value(icon),
    ));
    if (parentIds.isNotEmpty) {
      await repo.setParentIdsForGroup(id, parentIds);
    }
    ref.invalidateSelf();
    return id;
  }

  Future<void> updateGroup(
      int id, String name, String? icon, List<int> parentIds) async {
    final repo = ref.read(counterpartyRepositoryProvider);
    await repo.updateGroup(id, CounterpartyGroupsCompanion(
      name: Value(name),
      icon: Value(icon),
    ));
    await repo.setParentIdsForGroup(id, parentIds);
    ref.invalidateSelf();
  }

  Future<void> deleteGroup(int id) async {
    final repo = ref.read(counterpartyRepositoryProvider);
    await repo.deleteGroup(id);
    ref.invalidateSelf();
  }

  Future<List<int>> getParentIdsForGroup(int groupId) async {
    final repo = ref.read(counterpartyRepositoryProvider);
    return repo.getParentIdsForGroup(groupId);
  }
}

final counterpartiesProvider =
    AsyncNotifierProvider<CounterpartiesNotifier, CounterpartiesState>(
        CounterpartiesNotifier.new);
