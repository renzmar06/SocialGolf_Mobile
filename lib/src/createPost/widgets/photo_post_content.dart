import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/create_post_bloc.dart';
import '../bloc/create_post_event.dart';
import '../bloc/create_post_state.dart';
import 'post_text_field.dart';

class PhotoPostContent extends StatefulWidget {
  const PhotoPostContent({super.key});

  @override
  State<PhotoPostContent> createState() => _PhotoPostContentState();
}

class _PhotoPostContentState extends State<PhotoPostContent> {
  late final TextEditingController _captionController;

  @override
  void initState() {
    super.initState();
    _captionController = TextEditingController();
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null && mounted) {
        context.read<CreatePostBloc>().add(AddImageEvent(File(image.path)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  void _showImageSourceDialog(BuildContext blocContext) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Select Image Source',
              style:  TextStyle(fontWeight: FontWeight. bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration:  BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius. circular(10),
                ),
                child: Icon(Icons.photo_camera, color: Colors.green. shade700),
              ),
              title:  const Text('Take Photo'),
              subtitle: const Text('Use your camera'),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickImage(blocContext, ImageSource. camera);
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color:  Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.photo_library, color: Colors. blue.shade700),
              ),
              title: const Text('Choose from Gallery'),
              subtitle:  const Text('Select from your photos'),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickImage(blocContext, ImageSource.gallery);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostBloc, CreatePostState>(
      builder: (context, state) {
        // Check if we have an image
        final hasImage = state.selectedImages.isNotEmpty;

        return Column(
          children: [
            // --- IMAGE SELECTION AREA ---
            GestureDetector(
              // If there's an image, tapping it opens the picker to CHANGE the photo
              onTap: () => _showImageSourceDialog(context),
              child: Container(
                height: 250, // Increased height for better single photo visibility
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
                child: !hasImage
                    ? _buildPlaceholder()
                    : _buildMainImage(state.selectedImages[0]),
              ),
            ),

            const SizedBox(height: 16),

            // --- CAPTION FIELD ---
            PostTextField(
              controller: _captionController,
              hintText: 'Write a caption...',
              maxLines: 4,
            ),
          ],
        );
      },
    );
  }

  Widget _buildPlaceholder() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.cloud_upload_outlined, size: 48, color: Colors.grey),
        SizedBox(height: 8),
        Text('Upload a photo', style: TextStyle(fontWeight: FontWeight.w500)),
        Text('Tap to select', style: TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildMainImage(File file) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            file,
            key: ValueKey(file.path),
            fit: BoxFit.cover,
            gaplessPlayback: true,
          ),
        ),
        // Overlaid change indicator
        Positioned(
          bottom: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.edit, color: Colors.white, size: 14),
                SizedBox(width: 4),
                Text('Change', style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        ),
        // Remove button
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => context.read<CreatePostBloc>().add(const RemoveImageEvent(0)),
            child: const CircleAvatar(
              radius: 14,
              backgroundColor: Colors.black54,
              child: Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}