import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';

class TransactionWithDetails {
  final Transaction transaction;
  final Account fromAccount;
  final Account? toAccount;
  final Category? category;
  final Project? project;
  final Counterparty? counterparty;
  final Currency fromCurrency;
  final Currency? toCurrency;

  TransactionWithDetails({
    required this.transaction,
    required this.fromAccount,
    this.toAccount,
    this.category,
    this.project,
    this.counterparty,
    required this.fromCurrency,
    this.toCurrency,
  });
}

class TransactionRepository {
  TransactionRepository(this._db);
  final AppDatabase _db;

  Stream<List<TransactionWithDetails>> watchAll() {
    return (_db.select(_db.transactions)
          ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)]))
        .watch()
        .asyncMap(_hydrate);
  }

  Future<List<TransactionWithDetails>> _hydrate(
      List<Transaction> transactions) async {
    if (transactions.isEmpty) return [];

    final accountIds = <int>{};
    final categoryIds = <int>{};
    final projectIds = <int>{};
    final counterpartyIds = <int>{};
    for (final t in transactions) {
      accountIds.add(t.accountId);
      if (t.toAccountId != null) accountIds.add(t.toAccountId!);
      if (t.categoryId != null) categoryIds.add(t.categoryId!);
      if (t.projectId != null) projectIds.add(t.projectId!);
      if (t.counterpartyId != null) counterpartyIds.add(t.counterpartyId!);
    }

    final accounts = await (_db.select(_db.accounts)
          ..where((a) => a.id.isIn(accountIds)))
        .get();
    final currencies = await (_db.select(_db.currencies)
          ..where((c) => c.id.isIn(
              accounts.map((a) => a.currencyId).toSet().toList())))
        .get();
    final categories = categoryIds.isEmpty
        ? <Category>[]
        : await (_db.select(_db.categories)
              ..where((c) => c.id.isIn(categoryIds.toList())))
            .get();
    final projects = projectIds.isEmpty
        ? <Project>[]
        : await (_db.select(_db.projects)
              ..where((p) => p.id.isIn(projectIds.toList())))
            .get();
    final counterparties = counterpartyIds.isEmpty
        ? <Counterparty>[]
        : await (_db.select(_db.counterparties)
              ..where((c) => c.id.isIn(counterpartyIds.toList())))
            .get();

    final accById = {for (final a in accounts) a.id: a};
    final curById = {for (final c in currencies) c.id: c};
    final catById = {for (final c in categories) c.id: c};
    final projById = {for (final p in projects) p.id: p};
    final cpById = {for (final c in counterparties) c.id: c};

    final result = <TransactionWithDetails>[];
    for (final t in transactions) {
      final fromAcc = accById[t.accountId];
      if (fromAcc == null) continue;
      final fromCur = curById[fromAcc.currencyId];
      if (fromCur == null) continue;

      final toAcc = t.toAccountId != null ? accById[t.toAccountId] : null;
      final toCur = toAcc != null ? curById[toAcc.currencyId] : null;

      result.add(TransactionWithDetails(
        transaction: t,
        fromAccount: fromAcc,
        toAccount: toAcc,
        category: t.categoryId != null ? catById[t.categoryId] : null,
        project: t.projectId != null ? projById[t.projectId] : null,
        counterparty:
            t.counterpartyId != null ? cpById[t.counterpartyId] : null,
        fromCurrency: fromCur,
        toCurrency: toCur,
      ));
    }
    return result;
  }

  Future<int> addTransaction(TransactionsCompanion entry) =>
      _db.into(_db.transactions).insert(entry);

  Future<void> updateTransaction(int id, TransactionsCompanion entry) =>
      (_db.update(_db.transactions)..where((t) => t.id.equals(id)))
          .write(entry.copyWith(updatedAt: Value(DateTime.now())));

  Future<void> deleteTransaction(int id) =>
      (_db.delete(_db.transactions)..where((t) => t.id.equals(id))).go();

  Future<void> setDraft(int id, bool isDraft) =>
      (_db.update(_db.transactions)..where((t) => t.id.equals(id)))
          .write(TransactionsCompanion(
        isDraft: Value(isDraft),
        updatedAt: Value(DateTime.now()),
      ));

  /// Сколько транзакций ссылается на счёт (как на источник или получателя).
  Future<int> countTransactionsForAccount(int accountId) async {
    final expr = _db.transactions.id.count();
    final query = _db.selectOnly(_db.transactions)
      ..addColumns([expr])
      ..where(_db.transactions.accountId.equals(accountId) |
          _db.transactions.toAccountId.equals(accountId));
    final row = await query.getSingle();
    return row.read(expr) ?? 0;
  }

  /// Сколько транзакций ссылается на категорию.
  Future<int> countTransactionsForCategory(int categoryId) async {
    final expr = _db.transactions.id.count();
    final query = _db.selectOnly(_db.transactions)
      ..addColumns([expr])
      ..where(_db.transactions.categoryId.equals(categoryId));
    final row = await query.getSingle();
    return row.read(expr) ?? 0;
  }

  /// Сколько транзакций ссылается на проект.
  Future<int> countTransactionsForProject(int projectId) async {
    final expr = _db.transactions.id.count();
    final query = _db.selectOnly(_db.transactions)
      ..addColumns([expr])
      ..where(_db.transactions.projectId.equals(projectId));
    final row = await query.getSingle();
    return row.read(expr) ?? 0;
  }

  /// Сколько транзакций ссылается на контрагента.
  Future<int> countTransactionsForCounterparty(int counterpartyId) async {
    final expr = _db.transactions.id.count();
    final query = _db.selectOnly(_db.transactions)
      ..addColumns([expr])
      ..where(_db.transactions.counterpartyId.equals(counterpartyId));
    final row = await query.getSingle();
    return row.read(expr) ?? 0;
  }
}
