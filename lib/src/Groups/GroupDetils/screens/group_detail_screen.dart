import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/group_detail_bloc.dart';
import '../bloc/group_detail_event.dart';
import '../bloc/group_detail_state.dart';

class GroupDetailScreen extends StatelessWidget {
  final String groupId;

  const GroupDetailScreen({
    super.key,
    required this. groupId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupDetailBloc().. add(LoadGroupDetail(groupId)),
      child: const _GroupDetailView(),
    );
  }
}

class _GroupDetailView extends StatelessWidget {
  const _GroupDetailView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: BlocConsumer<GroupDetailBloc, GroupDetailState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:  Text(state.errorMessage!),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state. isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF2E7D32),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // Cover Image with App Bar
              _buildSliverAppBar(context, state),

              // Group Info Card
              SliverToBoxAdapter(
                child: _buildGroupInfoCard(context, state),
              ),

              // Members Section
              SliverToBoxAdapter(
                child: _buildMembersSection(context, state),
              ),

              // Tab Bar
              SliverPersistentHeader(
                pinned: true,
                delegate:  _TabBarDelegate(
                  child: _buildTabBar(context, state),
                ),
              ),

              // Tab Content
              _buildTabContentSliver(context, state),
            ],
          );
        },
      ),
      floatingActionButton: BlocBuilder<GroupDetailBloc, GroupDetailState>(
        builder:  (context, state) {
          if (! state.isMember) return const SizedBox. shrink();
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
                begin: Alignment.topLeft,
                end: Alignment. bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2E7D32).withOpacity(0.4),
                  blurRadius:  12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: () {
                _showCreateOptionsSheet(context);
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, GroupDetailState state) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black87, size: 22),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => _showOptionsBottomSheet(context, state),
            child: Container(
              width: 40,
              height:  40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons. more_horiz, color: Colors.black87, size: 22),
            ),
          ),
        ),
      ],
      flexibleSpace:  FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            state.coverImageUrl. isNotEmpty
                ? Image. network(
              state.coverImageUrl,
              fit:  BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildDefaultCover();
              },
            )
                : _buildDefaultCover(),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors. black.withOpacity(0.3),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultCover() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment. bottomRight,
          colors: [
            Color(0xFF1B5E20),
            Color(0xFF2E7D32),
            Color(0xFF43A047),
          ],
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white. withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.groups_rounded,
            size: 60,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildGroupInfoCard(BuildContext context, GroupDetailState state) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:  Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  state.groupName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              if (state.isPrivate)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.lock_rounded,
                    size: 16,
                    color: Color(0xFF757575),
                  ),
                ),
            ],
          ),
          const SizedBox(height:  8),
          Text(
            state.description,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF666666),
              height: 1.4,
            ),
          ),
          const SizedBox(height:  16),
          Container(
            height: 1,
            color: const Color(0xFFF0F0F0),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.people_alt_rounded,
                      size:  18,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment:  CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${state.memberCount}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const Text(
                        'Members',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              _buildJoinButton(context, state),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJoinButton(BuildContext context, GroupDetailState state) {
    final bool isMember = state.isMember;
    final bool isJoining = state.isJoining;

    return GestureDetector(
      onTap: isJoining
          ? null
          : () {
        if (isMember) {
          _showLeaveConfirmDialog(context);
        } else {
          context.read<GroupDetailBloc>().add(const JoinGroup());
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          gradient: isMember
              ? null
              : const LinearGradient(
            colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          color: isMember ? const Color(0xFFF5F5F5) : null,
          borderRadius: BorderRadius.circular(12),
          boxShadow:  isMember
              ? null
              : [
            BoxShadow(
              color:  const Color(0xFF2E7D32).withOpacity(0.3),
              blurRadius:  8,
              offset:  const Offset(0, 4),
            ),
          ],
        ),
        child: isJoining
            ? SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: isMember ? const Color(0xFF2E7D32) : Colors.white,
          ),
        )
            : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isMember ? Icons. check_rounded : Icons.group_add_rounded,
              size: 18,
              color: isMember ? const Color(0xFF666666) : Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              isMember ? 'Joined' : 'Join Group',
              style: TextStyle(
                color: isMember ? const Color(0xFF666666) : Colors.white,
                fontWeight:  FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembersSection(BuildContext context, GroupDetailState state) {
    if (state.members.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              const Text(
                'Members',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E7D32),
                ),
              ),
              if (state.members.length > 5)
                GestureDetector(
                  onTap: () {
                    // Navigate to all members
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical:  6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 56,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.members.length > 8 ? 8 : state. members.length,
              itemBuilder: (context, index) {
                final member = state.members[index];
                final isLast = index == 7 && state.members.length > 8;

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child:  GestureDetector(
                    onTap: () {
                      // Navigate to member profile
                    },
                    child: isLast
                        ? _buildMoreMembersAvatar(state. members.length - 8)
                        : _buildMemberAvatar(member),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberAvatar(GroupMember member) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF2E7D32).withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color:  Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CircleAvatar(
        radius:  26,
        backgroundColor: const Color(0xFFF5F5F5),
        backgroundImage:
        member.avatarUrl.isNotEmpty ? NetworkImage(member.avatarUrl) : null,
        child: member.avatarUrl. isEmpty
            ? Text(
          member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E7D32),
            fontSize: 18,
          ),
        )
            : null,
      ),
    );
  }

  Widget _buildMoreMembersAvatar(int count) {
    return Container(
      width: 56,
      height:  56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF2E7D32).withOpacity(0.1),
        border: Border.all(
          color: const Color(0xFF2E7D32).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          '+$count',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF2E7D32),
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, GroupDetailState state) {
    final tabs = ['Posts', 'Events', 'Chat'];
    final icons = [
      Icons.grid_view_rounded,
      Icons.event_rounded,
      Icons.chat_bubble_rounded
    ];

    return Container(
      color: const Color(0xFFFAFAFA),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = state.selectedTabIndex == index;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  context.read<GroupDetailBloc>().add(ChangeTab(index));
                },
                child: AnimatedContainer(
                  duration:  const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected ?  Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color:  Colors.black.withOpacity(0.06),
                        blurRadius:  8,
                        offset:  const Offset(0, 2),
                      ),
                    ]
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icons[index],
                        size: 18,
                        color: isSelected
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFF999999),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        tabs[index],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight. w500,
                          color: isSelected
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // Fixed: Using SliverList instead of SliverFillRemaining
  Widget _buildTabContentSliver(BuildContext context, GroupDetailState state) {
    switch (state.selectedTabIndex) {
      case 0:
        return _buildPostsSliverList(state);
      case 1:
        return _buildEventsSliverList(state);
      case 2:
        return _buildChatSliverContent(context, state);
      default:
        return _buildPostsSliverList(state);
    }
  }

  Widget _buildPostsSliverList(GroupDetailState state) {
    if (state.posts.isEmpty) {
      return SliverToBoxAdapter(
        child: _buildEmptyState(
          icon: Icons.photo_library_rounded,
          title: 'No posts yet',
          subtitle: 'Be the first to share something with the group!',
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final post = state.posts[index];
            return _buildPostCard(post);
          },
          childCount: state.posts.length,
        ),
      ),
    );
  }

  Widget _buildPostCard(GroupPost post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors. white,
        borderRadius: BorderRadius.circular(20),
        boxShadow:  [
          BoxShadow(
            color: Colors.black. withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF2E7D32).withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child:  CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(post.authorAvatar),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(post.createdAt),
                      style:  const TextStyle(
                        color: Color(0xFF999999),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:  const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.more_horiz,
                  size: 18,
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            post.content,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Color(0xFF333333),
            ),
          ),
          if (post.imageUrl != null) ...[
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                post.imageUrl! ,
                fit: BoxFit.cover,
              ),
            ),
          ],
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade100),
              ),
            ),
            child:  Row(
              children: [
                _buildActionButton(
                  icon: Icons.favorite_border_rounded,
                  label:  '${post.likes}',
                  color: const Color(0xFFE91E63),
                ),
                const SizedBox(width: 24),
                _buildActionButton(
                  icon: Icons.chat_bubble_outline_rounded,
                  label:  '${post.comments}',
                  color: const Color(0xFF2196F3),
                ),
                const Spacer(),
                _buildActionButton(
                  icon: Icons.share_rounded,
                  label: 'Share',
                  color:  const Color(0xFF2E7D32),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color:  color. withOpacity(0.8)),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildEventsSliverList(GroupDetailState state) {
    if (state.events.isEmpty) {
      return SliverToBoxAdapter(
        child: _buildEmptyState(
          icon: Icons. event_rounded,
          title: 'No group events yet',
          subtitle: 'Stay tuned for upcoming events!',
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final event = state.events[index];
            return _buildEventCard(event);
          },
          childCount: state.events.length,
        ),
      ),
    );
  }

  Widget _buildEventCard(GroupEvent event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors. white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:  [
                  const Color(0xFF2E7D32).withOpacity(0.1),
                  const Color(0xFF43A047).withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child:  Column(
              children: [
                Text(
                  '${event.dateTime.day}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                Text(
                  _getMonthName(event.dateTime. month),
                  style: const TextStyle(
                    fontSize:  13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF43A047),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color:  const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.location_on_rounded,
                        size: 14,
                        color: Color(0xFF999999),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        event. location,
                        style: const TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child:  const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatSliverContent(BuildContext context, GroupDetailState state) {
    if (! state.isMember) {
      return SliverToBoxAdapter(
        child: _buildEmptyState(
          icon: Icons.lock_rounded,
          title: 'Members Only',
          subtitle: 'Join the group to access the chat',
        ),
      );
    }

    return SliverFillRemaining(
      hasScrollBody: false,
      child:  Center(
        child:  Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chat_bubble_rounded,
                  size:  48,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height:  20),
              const Text(
                'Group Chat',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Connect with other members',
                style: TextStyle(
                  color: Color(0xFF999999),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height:  24),
              GestureDetector(
                onTap: () {
                  // Navigate to chat screen
                },
                child: Container(
                  padding: const EdgeInsets. symmetric(horizontal: 32, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
                      begin: Alignment.topLeft,
                      end: Alignment. bottomRight,
                    ),
                    borderRadius: BorderRadius. circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2E7D32).withOpacity(0.3),
                        blurRadius:  12,
                        offset:  const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chat_rounded, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Open Chat',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: const BoxDecoration(
              color:  Color(0xFFF5F5F5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 56,
              color: const Color(0xFFCCCCCC),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF999999),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateOptionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      // Add this to ensure proper sizing
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        // Move SafeArea outside Container
        child: Container(
          margin: const EdgeInsets.only(top: 8), // Small margin from top
          decoration: const BoxDecoration(
            color: Colors. white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize. min,
            children: [
              const SizedBox(height:  12),
              // Handle bar - now inside the white container
              Container(
                width: 40,
                height:  4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Create',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 16),
              _buildCreateOption(
                icon: Icons.photo_library_rounded,
                title: 'New Post',
                subtitle:  'Share photos or text with the group',
                color: const Color(0xFF2196F3),
                onTap: () {
                  Navigator.pop(sheetContext);
                },
              ),
              _buildCreateOption(
                icon: Icons.event_rounded,
                title: 'New Event',
                subtitle: 'Plan an activity with group members',
                color: const Color(0xFF2E7D32),
                onTap: () {
                  Navigator.pop(sheetContext);
                },
              ),
              // Add bottom padding for safe area
              SizedBox(height: MediaQuery. of(sheetContext).padding.bottom + 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showOptionsBottomSheet(BuildContext context, GroupDetailState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 8),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius. circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              _buildOptionItem(
                icon:  Icons.share_rounded,
                title: 'Share Group',
                color: const Color(0xFF2196F3),
                onTap: () {
                  Navigator.pop(sheetContext);
                },
              ),
              _buildOptionItem(
                icon:  Icons.notifications_rounded,
                title: 'Notifications',
                color: const Color(0xFFFF9800),
                onTap: () {
                  Navigator.pop(sheetContext);
                },
              ),
              _buildOptionItem(
                icon:  Icons.flag_rounded,
                title: 'Report Group',
                color: const Color(0xFF9E9E9E),
                onTap: () {
                  Navigator.pop(sheetContext);
                },
              ),
              if (state.isMember)
                _buildOptionItem(
                  icon: Icons.exit_to_app_rounded,
                  title: 'Leave Group',
                  color: Colors.red,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _showLeaveConfirmDialog(context);
                  },
                ),
              SizedBox(height: MediaQuery. of(sheetContext).padding.bottom + 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Container(
        padding: const EdgeInsets. all(12),
        decoration:  BoxDecoration(
          color:  color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Color(0xFF999999),
          fontSize: 13,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: Color(0xFFCCCCCC),
      ),
    );
  }

  void _showLeaveConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius:  BorderRadius.circular(20),
        ),
        title: const Text(
          'Leave Group',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Are you sure you want to leave this group?  You can always join again later.',
          style: TextStyle(color: Color(0xFF666666)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF666666)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator. pop(dialogContext);
              context.read<GroupDetailBloc>().add(const LeaveGroup());
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.red. shade50,
              shape: RoundedRectangleBorder(
                borderRadius:  BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Leave',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical:  2),
      leading: Container(
        padding: const EdgeInsets. all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: color == Colors.red ? Colors.red : const Color(0xFF1A1A1A),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff. inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
    ];
    return months[month - 1];
  }
}

// Custom delegate for sticky tab bar
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _TabBarDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 72;

  @override
  double get minExtent => 72;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}