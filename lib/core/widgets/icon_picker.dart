import 'package:flutter/material.dart';

class IconPicker extends StatefulWidget {
  final String? selectedIconName;
  final ValueChanged<String> onIconSelected;

  const IconPicker({
    Key? key,
    this.selectedIconName,
    required this.onIconSelected,
  }) : super(key: key);

  @override
  State<IconPicker> createState() => _IconPickerState();
}

class _IconPickerState extends State<IconPicker> {
  static const Map<String, IconData> availableIcons = {
    'folder': Icons.folder,
    'home': Icons.home,
    'star': Icons.star,
    'work': Icons.work,
    'shopping_cart': Icons.shopping_cart,
    'account_balance_wallet': Icons.account_balance_wallet,
    'credit_card': Icons.credit_card,
    'account_balance': Icons.account_balance,
    'receipt': Icons.receipt,
    'category': Icons.category,
    'person': Icons.person,
    'group': Icons.group,
    'settings': Icons.settings,
    'favorite': Icons.favorite,
    'flag': Icons.flag,
    'attach_money': Icons.attach_money,
  };

  static const Map<String, String> iconLabels = {
    'folder': 'Папка',
    'home': 'Дом',
    'star': 'Звезда',
    'work': 'Работа',
    'shopping_cart': 'Корзина',
    'account_balance_wallet': 'Кошелёк',
    'credit_card': 'Карта',
    'account_balance': 'Банк',
    'receipt': 'Чек',
    'category': 'Категория',
    'person': 'Человек',
    'group': 'Группа',
    'settings': 'Настройки',
    'favorite': 'Избранное',
    'flag': 'Флаг',
    'attach_money': 'Деньги',
  };

  Future<void> _selectIcon() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return GridView.count(
          crossAxisCount: 4,
          children: availableIcons.entries.map((entry) {
            return InkWell(
              onTap: () => Navigator.pop(context, entry.key),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(entry.value, size: 32),
                  const SizedBox(height: 4),
                  Text(
                    iconLabels[entry.key] ?? entry.key,
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
    if (selected != null) {
      widget.onIconSelected(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _selectIcon,
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Иконка',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.arrow_drop_down),
        ),
        child: widget.selectedIconName == null
            ? const Text('Не выбрана')
            : Row(
                children: [
                  Icon(availableIcons[widget.selectedIconName] ?? Icons.help),
                  const SizedBox(width: 8),
                  Text(iconLabels[widget.selectedIconName] ?? widget.selectedIconName!),
                ],
              ),
      ),
    );
  }
}
