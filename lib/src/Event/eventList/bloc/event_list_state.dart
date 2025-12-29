import 'package:equatable/equatable.dart';

class EventModel {
  final String id;
  final String title;
  final String imageUrl;
  final DateTime dateTime;
  final String level; // "Any Level", "Beginner", "Advanced", etc.
  final int spotsLeft;
  final List<EventParticipant> participants;
  final bool isJoined;

  const EventModel({
    required this. id,
    required this.title,
    required this.imageUrl,
    required this.dateTime,
    required this.level,
    required this.spotsLeft,
    this.participants = const [],
    this.isJoined = false,
  });

  EventModel copyWith({
    String? id,
    String? title,
    String? imageUrl,
    DateTime? dateTime,
    String?  level,
    int? spotsLeft,
    List<EventParticipant>? participants,
    bool? isJoined,
  }) {
    return EventModel(
      id: id ??  this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this. imageUrl,
      dateTime:  dateTime ?? this.dateTime,
      level: level ?? this. level,
      spotsLeft:  spotsLeft ?? this.spotsLeft,
      participants: participants ??  this.participants,
      isJoined: isJoined ??  this.isJoined,
    );
  }
}

class EventParticipant {
  final String id;
  final String name;
  final String avatarUrl;

  const EventParticipant({
    required this.id,
    required this. name,
    required this.avatarUrl,
  });
}

class EventGroup {
  final DateTime date;
  final List<EventModel> events;

  const EventGroup({
    required this.date,
    required this.events,
  });

  int get eventCount => events.length;
}

enum EventFilter { all, today, tomorrow, thisWeek }

class EventsState extends Equatable {
  final bool isLoading;
  final EventFilter selectedFilter;
  final String searchQuery;
  final List<EventGroup> eventGroups;
  final String? errorMessage;
  final String? joiningEventId;

  const EventsState({
    this.isLoading = false,
    this.selectedFilter = EventFilter.all,
    this.searchQuery = '',
    this.eventGroups = const [],
    this.errorMessage,
    this.joiningEventId,
  });

  EventsState copyWith({
    bool?  isLoading,
    EventFilter? selectedFilter,
    String?  searchQuery,
    List<EventGroup>? eventGroups,
    String? errorMessage,
    String? joiningEventId,
  }) {
    return EventsState(
      isLoading:  isLoading ?? this.isLoading,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      eventGroups: eventGroups ?? this. eventGroups,
      errorMessage: errorMessage,
      joiningEventId: joiningEventId,
    );
  }

  @override
  List<Object? > get props => [
    isLoading,
    selectedFilter,
    searchQuery,
    eventGroups,
    errorMessage,
    joiningEventId,
  ];
}