import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../data/project_repository.dart';

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ProjectRepository(db);
});

final projectsProvider = AsyncNotifierProvider<ProjectsNotifier, List<Project>>(ProjectsNotifier.new);

class ProjectsNotifier extends AsyncNotifier<List<Project>> {
  @override
  Future<List<Project>> build() async {
    final repo = ref.watch(projectRepositoryProvider);
    return repo.getAll();
  }

  Future<void> addProject(String name, {String? icon}) async {
    final repo = ref.watch(projectRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final id = await repo.insert(ProjectsCompanion.insert(name: name, icon: Value(icon)));
      final newProject = Project(id: id, name: name, isActive: true, icon: icon);
      return [...state.value ?? [], newProject];
    });
  }

  Future<void> updateProject(Project project) async {
    final repo = ref.watch(projectRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repo.update(project);
      final updatedList = (state.value ?? []).map((p) => p.id == project.id ? project : p).toList();
      return updatedList;
    });
  }

  Future<void> deleteProject(int id) async {
    final repo = ref.watch(projectRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repo.delete(id);
      return (state.value ?? []).where((p) => p.id != id).toList();
    });
  }
}
