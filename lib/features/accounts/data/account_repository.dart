import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';

class AccountWithCurrency {
  final Account account;
  final Currency currency;
  AccountWithCurrency(this.account, this.currency);
}

class AccountRepository {
  AccountRepository(this._db);
  final AppDatabase _db;

  // Группы
  Stream<List<AccountGroup>> watchActiveGroups() {
    return (_db.select(_db.accountGroups)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<int> addGroup(AccountGroupsCompanion entry) =>
      _db.into(_db.accountGroups).insert(entry);

  Future<void> updateGroup(int id, AccountGroupsCompanion entry) =>
      (_db.update(_db.accountGroups)..where((t) => t.id.equals(id))).write(entry);

  Future<void> deleteGroup(int id) =>
      (_db.update(_db.accountGroups)..where((t) => t.id.equals(id)))
          .write(const AccountGroupsCompanion(isActive: Value(false)));

  // Счета с валютой
  Stream<List<AccountWithCurrency>> watchActiveAccounts() {
    final query = _db.select(_db.accounts)
      ..where((t) => t.isActive.equals(true))
      ..orderBy([(t) => OrderingTerm.asc(t.name)]);

    return query
        .join([
          innerJoin(_db.currencies, _db.currencies.id.equalsExp(_db.accounts.currencyId)),
        ])
        .watch()
        .map((rows) => rows.map((row) {
              return AccountWithCurrency(
                row.readTable(_db.accounts),
                row.readTable(_db.currencies),
              );
            }).toList());
  }

  Future<int> addAccount(AccountsCompanion entry) =>
      _db.into(_db.accounts).insert(entry);

  Future<void> updateAccount(int id, AccountsCompanion entry) =>
      (_db.update(_db.accounts)..where((t) => t.id.equals(id))).write(entry);

  Future<void> deleteAccount(int id) =>
      (_db.update(_db.accounts)..where((t) => t.id.equals(id)))
          .write(const AccountsCompanion(isActive: Value(false)));

  // Связь с проектами
  Future<List<int>> getProjectIdsForAccount(int accountId) async {
    final rows = await (_db.select(_db.accountProjects)
          ..where((t) => t.accountId.equals(accountId)))
        .get();
    return rows.map((r) => r.projectId).toList();
  }

  Future<void> setProjectIdsForAccount(int accountId, List<int> projectIds) async {
    await _db.transaction(() async {
      await (_db.delete(_db.accountProjects)
            ..where((t) => t.accountId.equals(accountId)))
          .go();
      for (final projectId in projectIds) {
        await _db.into(_db.accountProjects).insert(
              AccountProjectsCompanion.insert(
                accountId: accountId,
                projectId: projectId,
              ),
            );
      }
    });
  }
}
