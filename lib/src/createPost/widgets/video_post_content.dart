import 'package:flutter/material.dart';
import 'post_text_field.dart';

class VideoPostContent extends StatelessWidget {
  const VideoPostContent({super.key});

  @override
  Widget build(BuildContext context) {
    final urlController = TextEditingController();
    final captionController = TextEditingController();

    return Column(
      children: [
        // Video URL field
        PostTextField(
          controller: urlController,
          hintText: 'Video URL (YouTube, Vimeo, etc.)',
          keyboardType: TextInputType.url,
        ),
        const SizedBox(height: 16),

        // Caption field
        PostTextField(
          controller: captionController,
          hintText: 'Write a caption...',
          maxLines: 4,
        ),
      ],
    );
  }
}
