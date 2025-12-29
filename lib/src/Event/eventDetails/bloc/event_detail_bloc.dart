import 'package:flutter_bloc/flutter_bloc.dart';
import 'event_detail_event.dart';
import 'event_detail_state.dart';

class EventDetailBloc extends Bloc<EventDetailEvent, EventDetailState> {
  EventDetailBloc() : super(const EventDetailState()) {
    on<LoadEventDetail>(_onLoadEventDetail);
    on<JoinEvent>(_onJoinEvent);
    on<LeaveEvent>(_onLeaveEvent);
    on<ShareEvent>(_onShareEvent);
    on<OpenChat>(_onOpenChat);
  }

  Future<void> _onLoadEventDetail(
      LoadEventDetail event,
      Emitter<EventDetailState> emit,
      ) async {
    emit(state.copyWith(isLoading: true));
    try {
      await Future.delayed(const Duration(seconds: 1));

      // Mock data - Replace with your API call
      final eventDetail = EventDetailModel(
        id: event.eventId,
        title: 'Torrey Pines',
        imageUrl: 'https://example.com/torrey-pines.jpg',
        level: 'Any Level',
        date: DateTime(2025, 12, 20),
        teeTime: '20:10',
        totalSpots: 4,
        joinedPlayers:  2,
        host: const PlayerModel(
          id: '1',
          username: 'flypoolnimda',
          avatarUrl: '',
          level: 'Beginner',
          isHost: true,
          isPremium: true,
        ),
        players: const [
          PlayerModel(
            id: '1',
            username: 'flypoolnimda',
            avatarUrl: '',
            level: 'Beginner',
            isHost: true,
            isPremium: true,
          ),
          PlayerModel(
            id: '2',
            username: 'renzmarr06',
            avatarUrl: '',
            level: 'Beginner',
            isPremium: false,
          ),
        ],
        isJoined: false,
        location: 'San Diego, CA',
      );

      emit(state.copyWith(
        isLoading: false,
        event: eventDetail,
      ));
    } catch (e) {
      emit(state. copyWith(
        isLoading: false,
        errorMessage:  e.toString(),
      ));
    }
  }

  Future<void> _onJoinEvent(
      JoinEvent event,
      Emitter<EventDetailState> emit,
      ) async {
    if (state.event == null) return;

    emit(state.copyWith(isJoining: true));
    try {
      await Future.delayed(const Duration(seconds: 1));

      final updatedEvent = state.event!. copyWith(
        isJoined: true,
        joinedPlayers: state.event!.joinedPlayers + 1,
      );

      emit(state.copyWith(
        isJoining: false,
        event: updatedEvent,
        successMessage: 'Successfully joined the round!',
      ));
    } catch (e) {
      emit(state.copyWith(
        isJoining: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLeaveEvent(
      LeaveEvent event,
      Emitter<EventDetailState> emit,
      ) async {
    if (state.event == null) return;

    emit(state.copyWith(isJoining: true));
    try {
      await Future.delayed(const Duration(seconds: 1));

      final updatedEvent = state.event!.copyWith(
        isJoined: false,
        joinedPlayers: state.event!.joinedPlayers - 1,
      );

      emit(state.copyWith(
        isJoining: false,
        event: updatedEvent,
        successMessage: 'You left the round',
      ));
    } catch (e) {
      emit(state.copyWith(
        isJoining: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onShareEvent(ShareEvent event, Emitter<EventDetailState> emit) {
    // Implement share functionality
  }

  void _onOpenChat(OpenChat event, Emitter<EventDetailState> emit) {
    // Implement chat navigation
  }
}