import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/widgets/counterparty_group_multi_select_dialog.dart';
import '../../../core/widgets/entity_form_screen.dart';
import 'counterparties_provider.dart';

class CounterpartyGroupFormScreen extends ConsumerStatefulWidget {
  final CounterpartyGroup? group;
  final VoidCallback onCancel;
  final Future<bool> Function()? onDeleteOverride;

  const CounterpartyGroupFormScreen({
    super.key,
    this.group,
    required this.onCancel,
    this.onDeleteOverride,
  });

  @override
  ConsumerState<CounterpartyGroupFormScreen> createState() =>
      _CounterpartyGroupFormScreenState();
}

class _CounterpartyGroupFormScreenState
    extends ConsumerState<CounterpartyGroupFormScreen> {
  final _nameController = TextEditingController();
  Set<int> _parentIds = {};

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.group?.name ?? '';
    if (widget.group != null) {
      Future.microtask(() async {
        final ids = await ref
            .read(counterpartiesProvider.notifier)
            .getParentIdsForGroup(widget.group!.id);
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
    FocusManager.instance.primaryFocus?.unfocus();
    final result = await showDialog<List<int>>(
      context: context,
      builder: (_) => CounterpartyGroupMultiSelectDialog(
        initiallySelectedIds: _parentIds.toList(),
        excludeGroupId: widget.group?.id,
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
          labelText: 'Родительские группы',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.arrow_drop_down),
        ),
        child: Text(value, overflow: TextOverflow.ellipsis),
      ),
    );
  }

  Future<void> _save(String? iconName) async {
    final notifier = ref.read(counterpartiesProvider.notifier);
    if (widget.group == null) {
      await notifier.addGroup(
        _nameController.text.trim(),
        iconName,
        _parentIds.toList(),
      );
    } else {
      await notifier.updateGroup(
        widget.group!.id,
        _nameController.text.trim(),
        iconName,
        _parentIds.toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.group != null;
    return EntityFormScreen(
      title: isEditing ? 'Редактировать группу' : 'Новая группа',
      nameController: _nameController,
      initialIconName: widget.group?.icon,
      isEditing: isEditing,
      showDelete: isEditing,
      onCancel: widget.onCancel,
      onSave: _save,
      onDelete: isEditing
          ? (widget.onDeleteOverride ??
              () async {
                await ref
                    .read(counterpartiesProvider.notifier)
                    .deleteGroup(widget.group!.id);
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

