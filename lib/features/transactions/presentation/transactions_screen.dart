import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/amount_utils.dart';
import '../data/transaction_repository.dart';
import 'transaction_form_screen.dart';
import 'transactions_provider.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  bool _showForm = false;
  Transaction? _editing;

  void _openCreate() {
    setState(() {
      _editing = null;
      _showForm = true;
    });
  }

  void _openEdit(TransactionWithDetails t) {
    setState(() {
      _editing = t.transaction;
      _showForm = true;
    });
  }

  void _closeForm() {
    setState(() {
      _showForm = false;
      _editing = null;
    });
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'expense': return Icons.remove;
      case 'income': return Icons.add;
      case 'transfer': return Icons.swap_horiz;
      default: return Icons.help_outline;
    }
  }

  Color _amountColor(String type) {
    switch (type) {
      case 'expense': return Colors.red;
      case 'income': return Colors.green;
      case 'transfer': return Colors.grey.shade700;
      default: return Colors.black87;
    }
  }

  String _amountText(TransactionWithDetails t) {
    final tx = t.transaction;
    final currency = t.fromCurrency.symbol ?? t.fromCurrency.code;
    final sign = tx.type == 'expense'
        ? '−'
        : tx.type == 'income'
            ? '+'
            : '';
    return '$sign${formatAmount(tx.amount)} $currency';
  }

  String? _secondAmountText(TransactionWithDetails t) {
    final tx = t.transaction;
    if (tx.type != 'transfer') return null;
    if (t.toCurrency == null || tx.toAmount == null) return null;
    if (t.fromCurrency.id == t.toCurrency!.id) return null;
    final toCurrency = t.toCurrency!.symbol ?? t.toCurrency!.code;
    return '+${formatAmount(tx.toAmount!)} $toCurrency';
  }

  String _subtitle(TransactionWithDetails t) {
    final tx = t.transaction;
    final from = t.fromAccount.name;
    if (tx.type == 'transfer' && t.toAccount != null) {
      return '$from → ${t.toAccount!.name}';
    }
    final parts = <String>[
      from,
      if (t.category != null) t.category!.name,
      if (t.project != null) t.project!.name,
    ];
    return parts.join(' · ');
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}.'
        '${dt.month.toString().padLeft(2, '0')}.'
        '${dt.year} '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_showForm) {
      return TransactionFormScreen(
        transaction: _editing,
        onCancel: _closeForm,
      );
    }

    final async = ref.watch(transactionsProvider);

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Ошибка: $e')),
      data: (list) {
        final drafts = list.where((t) => t.transaction.isDraft).toList();
        final done = list.where((t) => !t.transaction.isDraft).toList();

        return Stack(
          children: [
            if (list.isEmpty)
              const Center(child: Text('Нет операций'))
            else
              ListView(
                children: [
                  if (drafts.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: Text(
                        'Черновики',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    for (final t in drafts) _tile(t, isDraft: true),
                  ],
                  if (done.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: Text(
                        'Проведённые',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    for (final t in done) _tile(t, isDraft: false),
                  ],
                ],
              ),
            Positioned(
              right: 16,
              bottom: 16,
              child: FloatingActionButton(
                onPressed: _openCreate,
                child: const Icon(Icons.add),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _tile(TransactionWithDetails t, {required bool isDraft}) {
    final tx = t.transaction;
    final second = _secondAmountText(t);
    return ListTile(
      leading: isDraft
          ? Checkbox(
              value: false,
              onChanged: (_) {
                ref.read(transactionsNotifierProvider).setDraft(tx.id, false);
              },
            )
          : Icon(_typeIcon(tx.type), color: _amountColor(tx.type)),
      title: Text(_subtitle(t)),
      subtitle: Text(_formatDateTime(tx.occurredAt)),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _amountText(t),
            style: TextStyle(
              color: _amountColor(tx.type),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          if (second != null)
            Text(
              second,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
        ],
      ),
      onTap: () => _openEdit(t),
    );
  }
}
