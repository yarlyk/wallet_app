import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../core/database/app_database.dart';
import '../../../core/widgets/entity_form_screen.dart';
import '../../../core/widgets/entity_list_screen.dart';
import '../../../core/widgets/icon_picker.dart';
import 'projects_provider.dart';

class ProjectsScreen extends ConsumerStatefulWidget {
  final VoidCallback onBack;
  const ProjectsScreen({super.key, required this.onBack});

  @override
  ConsumerState<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends ConsumerState<ProjectsScreen> {
  bool _showForm = false;
  Project? _editingProject;
  final _nameController = TextEditingController();

  void _openCreate() {
    _nameController.text = '';
    setState(() {
      _editingProject = null;
      _showForm = true;
    });
  }

  void _openEdit(Project project) {
    _nameController.text = project.name;
    setState(() {
      _editingProject = project;
      _showForm = true;
    });
  }

  void _closeForm() {
    setState(() {
      _showForm = false;
      _editingProject = null;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showForm) {
      final isEditing = _editingProject != null;
      return EntityFormScreen(
        title: isEditing ? 'Редактирование проекта' : 'Новый проект',
        nameController: _nameController,
        initialIconName: _editingProject?.icon,
        isEditing: isEditing,
        showDelete: isEditing,
        onCancel: _closeForm,
        onSave: (iconName) async {
          if (isEditing) {
            await ref.read(projectsProvider.notifier).updateProject(
              _editingProject!.copyWith(
                name: _nameController.text.trim(),
                icon: iconName != null
                    ? drift.Value(iconName)
                    : const drift.Value.absent(),
              ),
            );
          } else {
            await ref.read(projectsProvider.notifier).addProject(
              _nameController.text.trim(),
              icon: iconName,
            );
          }
          return true;
        },
        onDelete: isEditing
            ? () async {
                await ref
                    .read(projectsProvider.notifier)
                    .deleteProject(_editingProject!.id);
                return true;
              }
            : null,
      );
    }

    final projectsAsync = ref.watch(projectsProvider);

    return projectsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Ошибка: $error')),
      data: (projects) {
        return EntityListScreen(
          title: 'Проекты',
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return ListTile(
              leading: Icon(iconFromName(project.icon)),
              title: Text(project.name),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _openEdit(project),
              ),
              onTap: () => _openEdit(project),
            );
          },
          onBack: widget.onBack,
          showAddItem: true,
          addItemLabel: 'Проект',
          onAddItem: _openCreate,
        );
      },
    );
  }
}
