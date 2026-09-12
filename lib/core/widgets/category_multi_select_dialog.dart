import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/categories/presentation/categories_provider.dart';
import 'icon_picker.dart';

class CategoryMultiSelectDialog extends ConsumerStatefulWidget {
  final List<int> initiallySelectedIds;
  final int? excludeCategoryId;

  const CategoryMultiSelectDialog({
    super.key,
    this.initiallySelectedIds = const [],
    this.excludeCategoryId,
  });

  @override
  ConsumerState<CategoryMultiSelectDialog> createState() =>
      _CategoryMultiSelectDialogState();
}

class _CategoryMultiSelectDialogState
    extends ConsumerState<CategoryMultiSelectDialog> {
  late Set<int> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = Set<int>.from(widget.initiallySelectedIds);
  }

  Set<int> _descendantsOf(int rootId, Map<int, List<int>> parentIds) {
    // Возвращает id всех категорий X, у которых rootId является предком
    // (в дереве категорий), т.е. всех потомков rootId.
    final result = <int>{};
    final queue = <int>[rootId];
    while (queue.isNotEmpty) {
      final current = queue.removeLast();
      for (final entry in parentIds.entries) {
        if (entry.value.contains(current) && !result.contains(entry.key)) {
          result.add(entry.key);
          queue.add(entry.key);
        }
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(categoriesProvider);

    return stateAsync.when(
      loading: () => const AlertDialog(
        content: SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (e, _) => AlertDialog(
        title: const Text('Ошибка'),
        content: Text('$e'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Закрыть'),
          ),
        ],
      ),
      data: (state) {
        final categories = state.categories;
        final parentIds = state.parentIds;

        final excluded = <int>{};
        if (widget.excludeCategoryId != null) {
          excluded.add(widget.excludeCategoryId!);
          excluded.addAll(_descendantsOf(widget.excludeCategoryId!, parentIds));
        }

        final available = categories
            .where((c) => !excluded.contains(c.id))
            .toList();

        if (available.isEmpty) {
          return AlertDialog(
            title: const Text('Выберите родительские категории'),
            content: const Text(
              'Нет доступных категорий для выбора.\n\n'
              'Чтобы избежать циклов, категория не может быть вложена '
              'в саму себя или в свои потомки.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: const Text('Понятно'),
              ),
            ],
          );
        }

        return AlertDialog(
          title: const Text('Родительские категории'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final c in available)
                  CheckboxListTile(
                    secondary: Icon(iconFromName(c.icon)),
                    title: Text(c.name),
                    value: _selectedIds.contains(c.id),
                    onChanged: (checked) {
                      setState(() {
                        if (checked == true) {
                          _selectedIds.add(c.id);
                        } else {
                          _selectedIds.remove(c.id);
                        }
                      });
                    },
                  ),
              ],
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
      },
    );
  }
}
