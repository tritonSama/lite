import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';
import 'widgets/create_task_step1_info.dart';
import 'widgets/create_task_step2_logistics.dart';
import 'widgets/create_task_step3_requirements.dart';
import 'widgets/create_task_step4_funding.dart';
import 'widgets/create_task_step5_review.dart';

class CreateTaskPage extends ConsumerStatefulWidget {
  const CreateTaskPage({super.key});

  @override
  ConsumerState<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends ConsumerState<CreateTaskPage> {
  int _currentStep = 0;

  List<Step> get _steps => [
        Step(
          title: const Text('Info'),
          content: const CreateTaskStep1Info(),
          isActive: _currentStep >= 0,
        ),
        Step(
          title: const Text('Logistics'),
          content: const CreateTaskStep2Logistics(),
          isActive: _currentStep >= 1,
        ),
        Step(
          title: const Text('Requirements'),
          content: const CreateTaskStep3Requirements(),
          isActive: _currentStep >= 2,
        ),
        Step(
          title: const Text('Funding'),
          content: const CreateTaskStep4Funding(),
          isActive: _currentStep >= 3,
        ),
        Step(
          title: const Text('Review'),
          content: const CreateTaskStep5Review(),
          isActive: _currentStep >= 4,
        ),
      ];

  void _onStepTapped(int step) {
    setState(() => _currentStep = step);
  }

  void _onStepContinue() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep += 1);
    } else {
      // Final submit handled in step 5
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Task')),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepTapped: _onStepTapped,
        onStepContinue: _onStepContinue,
        onStepCancel: _onStepCancel,
        steps: _steps,
      ),
    );
  }
}
