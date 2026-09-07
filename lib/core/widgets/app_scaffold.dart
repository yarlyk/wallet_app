import 'package:flutter/material.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _currentIndex = 0;
  String _selectedBalanceOption = 'Доступно: 0 ₽';

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
              items: [
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
            const ListTile(
              leading: Icon(Icons.person),
              title: Text('Профиль'),
            ),
            const ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text('Счета'),
            ),
            const ListTile(
              leading: Icon(Icons.category),
              title: Text('Категории'),
            ),
            const ListTile(
              leading: Icon(Icons.folder),
              title: Text('Проекты'),
            ),
            const ListTile(
              leading: Icon(Icons.people),
              title: Text('Контрагенты'),
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text('Настройки'),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          Center(child: Text('Сводка')),
          Center(child: Text('Лента')),
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
          });
        },
      ),
      floatingActionButton: (_currentIndex == 0 || _currentIndex == 1)
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
