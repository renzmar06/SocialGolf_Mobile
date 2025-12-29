import 'dart:io';
import 'package:social_golf_app/core/bloc/base_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'create_post_event.dart';
import 'create_post_state.dart';

class CreatePostBloc extends BaseBloc<CreatePostEvent, CreatePostState> {
  CreatePostBloc() : super(const CreatePostState()) {
    on<IncrementPlayersEvent>(_onIncrementPlayers);
    on<DecrementPlayersEvent>(_onDecrementPlayers);
    on<ChangeTabEvent>(_onChangeTab);
    on<AddImageEvent>(_onAddImage);
    on<RemoveImageEvent>(_onRemoveImage);
    on<ClearImagesEvent>(_onClearImages);
  }

  void _onIncrementPlayers(
    IncrementPlayersEvent event,
    Emitter<CreatePostState> emit,
  ) {
    if (state.playersNeeded < 3) {
      emit(state.copyWith(playersNeeded: state.playersNeeded + 1));
    }
  }

  void _onDecrementPlayers(
    DecrementPlayersEvent event,
    Emitter<CreatePostState> emit,
  ) {
    if (state.playersNeeded > 1) {
      emit(state.copyWith(playersNeeded: state.playersNeeded - 1));
    }
  }

  void _onChangeTab(ChangeTabEvent event, Emitter<CreatePostState> emit) {
    emit(state.copyWith(selectedTabIndex: event.tabIndex));
  }
  void _onAddImage(AddImageEvent event, Emitter<CreatePostState> emit) {
    // Purani images ki copy lo aur nayi image add karo
    final List<File> updatedImages = List<File>.from(state.selectedImages);

    if (state.selectedTabIndex == 0) {
      // Single Photo Post ke liye: Replace karo
      emit(state.copyWith(selectedImages: [event.image]));
    } else {
      // Sell Item ke liye: Add karo (max 5)
      if (updatedImages.length < 5) {
        updatedImages.add(event.image);
        emit(state.copyWith(selectedImages: updatedImages));
      }
    }
  }

  void _onRemoveImage(RemoveImageEvent event, Emitter<CreatePostState> emit) {
    final List<File> updatedImages = List<File>.from(state.selectedImages);

    // Specific index waali image remove karo
    if (event.index >= 0 && event.index < updatedImages.length) {
      updatedImages.removeAt(event.index);
      emit(state.copyWith(selectedImages: updatedImages));
    }
  }
  void _onClearImages(ClearImagesEvent event, Emitter<CreatePostState> emit) {
    emit(state.copyWith(selectedImages: []));
  }

}
