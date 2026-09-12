import 'package:flutter/material.dart';
import 'entity_form_body.dart';

class EntityFormScreen extends StatefulWidget {
  final String title;
  final TextEditingController nameController;
  final String? initialIconName;
  final ValueChanged<String>? onIconSelected;
  final List<Widget>? extraFields;
  final Future<void> Function(String? iconName) onSave;
  final Future<bool> Function()? onDelete;
  final bool showDelete;
  final bool isEditing;
  final VoidCallback onCancel;
  final TextCapitalization textCapitalization;
  final IconData? nameSuffixIcon;
  final VoidCallback? onNameSuffixIconTap;

  const EntityFormScreen({
    super.key,
    required this.title,
    required this.nameController,
    this.initialIconName,
    this.onIconSelected,
    this.extraFields,
    required this.onSave,
    this.onDelete,
    this.showDelete = false,
    this.isEditing = false,
    required this.onCancel,
    this.textCapitalization = TextCapitalization.words,
    this.nameSuffixIcon,
    this.onNameSuffixIconTap,
  });

  @override
  State<EntityFormScreen> createState() => _EntityFormScreenState();
}

class _EntityFormScreenState extends State<EntityFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bodyKey = GlobalKey<EntityFormBodyState>();
  bool _saving = false;

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await widget.onSave(_bodyKey.currentState?.selectedIconName);
      if (mounted) widget.onCancel();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _handleDelete() async {
    if (widget.onDelete == null) return;
    setState(() => _saving = true);
    try {
      final deleted = await widget.onDelete!.call();
      if (deleted && mounted) widget.onCancel();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Form(
            key: _formKey,
            child: EntityFormBody(
              key: _bodyKey,
              nameController: widget.nameController,
              initialIconName: widget.initialIconName,
              onIconSelected: widget.onIconSelected,
              extraFields: widget.extraFields,
              textCapitalization: widget.textCapitalization,
              nameSuffixIcon: widget.nameSuffixIcon,
              onNameSuffixIconTap: widget.onNameSuffixIconTap,
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                if (widget.showDelete)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: _saving ? null : _handleDelete,
                  ),
                const Spacer(),
                TextButton(
                  onPressed: _saving ? null : widget.onCancel,
                  child: const Text('Отмена'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _saving ? null : _handleSave,
                  child: Text(widget.isEditing ? 'Сохранить' : 'Создать'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
