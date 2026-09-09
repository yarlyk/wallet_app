import 'package:flutter/material.dart';

class EntityListScreen extends StatelessWidget {
  final String title;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final VoidCallback onBack;
  final bool showAddGroup;
  final bool showAddItem;
  final String addGroupLabel;
  final String addItemLabel;
  final VoidCallback? onAddGroup;
  final VoidCallback? onAddItem;

  const EntityListScreen({
    super.key,
    required this.title,
    required this.itemCount,
    required this.itemBuilder,
    required this.onBack,
    this.showAddGroup = false,
    this.showAddItem = false,
    this.addGroupLabel = 'Группа',
    this.addItemLabel = 'Элемент',
    this.onAddGroup,
    this.onAddItem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: itemCount,
            itemBuilder: itemBuilder,
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Назад'),
                ),
                const Spacer(),
                if (showAddGroup)
                  TextButton.icon(
                    onPressed: onAddGroup,
                    icon: const Icon(Icons.create_new_folder),
                    label: Text(addGroupLabel),
                  ),
                const SizedBox(width: 8),
                if (showAddItem)
                  ElevatedButton.icon(
                    onPressed: onAddItem,
                    icon: const Icon(Icons.add),
                    label: Text(addItemLabel),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
