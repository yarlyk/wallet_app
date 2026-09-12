import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';

class AccountGroupRepository {
  AccountGroupRepository(this._db);
  final AppDatabase _db;

  Stream<List<AccountGroup>> watchAllGroups() {
    return (_db.select(_db.accountGroups)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<int> addGroup(AccountGroupsCompanion entry) {
    return _db.into(_db.accountGroups).insert(entry);
  }

  Future<void> updateGroup(int id, AccountGroupsCompanion entry) {
    return (_db.update(_db.accountGroups)..where((t) => t.id.equals(id))).write(entry);
  }

  Future<void> deleteGroup(int id) async {
    await (_db.update(_db.accountGroups)..where((t) => t.id.equals(id)))
        .write(const AccountGroupsCompanion(isActive: Value(false)));
  }
}
