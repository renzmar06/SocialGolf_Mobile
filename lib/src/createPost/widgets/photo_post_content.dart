import 'package:flutter/material.dart';
import 'post_text_field.dart';

class PhotoPostContent extends StatelessWidget {
  const PhotoPostContent({super.key});

  @override
  Widget build(BuildContext context) {
    final captionController = TextEditingController();

    return Column(
      children: [
        // Upload photo area
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade300,
              style: BorderStyle.solid,
              width: 2,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 12),
                Text(
                  'Upload a photo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'PNG, JPG up to 10MB',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
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
