import 'package:flutter_bloc/flutter_bloc.dart';
import 'group_detail_event.dart';
import 'group_detail_state.dart';

class GroupDetailBloc extends Bloc<GroupDetailEvent, GroupDetailState> {
  GroupDetailBloc() : super(const GroupDetailState()) {
    on<LoadGroupDetail>(_onLoadGroupDetail);
    on<ChangeTab>(_onChangeTab);
    on<JoinGroup>(_onJoinGroup);
    on<LeaveGroup>(_onLeaveGroup);
    on<RefreshGroupData>(_onRefreshGroupData);
  }

  Future<void> _onLoadGroupDetail(
      LoadGroupDetail event,
      Emitter<GroupDetailState> emit,
      ) async {
    emit(state.copyWith(isLoading: true));
    try {
      // Simulate API call - Replace with your actual API
      await Future.delayed(const Duration(seconds: 1));

      // Mock data - Replace with actual API response
      emit(state.copyWith(
        isLoading: false,
        groupId: event.groupId,
        groupName: 'Warrior Club',
        description: 'test',
        coverImageUrl: 'https://example.com/cover.jpg',
        isPrivate: true,
        isMember: false,
        members: const [
          GroupMember(
            id: '1',
            name: 'John Doe',
            avatarUrl: 'https://example.com/avatar1.jpg',
          ),
        ],
        posts: const [],
        events: const [],
      ));
    } catch (e) {
      emit(state. copyWith(
        isLoading: false,
        errorMessage:  e.toString(),
      ));
    }
  }

  void _onChangeTab(ChangeTab event, Emitter<GroupDetailState> emit) {
    emit(state.copyWith(selectedTabIndex: event.tabIndex));
  }

  Future<void> _onJoinGroup(
      JoinGroup event,
      Emitter<GroupDetailState> emit,
      ) async {
    emit(state.copyWith(isJoining: true));
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(
        isJoining: false,
        isMember: true,
      ));
    } catch (e) {
      emit(state. copyWith(
        isJoining: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLeaveGroup(
      LeaveGroup event,
      Emitter<GroupDetailState> emit,
      ) async {
    emit(state.copyWith(isJoining: true));
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(
        isJoining: false,
        isMember: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isJoining: false,
        errorMessage:  e.toString(),
      ));
    }
  }

  Future<void> _onRefreshGroupData(
      RefreshGroupData event,
      Emitter<GroupDetailState> emit,
      ) async {
    add(LoadGroupDetail(state.groupId));
  }
}