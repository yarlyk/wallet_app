import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/widgets/category_multi_select_dialog.dart';
import '../../../core/widgets/entity_form_screen.dart';
import 'categories_provider.dart';

class CategoryFormScreen extends ConsumerStatefulWidget {
  final Category? category;
  final VoidCallback onCancel;
  final Future<bool> Function()? onDeleteOverride;

  const CategoryFormScreen({
    super.key,
    this.category,
    required this.onCancel,
    this.onDeleteOverride,
  });

  @override
  ConsumerState<CategoryFormScreen> createState() =>
      _CategoryFormScreenState();
}

class _CategoryFormScreenState extends ConsumerState<CategoryFormScreen> {
  final _nameController = TextEditingController();
  Set<int> _parentIds = {};

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.category?.name ?? '';
    if (widget.category != null) {
      Future.microtask(() async {
        final ids = await ref
            .read(categoriesProvider.notifier)
            .getParentIds(widget.category!.id);
        if (mounted) setState(() => _parentIds = ids.toSet());
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickParents() async {
    final result = await showDialog<List<int>>(
      context: context,
      builder: (_) => CategoryMultiSelectDialog(
        initiallySelectedIds: _parentIds.toList(),
        excludeCategoryId: widget.category?.id,
      ),
    );
    if (result != null) setState(() => _parentIds = result.toSet());
  }

  Widget _parentsField() {
    final value = _parentIds.isEmpty
        ? 'Не выбраны'
        : 'Выбрано: ${_parentIds.length}';
    return InkWell(
      onTap: _pickParents,
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Родительские категории',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.arrow_drop_down),
        ),
        child: Text(value, overflow: TextOverflow.ellipsis),
      ),
    );
  }

  Future<void> _save(String? iconName) async {
    final notifier = ref.read(categoriesProvider.notifier);
    if (widget.category == null) {
      await notifier.addCategory(
        _nameController.text.trim(),
        iconName,
        _parentIds.toList(),
      );
    } else {
      await notifier.updateCategory(
        widget.category!.id,
        _nameController.text.trim(),
        iconName,
        _parentIds.toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.category != null;
    return EntityFormScreen(
      title: isEditing ? 'Редактировать категорию' : 'Новая категория',
      nameController: _nameController,
      initialIconName: widget.category?.icon,
      isEditing: isEditing,
      showDelete: isEditing,
      onCancel: widget.onCancel,
      onSave: _save,
      onDelete: isEditing
          ? (widget.onDeleteOverride ??
              () async {
                await ref
                    .read(categoriesProvider.notifier)
                    .deleteCategory(widget.category!.id);
                return true;
              })
          : null,
      extraFields: [
        const SizedBox(height: 16),
        _parentsField(),
      ],
    );
  }
}
