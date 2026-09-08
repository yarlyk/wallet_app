import 'package:drift/drift.dart';
import 'app_database.dart';

Future<void> seedInitialData(AppDatabase db) async {
  // Проверяем, есть ли уже валюты
  final currencyCount = await db.currencies.count().getSingle();
  if (currencyCount == 0) {
    final currencies = [
      CurrenciesCompanion.insert(code: 'RUB', name: 'Российский рубль', symbol: const Value('₽'), numCode: 643),
      CurrenciesCompanion.insert(code: 'USD', name: 'Доллар США', symbol: const Value('\$'), numCode: 840),
      CurrenciesCompanion.insert(code: 'EUR', name: 'Евро', symbol: const Value('€'), numCode: 978),
      CurrenciesCompanion.insert(code: 'CNY', name: 'Китайский юань', symbol: const Value('¥'), numCode: 156),
      CurrenciesCompanion.insert(code: 'THB', name: 'Таиландский бат', symbol: const Value('฿'), numCode: 764, nominal: const Value(10)),
      CurrenciesCompanion.insert(code: 'GBP', name: 'Британский фунт', symbol: const Value('£'), numCode: 826),
      CurrenciesCompanion.insert(code: 'JPY', name: 'Японская иена', symbol: const Value('¥'), numCode: 392, nominal: const Value(100)),
      CurrenciesCompanion.insert(code: 'KZT', name: 'Казахстанский тенге', symbol: const Value('₸'), numCode: 398, nominal: const Value(100)),
      CurrenciesCompanion.insert(code: 'BYN', name: 'Белорусский рубль', symbol: const Value('Br'), numCode: 933),
      CurrenciesCompanion.insert(code: 'UAH', name: 'Украинская гривна', symbol: const Value('₴'), numCode: 980, nominal: const Value(10)),
      CurrenciesCompanion.insert(code: 'AED', name: 'Дирхам ОАЭ', symbol: const Value('د.إ'), numCode: 784),
      CurrenciesCompanion.insert(code: 'TRY', name: 'Турецкая лира', symbol: const Value('₺'), numCode: 949, nominal: const Value(10)),
      CurrenciesCompanion.insert(code: 'INR', name: 'Индийская рупия', symbol: const Value('₹'), numCode: 356, nominal: const Value(100)),
      CurrenciesCompanion.insert(code: 'CHF', name: 'Швейцарский франк', symbol: const Value('Fr'), numCode: 756),
      CurrenciesCompanion.insert(code: 'CAD', name: 'Канадский доллар', symbol: const Value('C\$'), numCode: 124),
      CurrenciesCompanion.insert(code: 'AUD', name: 'Австралийский доллар', symbol: const Value('A\$'), numCode: 36),
      CurrenciesCompanion.insert(code: 'SEK', name: 'Шведская крона', symbol: const Value('kr'), numCode: 752, nominal: const Value(10)),
      CurrenciesCompanion.insert(code: 'PLN', name: 'Польский злотый', symbol: const Value('zł'), numCode: 985),
      CurrenciesCompanion.insert(code: 'CZK', name: 'Чешская крона', symbol: const Value('Kč'), numCode: 203, nominal: const Value(10)),
      CurrenciesCompanion.insert(code: 'GEL', name: 'Грузинский лари', symbol: const Value('₾'), numCode: 981),
    ];
    await db.batch((batch) {
      batch.insertAll(db.currencies, currencies);
    });
  }

  // Проверяем проект «Личный»
  final projectCount = await db.projects.count().getSingle();
  if (projectCount == 0) {
    await db.into(db.projects).insert(
      ProjectsCompanion.insert(name: 'Личный'),
    );
  }
}
