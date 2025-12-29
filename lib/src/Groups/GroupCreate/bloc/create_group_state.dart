import 'dart:io';
import 'package:equatable/equatable.dart';

class CreateGroupState extends Equatable {
  final File? coverImage;
  final bool isPrivate;
  final bool isSubmitting;
  final String?  errorMessage;

  const CreateGroupState({
    this.coverImage,
    this. isPrivate = false,
    this. isSubmitting = false,
    this. errorMessage,
  });

  CreateGroupState copyWith({
    File? coverImage,
    bool?  clearCoverImage, // Helper to clear the image
    bool? isPrivate,
    bool? isSubmitting,
    String?  errorMessage,
  }) {
    return CreateGroupState(
      coverImage: clearCoverImage == true ? null : (coverImage ?? this. coverImage),
      isPrivate: isPrivate ?? this. isPrivate,
      isSubmitting:  isSubmitting ?? this.isSubmitting,
      errorMessage:  errorMessage,
    );
  }

  @override
  List<Object? > get props => [coverImage, isPrivate, isSubmitting, errorMessage];
}