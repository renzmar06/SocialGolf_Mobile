import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_golf_app/core/utils/constants/colors.dart';
import '../widgets/user_info_header.dart';
import '../widgets/post_tab_button.dart';
import '../widgets/photo_post_content.dart';
import '../widgets/video_post_content.dart';
import '../widgets/text_post_content.dart';
import '../widgets/score_post_content.dart';
import '../widgets/find_players_post_content.dart';
import '../widgets/sell_item_post_content.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CreatePostScreenContent();
  }
}

class _CreatePostScreenContent extends StatefulWidget {
  const _CreatePostScreenContent();

  @override
  State<_CreatePostScreenContent> createState() =>
      _CreatePostScreenContentState();
}

class _CreatePostScreenContentState extends State<_CreatePostScreenContent> {
  int _selectedTabIndex = 0;

  final List<Map<String, dynamic>> _tabs = [
    {'icon': Icons.photo_library_outlined, 'label': 'Photo'},
    {'icon': Icons.videocam_outlined, 'label': 'Video'},
    {'icon': Icons.text_fields, 'label': 'Text'},
    {'icon': Icons.golf_course, 'label': 'Score'},
    {'icon': Icons.people_outline, 'label': 'Find Players'},
    {'icon': Icons.shopping_bag_outlined, 'label': 'Sell Item'},
  ];

  Widget _buildContent() {
    switch (_selectedTabIndex) {
      case 0:
        return const PhotoPostContent();
      case 1:
        return const VideoPostContent();
      case 2:
        return const TextPostContent();
      case 3:
        return const ScorePostContent();
      case 4:
        return const FindPlayersPostContent();
      case 5:
        return const SellItemPostContent();
      default:
        return const PhotoPostContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text(
          'Create Post',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
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
      body: Column(
        children: [
          // Tab buttons
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_tabs.length, (index) {
                  final tab = _tabs[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: PostTabButton(
                      icon: tab['icon'],
                      label: tab['label'],
                      isSelected: _selectedTabIndex == index,
                      onTap: () {
                        setState(() {
                          _selectedTabIndex = index;
                        });
                      },
                    ),
                  );
                }),
              ),
            ),
          ),

          // User info header
          const UserInfoHeader(userName: 'Vikas Lohar'),

          const Divider(height: 1),

          // Content area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }
}
