import 'package:equatable/equatable.dart';

abstract class GroupDetailEvent extends Equatable {
  const GroupDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadGroupDetail extends GroupDetailEvent {
  final String groupId;
  const LoadGroupDetail(this.groupId);

  @override
  List<Object?> get props => [groupId];
}

class ChangeTab extends GroupDetailEvent {
  final int tabIndex;
  const ChangeTab(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}

class JoinGroup extends GroupDetailEvent {
  const JoinGroup();
}

class LeaveGroup extends GroupDetailEvent {
  const LeaveGroup();
}

class RefreshGroupData extends GroupDetailEvent {
  const RefreshGroupData();
}