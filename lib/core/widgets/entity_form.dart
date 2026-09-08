import 'package:flutter/material.dart';
import 'icon_picker.dart';

class EntityForm extends StatefulWidget {
  final String title;
  final TextEditingController nameController;
  final String? initialIconName;
  final ValueChanged<String>? onIconSelected;
  final List<Widget>? extraFields;
  final void Function(String? iconName) onSave;
  final VoidCallback? onDelete;
  final bool showDelete;
  final bool isEditing;
  final TextCapitalization textCapitalization;

  const EntityForm({
    Key? key,
    required this.title,
    required this.nameController,
    this.initialIconName,
    this.onIconSelected,
    this.extraFields,
    required this.onSave,
    this.onDelete,
    this.showDelete = false,
    this.isEditing = false,
    this.textCapitalization = TextCapitalization.words,
  }) : super(key: key);

  @override
  State<EntityForm> createState() => _EntityFormState();
}

class _EntityFormState extends State<EntityForm> {
  final _formKey = GlobalKey<FormState>();
  late String? _selectedIconName;

  @override
  void initState() {
    super.initState();
    _selectedIconName = widget.initialIconName;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: widget.nameController,
              textCapitalization: widget.textCapitalization,
              decoration: const InputDecoration(
                labelText: 'Название',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Введите название';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            IconPicker(
              selectedIconName: _selectedIconName,
              onIconSelected: (icon) {
                setState(() {
                  _selectedIconName = icon;
                });
                widget.onIconSelected?.call(icon);
              },
            ),
            if (widget.extraFields != null) ...widget.extraFields!,
            const SizedBox(height: 24),
            Row(
              children: [
                if (widget.showDelete)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: widget.onDelete,
                  ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Отмена'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSave(_selectedIconName);
                      Navigator.pop(context);
                    }
                  },
                  child: Text(widget.isEditing ? 'Сохранить' : 'Создать'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
