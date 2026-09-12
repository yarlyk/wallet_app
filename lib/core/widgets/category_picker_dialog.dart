import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/categories/presentation/categories_provider.dart';
import 'icon_picker.dart';

class CategoryPickerDialog extends ConsumerStatefulWidget {
  const CategoryPickerDialog({super.key});

  @override
  ConsumerState<CategoryPickerDialog> createState() =>
      _CategoryPickerDialogState();
}

class _CategoryPickerDialogState extends ConsumerState<CategoryPickerDialog> {
  final List<int> _pathIds = []; // путь вниз по дереву

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
        final byId = {for (final c in categories) c.id: c};

        // Дети текущего узла (или корневые, если путь пуст).
        final currentParentId =
            _pathIds.isEmpty ? null : _pathIds.last;
        final children = categories.where((c) {
          final parents = parentIds[c.id] ?? const [];
          if (currentParentId == null) {
            return parents.isEmpty;
          }
          return parents.contains(currentParentId);
        }).toList();

        // Текущий узел (если углубились).
        final current = currentParentId != null
            ? byId[currentParentId]
            : null;

        // Хлебные крошки.
        final crumbs = <String>[
          'Категории',
          ..._pathIds.map((id) => byId[id]?.name ?? '?'),
        ];

        return AlertDialog(
          title: const Text('Выберите категорию'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Хлебные крошки
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < crumbs.length; i++) ...[
                        if (i > 0)
                          const Icon(Icons.chevron_right, size: 18),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _pathIds.removeRange(
                                  i, _pathIds.length);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 6),
                            child: Text(
                              crumbs[i],
                              style: TextStyle(
                                color: i == crumbs.length - 1
                                    ? Colors.black87
                                    : Colors.indigo,
                                fontWeight: i == crumbs.length - 1
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Кнопка "Выбрать <текущий узел>"
                if (current != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context, current.id),
                      icon: const Icon(Icons.check),
                      label: Text('Выбрать "${current.name}"'),
                    ),
                  ),
                Expanded(
                  child: children.isEmpty
                      ? const Center(
                          child: Text('Нет вложенных категорий'))
                      : ListView(
                          children: [
                            for (final c in children)
                              ListTile(
                                leading: Icon(iconFromName(c.icon)),
                                title: Text(c.name),
                                trailing: _hasChildren(c.id, categories,
                                        parentIds)
                                    ? const Icon(Icons.chevron_right)
                                    : null,
                                onTap: () {
                                  if (_hasChildren(
                                      c.id, categories, parentIds)) {
                                    setState(() => _pathIds.add(c.id));
                                  } else {
                                    Navigator.pop(context, c.id);
                                  }
                                },
                              ),
                          ],
                        ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Отмена'),
            ),
            if (_pathIds.isNotEmpty)
              TextButton(
                onPressed: () => setState(() => _pathIds.clear()),
                child: const Text('К корню'),
              ),
          ],
        );
      },
    );
  }

  bool _hasChildren(
    int id,
    List<dynamic> categories,
    Map<int, List<int>> parentIds,
  ) {
    for (final entry in parentIds.entries) {
      if (entry.value.contains(id)) return true;
    }
    return false;
  }
}


