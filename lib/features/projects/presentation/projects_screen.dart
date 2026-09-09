import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../core/database/app_database.dart';
import '../../../core/widgets/entity_form.dart';
import '../../../core/widgets/entity_list_screen.dart';
import 'projects_provider.dart';

class ProjectsScreen extends ConsumerWidget {
  final VoidCallback onBack;
  const ProjectsScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              leading: Icon(
                project.icon != null
                    ? _iconFromName(project.icon!)
                    : Icons.folder,
              ),
              title: Text(project.name),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showProjectForm(context, ref, project: project),
              ),
              onTap: () => _showProjectForm(context, ref, project: project),
            );
          },
          onBack: onBack,
          showAddItem: true,
          addItemLabel: 'Проект',
          onAddItem: () => _showProjectForm(context, ref),
        );
      },
    );
  }

  IconData _iconFromName(String name) {
    const icons = {
      'folder': Icons.folder,
      'home': Icons.home,
      'star': Icons.star,
      'work': Icons.work,
      'shopping_cart': Icons.shopping_cart,
      'account_balance_wallet': Icons.account_balance_wallet,
      'credit_card': Icons.credit_card,
      'account_balance': Icons.account_balance,
      'receipt': Icons.receipt,
      'category': Icons.category,
      'person': Icons.person,
      'group': Icons.group,
      'settings': Icons.settings,
      'favorite': Icons.favorite,
      'flag': Icons.flag,
      'attach_money': Icons.attach_money,
    };
    return icons[name] ?? Icons.folder;
  }

  void _showProjectForm(BuildContext context, WidgetRef ref, {Project? project}) {
    final nameController = TextEditingController(text: project?.name ?? '');
    final isEditing = project != null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return EntityForm(
          title: isEditing ? 'Редактирование проекта' : 'Новый проект',
          nameController: nameController,
          initialIconName: project?.icon,
          onSave: (iconName) {
            if (isEditing) {
              ref.read(projectsProvider.notifier).updateProject(
                project.copyWith(
                  name: nameController.text.trim(),
                  icon: iconName != null ? drift.Value(iconName) : const drift.Value.absent(),
                ),
              );
            } else {
              ref.read(projectsProvider.notifier).addProject(
                nameController.text.trim(),
                icon: iconName,
              );
            }
          },
          onDelete: isEditing
              ? () {
                  ref.read(projectsProvider.notifier).deleteProject(project.id);
                  Navigator.pop(context);
                }
              : null,
          showDelete: isEditing,
          isEditing: isEditing,
        );
      },
    );
  }
}
