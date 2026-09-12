import 'package:flutter/material.dart';

class SelectOption<T> {
  final T value;
  final String label;
  final String? subtitle;
  final IconData? icon;

  const SelectOption({
    required this.value,
    required this.label,
    this.subtitle,
    this.icon,
  });
}

class SelectDialog<T> extends StatelessWidget {
  final String title;
  final List<SelectOption<T>> options;
  final T? selectedValue;

  const SelectDialog({
    super.key,
    required this.title,
    required this.options,
    this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: options.map((opt) {
            final isSelected = opt.value == selectedValue;
            return ListTile(
              leading: opt.icon != null ? Icon(opt.icon) : null,
              title: Text(opt.label),
              subtitle: opt.subtitle != null ? Text(opt.subtitle!) : null,
              trailing: isSelected ? const Icon(Icons.check) : null,
              selected: isSelected,
              onTap: () => Navigator.pop(context, opt.value),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
      ],
    );
  }
}
