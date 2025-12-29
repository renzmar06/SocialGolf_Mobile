import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class CreateGroupEvent extends Equatable {
  const CreateGroupEvent();

  @override
  List<Object?> get props => [];
}

class AddCoverImage extends CreateGroupEvent {
  final File image;
  const AddCoverImage(this.image);

  @override
  List<Object?> get props => [image];
}

class RemoveCoverImage extends CreateGroupEvent {
  const RemoveCoverImage();
}

class TogglePrivate extends CreateGroupEvent {
  final bool isPrivate;
  const TogglePrivate(this.isPrivate);

  @override
  List<Object?> get props => [isPrivate];
}

class SubmitGroup extends CreateGroupEvent {
  final String groupName;
  final String description;

  const SubmitGroup({
    required this.groupName,
    required this. description,
  });

  @override
  List<Object?> get props => [groupName, description];
}