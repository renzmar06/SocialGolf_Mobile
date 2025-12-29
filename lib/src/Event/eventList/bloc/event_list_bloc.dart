import 'package:flutter_bloc/flutter_bloc.dart';
import 'event_list_event.dart';
import 'event_list_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  EventsBloc() : super(const EventsState()) {
    on<LoadEvents>(_onLoadEvents);
    on<ChangeFilter>(_onChangeFilter);
    on<SearchEvents>(_onSearchEvents);
    on<JoinEvent>(_onJoinEvent);
    on<LeaveEvent>(_onLeaveEvent);
    on<RefreshEvents>(_onRefreshEvents);
  }

  Future<void> _onLoadEvents(
      LoadEvents event,
      Emitter<EventsState> emit,
      ) async {
    emit(state.copyWith(isLoading: true));
    try {
      // Simulate API call - Replace with your actual API
      await Future.delayed(const Duration(seconds: 1));

      // Mock data
      final eventGroups = [
        EventGroup(
          date: DateTime(2024, 12, 20),
          events: [
            EventModel(
              id: '1',
              title: 'Torrey Pines',
              imageUrl: 'https://example.com/torrey-pines.jpg',
              dateTime: DateTime(2024, 12, 20, 20, 10),
              level: 'Any Level',
              spotsLeft:  1,
              participants: const [
                EventParticipant(
                  id: '1',
                  name: 'John',
                  avatarUrl: 'https://example.com/avatar1.jpg',
                ),
                EventParticipant(
                  id: '2',
                  name: 'Jane',
                  avatarUrl: 'https://example.com/avatar2.jpg',
                ),
              ],
            ),
          ],
        ),
        EventGroup(
          date: DateTime(2024, 12, 21),
          events: [
            EventModel(
              id: '2',
              title: 'Pebble Beach',
              imageUrl:  'https://example.com/pebble-beach.jpg',
              dateTime: DateTime(2024, 12, 21, 14, 30),
              level:  'Intermediate',
              spotsLeft: 3,
              participants: const [
                EventParticipant(
                  id: '3',
                  name: 'Mike',
                  avatarUrl: 'https://example.com/avatar3.jpg',
                ),
              ],
            ),
          ],
        ),
      ];

      emit(state.copyWith(
        isLoading: false,
        eventGroups: eventGroups,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onChangeFilter(
      ChangeFilter event,
      Emitter<EventsState> emit,
      ) {
    emit(state.copyWith(selectedFilter: event.filter));
    add(const LoadEvents());
  }

  void _onSearchEvents(
      SearchEvents event,
      Emitter<EventsState> emit,
      ) {
    emit(state.copyWith(searchQuery: event.query));
    // Implement search logic or trigger API call
  }

  Future<void> _onJoinEvent(
      JoinEvent event,
      Emitter<EventsState> emit,
      ) async {
    emit(state.copyWith(joiningEventId: event.eventId));
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Update the event in the list
      final updatedGroups = state.eventGroups. map((group) {
        final updatedEvents = group.events. map((e) {
          if (e.id == event.eventId) {
            return e.copyWith(
              isJoined: true,
              spotsLeft: e.spotsLeft - 1,
            );
          }
          return e;
        }).toList();
        return EventGroup(date: group.date, events: updatedEvents);
      }).toList();

      emit(state.copyWith(
        joiningEventId: null,
        eventGroups: updatedGroups,
      ));
    } catch (e) {
      emit(state.copyWith(
        joiningEventId: null,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLeaveEvent(
      LeaveEvent event,
      Emitter<EventsState> emit,
      ) async {
    emit(state.copyWith(joiningEventId: event.eventId));
    try {
      await Future.delayed(const Duration(seconds: 1));

      final updatedGroups = state.eventGroups.map((group) {
        final updatedEvents = group. events.map((e) {
          if (e.id == event.eventId) {
            return e.copyWith(
              isJoined: false,
              spotsLeft: e.spotsLeft + 1,
            );
          }
          return e;
        }).toList();
        return EventGroup(date: group. date, events: updatedEvents);
      }).toList();

      emit(state.copyWith(
        joiningEventId: null,
        eventGroups: updatedGroups,
      ));
    } catch (e) {
      emit(state.copyWith(
        joiningEventId: null,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRefreshEvents(
      RefreshEvents event,
      Emitter<EventsState> emit,
      ) async {
    add(const LoadEvents());
  }
}