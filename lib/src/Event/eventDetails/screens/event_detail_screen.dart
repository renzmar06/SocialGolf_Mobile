import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import '../bloc/event_detail_bloc.dart';
import '../bloc/event_detail_event.dart';
import '../bloc/event_detail_state.dart';

class EventDetailScreen extends StatelessWidget {
  final String eventId;

  const EventDetailScreen({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventDetailBloc().. add(LoadEventDetail(eventId)),
      child: const _EventDetailView(),
    );
  }
}

class _EventDetailView extends StatelessWidget {
  const _EventDetailView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: BlocConsumer<EventDetailBloc, EventDetailState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            _showSnackBar(context, state.errorMessage!, isError: true);
          }
          if (state.successMessage != null) {
            _showSnackBar(context, state.successMessage!, isError: false);
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return _buildLoadingState();
          }

          if (state.event == null) {
            return _buildErrorState(context);
          }

          return Stack(
            children: [
              // Main Content
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildSliverAppBar(context, state. event!),
                  SliverToBoxAdapter(
                    child:  Column(
                      children: [
                        _buildEventInfoCard(context, state.event!),
                        _buildPlayersSection(context, state.event!),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ],
              ),
              _buildBottomButtons(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius. circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius:  20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const CircularProgressIndicator(
              color: Color(0xFF2E7D32),
              strokeWidth:  3,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Loading event details...',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade600,
              fontWeight: FontWeight. w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child:  Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.event_busy_rounded,
                size: 56,
                color: Colors.red.shade300,
              ),
            ),
            const SizedBox(height:  24),
            const Text(
              'Event not found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This event may have been removed\nor is no longer available.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                padding: const EdgeInsets. symmetric(horizontal: 32, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  'Go Back',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, EventDetailModel event) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      stretch: true,
      backgroundColor: const Color(0xFF1A1A1A),
      elevation: 0,
      leading:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => context.pop(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color:  Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors. white,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              context.read<EventDetailBloc>().add(const ShareEvent());
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter. blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.share_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Cover Image
            event.imageUrl.isNotEmpty
                ? Image.network(
              event.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildDefaultCover();
              },
            )
                : _buildDefaultCover(),

            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.black. withOpacity(0.8),
                  ],
                  stops: const [0.3, 1.0],
                ),
              ),
            ),

            // Level Badge and Title
            Positioned(
              bottom: 24,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment. start,
                children: [
                  // Level Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius:  10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2E7D32).withOpacity(0.4),
                                blurRadius:  6,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          event.level,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Event Title
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -1,
                      height: 1.1,
                      shadows: [
                        Shadow(
                          color: Colors.black45,
                          blurRadius:  10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),

                  // Location (if available)
                  if (event.location != null && event.location!.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size:  16,
                          color:  Colors.white. withOpacity(0.8),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          event.location! ,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors. white.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
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
            Color(0xFF37474F),
            Color(0xFF263238),
            Color(0xFF1A1A1A),
          ],
        ),
      ),
      child: Center(
        child:  Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white. withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.golf_course_rounded,
            size: 70,
            color: Colors.white. withOpacity(0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildEventInfoCard(BuildContext context, EventDetailModel event) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow:  [
          BoxShadow(
            color: Colors.black. withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Host Section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Host Avatar with Badge
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child:  CircleAvatar(
                          radius: 28,
                          backgroundColor: const Color(0xFFE8F5E9),
                          backgroundImage: event.host.avatarUrl.isNotEmpty
                              ? NetworkImage(event.host.avatarUrl)
                              : null,
                          child: event.host.avatarUrl.isEmpty
                              ? Text(
                            event.host.username.isNotEmpty
                                ? event.host. username[0].toLowerCase()
                                : '?',
                            style:  const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2E7D32),
                            ),
                          )
                              : null,
                        ),
                      ),
                    ),
                    // Premium Badge
                    if (event. host.isPremium)
                      Positioned(
                        right:  0,
                        bottom: 0,
                        child: Container(
                          padding:  const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color:  Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.workspace_premium_rounded,
                            size: 16,
                            color: Color(0xFFFFB300),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),

                // Host Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.host. username,
                        style: const TextStyle(
                          fontSize:  18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB300).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Host',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFFF8F00),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Message Host Button
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.message_rounded,
                    size: 20,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),

          // Divider with better design
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey.shade200.withOpacity(0),
                    Colors.grey.shade200,
                    Colors.grey.shade200.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),

          // Event Details
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildInfoRow(
                  icon: Icons.calendar_today_rounded,
                  iconColor: const Color(0xFF2E7D32),
                  backgroundColor: const Color(0xFFE8F5E9),
                  title: DateFormat('EEEE, MMMM d, yyyy').format(event.date),
                  subtitle: 'Date',
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  icon: Icons.access_time_rounded,
                  iconColor: const Color(0xFF1976D2),
                  backgroundColor:  const Color(0xFFE3F2FD),
                  title: event.teeTime,
                  subtitle: 'Tee Time',
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  icon: Icons. groups_rounded,
                  iconColor: const Color(0xFFFF9800),
                  backgroundColor: const Color(0xFFFFF3E0),
                  title:  '${event.joinedPlayers} / ${event.totalSpots} Players',
                  subtitle: event.spotsLeft > 0
                      ? '${event.spotsLeft} spot${event.spotsLeft != 1 ? 's' :  ''} left'
                      : 'Event is full',
                  subtitleColor: event.spotsLeft > 0
                      ? Colors.grey.shade500
                      : Colors.red.shade400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    required String subtitle,
    Color?  subtitleColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            size: 24,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height:  3),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: subtitleColor ?? Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlayersSection(BuildContext context, EventDetailModel event) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow:  [
          BoxShadow(
            color: Colors.black. withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
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
                    const SizedBox(width: 12),
                    const Text(
                      'Players Joined',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${event. joinedPlayers}/${event.totalSpots}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Players List
          ... event.players.asMap().entries.map((entry) {
            final index = entry.key;
            final player = entry.value;
            return Column(
              children: [
                if (index > 0)
                  Padding(
                    padding: const EdgeInsets. symmetric(horizontal: 20),
                    child:  Divider(
                      height: 1,
                      color: Colors.grey.shade100,
                    ),
                  ),
                _buildPlayerTile(player),
              ],
            );
          }),

          // Open Spots
          ... List.generate(event.spotsLeft, (index) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child:  Divider(
                    height: 1,
                    color: Colors.grey.shade100,
                  ),
                ),
                _buildOpenSpotTile(index + 1),
              ],
            );
          }),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildPlayerTile(PlayerModel player) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          // Avatar
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: player.isHost
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFFE0E0E0),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius:  8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child:  CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color(0xFFE8F5E9),
                  backgroundImage: player.avatarUrl. isNotEmpty
                      ? NetworkImage(player.avatarUrl)
                      : null,
                  child: player.avatarUrl. isEmpty
                      ? Text(
                    player.username. isNotEmpty
                        ? player.username[0].toLowerCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2E7D32),
                    ),
                  )
                      :  null,
                ),
              ),
              if (player.isPremium)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.workspace_premium_rounded,
                      size: 14,
                      color: Color(0xFFFFB300),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width:  14),

          // Player Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.username,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getLevelColor(player.level).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    player.level,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _getLevelColor(player.level),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Host Badge
          if (player.isHost)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration:  BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
                ),
                borderRadius: BorderRadius. circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFB300).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size:  14,
                    color: Colors. white,
                  ),
                  const SizedBox(width:  4),
                  const Text(
                    'Host',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _getLevelColor(String level) {
    switch (level. toLowerCase()) {
      case 'beginner':
        return const Color(0xFF4CAF50);
      case 'intermediate':
        return const Color(0xFF2196F3);
      case 'advanced':
        return const Color(0xFFFF9800);
      case 'professional':
        return const Color(0xFFE91E63);
      default:
        return const Color(0xFF2E7D32);
    }
  }

  Widget _buildOpenSpotTile(int spotNumber) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          // Empty Avatar with Animation
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF5F5F5),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child:  Center(
              child: Icon(
                Icons.person_add_alt_1_rounded,
                size: 24,
                color:  Colors.grey.shade400,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Open Spot Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment. start,
              children: [
                Text(
                  'Open spot #$spotNumber',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Waiting for player...',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors. grey.shade400,
                  ),
                ),
              ],
            ),
          ),

          // Invite Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child:  Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.person_add_rounded,
                  size: 16,
                  color: Color(0xFF2E7D32),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Invite',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context, EventDetailState state) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding:  EdgeInsets.fromLTRB(
          20,
          16,
          20,
          MediaQuery.of(context).padding.bottom + 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Join to Chat Button
            Expanded(
              flex: 4,
              child: GestureDetector(
                onTap: () {
                  context.read<EventDetailBloc>().add(const OpenChat());
                },
                child:  Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE0E0E0),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline_rounded,
                        size:  22,
                        color: Colors.grey.shade700,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Chat',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Join Round Button
            Expanded(
              flex: 6,
              child: GestureDetector(
                onTap: state.isJoining
                    ? null
                    : () {
                  if (state.event?. isJoined ??  false) {
                    _showLeaveConfirmDialog(context);
                  } else {
                    context.read<EventDetailBloc>().add(const JoinEvent());
                  }
                },
                child: AnimatedContainer(
                  duration:  const Duration(milliseconds: 200),
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: (state.event?.isJoined ?? false)
                        ? null
                        : const LinearGradient(
                      colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
                      begin: Alignment.topLeft,
                      end:  Alignment.bottomRight,
                    ),
                    color: (state.event?.isJoined ?? false)
                        ? const Color(0xFFF0F0F0)
                        : null,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: (state.event?.isJoined ?? false)
                        ? null
                        : [
                      BoxShadow(
                        color: const Color(0xFF2E7D32).withOpacity(0.4),
                        blurRadius:  16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: state.isJoining
                      ? Center(
                    child: SizedBox(
                      width:  24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: (state.event?.isJoined ?? false)
                            ?  const Color(0xFF2E7D32)
                            : Colors.white,
                      ),
                    ),
                  )
                      : Row(
                    mainAxisAlignment:  MainAxisAlignment.center,
                    children: [
                      Icon(
                        (state.event?.isJoined ?? false)
                            ?  Icons.check_circle_rounded
                            : Icons.flag_rounded,
                        size:  22,
                        color: (state.event?.isJoined ??  false)
                            ? const Color(0xFF666666)
                            : Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        (state.event?.isJoined ?? false)
                            ? 'Joined'
                            : 'Join Round',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: (state.event?.isJoined ?? false)
                              ? const Color(0xFF666666)
                              : Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLeaveConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius:  BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors. red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.exit_to_app_rounded,
                  size: 32,
                  color: Colors.red. shade400,
                ),
              ),
              const SizedBox(height:  20),
              const Text(
                'Leave Round?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Are you sure you want to leave this round?  Your spot will become available for others.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(dialogContext),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator. pop(dialogContext);
                        context.read<EventDetailBloc>().add(const LeaveEvent());
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.red.shade500,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(
                          child: Text(
                            'Leave',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight. w700,
                              color: Colors. white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white. withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isError ? Icons. error_outline_rounded : Icons. check_circle_outline_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width:  14),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.red. shade600 : const Color(0xFF2E7D32),
        shape: RoundedRectangleBorder(
          borderRadius:  BorderRadius.circular(14),
        ),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical:  14),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}