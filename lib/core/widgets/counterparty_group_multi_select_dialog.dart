import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/counterparties/presentation/counterparties_provider.dart';
import 'icon_picker.dart';

class CounterpartyGroupMultiSelectDialog extends ConsumerStatefulWidget {
  final List<int> initiallySelectedIds;
  final int? excludeGroupId;

  const CounterpartyGroupMultiSelectDialog({
    super.key,
    this.initiallySelectedIds = const [],
    this.excludeGroupId,
  });

  @override
  ConsumerState<CounterpartyGroupMultiSelectDialog> createState() =>
      _CounterpartyGroupMultiSelectDialogState();
}

class _CounterpartyGroupMultiSelectDialogState
    extends ConsumerState<CounterpartyGroupMultiSelectDialog> {
  late Set<int> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = Set<int>.from(widget.initiallySelectedIds);
  }

  Set<int> _descendantsOf(int rootId, Map<int, List<int>> parentIds) {
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
    final stateAsync = ref.watch(counterpartiesProvider);

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
        final groups = state.groups;
        final parentIds = state.groupParentIds;

        final excluded = <int>{};
        if (widget.excludeGroupId != null) {
          excluded.add(widget.excludeGroupId!);
          excluded.addAll(_descendantsOf(widget.excludeGroupId!, parentIds));
        }

        final available =
            groups.where((g) => !excluded.contains(g.id)).toList();

        if (available.isEmpty) {
          return AlertDialog(
            title: const Text('Родительские группы'),
            content: const Text(
              'Нет доступных групп для выбора.\n\n'
              'Чтобы избежать циклов, группа не может быть вложена '
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
          title: const Text('Родительские группы'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final g in available)
                  CheckboxListTile(
                    secondary: Icon(iconFromName(g.icon)),
                    title: Text(g.name),
                    value: _selectedIds.contains(g.id),
                    onChanged: (checked) {
                      setState(() {
                        if (checked == true) {
                          _selectedIds.add(g.id);
                        } else {
                          _selectedIds.remove(g.id);
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
