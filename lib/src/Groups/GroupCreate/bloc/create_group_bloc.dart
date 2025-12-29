import 'package:flutter_bloc/flutter_bloc.dart';
import 'create_group_event.dart';
import 'create_group_state.dart';

class CreateGroupBloc extends Bloc<CreateGroupEvent, CreateGroupState> {
  CreateGroupBloc() : super(const CreateGroupState()) {
    on<AddCoverImage>(_onAddCoverImage);
    on<RemoveCoverImage>(_onRemoveCoverImage);
    on<TogglePrivate>(_onTogglePrivate);
    on<SubmitGroup>(_onSubmitGroup);
  }

  void _onAddCoverImage(AddCoverImage event, Emitter<CreateGroupState> emit) {
    emit(state.copyWith(coverImage: event. image));
  }

  void _onRemoveCoverImage(RemoveCoverImage event, Emitter<CreateGroupState> emit) {
    emit(state. copyWith(clearCoverImage: true));
  }

  void _onTogglePrivate(TogglePrivate event, Emitter<CreateGroupState> emit) {
    emit(state.copyWith(isPrivate:  event.isPrivate));
  }

  Future<void> _onSubmitGroup(SubmitGroup event, Emitter<CreateGroupState> emit) async {
    emit(state.copyWith(isSubmitting:  true));
    try {
      // API call logic here
      // await repository.createGroup(... );
      emit(state.copyWith(isSubmitting:  false));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }
}