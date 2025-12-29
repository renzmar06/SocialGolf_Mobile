import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/create_post_bloc.dart';
import '../bloc/create_post_event.dart';
import '../bloc/create_post_state.dart';
import 'post_text_field.dart';

class SellItemPostContent extends StatefulWidget {
  const SellItemPostContent({super.key});

  @override
  State<SellItemPostContent> createState() => _SellItemPostContentState();
}

class _SellItemPostContentState extends State<SellItemPostContent> {
  // Controllers ko initState mein define kiya taki data clear na ho
  late final TextEditingController itemNameController;
  late final TextEditingController priceController;
  late final TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    itemNameController = TextEditingController();
    priceController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    itemNameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
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
        return Column(
          children: [
            // --- MAIN IMAGE BOX ---
            GestureDetector(
              onTap: () => _showImageSourceDialog(context),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
                child: state.selectedImages.isEmpty
                    ? _buildPlaceholder()
                    : _buildMainPreview(state),
              ),
            ),

            // --- HORIZONTAL GALLERY (For extra photos) ---
            if (state.selectedImages.length > 1) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.selectedImages.length - 1,
                  itemBuilder: (context, index) {
                    final imageIndex = index + 1;
                    return _buildGalleryItem(state, imageIndex);
                  },
                ),
              ),
            ],

            // --- ADD MORE BUTTON ---
            if (state.selectedImages.isNotEmpty && state.selectedImages.length < 5) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _showImageSourceDialog(context),
                icon: const Icon(Icons.add_photo_alternate_outlined),
                label: const Text('Add More Photos'),
              ),
            ],

            const SizedBox(height: 16),
            PostTextField(controller: itemNameController, hintText: 'Item name'),
            const SizedBox(height: 12),
            PostTextField(
              controller: priceController,
              hintText: 'Price',
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.attach_money, size: 20),
            ),
            const SizedBox(height: 12),
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

  // UI Helpers
  Widget _buildPlaceholder() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_photo_alternate_outlined, size: 48, color: Colors.grey),
          Text('Add item photo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildMainPreview(CreatePostState state) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(state.selectedImages[0], fit: BoxFit.cover),
          Positioned(
            top: 8, right: 8,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 18),
                onPressed: () => context.read<CreatePostBloc>().add(const RemoveImageEvent(0)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryItem(CreatePostState state, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(state.selectedImages[index], width: 80, height: 80, fit: BoxFit.cover),
          ),
          Positioned(
            top: 4, right: 4,
            child: GestureDetector(
              onTap: () => context.read<CreatePostBloc>().add(RemoveImageEvent(index)),
              child: const CircleAvatar(
                radius: 10, backgroundColor: Colors.black54,
                child: Icon(Icons.close, size: 12, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}