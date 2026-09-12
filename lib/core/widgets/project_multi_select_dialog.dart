import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/projects/presentation/projects_provider.dart';

class ProjectMultiSelectDialog extends ConsumerStatefulWidget {
  final List<int> initiallySelectedIds;
  const ProjectMultiSelectDialog({super.key, this.initiallySelectedIds = const []});

  @override
  ConsumerState<ProjectMultiSelectDialog> createState() => _ProjectMultiSelectDialogState();
}

class _ProjectMultiSelectDialogState extends ConsumerState<ProjectMultiSelectDialog> {
  late Set<int> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = Set<int>.from(widget.initiallySelectedIds);
  }

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(projectsProvider);

    return AlertDialog(
      title: const Text('Выберите проекты'),
      content: SizedBox(
        width: double.maxFinite,
        child: projectsAsync.when(
          data: (projects) {
            if (projects.isEmpty) {
              return const Text('Нет доступных проектов');
            }
            return ListView(
              shrinkWrap: true,
              children: [
                for (final project in projects)
                  CheckboxListTile(
                    title: Text(project.name),
                    value: _selectedIds.contains(project.id),
                    onChanged: (checked) {
                      setState(() {
                        if (checked == true) {
                          _selectedIds.add(project.id);
                        } else {
                          _selectedIds.remove(project.id);
                        }
                      });
                    },
                  ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Text('Ошибка: $e'),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _selectedIds.toList()),
          child: const Text('Готово'),
        ),
      ],
    );
  }
}
