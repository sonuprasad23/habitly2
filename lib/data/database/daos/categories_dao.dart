import 'package:drift/drift.dart';
import 'package:habitly/data/database/database.dart';
import 'package:habitly/data/database/tables/categories_table.dart';

part 'categories_dao.g.dart';

@DriftAccessor(tables: [Categories])
class CategoriesDao extends DatabaseAccessor<AppDatabase> with _$CategoriesDaoMixin {
  CategoriesDao(super.db);

  // Get all categories
  Stream<List<Category>> watchAllCategories() {
    return (select(categories)..orderBy([(c) => OrderingTerm.asc(c.sortOrder)])).watch();
  }

  // Get all categories (non-stream)
  Future<List<Category>> getAllCategories() {
    return (select(categories)..orderBy([(c) => OrderingTerm.asc(c.sortOrder)])).get();
  }

  // Get a category by ID
  Future<Category?> getCategory(int id) {
    return (select(categories)..where((c) => c.id.equals(id))).getSingleOrNull();
  }

  // Insert a new category
  Future<int> insertCategory(CategoriesCompanion category) {
    return into(categories).insert(category);
  }

  // Update a category
  Future<bool> updateCategory(Category category) {
    return update(categories).replace(category);
  }

  // Delete a category (only non-default)
  Future<int> deleteCategory(int id) {
    return (delete(categories)
          ..where((c) => c.id.equals(id) & c.isDefault.equals(false)))
        .go();
  }
}
