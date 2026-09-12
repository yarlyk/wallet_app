import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';

class AccountWithCurrency {
  final Account account;
  final Currency currency;
  final double balance;
  AccountWithCurrency(this.account, this.currency, {required this.balance});
}

class AccountRepository {
  AccountRepository(this._db);
  final AppDatabase _db;

  // Группы
  Stream<List<AccountGroup>> watchActiveGroups() {
    return (_db.select(_db.accountGroups)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<int> addGroup(AccountGroupsCompanion entry) =>
      _db.into(_db.accountGroups).insert(entry);

  Future<void> updateGroup(int id, AccountGroupsCompanion entry) =>
      (_db.update(_db.accountGroups)..where((t) => t.id.equals(id))).write(entry);

  Future<void> deleteGroup(int id) =>
      (_db.update(_db.accountGroups)..where((t) => t.id.equals(id)))
          .write(const AccountGroupsCompanion(isActive: Value(false)));

  // Счета с валютой и вычисленным балансом
  Stream<List<AccountWithCurrency>> watchActiveAccounts() {
    return _db
        .customSelect(
          '''
          SELECT
            a.id AS a_id,
            a.group_id AS a_group_id,
            a.name AS a_name,
            a.icon AS a_icon,
            a.type AS a_type,
            a.currency_id AS a_currency_id,
            a.initial_balance AS a_initial_balance,
            a.is_active AS a_is_active,
            a.is_credit_card AS a_is_credit_card,
            a.credit_limit AS a_credit_limit,
            a.payment_due_date AS a_payment_due_date,
            a.grace_period_days AS a_grace_period_days,
            a.card_last4_digits AS a_card_last4_digits,
            a.account_last4_digits AS a_account_last4_digits,
            a.sms_sender_name AS a_sms_sender_name,
            c.id AS c_id,
            c.code AS c_code,
            c.name AS c_name,
            c.symbol AS c_symbol,
            c.is_active AS c_is_active,
            c.num_code AS c_num_code,
            c.nominal AS c_nominal,
            c.country AS c_country,
            a.initial_balance + COALESCE((
              SELECT SUM(
                CASE
                  WHEN t.type = 'income' THEN t.amount
                  WHEN t.type = 'expense' THEN -t.amount
                  WHEN t.type = 'transfer' AND t.account_id = a.id THEN -t.amount
                  WHEN t.type = 'transfer' AND t.to_account_id = a.id THEN COALESCE(t.to_amount, t.amount)
                  ELSE 0
                END
              )
              FROM transactions t
              WHERE (t.account_id = a.id OR t.to_account_id = a.id)
                AND t.is_draft = 0
            ), 0) AS computed_balance
          FROM accounts a
          INNER JOIN currencies c ON c.id = a.currency_id
          WHERE a.is_active = 1
          ORDER BY a.name
          ''',
          readsFrom: {_db.accounts, _db.currencies, _db.transactions},
        )
        .watch()
        .map((rows) {
      return rows.map((row) {
        final account = Account(
          id: row.read<int>('a_id'),
          groupId: row.read<int?>('a_group_id'),
          name: row.read<String>('a_name'),
          icon: row.read<String?>('a_icon'),
          type: row.read<String>('a_type'),
          currencyId: row.read<int>('a_currency_id'),
          initialBalance: row.read<double>('a_initial_balance'),
          isActive: row.read<int>('a_is_active') == 1,
          isCreditCard: row.read<int>('a_is_credit_card') == 1,
          creditLimit: row.read<double?>('a_credit_limit'),
          paymentDueDate: row.read<String?>('a_payment_due_date'),
          gracePeriodDays: row.read<int?>('a_grace_period_days'),
          cardLast4Digits: row.read<String?>('a_card_last4_digits'),
          accountLast4Digits: row.read<String?>('a_account_last4_digits'),
          smsSenderName: row.read<String?>('a_sms_sender_name'),
        );
        final currency = Currency(
          id: row.read<int>('c_id'),
          code: row.read<String>('c_code'),
          name: row.read<String>('c_name'),
          symbol: row.read<String?>('c_symbol'),
          isActive: row.read<int>('c_is_active') == 1,
          numCode: row.read<int>('c_num_code'),
          nominal: row.read<int>('c_nominal'),
          country: row.read<String?>('c_country'),
        );
        return AccountWithCurrency(
          account,
          currency,
          balance: row.read<double>('computed_balance'),
        );
      }).toList();
    });
  }

  Future<int> addAccount(AccountsCompanion entry) =>
      _db.into(_db.accounts).insert(entry);

  Future<void> updateAccount(int id, AccountsCompanion entry) =>
      (_db.update(_db.accounts)..where((t) => t.id.equals(id))).write(entry);

  Future<void> deleteAccount(int id) =>
      (_db.update(_db.accounts)..where((t) => t.id.equals(id)))
          .write(const AccountsCompanion(isActive: Value(false)));

  // Связь с проектами
  Future<List<int>> getProjectIdsForAccount(int accountId) async {
    final rows = await (_db.select(_db.accountProjects)
          ..where((t) => t.accountId.equals(accountId)))
        .get();
    return rows.map((r) => r.projectId).toList();
  }

  Future<void> setProjectIdsForAccount(int accountId, List<int> projectIds) async {
    await _db.transaction(() async {
      await (_db.delete(_db.accountProjects)
            ..where((t) => t.accountId.equals(accountId)))
          .go();
      for (final projectId in projectIds) {
        await _db.into(_db.accountProjects).insert(
              AccountProjectsCompanion.insert(
                accountId: accountId,
                projectId: projectId,
              ),
            );
      }
    });
  }
}
