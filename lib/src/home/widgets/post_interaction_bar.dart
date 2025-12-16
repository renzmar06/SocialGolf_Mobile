import 'package:flutter/material.dart';

class PostInteractionBar extends StatelessWidget {
  final int likes;
  final int comments;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;

  const PostInteractionBar({
    super.key,
    this.likes = 0,
    this.comments = 0,
    this.onLike,
    this.onComment,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onLike,
          child: Row(
            children: [
              Icon(Icons.favorite_border, size: 20, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                '$likes',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        InkWell(
          onTap: onComment,
          child: Row(
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 20,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 6),
              Text(
                '$comments',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: onShare,
          child: Icon(Icons.share_outlined, size: 20, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
