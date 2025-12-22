import 'package:equatable/equatable.dart';
import 'dart:io';

class CreatePostState extends Equatable {
  final int playersNeeded;
  final int selectedTabIndex;
  final List<File> selectedImages;

  const CreatePostState({
    this.playersNeeded = 1,
    this.selectedTabIndex = 0,
    this.selectedImages = const [],
  });

  CreatePostState copyWith({
    int? playersNeeded,
    int? selectedTabIndex,
    List<File>? selectedImages,
  }) {
    return CreatePostState(
      playersNeeded: playersNeeded ?? this.playersNeeded,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      selectedImages: selectedImages ?? this.selectedImages,
    );
  }

  @override
  List<Object?> get props => [playersNeeded, selectedTabIndex, selectedImages];
}
