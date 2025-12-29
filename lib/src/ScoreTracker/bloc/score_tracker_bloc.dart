import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_golf_app/src/ScoreTracker/bloc/score_tracker_event.dart';
import 'package:social_golf_app/src/ScoreTracker/bloc/score_tracker_state.dart';

// --- Models ---
class ScoreRound extends Equatable {
  final String courseName;
  final int score;
  final int toPar;
  final String date;

  const ScoreRound({required this.courseName, required this.score, required this.toPar, required this.date});

  @override
  List<Object?> get props => [courseName, score, toPar, date];
}





// --- Bloc ---
class ScoreTrackerBloc extends Bloc<ScoreTrackerEvent, ScoreTrackerState> {
  ScoreTrackerBloc() : super(const ScoreTrackerState()) {
    on<AddNewScore>((event, emit) {
      final updatedRounds = List<ScoreRound>.from(state.rounds)..insert(0, event.round);
      emit(ScoreTrackerState(rounds: updatedRounds));
    });
  }
}