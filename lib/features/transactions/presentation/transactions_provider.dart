import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../data/transaction_repository.dart';

final transactionRepositoryProvider =
    Provider<TransactionRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return TransactionRepository(db);
});

final transactionsProvider =
    StreamProvider<List<TransactionWithDetails>>((ref) {
  final repo = ref.watch(transactionRepositoryProvider);
  return repo.watchAll();
});

class TransactionsNotifier {
  TransactionsNotifier(this._ref);
  final Ref _ref;

  TransactionRepository get _repo =>
      _ref.read(transactionRepositoryProvider);

  Future<int> add(TransactionsCompanion entry) => _repo.addTransaction(entry);

  Future<void> update(int id, TransactionsCompanion entry) =>
      _repo.updateTransaction(id, entry);

  Future<void> delete(int id) => _repo.deleteTransaction(id);

  Future<void> setDraft(int id, bool isDraft) => _repo.setDraft(id, isDraft);

  Future<bool> isAccountUsed(int id) => _repo.isAccountUsed(id);
  Future<bool> isCategoryUsed(int id) => _repo.isCategoryUsed(id);
  Future<bool> isProjectUsed(int id) => _repo.isProjectUsed(id);
}

final transactionsNotifierProvider =
    Provider<TransactionsNotifier>((ref) => TransactionsNotifier(ref));

