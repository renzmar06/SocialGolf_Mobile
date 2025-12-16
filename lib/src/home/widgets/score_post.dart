import 'package:flutter/material.dart';
import 'post_header.dart';
import 'post_interaction_bar.dart';
import 'score_card.dart';

class ScorePost extends StatelessWidget {
  final String username;
  final String timeAgo;
  final String courseName;
  final String date;
  final int score;
  final String description;
  final int likes;
  final int comments;

  const ScorePost({
    super.key,
    required this.username,
    required this.timeAgo,
    required this.courseName,
    required this.date,
    required this.score,
    required this.description,
    this.likes = 0,
    this.comments = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostHeader(username: username, timeAgo: timeAgo),
          const SizedBox(height: 12),
          ScoreCard(courseName: courseName, date: date, score: score),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          PostInteractionBar(likes: likes, comments: comments),
        ],
      ),
    );
  }
}
