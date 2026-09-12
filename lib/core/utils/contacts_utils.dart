import 'package:flutter_contacts/flutter_contacts.dart';

class PickedContact {
  final String name;
  final String? phone;
  final String? email;
  PickedContact({required this.name, this.phone, this.email});
}

/// Запрашивает разрешение и возвращает true, если доступ получен.
Future<bool> ensureContactsPermission() async {
  final status =
      await FlutterContacts.permissions.request(PermissionType.read);
  return status == PermissionStatus.granted ||
      status == PermissionStatus.limited;
}

/// Возвращает список контактов с именем, первым телефоном и первым email.
Future<List<PickedContact>> loadContacts() async {
  final contacts = await FlutterContacts.getAll(
    properties: {
      ContactProperty.name,
      ContactProperty.phone,
      ContactProperty.email,
    },
  );
  final result = <PickedContact>[];
  for (final c in contacts) {
    final name = (c.displayName ?? '').trim();
    if (name.isEmpty) continue;
    final phone = c.phones.isNotEmpty ? c.phones.first.number : null;
    final email = c.emails.isNotEmpty ? c.emails.first.address : null;
    result.add(PickedContact(name: name, phone: phone, email: email));
  }
  result.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  return result;
}

