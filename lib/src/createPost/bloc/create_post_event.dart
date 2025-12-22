import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class CreatePostEvent extends Equatable {
  const CreatePostEvent();

  @override
  List<Object?> get props => [];
}

class IncrementPlayersEvent extends CreatePostEvent {
  const IncrementPlayersEvent();
}

class DecrementPlayersEvent extends CreatePostEvent {
  const DecrementPlayersEvent();
}

class ChangeTabEvent extends CreatePostEvent {
  final int tabIndex;

  const ChangeTabEvent(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}

class AddImageEvent extends CreatePostEvent {
  final File image;

  const AddImageEvent(this.image);

  @override
  List<Object?> get props => [image];
}

class RemoveImageEvent extends CreatePostEvent {
  final int index;

  const RemoveImageEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class ClearImagesEvent extends CreatePostEvent {
  const ClearImagesEvent();
}
