import 'package:flutter/material.dart';
import '../../core/utils/contacts_utils.dart';

class ContactPickerDialog extends StatefulWidget {
  const ContactPickerDialog({super.key});

  @override
  State<ContactPickerDialog> createState() => _ContactPickerDialogState();
}

class _ContactPickerDialogState extends State<ContactPickerDialog> {
  late Future<List<PickedContact>> _future;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<PickedContact>> _load() async {
    final granted = await ensureContactsPermission();
    if (!granted) {
      throw Exception('Доступ к контактам запрещён');
    }
    return loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Выбор из контактов'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Поиск по имени',
              ),
              onChanged: (v) => setState(() => _query = v.toLowerCase()),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<PickedContact>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Ошибка: ${snapshot.error}'),
                      ),
                    );
                  }
                  final all = snapshot.data ?? [];
                  final filtered = _query.isEmpty
                      ? all
                      : all
                          .where((c) => c.name.toLowerCase().contains(_query))
                          .toList();
                  if (filtered.isEmpty) {
                    return const Center(child: Text('Нет контактов'));
                  }
                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final c = filtered[index];
                      final subtitle = [c.phone, c.email]
                          .whereType<String>()
                          .join(' · ');
                      return ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(c.name),
                        subtitle: subtitle.isEmpty ? null : Text(subtitle),
                        onTap: () => Navigator.pop(context, c),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Отмена'),
        ),
      ],
    );
  }
}
