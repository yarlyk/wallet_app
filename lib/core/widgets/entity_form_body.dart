import 'package:flutter/material.dart';
import 'icon_picker.dart';

class EntityFormBody extends StatefulWidget {
  final TextEditingController nameController;
  final String? initialIconName;
  final ValueChanged<String>? onIconSelected;
  final List<Widget>? extraFields;
  final TextCapitalization textCapitalization;

  const EntityFormBody({
    super.key,
    required this.nameController,
    this.initialIconName,
    this.onIconSelected,
    this.extraFields,
    this.textCapitalization = TextCapitalization.words,
  });

  @override
  State<EntityFormBody> createState() => EntityFormBodyState();
}

class EntityFormBodyState extends State<EntityFormBody> {
  late String? _selectedIconName;

  String? get selectedIconName => _selectedIconName;

  @override
  void initState() {
    super.initState();
    _selectedIconName = widget.initialIconName;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      children: [
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
      ],
    );
  }
}
