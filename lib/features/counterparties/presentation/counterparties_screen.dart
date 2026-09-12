import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/widgets/icon_picker.dart';
import 'counterparties_provider.dart';
import 'counterparty_form_screen.dart';
import 'counterparty_group_form_screen.dart';

class CounterpartiesScreen extends ConsumerStatefulWidget {
  final VoidCallback onBack;
  const CounterpartiesScreen({super.key, required this.onBack});

  @override
  ConsumerState<CounterpartiesScreen> createState() =>
      _CounterpartiesScreenState();
}

class _CounterpartiesScreenState extends ConsumerState<CounterpartiesScreen> {
  bool _showForm = false;
  bool _showGroupForm = false;
  Counterparty? _editingCounterparty;
  CounterpartyGroup? _editingGroup;
  final _groupNameController = TextEditingController();

  void _closeForm() {
    setState(() {
      _showForm = false;
      _showGroupForm = false;
      _editingCounterparty = null;
      _editingGroup = null;
    });
  }

  void _openCreateCounterparty() {
    setState(() {
      _editingCounterparty = null;
      _editingGroup = null;
      _showGroupForm = false;
      _showForm = true;
    });
  }

  void _openEditCounterparty(Counterparty c) {
    setState(() {
      _editingCounterparty = c;
      _editingGroup = null;
      _showGroupForm = false;
      _showForm = true;
    });
  }

  void _openCreateGroup() {
    _groupNameController.text = '';
    setState(() {
      _editingGroup = null;
      _editingCounterparty = null;
      _showForm = false;
      _showGroupForm = true;
    });
  }

  void _openEditGroup(CounterpartyGroup g) {
    _groupNameController.text = g.name;
    setState(() {
      _editingGroup = g;
      _editingCounterparty = null;
      _showForm = false;
      _showGroupForm = true;
    });
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  Set<int> _descendantsOfGroup(int rootId, Map<int, List<int>> parentIds) {
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

  String _pluralCounterparties(int n) {
    final mod10 = n % 10;
    final mod100 = n % 100;
    if (mod10 == 1 && mod100 != 11) return '$n контрагент';
    if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) {
      return '$n контрагента';
    }
    return '$n контрагентов';
  }

  Future<bool> _tryDeleteGroup(
    CounterpartyGroup group,
    CounterpartiesState state,
  ) async {
    // Считаем контрагентов во всех вложенных группах (рекурсивно).
    final allGroupIds = <int>{
      group.id,
      ..._descendantsOfGroup(group.id, state.groupParentIds),
    };
    final count = state.counterpartyGroupIds.values
        .where((groupIds) => groupIds.any(allGroupIds.contains))
        .length;

    if (count > 0) {
      if (!mounted) return false;
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Нельзя удалить группу'),
          content: Text(
            'Внутри группы ${_pluralCounterparties(count)}.\n\n'
            'Переместите их в другую группу или оставьте без группы, '
            'затем повторите удаление.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Понятно'),
            ),
          ],
        ),
      );
      return false;
    }
    await ref.read(counterpartiesProvider.notifier).deleteGroup(group.id);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(counterpartiesProvider);

    return stateAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Ошибка: $e')),
      data: (state) {
        if (_showForm) {
          return CounterpartyFormScreen(
            counterparty: _editingCounterparty,
            onCancel: _closeForm,
          );
        }
        if (_showGroupForm) {
          final isEditing = _editingGroup != null;
          return CounterpartyGroupFormScreen(
            group: _editingGroup,
            onCancel: _closeForm,
            onDeleteOverride:
                isEditing ? () => _tryDeleteGroup(_editingGroup!, state) : null,
          );
        }

        final groups = state.groups;
        final counterparties = state.counterparties;
        final parentIds = state.groupParentIds;
        final cpGroupIds = state.counterpartyGroupIds;

        final roots =
            groups.where((g) => (parentIds[g.id] ?? const []).isEmpty).toList();
        final withoutGroup = counterparties
            .where((c) => (cpGroupIds[c.id] ?? const []).isEmpty)
            .toList();

        final widgets = <Widget>[];
        for (final g in roots) {
          widgets.add(_buildGroupNode(g, state, <int>{}));
        }
        for (final c in withoutGroup) {
          widgets.add(_counterpartyTile(c, state));
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Контрагенты',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: widgets.isEmpty
                  ? const Center(child: Text('Нет контрагентов'))
                  : ListView(children: widgets),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    TextButton.icon(
                      onPressed: widget.onBack,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Назад'),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: _openCreateGroup,
                      icon: const Icon(Icons.create_new_folder),
                      label: const Text('Группа'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _openCreateCounterparty,
                      child: const Icon(Icons.person_add),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGroupNode(
    CounterpartyGroup node,
    CounterpartiesState state,
    Set<int> ancestorChain,
  ) {
    final all = state.groups;
    final parentIds = state.groupParentIds;
    final cpGroupIds = state.counterpartyGroupIds;

    final children = all
        .where((g) => (parentIds[g.id] ?? const []).contains(node.id))
        .where((g) => !ancestorChain.contains(g.id))
        .toList();

    final members = state.counterparties
        .where((c) => (cpGroupIds[c.id] ?? const []).contains(node.id))
        .toList();

    final nextChain = <int>{...ancestorChain, node.id};

    final header = ListTile(
      leading: Icon(iconFromName(node.icon)),
      title: Text(node.name),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        tooltip: 'Редактировать группу',
        onPressed: () => _openEditGroup(node),
      ),
    );

    final childrenWidgets = <Widget>[
      for (final g in children) _buildGroupNode(g, state, nextChain),
      for (final c in members)
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: _counterpartyTile(c, state),
        ),
    ];

    if (childrenWidgets.isEmpty) {
      return header;
    }
    return ExpansionTile(
      leading: Icon(iconFromName(node.icon)),
      title: Text(node.name),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        tooltip: 'Редактировать группу',
        onPressed: () => _openEditGroup(node),
      ),
      children: childrenWidgets,
    );
  }

  Widget _counterpartyTile(Counterparty c, CounterpartiesState state) {
    final innLabel =
        (c.inn == null || c.inn!.isEmpty) ? 'ИНН не указан' : 'ИНН ${c.inn}';
    return ListTile(
      leading: Icon(iconFromName(c.icon), color: Colors.indigo),
      title: Text(c.name),
      subtitle: Text(innLabel),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        color: Colors.indigo,
        onPressed: () => _openEditCounterparty(c),
      ),
      onTap: () => _openEditCounterparty(c),
    );
  }
}
