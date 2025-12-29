import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GolfCourse {
  final String id;
  final String name;
  final String imageUrl;
  final String?  location;

  const GolfCourse({
    required this.id,
    required this.name,
    required this. imageUrl,
    this.location,
  });
}

class CreateEventState extends Equatable {
  final bool isLoading;
  final bool isSubmitting;
  final String? selectedCourseId;
  final String courseSearchQuery;
  final List<GolfCourse> availableCourses;
  final List<GolfCourse> filteredCourses;
  final DateTime?  selectedDate;
  final TimeOfDay?  selectedTime;
  final int playersNeeded;
  final String skillLevel;
  final String notes;
  final bool isPublic;
  final String? errorMessage;
  final String? successMessage;

  const CreateEventState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.selectedCourseId,
    this.courseSearchQuery = '',
    this.availableCourses = const [],
    this.filteredCourses = const [],
    this.selectedDate,
    this.selectedTime,
    this. playersNeeded = 3,
    this.skillLevel = 'Any Level',
    this.notes = '',
    this.isPublic = true,
    this.errorMessage,
    this.successMessage,
  });

  GolfCourse? get selectedCourse {
    if (selectedCourseId == null) return null;
    try {
      return availableCourses.firstWhere((c) => c.id == selectedCourseId);
    } catch (e) {
      return null;
    }
  }

  bool get isFormValid {
    return selectedCourseId != null &&
        selectedDate != null &&
        selectedTime != null;
  }

  CreateEventState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    String? selectedCourseId,
    bool clearSelectedCourse = false,
    String? courseSearchQuery,
    List<GolfCourse>? availableCourses,
    List<GolfCourse>? filteredCourses,
    DateTime? selectedDate,
    bool clearDate = false,
    TimeOfDay? selectedTime,
    bool clearTime = false,
    int? playersNeeded,
    String? skillLevel,
    String? notes,
    bool?  isPublic,
    String?  errorMessage,
    String? successMessage,
  }) {
    return CreateEventState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      selectedCourseId: clearSelectedCourse ? null : (selectedCourseId ?? this. selectedCourseId),
      courseSearchQuery: courseSearchQuery ??  this.courseSearchQuery,
      availableCourses: availableCourses ?? this.availableCourses,
      filteredCourses: filteredCourses ?? this.filteredCourses,
      selectedDate: clearDate ? null : (selectedDate ?? this.selectedDate),
      selectedTime: clearTime ?  null : (selectedTime ?? this. selectedTime),
      playersNeeded: playersNeeded ?? this.playersNeeded,
      skillLevel: skillLevel ?? this. skillLevel,
      notes: notes ?? this.notes,
      isPublic: isPublic ?? this.isPublic,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object? > get props => [
    isLoading,
    isSubmitting,
    selectedCourseId,
    courseSearchQuery,
    availableCourses,
    filteredCourses,
    selectedDate,
    selectedTime,
    playersNeeded,
    skillLevel,
    notes,
    isPublic,
    errorMessage,
    successMessage,
  ];
}