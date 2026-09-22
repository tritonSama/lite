import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/local_database_service.dart';
import 'local_offerings_provider.dart';

class EditOfferingDialog extends ConsumerStatefulWidget {
  final Map<String, dynamic> offering;
  const EditOfferingDialog({super.key, required this.offering});

  @override
  ConsumerState<EditOfferingDialog> createState() => _EditOfferingDialogState();
}

class _EditOfferingDialogState extends ConsumerState<EditOfferingDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _bountyCtrl;

  @override
  void initState() {
    super.initState();
    final dataStr = widget.offering['data'] as String;
    Map<String, dynamic> decoded = {};
    try {
      decoded = jsonDecode(dataStr) as Map<String, dynamic>;
    } catch (_) {}

    _titleCtrl = TextEditingController(text: decoded['title']?.toString() ?? '');
    _descCtrl = TextEditingController(text: decoded['description']?.toString() ?? '');
    _bountyCtrl = TextEditingController(text: decoded['bounty']?.toString() ?? '0');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _bountyCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final dbService = LocalDatabaseService.instance;
    final db = await dbService.database;

    final dataStr = widget.offering['data'] as String;
    Map<String, dynamic> decoded = {};
    try {
      decoded = jsonDecode(dataStr) as Map<String, dynamic>;
    } catch (_) {}

    decoded['title'] = _titleCtrl.text;
    decoded['description'] = _descCtrl.text;
    decoded['bounty'] = int.tryParse(_bountyCtrl.text) ?? 0;

    await db.update(
      'tasks',
      {'data': jsonEncode(decoded)},
      where: 'id = ?',
      whereArgs: [widget.offering['id']],
    );

    if (mounted) {
      ref.refresh(localOfferingsProvider.future);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Offering'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bountyCtrl,
                decoration: const InputDecoration(labelText: 'Bounty'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
