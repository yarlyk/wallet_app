import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../services/currency_json_service.dart';
import '../data/currency_repository.dart';

final currencyRepositoryProvider = Provider<CurrencyRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return CurrencyRepository(db);
});

final currenciesProvider = AsyncNotifierProvider<CurrenciesNotifier, List<Currency>>(CurrenciesNotifier.new);

class CurrenciesNotifier extends AsyncNotifier<List<Currency>> {
  @override
  Future<List<Currency>> build() async {
    final repo = ref.watch(currencyRepositoryProvider);
    return repo.getAll();
  }

  Future<void> addCurrencyFromJson(CurrencyJsonItem item) async {
    final repo = ref.watch(currencyRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final entry = CurrenciesCompanion.insert(
        code: item.code,
        name: item.name,
        symbol: Value(item.symbol),
        numCode: item.numCode,
        nominal: Value(item.nominal),
        country: Value(item.countries.isNotEmpty ? item.countries.first : null),
      );
      final id = await repo.insert(entry);
      final newCurrency = await repo.getById(id);
      return [...state.value ?? [], if (newCurrency != null) newCurrency];
    });
  }

  Future<void> setCurrencyActive(Currency currency, bool isActive) async {
    final repo = ref.watch(currencyRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repo.update(currency.copyWith(isActive: isActive));
      final updatedList = (state.value ?? []).map((c) => c.id == currency.id ? c.copyWith(isActive: isActive) : c).toList();
      return updatedList;
    });
  }
}
