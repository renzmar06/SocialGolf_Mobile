import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetPopularEvent extends HomeEvent {
  final String type;
  GetPopularEvent(this.type);

  @override
  List<Object?> get props => [type];
}

class GetTrendingEvent extends HomeEvent {
  final String type;
  GetTrendingEvent(this.type);

  @override
  List<Object?> get props => [type];
}
