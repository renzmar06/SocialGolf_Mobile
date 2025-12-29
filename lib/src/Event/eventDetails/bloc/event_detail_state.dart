import 'package:equatable/equatable.dart';

class PlayerModel {
  final String id;
  final String username;
  final String avatarUrl;
  final String level; // "Beginner", "Intermediate", "Advanced"
  final bool isHost;
  final bool isPremium;

  const PlayerModel({
    required this. id,
    required this.username,
    required this.avatarUrl,
    required this.level,
    this.isHost = false,
    this.isPremium = false,
  });
}

class EventDetailModel {
  final String id;
  final String title;
  final String imageUrl;
  final String level;
  final DateTime date;
  final String teeTime;
  final int totalSpots;
  final int joinedPlayers;
  final List<PlayerModel> players;
  final PlayerModel host;
  final bool isJoined;
  final String?  description;
  final String? location;

  const EventDetailModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.level,
    required this. date,
    required this.teeTime,
    required this. totalSpots,
    required this.joinedPlayers,
    required this.players,
    required this.host,
    this.isJoined = false,
    this.description,
    this.location,
  });

  int get spotsLeft => totalSpots - joinedPlayers;

  EventDetailModel copyWith({
    String? id,
    String? title,
    String? imageUrl,
    String? level,
    DateTime?  date,
    String? teeTime,
    int? totalSpots,
    int? joinedPlayers,
    List<PlayerModel>? players,
    PlayerModel? host,
    bool?  isJoined,
    String? description,
    String? location,
  }) {
    return EventDetailModel(
      id:  id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ??  this.imageUrl,
      level: level ?? this.level,
      date: date ?? this.date,
      teeTime: teeTime ?? this.teeTime,
      totalSpots: totalSpots ?? this.totalSpots,
      joinedPlayers:  joinedPlayers ?? this.joinedPlayers,
      players:  players ?? this.players,
      host: host ?? this.host,
      isJoined: isJoined ?? this.isJoined,
      description: description ?? this.description,
      location: location ?? this.location,
    );
  }
}

class EventDetailState extends Equatable {
  final bool isLoading;
  final bool isJoining;
  final EventDetailModel?  event;
  final String? errorMessage;
  final String? successMessage;

  const EventDetailState({
    this.isLoading = false,
    this.isJoining = false,
    this.event,
    this. errorMessage,
    this.successMessage,
  });

  EventDetailState copyWith({
    bool? isLoading,
    bool? isJoining,
    EventDetailModel? event,
    String? errorMessage,
    String? successMessage,
  }) {
    return EventDetailState(
      isLoading: isLoading ?? this.isLoading,
      isJoining: isJoining ?? this.isJoining,
      event: event ??  this.event,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object? > get props => [isLoading, isJoining, event, errorMessage, successMessage];
}