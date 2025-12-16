import 'package:flutter/material.dart';

class PostHeader extends StatelessWidget {
  final String username;
  final String timeAgo;
  final Widget? avatar;

  const PostHeader({
    super.key,
    required this.username,
    required this.timeAgo,
    this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        avatar ??
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.amber[700],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shield, color: Colors.black, size: 24),
            ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Text(
                timeAgo,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
