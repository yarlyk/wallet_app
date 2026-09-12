import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:url_launcher/url_launcher.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/amount_utils.dart';
import '../../../core/widgets/calculator_dialog.dart';
import '../../../core/widgets/category_picker_dialog.dart';
import '../../../core/widgets/entity_form_screen.dart';
import '../../../core/widgets/select_dialog.dart';
import '../../accounts/data/account_repository.dart';
import '../../accounts/presentation/accounts_provider.dart';
import '../../categories/presentation/categories_provider.dart';
import '../../counterparties/presentation/counterparties_provider.dart';
import '../../projects/presentation/projects_provider.dart';
import 'transactions_provider.dart';

const _typeOptions = <SelectOption<String>>[
  SelectOption(value: 'expense', label: 'Расход', icon: Icons.remove),
  SelectOption(value: 'income', label: 'Доход', icon: Icons.add),
  SelectOption(value: 'transfer', label: 'Перевод', icon: Icons.swap_horiz),
];

class TransactionFormScreen extends ConsumerStatefulWidget {
  final Transaction? transaction;
  final VoidCallback onCancel;

  const TransactionFormScreen({
    super.key,
    this.transaction,
    required this.onCancel,
  });

  @override
  ConsumerState<TransactionFormScreen> createState() =>
      _TransactionFormScreenState();
}

class _TransactionFormScreenState
    extends ConsumerState<TransactionFormScreen> {
  final _amountController = TextEditingController();
  final _toAmountController = TextEditingController();
  final _rateController = TextEditingController();
  final _commentController = TextEditingController();

  String? _type;
  int? _accountId;
  int? _toAccountId;
  int? _categoryId;
  int? _projectId;
  int? _counterpartyId;
  DateTime _occurredAt = DateTime.now();
  bool _isDraft = true;

  @override
  void initState() {
    super.initState();
    final t = widget.transaction;
    if (t != null) {
      _type = t.type;
      _amountController.text = formatAmount(t.amount);
      _toAmountController.text =
          t.toAmount != null ? formatAmount(t.toAmount!) : '';
      _rateController.text =
          t.rate != null ? t.rate!.toString().replaceAll('.', ',') : '';
      _commentController.text = t.comment ?? '';
      _accountId = t.accountId;
      _toAccountId = t.toAccountId;
      _categoryId = t.categoryId;
      _projectId = t.projectId;
      _counterpartyId = t.counterpartyId;
      _occurredAt = t.occurredAt;
      _isDraft = t.isDraft;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _toAmountController.dispose();
    _rateController.dispose();
    _commentController.dispose();
    super.dispose();
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

  Future<void> _pickType() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final r = await showDialog<String>(
      context: context,
      builder: (_) => SelectDialog<String>(
        title: 'Тип операции',
        options: _typeOptions,
        selectedValue: _type,
      ),
    );
    if (r != null) {
      setState(() {
        _type = r;
        if (_type != 'transfer') _toAccountId = null;
      });
    }
  }

  Future<void> _pickAccount({required bool isTo}) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final state = ref.read(accountsProvider).value;
    if (state == null) return;
    final options = <SelectOption<int>>[];
    for (final awc in state.accounts) {
      if (!isTo && awc.account.id == _toAccountId) continue;
      if (isTo && awc.account.id == _accountId) continue;
      options.add(SelectOption(
        value: awc.account.id,
        label: awc.account.name,
        subtitle:
            '${awc.currency.code} · ${formatAmount(awc.balance)} ${awc.currency.symbol ?? awc.currency.code}',
      ));
    }
    final r = await showDialog<int>(
      context: context,
      builder: (_) => SelectDialog<int>(
        title: isTo ? 'Счёт получателя' : 'Счёт',
        options: options,
        selectedValue: isTo ? _toAccountId : _accountId,
      ),
    );
    if (r != null) {
      setState(() {
        if (isTo) {
          _toAccountId = r;
        } else {
          _accountId = r;
        }
      });
    }
  }

  void _swapAccounts() {
    setState(() {
      final tmp = _accountId;
      _accountId = _toAccountId;
      _toAccountId = tmp;
      final tmpAmount = _amountController.text;
      _amountController.text = _toAmountController.text;
      _toAmountController.text = tmpAmount;
      _rateController.clear();
    });
  }

  AccountWithCurrency? _accountById(int? id) {
    if (id == null) return null;
    final state = ref.read(accountsProvider).value;
    if (state == null) return null;
    final found = state.accounts.where((a) => a.account.id == id).toList();
    return found.isEmpty ? null : found.first;
  }

  bool get _isTransferDifferentCurrency {
    if (_type != 'transfer') return false;
    final from = _accountById(_accountId);
    final to = _accountById(_toAccountId);
    if (from == null || to == null) return false;
    return from.currency.id != to.currency.id;
  }

  String _currencySymbol(int? accountId) {
    final awc = _accountById(accountId);
    if (awc == null) return '';
    return awc.currency.symbol ?? awc.currency.code;
  }

  Future<void> _pickCategory() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final r = await showDialog<int>(
      context: context,
      builder: (_) => const CategoryPickerDialog(),
    );
    if (r != null) setState(() => _categoryId = r);
  }

  Future<void> _pickProject() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final projects = ref.read(projectsProvider).value;
    if (projects == null) return;
    final r = await showDialog<int>(
      context: context,
      builder: (_) => SelectDialog<int>(
        title: 'Проект',
        options: projects
            .map((p) => SelectOption(value: p.id, label: p.name))
            .toList(),
        selectedValue: _projectId,
      ),
    );
    if (r != null) setState(() => _projectId = r);
  }

  Future<void> _pickCounterparty() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final state = ref.read(counterpartiesProvider).value;
    if (state == null) return;
    final options = <SelectOption<int>>[
      const SelectOption(value: -1, label: 'Без контрагента'),
      ...state.counterparties.map(
          (c) => SelectOption(value: c.id, label: c.name)),
    ];
    final r = await showDialog<int>(
      context: context,
      builder: (_) => SelectDialog<int>(
        title: 'Контрагент',
        options: options,
        selectedValue: _counterpartyId ?? -1,
      ),
    );
    if (r != null) {
      setState(() => _counterpartyId = r == -1 ? null : r);
    }
  }

  Future<void> _pickDateTime() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final date = await showDatePicker(
      context: context,
      initialDate: _occurredAt,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;
    if (!mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_occurredAt),
    );
    setState(() {
      _occurredAt = DateTime(
        date.year, date.month, date.day,
        time?.hour ?? _occurredAt.hour,
        time?.minute ?? _occurredAt.minute,
      );
    });
  }

  Future<void> _pickAmountViaCalculator() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final current = parseAmount(_amountController.text);
    final result = await showDialog<double>(
      context: context,
      builder: (_) => CalculatorDialog(
        initialValue: current == 0 ? null : current,
      ),
    );
    if (result != null) {
      setState(() {
        _amountController.text = formatAmount(result);
      });
      _recalcToAmountFromRate();
    }
  }

  /// Пересчитывает toAmount по курсу (если введены amount и rate).
  void _recalcToAmountFromRate() {
    if (!_isTransferDifferentCurrency) return;
    final amount = parseAmount(_amountController.text);
    final rate = _parseRate();
    if (amount > 0 && rate != null && rate > 0) {
      setState(() {
        _toAmountController.text = formatAmount(amount / rate);
      });
    }
  }


  /// Курс из полей amount и toAmount (ЦБ-стиль: RUB за 1 единицу валюты).
  void _recalcRateFromAmounts() {
    if (!_isTransferDifferentCurrency) return;
    final amount = parseAmount(_amountController.text);
    final toAmount = parseAmount(_toAmountController.text);
    if (amount > 0 && toAmount > 0) {
      setState(() {
        _rateController.text =
            (amount / toAmount).toStringAsFixed(4).replaceAll('.', ',');
      });
    }
  }

  double? _parseRate() {
    final raw = _rateController.text.trim();
    if (raw.isEmpty) return null;
    if (raw.endsWith(',') || raw.endsWith('.')) return null;
    return double.tryParse(raw.replaceAll(',', '.'));
  }

  String _accountName(int? id) {
    if (id == null) return 'Не выбран';
    final awc = _accountById(id);
    return awc?.account.name ?? 'Не выбран';
  }

  String _categoryName() {
    if (_categoryId == null) return 'Без категории';
    final state = ref.read(categoriesProvider).value;
    if (state == null) return 'Без категории';
    final found = state.categories.where((c) => c.id == _categoryId).toList();
    return found.isEmpty ? 'Без категории' : found.first.name;
  }

  String _projectName() {
    if (_projectId == null) return 'Не выбран';
    final list = ref.read(projectsProvider).value;
    if (list == null) return 'Не выбран';
    final found = list.where((p) => p.id == _projectId).toList();
    return found.isEmpty ? 'Не выбран' : found.first.name;
  }

  Counterparty? _selectedCounterparty() {
    if (_counterpartyId == null) return null;
    final state = ref.read(counterpartiesProvider).value;
    if (state == null) return null;
    final found =
        state.counterparties.where((c) => c.id == _counterpartyId).toList();
    return found.isEmpty ? null : found.first;
  }

  String _counterpartyName() {
    final cp = _selectedCounterparty();
    return cp?.name ?? 'Без контрагента';
  }

  Future<void> _callCounterparty(String phone) async {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return;
    final uri = Uri(scheme: 'tel', path: '+$digits');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _emailCounterparty(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Widget _counterpartyField() {
    final cp = _selectedCounterparty();
    final hasPhone = cp?.phone != null && cp!.phone!.isNotEmpty;
    final hasEmail = cp?.email != null && cp!.email!.isNotEmpty;

    return InkWell(
      onTap: _pickCounterparty,
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Контрагент',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.arrow_drop_down),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _counterpartyName(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (cp != null && hasPhone)
              IconButton(
                icon: const Icon(Icons.phone, color: Colors.green),
                onPressed: () => _callCounterparty(cp.phone!),
                tooltip: 'Позвонить',
              ),
            if (cp != null && hasEmail)
              IconButton(
                icon: const Icon(Icons.email, color: Colors.indigo),
                onPressed: () => _emailCounterparty(cp.email!),
                tooltip: 'Написать',
              ),
          ],
        ),
      ),
    );
  }

  String _typeLabel() {
    if (_type == null) return 'Не выбран';
    return _typeOptions.firstWhere((o) => o.value == _type).label;
  }

  String _rateLabel() {
    if (_type != 'transfer') return 'Курс';
    final fromCur = _accountById(_accountId)?.currency;
    final toCur = _accountById(_toAccountId)?.currency;
    if (fromCur == null || toCur == null) return 'Курс';
    final fromSym = fromCur.symbol ?? fromCur.code;
    final toSym = toCur.symbol ?? toCur.code;
    return 'Курс ($fromSym/$toSym)';
  }

  Future<void> _save(String? _) async {
    if (_type == null) return;
    final amount = parseAmount(_amountController.text);
    if (amount <= 0) return;
    if (_accountId == null) return;
    if (_type != 'transfer' && _projectId == null) return;
    if (_type == 'transfer' && _toAccountId == null) return;
    if (_type != 'transfer' && _categoryId == null) return;

    final entry = TransactionsCompanion(
      type: Value(_type!),
      amount: Value(amount),
      occurredAt: Value(_occurredAt),
      accountId: Value(_accountId!),
      toAccountId: Value(_type == 'transfer' ? _toAccountId : null),
      categoryId: Value(_type == 'transfer' ? null : _categoryId),
      projectId: Value(_type == 'transfer' ? null : _projectId),
      counterpartyId: Value(_counterpartyId),
      comment: Value(
          _commentController.text.trim().isEmpty
              ? null
              : _commentController.text.trim()),
      rate: Value(_type == 'transfer' && _isTransferDifferentCurrency
          ? _parseRate()
          : null),
      toAmount: Value(_type == 'transfer' && _isTransferDifferentCurrency
          ? parseAmount(_toAmountController.text)
          : null),
      isDraft: Value(_isDraft),
    );

    final notifier = ref.read(transactionsNotifierProvider);
    if (widget.transaction == null) {
      await notifier.add(entry);
    } else {
      await notifier.update(widget.transaction!.id, entry);
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(projectsProvider);
    final projects = projectsAsync.value ?? [];
    if (_projectId == null && projects.length == 1) {
      _projectId = projects.first.id;
    }

    final accountsAsync = ref.watch(accountsProvider);
    if (accountsAsync.value == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (projectsAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    ref.watch(categoriesProvider);
    ref.watch(counterpartiesProvider);

    final isEditing = widget.transaction != null;
    final isTransfer = _type == 'transfer';
    final showDifferentCurrency = _isTransferDifferentCurrency;
    final fromSymbol = _currencySymbol(_accountId);
    final toSymbol = _currencySymbol(_toAccountId);

    return EntityFormScreen(
      title: isEditing ? 'Редактировать операцию' : 'Новая операция',
      nameController: _commentController,
      nameLabel: 'Комментарий',
      nameRequired: false,
      showIconPicker: false,
      isEditing: isEditing,
      showDelete: isEditing,
      onDelete: isEditing
          ? () async {
              await ref
                  .read(transactionsNotifierProvider)
                  .delete(widget.transaction!.id);
              return true;
            }
          : null,
      onCancel: widget.onCancel,
      onSave: _save,
      textCapitalization: TextCapitalization.sentences,
      extraFields: [
        const SizedBox(height: 16),
        _selectField(
          label: 'Тип',
          value: _typeLabel(),
          onTap: _pickType,
        ),
        if (_type == null) ...[
          const SizedBox(height: 24),
          const Center(
            child: Text(
              'Выберите тип операции, чтобы продолжить',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
        if (_type != null) ...[
          const SizedBox(height: 16),
          TextFormField(
            controller: _amountController,
            readOnly: true,
            showCursor: false,
            decoration: InputDecoration(
              labelText: 'Сумма',
              border: const OutlineInputBorder(),
              suffixText: fromSymbol.isEmpty ? null : fromSymbol,
              suffixIcon: const Icon(Icons.calculate),
            ),
            onTap: _pickAmountViaCalculator,
          ),
          const SizedBox(height: 16),
          _selectField(
            label: isTransfer ? 'Счёт-отправитель' : 'Счёт',
            value: _accountName(_accountId),
            onTap: () => _pickAccount(isTo: false),
          ),
          if (isTransfer) ...[
            const SizedBox(height: 8),
            Center(
              child: IconButton(
                onPressed: _swapAccounts,
                icon: const Icon(Icons.swap_vert),
                tooltip: 'Поменять счета местами',
              ),
            ),
            const SizedBox(height: 8),
            _selectField(
              label: 'Счёт-получатель',
              value: _accountName(_toAccountId),
              onTap: () => _pickAccount(isTo: true),
            ),
            if (showDifferentCurrency) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _rateController,
                decoration: InputDecoration(
                  labelText: _rateLabel(),
                  border: const OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (v) {
                  if (v.endsWith(',') || v.endsWith('.')) return;
                  _recalcToAmountFromRate();
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _toAmountController,
                decoration: InputDecoration(
                  labelText: 'Сумма во второй валюте',
                  border: const OutlineInputBorder(),
                  suffixText: toSymbol.isEmpty ? null : toSymbol,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calculate),
                    onPressed: () async {
                      final current = parseAmount(_toAmountController.text);
                      final result = await showDialog<double>(
                        context: context,
                        builder: (_) => CalculatorDialog(
                          initialValue: current == 0 ? null : current,
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          _toAmountController.text = formatAmount(result);
                        });
                        _recalcRateFromAmounts();
                      }
                    },
                  ),
                ),
                readOnly: true,
                showCursor: false,
                onTap: () async {
                  final current = parseAmount(_toAmountController.text);
                  final result = await showDialog<double>(
                    context: context,
                    builder: (_) => CalculatorDialog(
                      initialValue: current == 0 ? null : current,
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      _toAmountController.text = formatAmount(result);
                    });
                    _recalcRateFromAmounts();
                  }
                },
              ),
            ],
          ],
          if (!isTransfer) ...[
            const SizedBox(height: 16),
            _selectField(
              label: 'Категория',
              value: _categoryName(),
              onTap: _pickCategory,
            ),
            const SizedBox(height: 16),
            _counterpartyField(),
            const SizedBox(height: 16),
            _selectField(
              label: 'Проект',
              value: _projectName(),
              onTap: _pickProject,
            ),
          ],
          const SizedBox(height: 16),
          _selectField(
            label: 'Дата и время',
            value: '${_occurredAt.day.toString().padLeft(2, '0')}.'
                '${_occurredAt.month.toString().padLeft(2, '0')}.'
                '${_occurredAt.year} '
                '${_occurredAt.hour.toString().padLeft(2, '0')}:'
                '${_occurredAt.minute.toString().padLeft(2, '0')}',
            onTap: _pickDateTime,
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Черновик'),
            subtitle: const Text('Не влияет на баланс до подтверждения'),
            value: _isDraft,
            onChanged: (v) => setState(() => _isDraft = v),
          ),
        ],
      ],
    );
  }
}






