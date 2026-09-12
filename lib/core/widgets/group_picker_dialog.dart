import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/accounts/presentation/accounts_provider.dart';
import 'entity_form.dart';

IconData _iconFromName(String? name) {
  // Заглушка: позже заменить на реальную карту иконок.
  return Icons.folder;
}

class GroupPickerDialog extends ConsumerWidget {
  const GroupPickerDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(accountsProvider);

    return groupsAsync.when(
      loading: () => const AlertDialog(
        content: SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (e, st) => AlertDialog(
        title: const Text('Ошибка'),
        content: Text('$e'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
      data: (state) {
        final groups = state.groups;
        if (groups.isEmpty) {
          return const _FirstGroupForm();
        }
        return AlertDialog(
          title: const Text('Выберите группу'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  title: const Text('Без группы'),
                  onTap: () => Navigator.pop(context, null),
                ),
                ...groups.map((group) => ListTile(
                      leading: Icon(_iconFromName(group.icon)),
                      title: Text(group.name),
                      onTap: () => Navigator.pop(context, group.id),
                    )),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            TextButton.icon(
              onPressed: () async {
                final newId = await showDialog<int>(
                  context: context,
                  builder: (_) => const _FirstGroupForm(),
                );
                if (newId != null && context.mounted) {
                  Navigator.pop(context, newId);
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Группа'),
            ),
          ],
        );
      },
    );
  }
}

class _FirstGroupForm extends ConsumerStatefulWidget {
  const _FirstGroupForm();

  @override
  ConsumerState<_FirstGroupForm> createState() => _FirstGroupFormState();
}

class _FirstGroupFormState extends ConsumerState<_FirstGroupForm> {
  final _nameController = TextEditingController();
  String? _selectedIcon;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EntityForm(
      title: 'Создайте первую группу',
      nameController: _nameController,
      initialIconName: _selectedIcon,
      onIconSelected: (icon) => _selectedIcon = icon,
      onSave: (icon) async {
        final id = await ref
            .read(accountsProvider.notifier)
            .addGroup(_nameController.text.trim(), icon, null);
        if (mounted) Navigator.pop(context, id);
      },
      showDelete: false,
      isEditing: false,
    );
  }
}
