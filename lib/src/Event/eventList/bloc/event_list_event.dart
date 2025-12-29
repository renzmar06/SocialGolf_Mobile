import 'package:equatable/equatable.dart';
import 'event_list_state.dart';

abstract class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object?> get props => [];
}

class LoadEvents extends EventsEvent {
  const LoadEvents();
}

class ChangeFilter extends EventsEvent {
  final EventFilter filter;
  const ChangeFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}

class SearchEvents extends EventsEvent {
  final String query;
  const SearchEvents(this.query);

  @override
  List<Object? > get props => [query];
}

class JoinEvent extends EventsEvent {
  final String eventId;
  const JoinEvent(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

class LeaveEvent extends EventsEvent {
  final String eventId;
  const LeaveEvent(this. eventId);

  @override
  List<Object?> get props => [eventId];
}

class RefreshEvents extends EventsEvent {
  const RefreshEvents();
}