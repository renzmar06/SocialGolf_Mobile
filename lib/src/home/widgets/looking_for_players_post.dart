import 'package:flutter/material.dart';
import 'post_header.dart';
import 'post_interaction_bar.dart';

class LookingForPlayersPost extends StatelessWidget {
  final String username;
  final String timeAgo;
  final String location;
  final String time;
  final int playersNeeded;
  final String description;
  final int likes;
  final int comments;

  const LookingForPlayersPost({
    super.key,
    required this.username,
    required this.timeAgo,
    required this.location,
    required this.time,
    required this.playersNeeded,
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
          _buildPostContent(),
          const SizedBox(height: 16),
          PostInteractionBar(likes: likes, comments: comments),
        ],
      ),
    );
  }

  Widget _buildPostContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.flag_outlined, size: 18, color: Colors.grey[700]),
            const SizedBox(width: 8),
            const Text(
              'Looking for Players',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              location,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(time, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.people_outline, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              '$playersNeeded players needed',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }
}
