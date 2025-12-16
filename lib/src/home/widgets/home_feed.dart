import 'package:flutter/material.dart';
import 'looking_for_players_post.dart';
import 'score_post.dart';

class HomeFeed extends StatelessWidget {
  const HomeFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        LookingForPlayersPost(
          username: 'renzmarr06',
          timeAgo: '4 days ago',
          location: 'Looking for a beginner player',
          time: '20:12',
          playersNeeded: 5,
          description: 'test',
          likes: 0,
          comments: 0,
        ),
        SizedBox(height: 16),
        ScorePost(
          username: 'renzmarr06',
          timeAgo: '4 days ago',
          courseName: 'Golf San francisco',
          date: '2025-12-11',
          score: 88,
          description: 'test',
          likes: 1,
          comments: 0,
        ),
        SizedBox(height: 16),
        LookingForPlayersPost(
          username: 'renzmarr06',
          timeAgo: '4 days ago',
          location: 'Looking for a beginner player',
          time: '20:12',
          playersNeeded: 5,
          description: 'test',
          likes: 0,
          comments: 0,
        ),
      ],
    );
  }
}
