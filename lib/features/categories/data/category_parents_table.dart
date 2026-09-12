import 'package:drift/drift.dart';
import 'categories_table.dart';

class CategoryParents extends Table {
  @ReferenceName('childLinks')
  IntColumn get categoryId => integer().references(Categories, #id)();

  @ReferenceName('parentLinks')
  IntColumn get parentId => integer().references(Categories, #id)();

  @override
  Set<Column> get primaryKey => {categoryId, parentId};
}
