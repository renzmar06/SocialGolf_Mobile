import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class CreateEventEvent extends Equatable {
  const CreateEventEvent();

  @override
  List<Object?> get props => [];
}

class LoadCourses extends CreateEventEvent {
  const LoadCourses();
}

class SearchCourses extends CreateEventEvent {
  final String query;
  const SearchCourses(this. query);

  @override
  List<Object?> get props => [query];
}

class SelectCourse extends CreateEventEvent {
  final String courseId;
  const SelectCourse(this.courseId);

  @override
  List<Object?> get props => [courseId];
}

class SelectDate extends CreateEventEvent {
  final DateTime date;
  const SelectDate(this.date);

  @override
  List<Object?> get props => [date];
}

class SelectTime extends CreateEventEvent {
  final TimeOfDay time;
  const SelectTime(this.time);

  @override
  List<Object?> get props => [time];
}

class ChangePlayersNeeded extends CreateEventEvent {
  final int players;
  const ChangePlayersNeeded(this.players);

  @override
  List<Object?> get props => [players];
}

class ChangeSkillLevel extends CreateEventEvent {
  final String level;
  const ChangeSkillLevel(this.level);

  @override
  List<Object? > get props => [level];
}

class ChangeNotes extends CreateEventEvent {
  final String notes;
  const ChangeNotes(this.notes);

  @override
  List<Object? > get props => [notes];
}

class TogglePublic extends CreateEventEvent {
  final bool isPublic;
  const TogglePublic(this.isPublic);

  @override
  List<Object?> get props => [isPublic];
}

class SubmitEvent extends CreateEventEvent {
  const SubmitEvent();
}

class ResetForm extends CreateEventEvent {
  const ResetForm();
}