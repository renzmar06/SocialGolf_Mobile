import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'create_listing_event.dart';
import 'create_listing_state.dart';

class CreateListingBloc extends Bloc<CreateListingEvent, CreateListingState> {
  CreateListingBloc() : super(const CreateListingState()) {
    on<AddListingImage>(_onAddImage);
    on<RemoveListingImage>(_onRemoveImage);
    on<SubmitListing>(_onSubmitListing);
    on<ChangeCategory>((event, emit) => emit(state.copyWith(selectedCategory: event.category)));
    on<ChangeCondition>((event, emit) => emit(state.copyWith(selectedCondition: event.condition)));
  }

  void _onAddImage(AddListingImage event, Emitter<CreateListingState> emit) {
    // Limits the list to exactly 5 photos as per your UI requirement
    if (state.images.length < 5) {
      final updatedList = List<File>.from(state.images)..add(event.image);
      emit(state.copyWith(images: updatedList));
    }
  }

  void _onRemoveImage(RemoveListingImage event, Emitter<CreateListingState> emit) {
    final updatedList = List<File>.from(state.images);
    if (event.index >= 0 && event.index < updatedList.length) {
      updatedList.removeAt(event.index);
      emit(state.copyWith(images: updatedList));
    }
  }

  Future<void> _onSubmitListing(SubmitListing event, Emitter<CreateListingState> emit) async {
    emit(state.copyWith(isSubmitting: true));
    try {
      // Logic for calling your API would go here
      // await repository.uploadListing(...);
      emit(state.copyWith(isSubmitting: false));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }


}