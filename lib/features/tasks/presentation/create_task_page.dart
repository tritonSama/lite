import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../app/theme.dart';
import '../../../core/constants/enums.dart';
import '../../auth/presentation/auth_providers.dart';
import '../domain/task.dart';
import '../data/task_repository.dart';

class CreateTaskPage extends ConsumerStatefulWidget {
  const CreateTaskPage({super.key});

  @override
  ConsumerState<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends ConsumerState<CreateTaskPage> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Form controllers & state
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  TaskCategory _category = TaskCategory.cleanup;

  final _locationCtrl = TextEditingController();
  DateTime? _desiredDate;
  int _workerCount = 1;

  final _budgetCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _locationCtrl.dispose();
    _budgetCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_desiredDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a desired date')),
      );
      return;
    }

    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final budget = double.tryParse(_budgetCtrl.text) ?? 0.0;

    final newTask = Task(
      id: const Uuid().v4(), // Client-side generated ID, or empty if relying on Firestore ref.id
      creatorId: user.uid,
      title: _titleCtrl.text,
      description: _descCtrl.text,
      category: _category,
      location: const GeoPoint(0, 0), // Placeholder, would use real geocoding
      locationLabel: _locationCtrl.text,
      geohash: 'placeholder',
      desiredCompletionDate: _desiredDate!,
      budgetAmount: budget,
      workerCount: _workerCount,
      status: TaskStatus.published,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final taskId = await ref.read(taskRepositoryProvider).createTask(newTask);

      if (mounted) {
        Navigator.pop(context); // close dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task Published!')),
        );
        // Reset form
        setState(() {
          _currentStep = 0;
          _titleCtrl.clear();
          _descCtrl.clear();
          _locationCtrl.clear();
          _budgetCtrl.clear();
          _desiredDate = null;
          _workerCount = 1;
        });
        // Navigate to the new task
        context.go('/board/task/$taskId');
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Task')),
      body: Form(
        key: _formKey,
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepContinue: () {
            final isLastStep = _currentStep == 3;
            if (isLastStep) {
              _submit();
            } else {
              setState(() => _currentStep += 1);
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep -= 1);
            }
          },
          controlsBuilder: (context, details) {
            final isLastStep = _currentStep == 3;
            return Padding(
              padding: const EdgeInsets.only(top: HBSpacing.md),
              child: Row(
                children: [
                  FilledButton(
                    onPressed: details.onStepContinue,
                    child: Text(isLastStep ? 'Publish Task' : 'Next'),
                  ),
                  if (_currentStep > 0) ...[
                    const SizedBox(width: HBSpacing.md),
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Back'),
                    ),
                  ],
                ],
              ),
            );
          },
          steps: [
            Step(
              title: const Text('Basic Info'),
              isActive: _currentStep >= 0,
              content: Column(
                children: [
                  TextFormField(
                    controller: _titleCtrl,
                    decoration: const InputDecoration(labelText: 'Task Title'),
                    validator: (v) => v?.isEmpty == true ? 'Required' : null,
                  ),
                  const SizedBox(height: HBSpacing.sm),
                  TextFormField(
                    controller: _descCtrl,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    validator: (v) => v?.isEmpty == true ? 'Required' : null,
                  ),
                  const SizedBox(height: HBSpacing.sm),
                  DropdownButtonFormField<TaskCategory>(
                    value: _category,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: TaskCategory.values.map((c) {
                      return DropdownMenuItem(
                        value: c,
                        child: Text('${c.emoji} ${c.label}'),
                      );
                    }).toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _category = v);
                    },
                  ),
                ],
              ),
            ),
            Step(
              title: const Text('Logistics'),
              isActive: _currentStep >= 1,
              content: Column(
                children: [
                  TextFormField(
                    controller: _locationCtrl,
                    decoration: const InputDecoration(labelText: 'Location Label (e.g. 123 Main St)'),
                    validator: (v) => v?.isEmpty == true ? 'Required' : null,
                  ),
                  const SizedBox(height: HBSpacing.sm),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(_desiredDate == null
                        ? 'Select Desired Completion Date'
                        : 'Date: ${_desiredDate!.toLocal().toString().split(' ').first}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(const Duration(days: 1)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() => _desiredDate = date);
                      }
                    },
                  ),
                  const SizedBox(height: HBSpacing.sm),
                  Row(
                    children: [
                      const Text('Number of Workers Needed:'),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: _workerCount > 1
                            ? () => setState(() => _workerCount--)
                            : null,
                      ),
                      Text('$_workerCount', style: Theme.of(context).textTheme.titleMedium),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => setState(() => _workerCount++),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Step(
              title: const Text('Funding'),
              isActive: _currentStep >= 2,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Set the initial bounty for this task.'),
                  const SizedBox(height: HBSpacing.sm),
                  TextFormField(
                    controller: _budgetCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Bounty Amount (\$)',
                      prefixText: '\$ ',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v?.isEmpty == true) return 'Required';
                      if (double.tryParse(v!) == null) return 'Must be a number';
                      return null;
                    },
                  ),
                ],
              ),
            ),
            Step(
              title: const Text('Review & Publish'),
              isActive: _currentStep >= 3,
              content: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Review your task details before publishing to the board. Providers will be able to see this and submit offers.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
