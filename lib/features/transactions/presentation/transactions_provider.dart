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

  Future<int> countForAccount(int id) =>
      _repo.countTransactionsForAccount(id);
  Future<int> countForCategory(int id) =>
      _repo.countTransactionsForCategory(id);
  Future<int> countForProject(int id) =>
      _repo.countTransactionsForProject(id);
  Future<int> countForCounterparty(int id) =>
      _repo.countTransactionsForCounterparty(id);
}

final transactionsNotifierProvider =
    Provider<TransactionsNotifier>((ref) => TransactionsNotifier(ref));
