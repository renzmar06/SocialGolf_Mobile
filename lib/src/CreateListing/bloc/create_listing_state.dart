import 'dart:io';
import 'package:equatable/equatable.dart';

class CreateListingState extends Equatable {
  final List<File> images;
  final String selectedCategory; // Added
  final String selectedCondition; // Added
  final bool isSubmitting;
  final String? errorMessage;

  const CreateListingState({
    this.images = const [],
    this.selectedCategory = '',
    this.selectedCondition = '',
    this.isSubmitting = false,
    this.errorMessage,
  });

  CreateListingState copyWith({
    List<File>? images,
    String? selectedCategory,
    String? selectedCondition,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return CreateListingState(
      images: images ?? this.images,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedCondition: selectedCondition ?? this.selectedCondition,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [images, selectedCategory, selectedCondition, isSubmitting, errorMessage];
}