import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/create_post_bloc.dart';
import '../bloc/create_post_event.dart';
import '../bloc/create_post_state.dart';
import 'post_text_field.dart';

class SellItemPostContent extends StatelessWidget {
  const SellItemPostContent({super.key});

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null && context.mounted) {
        context.read<CreatePostBloc>().add(AddImageEvent(File(image.path)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
      }
    }
  }

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Take Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(context, ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemNameController = TextEditingController();
    final priceController = TextEditingController();
    final descriptionController = TextEditingController();

    return BlocBuilder<CreatePostBloc, CreatePostState>(
      builder: (context, state) {
        return Column(
          children: [
            // Upload item photo area
            GestureDetector(
              onTap: () => _showImageSourceDialog(context),
              child: Container(
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
                child: state.selectedImages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Add item photo',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tap to select image',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            Image.file(
                              state.selectedImages[0],
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Row(
                                children: [
                                  if (state.selectedImages.length > 1)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '+${state.selectedImages.length - 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(width: 8),
                                  CircleAvatar(
                                    backgroundColor: Colors.black54,
                                    radius: 16,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        context.read<CreatePostBloc>().add(
                                          const RemoveImageEvent(0),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),

            // Additional images gallery
            if (state.selectedImages.length > 1) ...<Widget>[
              const SizedBox(height: 12),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.selectedImages.length - 1,
                  itemBuilder: (context, index) {
                    final imageIndex = index + 1;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              state.selectedImages[imageIndex],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: CircleAvatar(
                              backgroundColor: Colors.black54,
                              radius: 12,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  size: 12,
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  context.read<CreatePostBloc>().add(
                                    RemoveImageEvent(imageIndex),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],

            // Add more photos button
            if (state.selectedImages.isNotEmpty &&
                state.selectedImages.length < 5) ...<Widget>[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _showImageSourceDialog(context),
                icon: const Icon(Icons.add_photo_alternate_outlined),
                label: const Text('Add More Photos'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey.shade700,
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Item name
            PostTextField(
              controller: itemNameController,
              hintText: 'Item name',
            ),
            const SizedBox(height: 12),

            // Price
            PostTextField(
              controller: priceController,
              hintText: 'Price',
              keyboardType: TextInputType.number,
              prefixIcon: Icon(
                Icons.attach_money,
                size: 20,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12),

            // Description
            PostTextField(
              controller: descriptionController,
              hintText: 'Item description...',
              maxLines: 4,
            ),
          ],
        );
      },
    );
  }
}
