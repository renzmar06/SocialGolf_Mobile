import 'package:flutter/material.dart';
import 'package:social_golf_app/core/utils/constants/colors.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/top_navigation_bar.dart';
import '../widgets/home_feed.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.chatBotGreyBg,
      appBar: const HomeAppBar(),
      body: const Column(
        children: [
          TopNavigationBar(),
          Expanded(child: HomeFeed()),
        ],
      ),
    );
  }
}
