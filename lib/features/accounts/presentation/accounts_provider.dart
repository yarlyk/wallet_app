import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../data/account_repository.dart';

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return AccountRepository(db);
});

class AccountsState {
  final List<AccountGroup> groups;
  final List<AccountWithCurrency> accounts;
  AccountsState({required this.groups, required this.accounts});
}

class AccountsNotifier extends AsyncNotifier<AccountsState> {
  @override
  Future<AccountsState> build() async {
    final repo = ref.watch(accountRepositoryProvider);
    final groupsFuture = repo.watchActiveGroups().first;
    final accountsFuture = repo.watchActiveAccounts().first;
    final results = await Future.wait([groupsFuture, accountsFuture]);
    return AccountsState(
      groups: results[0] as List<AccountGroup>,
      accounts: results[1] as List<AccountWithCurrency>,
    );
  }

  Future<int> addGroup(String name, String? icon, int? parentId) async {
    final repo = ref.read(accountRepositoryProvider);
    final id = await repo.addGroup(AccountGroupsCompanion.insert(
      name: name,
      icon: Value(icon),
      parentId: Value(parentId),
    ));
    ref.invalidateSelf();
    return id;
  }

  Future<void> updateGroup(int id, String name, String? icon, int? parentId) async {
    final repo = ref.read(accountRepositoryProvider);
    await repo.updateGroup(id, AccountGroupsCompanion(
      name: Value(name),
      icon: Value(icon),
      parentId: Value(parentId),
    ));
    ref.invalidateSelf();
  }

  Future<void> deleteGroup(int id) async {
    final repo = ref.read(accountRepositoryProvider);
    await repo.deleteGroup(id);
    ref.invalidateSelf();
  }

  Future<int> addAccount(AccountsCompanion entry) async {
    final repo = ref.read(accountRepositoryProvider);
    final id = await repo.addAccount(entry);
    ref.invalidateSelf();
    return id;
  }

  Future<void> updateAccount(int id, AccountsCompanion entry) async {
    final repo = ref.read(accountRepositoryProvider);
    await repo.updateAccount(id, entry);
    ref.invalidateSelf();
  }

  Future<void> deleteAccount(int id) async {
    final repo = ref.read(accountRepositoryProvider);
    await repo.deleteAccount(id);
    ref.invalidateSelf();
  }

  Future<List<int>> getProjectIdsForAccount(int accountId) async {
    final repo = ref.read(accountRepositoryProvider);
    return repo.getProjectIdsForAccount(accountId);
  }

  Future<void> setProjectIdsForAccount(int accountId, List<int> projectIds) async {
    final repo = ref.read(accountRepositoryProvider);
    await repo.setProjectIdsForAccount(accountId, projectIds);
    ref.invalidateSelf();
  }
}

final accountsProvider = AsyncNotifierProvider<AccountsNotifier, AccountsState>(AccountsNotifier.new);
