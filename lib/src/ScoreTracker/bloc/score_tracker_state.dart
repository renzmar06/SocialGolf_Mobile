// --- State ---
import 'package:equatable/equatable.dart';
import 'package:social_golf_app/src/ScoreTracker/bloc/score_tracker_bloc.dart';

class ScoreTrackerState extends Equatable {
  final List<ScoreRound> rounds;

  const ScoreTrackerState({this.rounds = const []});

  int get bestScore => rounds.isEmpty ? 0 : rounds.map((e) => e.score).reduce((a, b) => a < b ? a : b);
  int get averageScore => rounds.isEmpty ? 0 : (rounds.map((e) => e.score).reduce((a, b) => a + b) / rounds.length).round();
  int get totalRounds => rounds.length;

  @override
  List<Object?> get props => [rounds];
}