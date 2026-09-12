import 'package:flutter/material.dart';
import '../../features/accounts/presentation/accounts_screen.dart';
import '../../features/categories/presentation/categories_screen.dart';
import '../../features/counterparties/presentation/counterparties_screen.dart';
import '../../features/currencies/presentation/currencies_screen.dart';
import '../../features/projects/presentation/projects_screen.dart';
import '../../features/transactions/presentation/transactions_screen.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _currentIndex = 0;
  String _selectedBalanceOption = 'Доступно: 0 ₽';
  bool _showProjects = false;
  bool _showCurrencies = false;
  bool _showAccounts = false;
  bool _showCategories = false;
  bool _showCounterparties = false;

  bool get _anyPanelOpen =>
      _showProjects ||
      _showCurrencies ||
      _showAccounts ||
      _showCategories ||
      _showCounterparties;

  static const List<String> _titles = [
    'Сводка',
    'Лента',
    'Отчёт',
    'Заём',
    'Увед',
  ];

  static const List<IconData> _icons = [
    Icons.home,
    Icons.list,
    Icons.bar_chart,
    Icons.handshake,
    Icons.notifications,
  ];

  void _closeAllPanels() {
    setState(() {
      _showProjects = false;
      _showCurrencies = false;
      _showAccounts = false;
      _showCategories = false;
      _showCounterparties = false;
    });
  }

  void _openPanel(void Function() setFlag) {
    Navigator.pop(context);
    setState(() {
      _showProjects = false;
      _showCurrencies = false;
      _showAccounts = false;
      _showCategories = false;
      _showCounterparties = false;
      setFlag();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        centerTitle: true,
        title: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedBalanceOption,
              isExpanded: true,
              alignment: Alignment.center,
              items: const [
                DropdownMenuItem(
                  value: 'Доступно: 0 ₽',
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(child: Text('Доступно: 0 ₽')),
                  ),
                ),
                DropdownMenuItem(
                  value: 'Займы: 0 ₽',
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(child: Text('Займы: 0 ₽')),
                  ),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedBalanceOption = value;
                  });
                }
              },
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // TODO: logout
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Меню',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Закрыть'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'user@gmail.com',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Счета'),
              onTap: () => _openPanel(() => _showAccounts = true),
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Категории'),
              onTap: () => _openPanel(() => _showCategories = true),
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('Проекты'),
              onTap: () => _openPanel(() => _showProjects = true),
            ),
            ListTile(
              leading: const Icon(Icons.currency_exchange),
              title: const Text('Валюты'),
              onTap: () => _openPanel(() => _showCurrencies = true),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Контрагенты'),
              onTap: () => _openPanel(() => _showCounterparties = true),
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text('Настройки'),
            ),
          ],
        ),
      ),
      body: _showCounterparties
          ? CounterpartiesScreen(onBack: _closeAllPanels)
          : _showCategories
              ? CategoriesScreen(onBack: _closeAllPanels)
              : _showAccounts
                  ? AccountsScreen(onBack: _closeAllPanels)
                  : _showProjects
                      ? ProjectsScreen(onBack: _closeAllPanels)
                      : _showCurrencies
                          ? CurrenciesScreen(onBack: _closeAllPanels)
                          : IndexedStack(
                              index: _currentIndex,
                              children: const [
                                Center(child: Text('Сводка')),
                                TransactionsScreen(),
                                Center(child: Text('Отчёт')),
                                Center(child: Text('Заём')),
                                Center(child: Text('Увед')),
                              ],
                            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: List.generate(5, (index) {
          return BottomNavigationBarItem(
            icon: Icon(_icons[index]),
            label: _titles[index],
          );
        }),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _closeAllPanels();
          });
        },
      ),
      floatingActionButton: _currentIndex == 0 && !_anyPanelOpen
          ? FloatingActionButton(
              onPressed: () {
                // TODO: add new transaction
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
