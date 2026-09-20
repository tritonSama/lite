import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/enums.dart';
import '../../domain/task.dart';

part 'task_creation_controller.g.dart';

@riverpod
class TaskCreationController extends _$TaskCreationController {
  @override
  Task build() {
    return Task(
      id: '', // Will be generated on publish
      creatorId: '', // Set by auth context at publish time
      title: '',
      description: '',
      location: const GeoPoint(0, 0),
      locationLabel: '',
      geohash: '',
      desiredCompletionDate: DateTime.now().add(const Duration(days: 7)),
      budgetAmount: 0.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  // --- Step 1: Info ---
  void updateInfo({
    String? title,
    String? description,
    TaskCategory? category,
  }) {
    state = state.copyWith(
      title: title ?? state.title,
      description: description ?? state.description,
      category: category ?? state.category,
    );
  }

  // --- Step 2: Logistics ---
  void updateLogistics({
    GeoPoint? location,
    String? locationLabel,
    String? geohash,
    DateTime? desiredCompletionDate,
    int? workerCount,
  }) {
    state = state.copyWith(
      location: location ?? state.location,
      locationLabel: locationLabel ?? state.locationLabel,
      geohash: geohash ?? state.geohash,
      desiredCompletionDate:
          desiredCompletionDate ?? state.desiredCompletionDate,
      workerCount: workerCount ?? state.workerCount,
    );
  }

  // --- Step 3: Requirements ---
  void updateRequirements({
    List<String>? requiredSkills,
    List<String>? requiredEquipment,
    List<RequiredCredential>? requiredCredentials,
    String? specialRequirements,
  }) {
    state = state.copyWith(
      requiredSkills: requiredSkills ?? state.requiredSkills,
      requiredEquipment: requiredEquipment ?? state.requiredEquipment,
      requiredCredentials: requiredCredentials ?? state.requiredCredentials,
      specialRequirements: specialRequirements ?? state.specialRequirements,
    );
  }

  // --- Step 4: Funding ---
  void updateFunding({double? budgetAmount}) {
    state = state.copyWith(
      budgetAmount: budgetAmount ?? state.budgetAmount,
    );
  }
}
