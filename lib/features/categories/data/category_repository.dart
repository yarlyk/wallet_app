import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';

class CategoryRepository {
  CategoryRepository(this._db);
  final AppDatabase _db;

  Stream<List<Category>> watchActiveCategories() {
    return (_db.select(_db.categories)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<int> addCategory(CategoriesCompanion entry) =>
      _db.into(_db.categories).insert(entry);

  Future<void> updateCategory(int id, CategoriesCompanion entry) =>
      (_db.update(_db.categories)..where((t) => t.id.equals(id))).write(entry);

  Future<void> deleteCategory(int id) =>
      (_db.update(_db.categories)..where((t) => t.id.equals(id)))
          .write(const CategoriesCompanion(isActive: Value(false)));

  Future<List<int>> getParentIdsForCategory(int categoryId) async {
    final rows = await (_db.select(_db.categoryParents)
          ..where((t) => t.categoryId.equals(categoryId)))
        .get();
    return rows.map((r) => r.parentId).toList();
  }

  Future<void> setParentIdsForCategory(
      int categoryId, List<int> parentIds) async {
    await _db.transaction(() async {
      await (_db.delete(_db.categoryParents)
            ..where((t) => t.categoryId.equals(categoryId)))
          .go();
      for (final pid in parentIds) {
        if (pid == categoryId) continue;
        await _db.into(_db.categoryParents).insert(
              CategoryParentsCompanion.insert(
                categoryId: categoryId,
                parentId: pid,
              ),
            );
      }
    });
  }
}
