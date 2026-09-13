import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import '../../../core/database/app_database.dart';
import '../../../core/utils/amount_utils.dart';
import '../../../core/widgets/entity_form_screen.dart';
import '../../../core/widgets/group_picker_dialog.dart';
import '../../../core/widgets/project_multi_select_dialog.dart';
import '../../../core/widgets/select_dialog.dart';
import '../../currencies/presentation/currencies_provider.dart';
import 'accounts_provider.dart';

const _accountTypeOptions = <SelectOption<String>>[
  SelectOption(value: 'cash', label: 'Наличные', icon: Icons.money),
  SelectOption(value: 'card', label: 'Карта', icon: Icons.credit_card),
  SelectOption(value: 'bank', label: 'Банк', icon: Icons.account_balance),
  SelectOption(value: 'crypto', label: 'Крипто', icon: Icons.currency_bitcoin),
  SelectOption(value: 'stocks', label: 'Акции', icon: Icons.trending_up),
];

String _accountTypeLabel(String type) {
  switch (type) {
    case 'cash': return 'Наличные';
    case 'card': return 'Карта';
    case 'bank': return 'Банк';
    case 'crypto': return 'Крипто';
    case 'stocks': return 'Акции';
    default: return type;
  }
}

class AccountFormScreen extends ConsumerStatefulWidget {
  final Account? account;
  final List<AccountGroup> groups;
  final VoidCallback onCancel;

  const AccountFormScreen({
    super.key,
    this.account,
    required this.groups,
    required this.onCancel,
  });

  @override
  ConsumerState<AccountFormScreen> createState() => _AccountFormScreenState();
}

class _AccountFormScreenState extends ConsumerState<AccountFormScreen> {
  final _nameController = TextEditingController();
  final _initialBalanceController = TextEditingController();
  final _creditLimitController = TextEditingController();
  final _gracePeriodDaysController = TextEditingController();
  final _paymentDueDayController = TextEditingController();
  final _cardLast4Controller = TextEditingController();
  final _accountLast4Controller = TextEditingController();
  final _smsSenderNameController = TextEditingController();

  final _initialBalanceFocus = FocusNode();
  final _creditLimitFocus = FocusNode();

  String _selectedType = 'cash';
  int? _selectedCurrencyId;
  int? _selectedGroupId;
  bool _isCreditCard = false;
  Set<int> _selectedProjectIds = {};

  @override
  void initState() {
    super.initState();
    final a = widget.account;
    _nameController.text = a?.name ?? '';
    _initialBalanceController.text = a != null ? formatAmount(a.initialBalance) : '';
    _creditLimitController.text =
        (a != null && a.creditLimit != null) ? formatAmount(a.creditLimit!) : '';
    _gracePeriodDaysController.text = a?.gracePeriodDays?.toString() ?? '';
    _paymentDueDayController.text = a?.paymentDueDate ?? '';
    _cardLast4Controller.text = a?.cardLast4Digits ?? '';
    _accountLast4Controller.text = a?.accountLast4Digits ?? '';
    _smsSenderNameController.text = a?.smsSenderName ?? '';
    _selectedType = a?.type ?? 'cash';
    _selectedCurrencyId = a?.currencyId;
    _selectedGroupId = a?.groupId;
    _isCreditCard = a?.isCreditCard ?? false;

    _initialBalanceFocus.addListener(() {
      if (_initialBalanceFocus.hasFocus) {
        final v = parseAmount(_initialBalanceController.text);
        if (v == 0) _initialBalanceController.clear();
      }
    });
    _creditLimitFocus.addListener(() {
      if (_creditLimitFocus.hasFocus) {
        final v = parseAmount(_creditLimitController.text);
        if (v == 0) _creditLimitController.clear();
      }
    });

    if (a != null) {
      Future.microtask(() async {
        final ids = await ref
            .read(accountsProvider.notifier)
            .getProjectIdsForAccount(a.id);
        if (mounted) setState(() => _selectedProjectIds = ids.toSet());
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _initialBalanceController.dispose();
    _creditLimitController.dispose();
    _gracePeriodDaysController.dispose();
    _paymentDueDayController.dispose();
    _cardLast4Controller.dispose();
    _accountLast4Controller.dispose();
    _smsSenderNameController.dispose();
    _initialBalanceFocus.dispose();
    _creditLimitFocus.dispose();
    super.dispose();
  }

  String? _validateLast4(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.length != 4 || int.tryParse(value) == null) return 'Укажите 4 цифры';
    return null;
  }

  String? _validateDay(String? value) {
    if (value == null || value.isEmpty) return null;
    final n = int.tryParse(value);
    if (n == null || n < 1 || n > 28) return 'Число 1–28';
    return null;
  }

  Future<void> _pickGroup() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final result = await showDialog<SelectOption<int?>>(
      context: context,
      builder: (_) => const GroupPickerDialog(),
    );
    if (result == null) return;
    setState(() => _selectedGroupId = result.value);
  }

  Future<void> _pickType() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final result = await showDialog<String>(
      context: context,
      builder: (_) => SelectDialog<String>(
        title: 'Тип счёта',
        options: _accountTypeOptions,
        selectedValue: _selectedType,
      ),
    );
    if (result != null) {
      setState(() {
        _selectedType = result;
        if (result != 'card') _isCreditCard = false;
      });
    }
  }

  Future<void> _pickCurrency(List<Currency> currencies) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final result = await showDialog<int>(
      context: context,
      builder: (_) => SelectDialog<int>(
        title: 'Валюта',
        options: currencies
            .map((c) => SelectOption<int>(
                  value: c.id,
                  label: '${c.code} — ${c.name}',
                  subtitle: c.symbol,
                ))
            .toList(),
        selectedValue: _selectedCurrencyId,
      ),
    );
    if (result != null) setState(() => _selectedCurrencyId = result);
  }

  Future<void> _pickProjects() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final result = await showDialog<List<int>>(
      context: context,
      builder: (_) => ProjectMultiSelectDialog(
        initiallySelectedIds: _selectedProjectIds.toList(),
      ),
    );
    if (result != null) setState(() => _selectedProjectIds = result.toSet());
  }

  Widget _selectField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.arrow_drop_down),
        ),
        child: Text(value, overflow: TextOverflow.ellipsis),
      ),
    );
  }

  String _groupName() {
    if (_selectedGroupId == null) return 'Без группы';
    final g = widget.groups.firstWhere(
      (e) => e.id == _selectedGroupId,
      orElse: () => widget.groups.first,
    );
    return g.name;
  }

  Future<bool> _save(String? iconName) async {
    if (_selectedCurrencyId == null) return false;

    final entry = AccountsCompanion(
      groupId: Value(_selectedGroupId),
      name: Value(_nameController.text.trim()),
      icon: Value(iconName),
      type: Value(_selectedType),
      currencyId: Value(_selectedCurrencyId!),
      initialBalance: Value(parseAmount(_initialBalanceController.text)),
      isCreditCard: Value(_selectedType == 'card' && _isCreditCard),
      creditLimit: Value(_selectedType == 'card' && _isCreditCard
          ? parseAmount(_creditLimitController.text)
          : null),
      paymentDueDate: Value(_selectedType == 'card' && _isCreditCard
          ? _paymentDueDayController.text
          : null),
      gracePeriodDays: Value(_selectedType == 'card' && _isCreditCard
          ? int.tryParse(_gracePeriodDaysController.text)
          : null),
      cardLast4Digits: Value(_selectedType == 'card' &&
              _cardLast4Controller.text.isNotEmpty
          ? _cardLast4Controller.text
          : null),
      accountLast4Digits: Value(
          (_selectedType == 'card' || _selectedType == 'bank') &&
                  _accountLast4Controller.text.isNotEmpty
              ? _accountLast4Controller.text
              : null),
      smsSenderName: Value(_smsSenderNameController.text.isNotEmpty
          ? _smsSenderNameController.text
          : null),
    );

    final notifier = ref.read(accountsProvider.notifier);
    if (widget.account == null) {
      final id = await notifier.addAccount(entry);
      if (_selectedProjectIds.isNotEmpty) {
        await notifier.setProjectIdsForAccount(id, _selectedProjectIds.toList());
      }
    } else {
      await notifier.updateAccount(widget.account!.id, entry);
      await notifier.setProjectIdsForAccount(
          widget.account!.id, _selectedProjectIds.toList());
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final currenciesAsync = ref.watch(currenciesProvider);
    final currencies = currenciesAsync.value ?? [];

    if (_selectedCurrencyId == null && currencies.isNotEmpty) {
      _selectedCurrencyId = currencies.first.id;
    }

    final symbol = currencies
        .where((c) => c.id == _selectedCurrencyId)
        .map((c) => c.symbol ?? c.code)
        .firstOrNull ?? '';

    return currenciesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Ошибка: $e')),
      data: (_) => EntityFormScreen(
        title: widget.account == null ? 'Новый счёт' : 'Редактировать счёт',
        nameController: _nameController,
        initialIconName: widget.account?.icon,
        isEditing: widget.account != null,
        showDelete: widget.account != null,
        onCancel: widget.onCancel,
        onSave: _save,
        onDelete: widget.account != null
            ? () async {
                await ref
                    .read(accountsProvider.notifier)
                    .deleteAccount(widget.account!.id);
                return true;
              }
            : null,
        extraFields: [
          const SizedBox(height: 16),
          _selectField(
            label: 'Родительская группа',
            value: _groupName(),
            onTap: _pickGroup,
          ),
          const SizedBox(height: 16),
          _selectField(
            label: 'Проекты',
            value: _selectedProjectIds.isEmpty
                ? 'Не выбраны'
                : 'Выбрано: ${_selectedProjectIds.length}',
            onTap: _pickProjects,
          ),
          const SizedBox(height: 16),
          _selectField(
            label: 'Тип счёта',
            value: _accountTypeLabel(_selectedType),
            onTap: _pickType,
          ),
          const SizedBox(height: 16),
          _selectField(
            label: 'Валюта',
            value: currencies
                    .where((c) => c.id == _selectedCurrencyId)
                    .map((c) => '${c.code} — ${c.name}')
                    .firstOrNull ??
                'Не выбрана',
            onTap: () => _pickCurrency(currencies),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _initialBalanceController,
            focusNode: _initialBalanceFocus,
            decoration: InputDecoration(
              labelText: 'Начальный баланс',
              suffixText: symbol,
              border: const OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [AmountInputFormatter()],
          ),
          const SizedBox(height: 16),
          if (_selectedType == 'bank') ...[
            TextFormField(
              controller: _accountLast4Controller,
              decoration: const InputDecoration(
                labelText: 'Последние 4 цифры счёта',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              validator: _validateLast4,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _smsSenderNameController,
              decoration: const InputDecoration(
                labelText: 'Имя отправителя SMS/Push',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (_selectedType == 'card') ...[
            SwitchListTile(
              title: const Text('Кредитная карта'),
              value: _isCreditCard,
              onChanged: (v) => setState(() => _isCreditCard = v),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _cardLast4Controller,
              decoration: const InputDecoration(
                labelText: 'Последние 4 цифры карты',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              validator: _validateLast4,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _accountLast4Controller,
              decoration: const InputDecoration(
                labelText: 'Последние 4 цифры счёта карты',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              validator: _validateLast4,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _smsSenderNameController,
              decoration: const InputDecoration(
                labelText: 'Имя отправителя SMS/Push',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            if (_isCreditCard) ...[
              TextFormField(
                controller: _creditLimitController,
                focusNode: _creditLimitFocus,
                decoration: InputDecoration(
                  labelText: 'Кредитный лимит',
                  suffixText: symbol,
                  border: const OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [AmountInputFormatter()],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _gracePeriodDaysController,
                decoration: const InputDecoration(
                  labelText: 'Льготный период (дней)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _paymentDueDayController,
                decoration: const InputDecoration(
                  labelText: 'Дата погашения (число месяца 1–28)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: _validateDay,
              ),
              const SizedBox(height: 16),
            ],
          ],
        ],
      ),
    );
  }
}
