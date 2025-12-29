import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/widgets/common_text_field.dart';
import '../../../../core/utils/constants/colors.dart';
import '../bloc/event_list_bloc.dart';
import '../bloc/event_list_event.dart';
import '../bloc/event_list_state.dart';

class EventListScreen extends StatelessWidget {
  const EventListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventsBloc()..add(const LoadEvents()),
      child: const _EventsView(),
    );
  }
}

class _EventsView extends StatefulWidget {
  const _EventsView();

  @override
  State<_EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<_EventsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<EventsBloc, EventsState>(
          listener: (context, state) {
            if (state. errorMessage != null) {
              _showSnackBar(context, state.errorMessage!);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                // Fixed Header Section
                _buildHeader(context),

                // Search Bar
                _buildSearchBar(context),

                // Filter Chips
                _buildFilterChips(context, state),

                // Events List
                Expanded(
                  child: state.isLoading
                      ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF2E7D32),
                    ),
                  )
                      :  state.eventGroups.isEmpty
                      ?  _buildEmptyState()
                      : _buildEventsList(context, state),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      color: const Color(0xFFFAFAFA),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow:  [
                  BoxShadow(
                    color: Colors. black.withOpacity(0.04),
                    blurRadius:  10,
                    offset:  const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Title
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Events Near You',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CommonTextField(
        // controller: controller,
        hintText: 'Search events...',
        fillColor: Colors.grey[100]!,
        borderColor: Colors.transparent,
        borderRadius: 12,
        maxLines: 1,
        textInputAction: TextInputAction.search,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Icon(Icons.search, color: ColorConstants.grey),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, EventsState state) {
    final filters = [
      {'label': 'All', 'filter': EventFilter.all, 'icon': Icons.apps_rounded},
      {'label':  'Today', 'filter': EventFilter. today, 'icon': Icons. today_rounded},
      {'label':  'Tomorrow', 'filter': EventFilter. tomorrow, 'icon': Icons. event_rounded},
      {'label': 'This Week', 'filter': EventFilter.thisWeek, 'icon': Icons.date_range_rounded},
    ];

    return Container(
      height: 45,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters. length,
        itemBuilder: (context, index) {
          final filterData = filters[index];
          final filter = filterData['filter'] as EventFilter;
          final label = filterData['label'] as String;
          final isSelected = state.selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () {
                context.read<EventsBloc>().add(ChangeFilter(filter));
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2E7D32) : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border. all(
                    color: isSelected
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFFE8E8E8),
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                      color: const Color(0xFF2E7D32).withOpacity(0.25),
                      blurRadius:  8,
                      offset:  const Offset(0, 3),
                    ),
                  ]
                      : null,
                ),
                child:  Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors. white : const Color(0xFF666666),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventsList(BuildContext context, EventsState state) {
    return RefreshIndicator(
      color: const Color(0xFF2E7D32),
      onRefresh: () async {
        context.read<EventsBloc>().add(const RefreshEvents());
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 100),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.eventGroups.length,
        itemBuilder: (context, index) {
          final group = state.eventGroups[index];
          return _buildEventGroup(context, group, state);
        },
      ),
    );
  }

  Widget _buildEventGroup(BuildContext context, EventGroup group, EventsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Header
        Container(
          margin: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child:  const Icon(
                  Icons.calendar_today_rounded,
                  size: 16,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _formatDateHeader(group.date),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:  Text(
                  '${group.eventCount} event${group.eventCount > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Events
        ... group.events.map((event) => _buildEventCard(context, event, state)),
      ],
    );
  }

  Widget _buildEventCard(BuildContext context, EventModel event, EventsState state) {
    final isJoining = state.joiningEventId == event.id;

    return GestureDetector(
      onTap: (){
        context.push('/EventDetail',extra: event.id);
      },
      child: Container(
        margin:  const EdgeInsets.fromLTRB(20, 0, 20, 16),
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
            // Event Image Section
            Stack(
              children: [
                // Image
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: Container(
                    height: 160,
                    width: double. infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF37474F),
                          const Color(0xFF263238),
                        ],
                      ),
                    ),
                    child: event. imageUrl.isNotEmpty
                        ? Image.network(
                      event.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultImage();
                      },
                    )
                        : _buildDefaultImage(),
                  ),
                ),

                // Gradient Overlay
                Positioned. fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                      gradient: LinearGradient(
                        begin:  Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.4, 1.0],
                      ),
                    ),
                  ),
                ),

                // Level Badge
                Positioned(
                  top: 16,
                  right: 16,
                  child: ClipRRect(
                    borderRadius:  BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white. withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          event.level,
                          style: const TextStyle(
                            fontSize:  12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Event Title on Image
                Positioned(
                  bottom: 16,
                  left: 20,
                  right: 20,
                  child:  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors. white,
                      letterSpacing: -0.5,
                      shadows: [
                        Shadow(
                          color: Colors.black38,
                          blurRadius:  8,
                          offset:  Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Event Details Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Date & Time Row
                  Row(
                    children: [
                      _buildInfoBadge(
                        icon:  Icons.calendar_today_rounded,
                        label: DateFormat('MMM d').format(event.dateTime),
                        color: const Color(0xFF2E7D32),
                      ),
                      const SizedBox(width: 12),
                      _buildInfoBadge(
                        icon: Icons.access_time_rounded,
                        label: DateFormat('HH:mm').format(event.dateTime),
                        color:  const Color(0xFF1976D2),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Divider
                  Container(
                    height: 1,
                    color: const Color(0xFFF0F0F0),
                  ),

                  const SizedBox(height: 18),

                  // Participants & Join Button Row
                  Row(
                    children: [
                      // Stacked Avatars
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(
                              width:  70,
                              height: 36,
                              child: Stack(
                                children: List.generate(
                                  event. participants.length > 3
                                      ? 3
                                      : event.participants.length,
                                      (index) {
                                    return Positioned(
                                      left: index * 18.0,
                                      child:  Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2.5,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black. withOpacity(0.1),
                                              blurRadius:  4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: CircleAvatar(
                                          radius: 16,
                                          backgroundColor: const Color(0xFFE8F5E9),
                                          backgroundImage: event
                                              .participants[index]
                                              .avatarUrl
                                              .isNotEmpty
                                              ? NetworkImage(
                                              event.participants[index]. avatarUrl)
                                              : null,
                                          child: event.participants[index]
                                              .avatarUrl
                                              .isEmpty
                                              ? Text(
                                            event.participants[index].name
                                                .isNotEmpty
                                                ?  event.participants[index]
                                                .name[0]
                                                . toUpperCase()
                                                : '?',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color:  Color(0xFF2E7D32),
                                            ),
                                          )
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${event.spotsLeft}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight:  FontWeight.w800,
                                      color: Color(0xFF2E7D32),
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' spot${event.spotsLeft > 1 ? 's' : ''} left',
                                    style: TextStyle(
                                      fontSize:  14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Join Button
                      GestureDetector(
                        onTap: isJoining
                            ? null
                            : () {
                          if (event.isJoined) {
                            context.read<EventsBloc>().add(LeaveEvent(event.id));
                          } else {
                            context.read<EventsBloc>().add(JoinEvent(event.id));
                          }
                        },
                        child: AnimatedContainer(
                          duration:  const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: event.isJoined
                                ? null
                                : const LinearGradient(
                              colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
                              begin: Alignment.topLeft,
                              end:  Alignment.bottomRight,
                            ),
                            color: event.isJoined ?  const Color(0xFFF5F5F5) : null,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: event.isJoined
                                ? null
                                : [
                              BoxShadow(
                                color: const Color(0xFF2E7D32).withOpacity(0.35),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: isJoining
                              ? SizedBox(
                            width:  20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: event.isJoined
                                  ? const Color(0xFF2E7D32)
                                  : Colors.white,
                            ),
                          )
                              : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                event.isJoined
                                    ? Icons.check_rounded
                                    : Icons.flag_rounded,
                                size: 18,
                                color: event.isJoined
                                    ? const Color(0xFF666666)
                                    : Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                event.isJoined ?  'Joined' : 'Join',
                                style:  TextStyle(
                                  color: event.isJoined
                                      ? const Color(0xFF666666)
                                      : Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical:  8),
      decoration: BoxDecoration(
        color: color. withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize:  MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color:  color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultImage() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF546E7A),
            Color(0xFF37474F),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.golf_course_rounded,
          size: 56,
          color: Colors.white. withOpacity(0.2),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child:  Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.event_busy_rounded,
                size: 64,
                color: Color(0xFFCCCCCC),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'No events found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Check back later or create\nyour own event! ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () =>   context.push("/CreateEvent"),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  mainAxisSize:  MainAxisSize.min,
                  children: [
                    Icon(Icons.add_rounded, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Create Event',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
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
    );
  }

  Widget _buildFAB(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push("/CreateEvent"),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow:  [
            BoxShadow(
              color: const Color(0xFF2E7D32).withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons. add_rounded, color: Colors. white, size: 22),
            SizedBox(width: 10),
            Text(
              'Create Event',
              style: TextStyle(
                color: Colors. white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today, ${DateFormat('MMMM d').format(date)}';
    } else if (dateOnly == tomorrow) {
      return 'Tomorrow, ${DateFormat('MMMM d').format(date)}';
    } else {
      return DateFormat('EEEE, MMMM d').format(date);
    }
  }
}