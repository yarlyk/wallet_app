import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/entity_list_screen.dart';
import 'currencies_provider.dart';

class CurrenciesScreen extends ConsumerWidget {
  final VoidCallback onBack;
  const CurrenciesScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currenciesAsync = ref.watch(currenciesProvider);

    return currenciesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Ошибка: $error')),
      data: (currencies) {
        return EntityListScreen(
          title: 'Валюты',
          itemCount: currencies.length,
          itemBuilder: (context, index) {
            final currency = currencies[index];
            return ListTile(
              leading: Text(
                currency.symbol ?? '',
                style: const TextStyle(fontSize: 20),
              ),
              title: Text(currency.name),
              subtitle: Text('${currency.code} · ${currency.country ?? ''}'),
              trailing: Switch(
                value: currency.isActive,
                onChanged: (value) {
                  ref.read(currenciesProvider.notifier).setCurrencyActive(currency, value);
                },
              ),
            );
          },
          onBack: onBack,
          // Без кнопок добавления
        );
      },
    );
  }
}
