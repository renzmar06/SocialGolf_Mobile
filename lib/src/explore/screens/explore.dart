import 'package:flutter/material.dart';
import 'package:social_golf_app/core/utils/constants/colors.dart';
import 'package:social_golf_app/core/common/widgets/common_text_field.dart';
import '../widgets/people_tab.dart';
import '../widgets/trending_tab.dart';
import '../widgets/events_tab.dart';
import '../widgets/groups_tab.dart';

class ExploreScreen extends StatelessWidget {
  ExploreScreen({super.key});

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Explore'),
          elevation: 0,
          automaticallyImplyLeading: false,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(120),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: CommonTextField(
                    controller: searchController,
                    hintText: 'Search golfers, courses, events...',
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
                ),
                TabBar(
                  indicatorColor: ColorConstants.btnColor,
                  labelColor: ColorConstants.btnColor,
                  tabs: const [
                    Tab(icon: Icon(Icons.people), text: 'People'),
                    Tab(icon: Icon(Icons.trending_up), text: 'Trending'),
                    Tab(icon: Icon(Icons.event), text: 'Events'),
                    Tab(icon: Icon(Icons.groups), text: 'Groups'),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: [PeopleTab(), TrendingTab(), EventsTab(), GroupsTab()],
        ),
      ),
    );
  }
}
