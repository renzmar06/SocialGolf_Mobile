
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../bloc/create_event_bloc.dart';
import '../bloc/create_event_event.dart';
import '../bloc/create_event_state.dart';

class CreateEventScreen extends StatelessWidget {
  const CreateEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateEventBloc()..add(const LoadCourses()),
      child: const _CreateEventView(),
    );
  }
}

class _CreateEventView extends StatefulWidget {
  const _CreateEventView();

  @override
  State<_CreateEventView> createState() => _CreateEventViewState();
}

class _CreateEventViewState extends State<_CreateEventView>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _notesFocusNode = FocusNode();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration:  const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve:  Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController. dispose();
    _notesController.dispose();
    _searchFocusNode.dispose();
    _notesFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFB),
        body: BlocConsumer<CreateEventBloc, CreateEventState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              _showSnackBar(context, state.errorMessage!, isError: true);
            }
            if (state.successMessage != null) {
              HapticFeedback.heavyImpact();
              _showSuccessDialog(context);
            }
          },
          builder: (context, state) {
            return FadeTransition(
              opacity:  _fadeAnimation,
              child:  CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Custom App Bar
                    _buildSliverAppBar(context, state),

                    // Content
                    SliverPadding(
                        padding:  const EdgeInsets.only(bottom: 120),
                        sliver: SliverList(
                            delegate: SliverChildListDelegate([
                            if (state.isLoading)
                            _buildLoadingState()
                        else ...[
                        _buildProgressIndicator(state),
                    _buildCourseSection(context, state),
                    _buildDateTimeSection(context, state),
                    _buildPlayersSkillSection(context, state),
                    _buildNotesSection(context, state),
                    _buildPublicToggle(context, state),
                  ],
                  ]),
            ),
            ),
            ],
            ),
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<CreateEventBloc, CreateEventState>(
          builder:  (context, state) {
            return _buildSubmitButton(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, CreateEventState state) {
    return SliverAppBar(
      expandedHeight: 100,
      floating: false,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leadingWidth: 60,
      leading:  Padding(
        padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
        child: GestureDetector(
          onTap: () {
            HapticFeedback. lightImpact();
            context.pop();
          },
          child:  Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7F8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF1A1A1A),
              size: 20,
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets. only(right: 16, top: 8, bottom: 8),
          child: GestureDetector(
            onTap: () => _showHelpSheet(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child:  const Icon(
                Icons.help_outline_rounded,
                color: Color(0xFF666666),
                size: 20,
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,  // Center the title
        titlePadding: const EdgeInsets.only(bottom: 16),
        title: const Text(
          'Create a Round',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
            letterSpacing: -0.3,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color:  Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildProgressIndicator(CreateEventState state) {
    int completedSteps = 0;
    if (state.selectedCourseId != null) completedSteps++;
    if (state.selectedDate != null) completedSteps++;
    if (state.selectedTime != null) completedSteps++;

    double progress = completedSteps / 3;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              Text(
                'Setup Progress',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: progress == 1.0
                      ? const Color(0xFF2E7D32).withOpacity(0.1)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child:  Text(
                  '$completedSteps of 3 completed',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: progress == 1.0
                        ?  const Color(0xFF2E7D32)
                        : Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                height: 6,
                width: MediaQuery.of(context).size.width * progress * 0.9,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF66BB6A), Color(0xFF2E7D32)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2E7D32).withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 400,
      alignment: Alignment. center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow:  [
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
            'Loading courses...',
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

  Widget _buildCourseSection(BuildContext context, CreateEventState state) {
    return Container(
      margin:  const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow:  [
          BoxShadow(
            color: Colors.black. withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              children: [
                _buildSectionIcon(
                  icon: Icons.golf_course_rounded,
                  isCompleted: state.selectedCourseId != null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment. start,
                    children: [
                      const Text(
                        'Select a Course',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Choose where you want to play',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (state.selectedCourse != null)
                  _buildCompletedBadge(),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7F8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _searchFocusNode.hasFocus
                      ? const Color(0xFF2E7D32).withOpacity(0.5)
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: (value) {
                  context.read<CreateEventBloc>().add(SearchCourses(value));
                },
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Search courses...',
                  hintStyle: TextStyle(
                    color: Colors.grey. shade400,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(12),
                    child:  Icon(
                      Icons.search_rounded,
                      color: Colors.grey.shade400,
                      size: 24,
                    ),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ?  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      context.read<CreateEventBloc>().add(const SearchCourses(''));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors. grey.shade400,
                        size: 20,
                      ),
                    ),
                  )
                      : null,
                  border:  InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Course Cards
          SizedBox(
            height: 165,
            child: state.filteredCourses.isEmpty
                ? _buildEmptyCourseState()
                : ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
              itemCount: state.filteredCourses.length,
              itemBuilder: (context, index) {
                final course = state.filteredCourses[index];
                final isSelected = state.selectedCourseId == course.id;
                return _buildCourseCard(context, course, isSelected, index);
              },
            ),
          ),

          const SizedBox(height:  16),
        ],
      ),
    );
  }

  Widget _buildSectionIcon({
    required IconData icon,
    required bool isCompleted,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: isCompleted
            ? const LinearGradient(
          colors: [Color(0xFF66BB6A), Color(0xFF2E7D32)],
        )
            : null,
        color: isCompleted ?  null : const Color(0xFFF5F7F8),
        borderRadius: BorderRadius.circular(14),
        boxShadow:  isCompleted
            ? [
          BoxShadow(
            color: const Color(0xFF2E7D32).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ]
            :  null,
      ),
      child: Icon(
        isCompleted ? Icons.check_rounded : icon,
        size: 22,
        color: isCompleted ? Colors.white : const Color(0xFF666666),
      ),
    );
  }

  Widget _buildCompletedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical:  6),
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 14,
            color: Color(0xFF2E7D32),
          ),
          SizedBox(width: 4),
          Text(
            'Selected',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCourseState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons. search_off_rounded,
            size: 40,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 8),
          Text(
            'No courses found',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(
      BuildContext context,
      GolfCourse course,
      bool isSelected,
      int index,
      ) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        context.read<CreateEventBloc>().add(SelectCourse(course.id));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        width: 145,
        margin: EdgeInsets.only(
          left: index == 0 ? 4 : 0,
          right: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ?  const Color(0xFF2E7D32) : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFF2E7D32).withOpacity(0.25)
                  : Colors.black.withOpacity(0.08),
              blurRadius: isSelected ? 16 : 12,
              offset:  Offset(0, isSelected ? 8 : 4),
            ),
          ],
        ),
        child: Stack(
          children:  [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: course.imageUrl. isNotEmpty
                  ? Image.network(
                course. imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return _buildDefaultCourseImage(index);
                },
              )
                  : _buildDefaultCourseImage(index),
            ),

            // Gradient Overlay
            Positioned. fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                    stops: const [0.35, 1.0],
                  ),
                ),
              ),
            ),

            // Content
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors. white,
                      height: 1.2,
                    ),
                  ),
                  if (course.location != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 10,
                          color: Colors. white.withOpacity(0.8),
                        ),
                        const SizedBox(width:  2),
                        Expanded(
                          child: Text(
                            course.location! ,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors. white.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Selected Indicator
            if (isSelected)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32),
                    shape: BoxShape. circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2E7D32).withOpacity(0.4),
                        blurRadius:  8,
                        offset:  const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size:  14,
                    color: Colors. white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultCourseImage(int index) {
    final colors = [
      [const Color(0xFF66BB6A), const Color(0xFF2E7D32)],
      [const Color(0xFF4FC3F7), const Color(0xFF0288D1)],
      [const Color(0xFFFFB74D), const Color(0xFFF57C00)],
      [const Color(0xFFBA68C8), const Color(0xFF7B1FA2)],
      [const Color(0xFF4DB6AC), const Color(0xFF00796B)],
      [const Color(0xFFFF8A65), const Color(0xFFE64A19)],
    ];

    final colorPair = colors[index % colors.length];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment. bottomRight,
          colors: colorPair,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.golf_course_rounded,
          size: 40,
          color: Colors. white. withOpacity(0.4),
        ),
      ),
    );
  }

  Widget _buildDateTimeSection(BuildContext context, CreateEventState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical:  8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow:  [
          BoxShadow(
            color: Colors.black. withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child:  Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children:  [
                _buildSectionIcon(
                  icon: Icons.calendar_month_rounded,
                  isCompleted: state.selectedDate != null && state.selectedTime != null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Date & Time',
                        style:  TextStyle(
                          fontSize:  17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'When do you want to play?',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey. shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Column(
              children: [
                // Date Field
                _buildDateTimeFieldEnhanced(
                  context:  context,
                  label: 'Date',
                  icon: Icons.calendar_today_rounded,
                  value: state.selectedDate != null
                      ? DateFormat('EEE, MMM d').format(state.selectedDate!)
                      : 'Select date',
                  hasValue: state.selectedDate != null,
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 14),
                // Time Field
                _buildDateTimeFieldEnhanced(
                  context: context,
                  label: 'Tee Time',
                  icon: Icons.access_time_rounded,
                  value: state.selectedTime != null
                      ? state.selectedTime!.format(context)
                      : 'Select time',
                  hasValue:  state.selectedTime != null,
                  onTap: () => _selectTime(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeFieldEnhanced({
    required BuildContext context,
    required String label,
    required IconData icon,
    required String value,
    required bool hasValue,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height:  8),
        GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: hasValue
                  ? const Color(0xFF2E7D32).withOpacity(0.05)
                  : const Color(0xFFF5F7F8),
              borderRadius: BorderRadius. circular(14),
              border:  Border.all(
                color: hasValue
                    ? const Color(0xFF2E7D32).withOpacity(0.3)
                    : const Color(0xFFE8E8E8),
                width: hasValue ? 1.5 : 1,
              ),
            ),
            child:  Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: hasValue
                        ? const Color(0xFF2E7D32).withOpacity(0.1)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: hasValue
                        ? const Color(0xFF2E7D32)
                        : Colors.grey.shade400,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:  hasValue ? FontWeight.w600 : FontWeight.w400,
                      color: hasValue
                          ? const Color(0xFF1A1A1A)
                          : Colors.grey.shade400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayersSkillSection(BuildContext context, CreateEventState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors. black.withOpacity(0.04),
            blurRadius:  20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                _buildSectionIcon(
                  icon: Icons.groups_rounded,
                  isCompleted:  true,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Players & Level',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Set group size and skill requirements',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors. grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Column(
              children: [
                // Players Needed
                _buildDropdownFieldEnhanced(
                  label: 'Players Needed',
                  icon: Icons.person_add_rounded,
                  value:  '${state.playersNeeded} Player${state.playersNeeded > 1 ? 's' :  ''}',
                  items: ['1 Player', '2 Players', '3 Players', '4 Players'],
                  onChanged: (value) {
                    if (value != null) {
                      HapticFeedback. selectionClick();
                      final players = int.tryParse(value. split(' ')[0]) ?? 3;
                      context.read<CreateEventBloc>().add(ChangePlayersNeeded(players));
                    }
                  },
                ),
                const SizedBox(width:  14),
                // Skill Level
                _buildDropdownFieldEnhanced(
                  label: 'Skill Level',
                  icon: Icons.trending_up_rounded,
                  value: state.skillLevel,
                  items: ['Any Level', 'Beginner', 'Intermediate', 'Advanced'],
                  onChanged: (value) {
                    if (value != null) {
                      HapticFeedback.selectionClick();
                      context.read<CreateEventBloc>().add(ChangeSkillLevel(value));
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownFieldEnhanced({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical:  4),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7F8),
            borderRadius:  BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE8E8E8)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child:  Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
              ),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(16),
              elevation: 8,
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Row(
                    children: [
                      Container(
                        padding:  const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          icon,
                          size: 16,
                          color: const Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(item),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(BuildContext context, CreateEventState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets. all(20),
        child: Column(
          crossAxisAlignment:  CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7F8),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.notes_rounded,
                    size:  22,
                    color: Colors. grey.shade600,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Notes',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight. w700,
                              color:  Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Optional',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors. grey.shade500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Add any additional details',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7F8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _notesFocusNode.hasFocus
                      ? const Color(0xFF2E7D32).withOpacity(0.5)
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: TextField(
                controller: _notesController,
                focusNode: _notesFocusNode,
                onChanged: (value) {
                  context.read<CreateEventBloc>().add(ChangeNotes(value));
                },
                maxLines: 4,
                maxLength: 200,
                style: const TextStyle(
                  fontSize:  14,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'e.g., Cart rental included, meet at the clubhouse...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                  counterStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPublicToggle(BuildContext context, CreateEventState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets. all(20),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: state.isPublic
                    ?  const LinearGradient(
                  colors: [Color(0xFF66BB6A), Color(0xFF2E7D32)],
                )
                    : null,
                color: state.isPublic ?  null : const Color(0xFFF5F7F8),
                borderRadius: BorderRadius.circular(16),
                boxShadow: state.isPublic
                    ? [
                  BoxShadow(
                    color: const Color(0xFF2E7D32).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
                    : null,
              ),
              child: Icon(
                state. isPublic ? Icons.public_rounded : Icons.lock_rounded,
                size: 24,
                color: state.isPublic ? Colors.white : Colors. grey.shade500,
              ),
            ),
            const SizedBox(width:  16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.isPublic ? 'Public Round' : 'Private Round',
                    style: const TextStyle(
                      fontSize:  17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedSwitcher(
                    duration:  const Duration(milliseconds: 200),
                    child: Text(
                      state.isPublic
                          ? 'Anyone can discover and request to join'
                          : 'Only people you invite can join',
                      key: ValueKey(state.isPublic),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors. grey.shade500,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                context.read<CreateEventBloc>().add(TogglePublic(! state.isPublic));
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 56,
                height: 32,
                decoration: BoxDecoration(
                  gradient: state. isPublic
                      ? const LinearGradient(
                    colors: [Color(0xFF66BB6A), Color(0xFF2E7D32)],
                  )
                      : null,
                  color: state. isPublic ? null : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  alignment:  state.isPublic
                      ? Alignment.centerRight
                      : Alignment. centerLeft,
                  child:  Container(
                    margin: const EdgeInsets.all(3),
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color:  Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius:  4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, CreateEventState state) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow:  [
          BoxShadow(
            color: Colors.black. withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: state.isSubmitting || ! state.isFormValid
            ?  null
            : () {
          HapticFeedback.heavyImpact();
          context.read<CreateEventBloc>().add(const SubmitEvent());
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 60,
          decoration: BoxDecoration(
            gradient: state.isFormValid
                ? const LinearGradient(
              colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
              begin: Alignment.topLeft,
              end:  Alignment.bottomRight,
            )
                : null,
            color: state.isFormValid ?  null : const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(18),
            boxShadow: state.isFormValid
                ? [
              BoxShadow(
                color: const Color(0xFF2E7D32).withOpacity(0.4),
                blurRadius:  20,
                offset:  const Offset(0, 8),
              ),
            ]
                : null,
          ),
          child: Center(
            child: state.isSubmitting
                ? const SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.white,
              ),
            )
                : Row(
              mainAxisAlignment:  MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.flag_rounded,
                  size:  24,
                  color:  state.isFormValid
                      ? Colors.white
                      : Colors.grey.shade500,
                ),
                const SizedBox(width: 12),
                Text(
                  'Create Round',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: state. isFormValid
                        ? Colors.white
                        : Colors. grey.shade500,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime. now(),
      lastDate: DateTime. now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme. light(
              primary: Color(0xFF2E7D32),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1A1A1A),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && context.mounted) {
      context.read<CreateEventBloc>().add(SelectDate(picked));
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context:  context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data:  Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2E7D32),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1A1A1A),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && context.mounted) {
      context.read<CreateEventBloc>().add(SelectTime(picked));
    }
  }

  void _showHelpSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors. grey.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height:  24),
              const Text(
                'How to Create a Round',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height:  24),
              _buildHelpItem(
                number: '1',
                title: 'Select a Course',
                description: 'Choose from popular courses or search for your preferred location',
              ),
              _buildHelpItem(
                number:  '2',
                title: 'Set Date & Time',
                description: 'Pick when you want to play your round',
              ),
              _buildHelpItem(
                number: '3',
                title:  'Configure Settings',
                description: 'Set player count, skill level, and visibility',
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpItem({
    required String number,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight. w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF66BB6A), Color(0xFF2E7D32)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2E7D32).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 40,
                  color: Colors. white,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Round Created! ',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your round has been created successfully.\nPlayers can now join! ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors. grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height:  28),
              GestureDetector(
                onTap: () {
                  Navigator.pop(dialogContext);
                  context.pop();
                },
                child:  Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors. white,
                      ),
                    ),
                  ),
                ),
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
              child:  Icon(
                isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}