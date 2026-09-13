import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/plural_utils.dart';
import '../../../core/widgets/icon_picker.dart';
import '../../transactions/presentation/transactions_provider.dart';
import 'categories_provider.dart';
import 'category_form_screen.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  final VoidCallback onBack;
  const CategoriesScreen({super.key, required this.onBack});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  bool _showForm = false;
  Category? _editing;

  void _openCreate() {
    setState(() {
      _editing = null;
      _showForm = true;
    });
  }

  void _openEdit(Category c) {
    setState(() {
      _editing = c;
      _showForm = true;
    });
  }

  void _closeForm() {
    setState(() {
      _showForm = false;
      _editing = null;
    });
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

  Future<bool> _tryDeleteCategory(
    Category category,
    Map<int, List<int>> parentIds,
  ) async {
    final descendants = _descendantsOf(category.id, parentIds);
    if (descendants.isNotEmpty) {
      if (!mounted) return false;
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Нельзя удалить категорию'),
          content: Text(
            'Внутри категории ${pluralRu(descendants.length, 'вложенная категория', 'вложенные категории', 'вложенных категорий')}.\n\n'
            'Сначала удалите или переместите вложенные категории, '
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

    final used = await ref
        .read(transactionsNotifierProvider)
        .countForCategory(category.id);

    if (used > 0) {
      if (!mounted) return false;
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Нельзя удалить категорию'),
          content: Text(
            'Категория участвует в ${pluralRu(used, 'транзакции', 'транзакциях', 'транзакциях')}.\n\n'
            'Удалите или переназначьте эти операции, затем повторите удаление.',
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

    await ref.read(categoriesProvider.notifier).deleteCategory(category.id);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(categoriesProvider);

    return stateAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Ошибка: $e')),
      data: (state) {
        if (_showForm) {
          return CategoryFormScreen(
            category: _editing,
            onCancel: _closeForm,
            onDeleteOverride: _editing != null
                ? () => _tryDeleteCategory(_editing!, state.parentIds)
                : null,
          );
        }

        final categories = state.categories;
        final parentIds = state.parentIds;

        final roots = categories
            .where((c) => (parentIds[c.id] ?? const []).isEmpty)
            .toList();

        final widgets = <Widget>[];
        for (final root in roots) {
          widgets.add(_buildNode(root, categories, parentIds, <int>{}));
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Категории',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: widgets.isEmpty
                  ? const Center(child: Text('Нет категорий'))
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
                    ElevatedButton.icon(
                      onPressed: _openCreate,
                      icon: const Icon(Icons.add),
                      label: const Text('Категория'),
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

  Widget _buildNode(
    Category node,
    List<Category> all,
    Map<int, List<int>> parentIds,
    Set<int> ancestorChain,
  ) {
    final children = all
        .where((c) => (parentIds[c.id] ?? const []).contains(node.id))
        .toList();

    final filtered =
        children.where((c) => !ancestorChain.contains(c.id)).toList();

    final nextChain = <int>{...ancestorChain, node.id};

    if (filtered.isEmpty) {
      return ListTile(
        leading: Icon(iconFromName(node.icon)),
        title: Text(node.name),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          tooltip: 'Редактировать категорию',
          onPressed: () => _openEdit(node),
        ),
        onTap: () => _openEdit(node),
      );
    }

    return ExpansionTile(
      leading: Icon(iconFromName(node.icon)),
      title: Text(node.name),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        tooltip: 'Редактировать категорию',
        onPressed: () => _openEdit(node),
      ),
      children: [
        for (final child in filtered)
          _buildNode(child, all, parentIds, nextChain),
      ],
    );
  }
}
