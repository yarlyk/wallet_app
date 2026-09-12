import 'package:flutter/material.dart';
import 'icon_picker.dart';

class EntityFormBody extends StatefulWidget {
  final TextEditingController nameController;
  final String? initialIconName;
  final ValueChanged<String>? onIconSelected;
  final List<Widget>? extraFields;
  final TextCapitalization textCapitalization;
  final IconData? nameSuffixIcon;
  final VoidCallback? onNameSuffixIconTap;
  final String nameLabel;
  final bool nameRequired;
  final bool showIconPicker;

  const EntityFormBody({
    super.key,
    required this.nameController,
    this.initialIconName,
    this.onIconSelected,
    this.extraFields,
    this.textCapitalization = TextCapitalization.words,
    this.nameSuffixIcon,
    this.onNameSuffixIconTap,
    this.nameLabel = 'Название',
    this.nameRequired = true,
    this.showIconPicker = true,
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
          decoration: InputDecoration(
            labelText: widget.nameLabel,
            border: const OutlineInputBorder(),
            suffixIcon: widget.nameSuffixIcon != null
                ? IconButton(
                    icon: Icon(widget.nameSuffixIcon, color: Colors.indigo),
                    onPressed: widget.onNameSuffixIconTap,
                    tooltip: 'Выбрать из контактов',
                  )
                : null,
          ),
          validator: widget.nameRequired
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Введите название';
                  }
                  return null;
                }
              : null,
        ),
        if (widget.showIconPicker) ...[
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
        ],
        if (widget.extraFields != null) ...widget.extraFields!,
      ],
    );
  }
}
