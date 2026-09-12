import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../data/category_repository.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return CategoryRepository(db);
});

class CategoriesState {
  final List<Category> categories;
  final Map<int, List<int>> parentIds;
  CategoriesState({required this.categories, required this.parentIds});
}

class CategoriesNotifier extends AsyncNotifier<CategoriesState> {
  @override
  Future<CategoriesState> build() async {
    final repo = ref.watch(categoryRepositoryProvider);
    final categories = await repo.watchActiveCategories().first;
    final parentMap = <int, List<int>>{};
    for (final c in categories) {
      parentMap[c.id] = await repo.getParentIdsForCategory(c.id);
    }
    return CategoriesState(categories: categories, parentIds: parentMap);
  }

  Future<int> addCategory(String name, String? icon, List<int> parentIds) async {
    final repo = ref.read(categoryRepositoryProvider);
    final id = await repo.addCategory(CategoriesCompanion.insert(
      name: name,
      icon: Value(icon),
    ));
    if (parentIds.isNotEmpty) {
      await repo.setParentIdsForCategory(id, parentIds);
    }
    ref.invalidateSelf();
    return id;
  }

  Future<void> updateCategory(
      int id, String name, String? icon, List<int> parentIds) async {
    final repo = ref.read(categoryRepositoryProvider);
    await repo.updateCategory(id, CategoriesCompanion(
      name: Value(name),
      icon: Value(icon),
    ));
    await repo.setParentIdsForCategory(id, parentIds);
    ref.invalidateSelf();
  }

  Future<void> deleteCategory(int id) async {
    final repo = ref.read(categoryRepositoryProvider);
    await repo.deleteCategory(id);
    ref.invalidateSelf();
  }

  Future<List<int>> getParentIds(int categoryId) async {
    final repo = ref.read(categoryRepositoryProvider);
    return repo.getParentIdsForCategory(categoryId);
  }
}

final categoriesProvider =
    AsyncNotifierProvider<CategoriesNotifier, CategoriesState>(
        CategoriesNotifier.new);
