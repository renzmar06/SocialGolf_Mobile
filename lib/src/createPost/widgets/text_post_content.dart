import 'package:flutter/material.dart';
import 'post_text_field.dart';

class TextPostContent extends StatelessWidget {
  const TextPostContent({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    return PostTextField(
      controller: textController,
      hintText: "What's on your mind?",
      maxLines: 10,
    );
  }
}
