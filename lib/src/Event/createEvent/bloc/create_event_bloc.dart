import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'create_event_event.dart';
import 'create_event_state.dart';

class CreateEventBloc extends Bloc<CreateEventEvent, CreateEventState> {
  CreateEventBloc() : super(const CreateEventState()) {
    on<LoadCourses>(_onLoadCourses);
    on<SearchCourses>(_onSearchCourses);
    on<SelectCourse>(_onSelectCourse);
    on<SelectDate>(_onSelectDate);
    on<SelectTime>(_onSelectTime);
    on<ChangePlayersNeeded>(_onChangePlayersNeeded);
    on<ChangeSkillLevel>(_onChangeSkillLevel);
    on<ChangeNotes>(_onChangeNotes);
    on<TogglePublic>(_onTogglePublic);
    on<SubmitEvent>(_onSubmitEvent);
    on<ResetForm>(_onResetForm);
  }

  Future<void> _onLoadCourses(
      LoadCourses event,
      Emitter<CreateEventState> emit,
      ) async {
    emit(state.copyWith(isLoading: true));
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock data - Replace with your API call
      const courses = [
        GolfCourse(
          id: '1',
          name: 'Pebble Beach Golf Links',
          imageUrl: 'https://example.com/pebble-beach.jpg',
          location: 'Pebble Beach, CA',
        ),
        GolfCourse(
          id: '2',
          name: 'TPC Sawgrass',
          imageUrl: 'https://example.com/tpc-sawgrass.jpg',
          location: 'Ponte Vedra Beach, FL',
        ),
        GolfCourse(
          id: '3',
          name: 'Torrey Pines',
          imageUrl: 'https://example.com/torrey-pines.jpg',
          location: 'San Diego, CA',
        ),
        GolfCourse(
          id: '4',
          name: 'Pinehurst Resort',
          imageUrl: 'https://example.com/pinehurst.jpg',
          location: 'Pinehurst, NC',
        ),
        GolfCourse(
          id: '5',
          name:  'Augusta National',
          imageUrl: 'https://example.com/augusta.jpg',
          location: 'Augusta, GA',
        ),
        GolfCourse(
          id: '6',
          name:  'St Andrews Links',
          imageUrl: 'https://example.com/st-andrews.jpg',
          location: 'St Andrews, Scotland',
        ),
      ];

      emit(state.copyWith(
        isLoading: false,
        availableCourses: courses,
        filteredCourses: courses,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onSearchCourses(
      SearchCourses event,
      Emitter<CreateEventState> emit,
      ) {
    final query = event.query.toLowerCase();
    final filtered = state.availableCourses.where((course) {
      return course.name.toLowerCase().contains(query) ||
          (course.location?. toLowerCase().contains(query) ?? false);
    }).toList();

    emit(state.copyWith(
      courseSearchQuery: event.query,
      filteredCourses: filtered,
    ));
  }

  void _onSelectCourse(
      SelectCourse event,
      Emitter<CreateEventState> emit,
      ) {
    emit(state.copyWith(selectedCourseId: event.courseId));
  }

  void _onSelectDate(
      SelectDate event,
      Emitter<CreateEventState> emit,
      ) {
    emit(state.copyWith(selectedDate: event. date));
  }

  void _onSelectTime(
      SelectTime event,
      Emitter<CreateEventState> emit,
      ) {
    emit(state.copyWith(selectedTime: event.time));
  }

  void _onChangePlayersNeeded(
      ChangePlayersNeeded event,
      Emitter<CreateEventState> emit,
      ) {
    emit(state.copyWith(playersNeeded: event.players));
  }

  void _onChangeSkillLevel(
      ChangeSkillLevel event,
      Emitter<CreateEventState> emit,
      ) {
    emit(state.copyWith(skillLevel: event.level));
  }

  void _onChangeNotes(
      ChangeNotes event,
      Emitter<CreateEventState> emit,
      ) {
    emit(state.copyWith(notes: event.notes));
  }

  void _onTogglePublic(
      TogglePublic event,
      Emitter<CreateEventState> emit,
      ) {
    emit(state.copyWith(isPublic: event.isPublic));
  }

  Future<void> _onSubmitEvent(
      SubmitEvent event,
      Emitter<CreateEventState> emit,
      ) async {
    if (! state.isFormValid) {
      emit(state.copyWith(
        errorMessage: 'Please fill in all required fields',
      ));
      return;
    }

    emit(state.copyWith(isSubmitting: true));
    try {
      // Simulate API call
      await Future. delayed(const Duration(seconds: 2));

      emit(state.copyWith(
        isSubmitting: false,
        successMessage: 'Round created successfully! ',
      ));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onResetForm(
      ResetForm event,
      Emitter<CreateEventState> emit,
      ) {
    emit(CreateEventState(
      availableCourses: state.availableCourses,
      filteredCourses: state.availableCourses,
    ));
  }
}