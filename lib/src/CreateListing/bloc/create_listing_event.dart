import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class CreateListingEvent extends Equatable {
  const CreateListingEvent();

  @override
  List<Object?> get props => [];
}

class AddListingImage extends CreateListingEvent {
  final File image;
  const AddListingImage(this.image);

  @override
  List<Object?> get props => [image];
}

class RemoveListingImage extends CreateListingEvent {
  final int index;
  const RemoveListingImage(this.index);

  @override
  List<Object?> get props => [index];
}

// --- New Events for Dropdowns ---

class ChangeCategory extends CreateListingEvent {
  final String category;
  const ChangeCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class ChangeCondition extends CreateListingEvent {
  final String condition;
  const ChangeCondition(this.condition);

  @override
  List<Object?> get props => [condition];
}

// ------------------------------

class SubmitListing extends CreateListingEvent {
  final String title;
  final String price;
  final String location;
  final String description;

  const SubmitListing({
    required this.title,
    required this.price,
    required this.location,
    required this.description,
  });

  @override
  List<Object?> get props => [title, price, location, description];
}