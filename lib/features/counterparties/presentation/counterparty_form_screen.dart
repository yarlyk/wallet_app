import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:url_launcher/url_launcher.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/contacts_utils.dart';
import '../../../core/utils/phone_utils.dart';
import '../../../core/widgets/contact_picker_dialog.dart';
import '../../../core/widgets/entity_form_screen.dart';
import '../../../core/widgets/project_multi_select_dialog.dart';
import 'counterparties_provider.dart';

class CounterpartyFormScreen extends ConsumerStatefulWidget {
  final Counterparty? counterparty;
  final VoidCallback onCancel;

  const CounterpartyFormScreen({
    super.key,
    this.counterparty,
    required this.onCancel,
  });

  @override
  ConsumerState<CounterpartyFormScreen> createState() =>
      _CounterpartyFormScreenState();
}

class _CounterpartyFormScreenState
    extends ConsumerState<CounterpartyFormScreen> {
  final _nameController = TextEditingController();
  final _innController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _noteController = TextEditingController();

  Set<int> _groupIds = {};
  Set<int> _projectIds = {};

  @override
  void initState() {
    super.initState();
    final c = widget.counterparty;
    _nameController.text = c?.name ?? '';
    _innController.text = c?.inn ?? '';
    _phoneController.text = c?.phone ?? '';
    _emailController.text = c?.email ?? '';
    _noteController.text = c?.note ?? '';

    if (c != null) {
      Future.microtask(() async {
        final notifier = ref.read(counterpartiesProvider.notifier);
        final gIds = await notifier.getGroupIds(c.id);
        final pIds = await notifier.getProjectIds(c.id);
        if (mounted) {
          setState(() {
            _groupIds = gIds.toSet();
            _projectIds = pIds.toSet();
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _innController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return null;
    final re = RegExp(r'^[\w\.\-]+@[\w\-]+\.[\w\.\-]+$');
    if (!re.hasMatch(value)) return 'Неверный email';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return null;
    if (!isPhoneComplete(value)) return 'Введите 10 цифр номера';
    return null;
  }

  Future<void> _callPhone() async {
    final phone = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    if (phone.isEmpty) return;
    final uri = Uri(scheme: 'tel', path: '+$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _sendEmail() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _pickContact() async {
    final picked = await showDialog<PickedContact>(
      context: context,
      builder: (_) => const ContactPickerDialog(),
    );
    if (picked == null) return;
    setState(() {
      _nameController.text = picked.name;
      if (picked.phone != null && picked.phone!.isNotEmpty) {
        _phoneController.text = formatPhoneRu(picked.phone!);
      }
      if (picked.email != null && picked.email!.isNotEmpty) {
        _emailController.text = picked.email!;
      }
    });
  }

  Future<void> _pickGroups() async {
    final result = await showDialog<List<int>>(
      context: context,
      builder: (_) => _GroupMultiSelectDialog(
        initiallySelectedIds: _groupIds.toList(),
      ),
    );
    if (result != null) setState(() => _groupIds = result.toSet());
  }

  Future<void> _pickProjects() async {
    final result = await showDialog<List<int>>(
      context: context,
      builder: (_) => ProjectMultiSelectDialog(
        initiallySelectedIds: _projectIds.toList(),
      ),
    );
    if (result != null) setState(() => _projectIds = result.toSet());
  }

  Widget _selectField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.arrow_drop_down),
        ),
        child: Text(value, overflow: TextOverflow.ellipsis),
      ),
    );
  }

  Future<void> _save(String? iconName) async {
    final notifier = ref.read(counterpartiesProvider.notifier);
    final entry = CounterpartiesCompanion(
      name: Value(_nameController.text.trim()),
      inn: Value(_innController.text.trim().isEmpty
          ? null
          : _innController.text.trim()),
      phone: Value(_phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim()),
      email: Value(_emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim()),
      note: Value(_noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim()),
      icon: Value(iconName),
    );

    if (widget.counterparty == null) {
      await notifier.addCounterparty(
        entry,
        _groupIds.toList(),
        _projectIds.toList(),
      );
    } else {
      await notifier.updateCounterparty(
        widget.counterparty!.id,
        entry,
        _groupIds.toList(),
        _projectIds.toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.counterparty != null;
    return EntityFormScreen(
      title: isEditing ? 'Редактировать контрагента' : 'Новый контрагент',
      nameController: _nameController,
      initialIconName: widget.counterparty?.icon,
      nameSuffixIcon: Icons.contacts,
      onNameSuffixIconTap: _pickContact,
      isEditing: isEditing,
      showDelete: isEditing,
      onCancel: widget.onCancel,
      onSave: _save,
      onDelete: isEditing
          ? () async {
              await ref
                  .read(counterpartiesProvider.notifier)
                  .deleteCounterparty(widget.counterparty!.id);
              return true;
            }
          : null,
      extraFields: [
        const SizedBox(height: 16),
        _selectField(
          label: 'Группы',
          value: _groupIds.isEmpty
              ? 'Не выбраны'
              : 'Выбрано: ${_groupIds.length}',
          onTap: _pickGroups,
        ),
        const SizedBox(height: 16),
        _selectField(
          label: 'Проекты',
          value: _projectIds.isEmpty
              ? 'Не выбраны'
              : 'Выбрано: ${_projectIds.length}',
          onTap: _pickProjects,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _innController,
          decoration: const InputDecoration(
            labelText: 'ИНН',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          decoration: InputDecoration(
            labelText: 'Телефон',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.phone, color: Colors.green),
              onPressed: _callPhone,
            ),
          ),
          keyboardType: TextInputType.phone,
          inputFormatters: [PhoneInputFormatter()],
          validator: _validatePhone,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.email, color: Colors.indigo),
              onPressed: _sendEmail,
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: _validateEmail,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _noteController,
          decoration: const InputDecoration(
            labelText: 'Заметка',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ],
    );
  }
}

class _GroupMultiSelectDialog extends ConsumerStatefulWidget {
  final List<int> initiallySelectedIds;
  const _GroupMultiSelectDialog({this.initiallySelectedIds = const []});

  @override
  ConsumerState<_GroupMultiSelectDialog> createState() =>
      _GroupMultiSelectDialogState();
}

class _GroupMultiSelectDialogState
    extends ConsumerState<_GroupMultiSelectDialog> {
  late final Set<int> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set<int>.from(widget.initiallySelectedIds);
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(counterpartiesProvider);
    return stateAsync.when(
      loading: () => const AlertDialog(
        content: SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (e, _) => AlertDialog(
        title: const Text('Ошибка'),
        content: Text('$e'),
      ),
      data: (state) {
        final groups = state.groups;
        return AlertDialog(
          title: const Text('Группы контрагента'),
          content: SizedBox(
            width: double.maxFinite,
            child: groups.isEmpty
                ? const Text('Нет доступных групп')
                : ListView(
                    shrinkWrap: true,
                    children: [
                      for (final g in groups)
                        CheckboxListTile(
                          title: Text(g.name),
                          value: _selected.contains(g.id),
                          onChanged: (checked) {
                            setState(() {
                              if (checked == true) {
                                _selected.add(g.id);
                              } else {
                                _selected.remove(g.id);
                              }
                            });
                          },
                        ),
                    ],
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, _selected.toList()),
              child: const Text('Готово'),
            ),
          ],
        );
      },
    );
  }
}


