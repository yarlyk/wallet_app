import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/amount_utils.dart';
import '../../../core/widgets/entity_form_screen.dart';
import '../../../core/widgets/icon_picker.dart';
import '../data/account_repository.dart';
import 'account_form_screen.dart';
import 'accounts_provider.dart';

class AccountsScreen extends ConsumerStatefulWidget {
  final VoidCallback onBack;
  const AccountsScreen({super.key, required this.onBack});

  @override
  ConsumerState<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends ConsumerState<AccountsScreen> {
  bool _showForm = false;
  Account? _editingAccount;
  AccountGroup? _editingGroup;
  bool _creatingGroup = false;
  final _groupNameController = TextEditingController();

  void _closeForm() {
    setState(() {
      _showForm = false;
      _editingAccount = null;
      _editingGroup = null;
      _creatingGroup = false;
    });
  }

  void _openCreateAccount() {
    setState(() {
      _editingAccount = null;
      _editingGroup = null;
      _creatingGroup = false;
      _showForm = true;
    });
  }

  void _openEditAccount(Account a) {
    setState(() {
      _editingAccount = a;
      _editingGroup = null;
      _creatingGroup = false;
      _showForm = true;
    });
  }

  void _openCreateGroup() {
    _groupNameController.text = '';
    setState(() {
      _creatingGroup = true;
      _editingGroup = null;
      _editingAccount = null;
      _showForm = true;
    });
  }

  void _openEditGroup(AccountGroup g) {
    _groupNameController.text = g.name;
    setState(() {
      _editingGroup = g;
      _creatingGroup = false;
      _editingAccount = null;
      _showForm = true;
    });
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  List<AccountWithCurrency> _descendantAccounts(
    int groupId,
    List<AccountGroup> groups,
    List<AccountWithCurrency> accounts,
  ) {
    final result = <AccountWithCurrency>[];
    result.addAll(accounts.where((a) => a.account.groupId == groupId));
    for (final g in groups.where((g) => g.parentId == groupId)) {
      result.addAll(_descendantAccounts(g.id, groups, accounts));
    }
    return result;
  }

  String _pluralAccounts(int n) {
    final mod10 = n % 10;
    final mod100 = n % 100;
    if (mod10 == 1 && mod100 != 11) return '$n вложенный счёт';
    if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) {
      return '$n вложенных счёта';
    }
    return '$n вложенных счетов';
  }

  String _groupBalanceLabel(
    AccountGroup group,
    List<AccountGroup> groups,
    List<AccountWithCurrency> accounts,
  ) {
    final list = _descendantAccounts(group.id, groups, accounts);
    if (list.isEmpty) return 'Группа · пусто';
    final currencyIds = list.map((a) => a.currency.id).toSet();
    if (currencyIds.length > 1) {
      return 'Группа · ${list.length} счётов';
    }
    final total = list.fold<double>(0, (s, a) => s + a.account.initialBalance);
    final symbol = list.first.currency.symbol ?? list.first.currency.code;
    return 'Группа · ${formatAmount(total)} $symbol';
  }

  Future<bool> _tryDeleteGroup(
    AccountGroup group,
    List<AccountGroup> groups,
    List<AccountWithCurrency> accounts,
  ) async {
    final count = _descendantAccounts(group.id, groups, accounts).length;
    if (count > 0) {
      if (!mounted) return false;
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Нельзя удалить группу'),
          content: Text(
            'Внутри группы ${_pluralAccounts(count)}.\n\n'
            'Переместите счета в другую группу или оставьте без группы, '
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
    await ref.read(accountsProvider.notifier).deleteGroup(group.id);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(accountsProvider);

    return stateAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Ошибка: $e')),
      data: (state) {
        if (_showForm) {
          if (_creatingGroup || _editingGroup != null) {
            final isEditing = _editingGroup != null;
            return EntityFormScreen(
              title: isEditing ? 'Редактировать группу' : 'Новая группа',
              nameController: _groupNameController,
              initialIconName: _editingGroup?.icon,
              isEditing: isEditing,
              showDelete: isEditing,
              onCancel: _closeForm,
              onSave: (icon) async {
                if (isEditing) {
                  await ref.read(accountsProvider.notifier).updateGroup(
                        _editingGroup!.id,
                        _groupNameController.text.trim(),
                        icon,
                        _editingGroup!.parentId,
                      );
                } else {
                  await ref.read(accountsProvider.notifier).addGroup(
                        _groupNameController.text.trim(),
                        icon,
                        null,
                      );
                }
              },
              onDelete: isEditing
                  ? () => _tryDeleteGroup(
                        _editingGroup!,
                        state.groups,
                        state.accounts,
                      )
                  : null,
            );
          }
          return AccountFormScreen(
            account: _editingAccount,
            groups: state.groups,
            onCancel: _closeForm,
          );
        }

        final groups = state.groups;
        final accounts = state.accounts;
        final withoutGroup =
            accounts.where((a) => a.account.groupId == null).toList();
        final topGroups = groups.where((g) => g.parentId == null).toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Счета',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  ...withoutGroup.map(_accountTile),
                  ...topGroups.map(
                    (g) => _groupTile(g, groups, accounts, 0),
                  ),
                ],
              ),
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
                    TextButton.icon(
                      onPressed: _openCreateGroup,
                      icon: const Icon(Icons.create_new_folder),
                      label: const Text('Группа'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _openCreateAccount,
                      icon: const Icon(Icons.add),
                      label: const Text('Счёт'),
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

  Widget _accountTile(AccountWithCurrency awc) {
    final a = awc.account;
    final c = awc.currency;
    final balance =
        '${formatAmount(a.initialBalance)} ${c.symbol ?? c.code}';
    return ListTile(
      leading: Icon(iconFromName(a.icon), color: Colors.indigo),
      title: Text(a.name),
      subtitle: Text('${_typeLabel(a.type)} · $balance'),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        color: Colors.indigo,
        onPressed: () => _openEditAccount(a),
      ),
      onTap: () => _openEditAccount(a),
    );
  }

  Widget _groupTile(
    AccountGroup group,
    List<AccountGroup> groups,
    List<AccountWithCurrency> accounts,
    int depth,
  ) {
    final children = groups.where((g) => g.parentId == group.id).toList();
    final items =
        accounts.where((a) => a.account.groupId == group.id).toList();

    return Padding(
      padding: EdgeInsets.only(left: 12.0 * depth),
      child: ExpansionTile(
        leading: Icon(iconFromName(group.icon)),
        title: Text(group.name),
        subtitle: Text(_groupBalanceLabel(group, groups, accounts)),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          tooltip: 'Редактировать группу',
          onPressed: () => _openEditGroup(group),
        ),
        children: [
          ...children.map((g) => _groupTile(g, groups, accounts, depth + 1)),
          ...items.map(
            (a) => Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: _accountTile(a),
            ),
          ),
        ],
      ),
    );
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'cash': return 'Наличные';
      case 'card': return 'Карта';
      case 'bank': return 'Банк';
      case 'crypto': return 'Крипто';
      case 'stocks': return 'Акции';
      default: return type;
    }
  }
}
