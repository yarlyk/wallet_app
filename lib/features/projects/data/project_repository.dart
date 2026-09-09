import '../../../core/database/app_database.dart';

class ProjectRepository {
  final AppDatabase _db;
  ProjectRepository(this._db);

  Future<List<Project>> getAll() => _db.select(_db.projects).get();
  Future<Project?> getById(int id) => (_db.select(_db.projects)..where((t) => t.id.equals(id))).getSingleOrNull();
  Future<int> insert(ProjectsCompanion entry) => _db.into(_db.projects).insert(entry);
  Future<bool> update(Project project) => _db.update(_db.projects).replace(project);
  Future<int> delete(int id) => (_db.delete(_db.projects)..where((t) => t.id.equals(id))).go();
}
