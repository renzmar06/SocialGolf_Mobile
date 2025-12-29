import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_golf_app/core/utils/constants/colors.dart';

// CreatePost Imports
import 'package:social_golf_app/src/createPost/bloc/create_post_event.dart';
import 'package:social_golf_app/src/createPost/bloc/create_post_state.dart';
import '../../createPost/bloc/create_post_bloc.dart';
import '../../createPost/widgets/find_players_post_content.dart';
import '../../createPost/widgets/photo_post_content.dart';
import '../../createPost/widgets/post_tab_button.dart';
import '../../createPost/widgets/score_post_content.dart';
import '../../createPost/widgets/sell_item_post_content.dart';
import '../../createPost/widgets/text_post_content.dart';
import '../../createPost/widgets/user_info_header.dart';
import '../../createPost/widgets/video_post_content.dart';

// Home Imports
import '../widgets/home_app_bar.dart';
import '../widgets/top_navigation_bar.dart';
import '../widgets/home_feed.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreatePostBloc(),
      child: const HomeScreenContent(),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  final List<Map<String, dynamic>> _tabs = const [
    {'icon': Icons.photo_library_outlined, 'label': 'Photo'},
    {'icon': Icons.videocam_outlined, 'label': 'Video'},
    {'icon': Icons.text_fields, 'label': 'Text'},
    {'icon': Icons.golf_course, 'label': 'Score'},
    {'icon': Icons.people_outline, 'label': 'Find Players'},
    {'icon': Icons.shopping_bag_outlined, 'label': 'Sell Item'},
  ];

  Widget _buildCreatePostContent(int selectedTabIndex) {
    switch (selectedTabIndex) {
      case 0: return const PhotoPostContent();
      case 1: return const VideoPostContent();
      case 2: return const TextPostContent();
      case 3: return const ScorePostContent();
      case 4: return const FindPlayersPostContent();
      case 5: return const SellItemPostContent();
      default: return const PhotoPostContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostBloc, CreatePostState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ColorConstants.chatBotGreyBg,
          appBar: const HomeAppBar(),
          body: Column(
            children: [
              const TopNavigationBar(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: List.generate(_tabs.length, (index) {
                                final tab = _tabs[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: PostTabButton(
                                    icon: tab['icon'],
                                    label: tab['label'],
                                    isSelected: state.selectedTabIndex == index,
                                    onTap: () {
                                      final bloc = context.read<CreatePostBloc>();
                                      bloc.add(const ClearImagesEvent());
                                      bloc.add(ChangeTabEvent(index));
                                    },
                                  ),
                                );
                              }),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(child: const UserInfoHeader(userName: 'Vikas Lohar')),
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: TextButton(
                                  onPressed: () {
                                    // Handle post submission
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: ColorConstants.btnColor,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Post',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 1),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: _buildCreatePostContent(state.selectedTabIndex),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const HomeFeed(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}