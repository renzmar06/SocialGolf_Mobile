// --- Events ---
import 'package:equatable/equatable.dart';
import 'package:social_golf_app/src/ScoreTracker/bloc/score_tracker_bloc.dart';

abstract class ScoreTrackerEvent extends Equatable {
  const ScoreTrackerEvent();
  @override
  List<Object?> get props => [];
}

class AddNewScore extends ScoreTrackerEvent {
  final ScoreRound round;
  const AddNewScore(this.round);
  @override
  List<Object?> get props => [round];
}