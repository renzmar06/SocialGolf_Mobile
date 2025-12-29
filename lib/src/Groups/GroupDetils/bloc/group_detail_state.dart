import 'package:equatable/equatable.dart';

class GroupMember {
  final String id;
  final String name;
  final String avatarUrl;

  const GroupMember({
    required this.id,
    required this. name,
    required this.avatarUrl,
  });
}

class GroupPost {
  final String id;
  final String authorName;
  final String authorAvatar;
  final String content;
  final String?  imageUrl;
  final DateTime createdAt;
  final int likes;
  final int comments;

  const GroupPost({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.content,
    this. imageUrl,
    required this. createdAt,
    this.likes = 0,
    this.comments = 0,
  });
}

class GroupEvent {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String location;

  const GroupEvent({
    required this.id,
    required this.title,
    required this. description,
    required this.dateTime,
    required this.location,
  });
}

class GroupDetailState extends Equatable {
  final String groupId;
  final String groupName;
  final String description;
  final String coverImageUrl;
  final bool isPrivate;
  final bool isMember;
  final bool isLoading;
  final bool isJoining;
  final int selectedTabIndex;
  final List<GroupMember> members;
  final List<GroupPost> posts;
  final List<GroupEvent> events;
  final String?  errorMessage;

  const GroupDetailState({
    this.groupId = '',
    this.groupName = '',
    this.description = '',
    this. coverImageUrl = '',
    this.isPrivate = false,
    this.isMember = false,
    this.isLoading = false,
    this.isJoining = false,
    this.selectedTabIndex = 0,
    this.members = const [],
    this.posts = const [],
    this.events = const [],
    this.errorMessage,
  });

  int get memberCount => members.length;

  GroupDetailState copyWith({
    String? groupId,
    String?  groupName,
    String? description,
    String? coverImageUrl,
    bool? isPrivate,
    bool? isMember,
    bool? isLoading,
    bool? isJoining,
    int? selectedTabIndex,
    List<GroupMember>? members,
    List<GroupPost>? posts,
    List<GroupEvent>? events,
    String? errorMessage,
  }) {
    return GroupDetailState(
      groupId:  groupId ?? this.groupId,
      groupName: groupName ??  this.groupName,
      description: description ?? this.description,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      isPrivate: isPrivate ?? this.isPrivate,
      isMember: isMember ?? this.isMember,
      isLoading: isLoading ?? this.isLoading,
      isJoining: isJoining ?? this.isJoining,
      selectedTabIndex:  selectedTabIndex ?? this.selectedTabIndex,
      members: members ??  this.members,
      posts: posts ?? this.posts,
      events: events ?? this.events,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object? > get props => [
    groupId,
    groupName,
    description,
    coverImageUrl,
    isPrivate,
    isMember,
    isLoading,
    isJoining,
    selectedTabIndex,
    members,
    posts,
    events,
    errorMessage,
  ];
}