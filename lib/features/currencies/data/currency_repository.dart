import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import 'currencies_table.dart';

class CurrencyRepository {
  final AppDatabase _db;
  CurrencyRepository(this._db);

  Future<List<Currency>> getAll() => _db.select(_db.currencies).get();
  Future<Currency?> getById(int id) => (_db.select(_db.currencies)..where((t) => t.id.equals(id))).getSingleOrNull();
  Future<int> insert(CurrenciesCompanion entry) => _db.into(_db.currencies).insert(entry);
  Future<bool> update(Currency currency) => _db.update(_db.currencies).replace(currency);
  Future<int> delete(int id) => (_db.delete(_db.currencies)..where((t) => t.id.equals(id))).go();
}
