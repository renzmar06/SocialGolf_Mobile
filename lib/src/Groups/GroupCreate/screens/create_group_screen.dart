import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/constants/colors.dart';
import '../bloc/create_group_bloc.dart';
import '../bloc/create_group_event.dart';
import '../bloc/create_group_state.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _groupNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // --- IMAGE PICKING LOGIC ---
  Future<void> _pickImage(BuildContext blocContext, ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null && mounted) {
        blocContext.read<CreateGroupBloc>().add(AddCoverImage(File(image.path)));
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
    return BlocProvider(
      create: (context) => CreateGroupBloc(),
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFB),
        appBar:  AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Create Group',
            style: TextStyle(fontWeight: FontWeight. bold, color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            BlocBuilder<CreateGroupBloc, CreateGroupState>(
              builder: (blocContext, state) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: TextButton(
                    onPressed: state.isSubmitting
                        ? null
                        : () {
                      blocContext.read<CreateGroupBloc>().add(
                        SubmitGroup(
                          groupName: _groupNameController.text,
                          description:  _descriptionController. text,
                        ),
                      );
                    },
                    style:  TextButton.styleFrom(
                      backgroundColor: ColorConstants.btnColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: state.isSubmitting
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color:  Colors.white,
                        strokeWidth:  2,
                      ),
                    )
                        :  const Text(
                      'Create',
                      style:  TextStyle(
                        color: Colors. white,
                        fontSize: 14,
                        fontWeight: FontWeight. w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocConsumer<CreateGroupBloc, CreateGroupState>(
          listener:  (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state. errorMessage!)),
              );
            }
          },
          builder: (blocContext, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel("Cover Image"),
                  const SizedBox(height: 8),
                  // Upload Box with Image Preview
                  _buildCoverImageBox(blocContext, state),
                  const SizedBox(height:  24),
                  _sectionLabel("Group Name"),
                  const SizedBox(height: 8),
                  _buildTextField(
                    _groupNameController,
                    "e.g., Weekend Warriors Golf Club",
                  ),
                  const SizedBox(height: 24),
                  _sectionLabel("Description"),
                  const SizedBox(height: 8),
                  _buildTextField(
                    _descriptionController,
                    "Tell people what this group is about...",
                    maxLines: 4,
                  ),
                  const SizedBox(height:  24),
                  // Private Group Toggle Card
                  _buildPrivateToggle(blocContext, state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // --- COVER IMAGE BOX ---
  Widget _buildCoverImageBox(BuildContext blocContext, CreateGroupState state) {
    final hasImage = state.coverImage != null;

    return GestureDetector(
      onTap: () => _showImageSourceDialog(blocContext),
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors. grey.shade200,
            style: BorderStyle.solid,
          ),
        ),
        child: hasImage
            ? _buildImagePreview(blocContext, state.coverImage!)
            : _buildUploadPlaceholder(),
      ),
    );
  }

  Widget _buildUploadPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment. center,
      children: [
        Icon(Icons.cloud_upload_outlined, size: 40, color: Colors. grey.shade400),
        const SizedBox(height:  12),
        Text(
          'Upload cover image',
          style: TextStyle(
            color:  Colors.grey.shade600,
            fontWeight: FontWeight. w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Tap to select from camera or gallery',
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize:  12,
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview(BuildContext blocContext, File imageFile) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(
            imageFile,
            fit: BoxFit.cover,
            key: ValueKey(imageFile.path),
            gaplessPlayback: true,
          ),
        ),
        // Change Image Overlay Button
        Positioned(
          bottom: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration:  BoxDecoration(
              color: Colors. black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child:  const Row(
              mainAxisSize: MainAxisSize. min,
              children: [
                Icon(Icons.edit, color: Colors.white, size: 16),
                SizedBox(width:  4),
                Text(
                  'Change',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        // Remove Image Button
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => blocContext.read<CreateGroupBloc>().add(const RemoveCoverImage()),
            child: Container(
              padding:  const EdgeInsets. all(6),
              decoration:  const BoxDecoration(
                color: Colors. black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- PRIVATE TOGGLE ---
  Widget _buildPrivateToggle(BuildContext blocContext, CreateGroupState state) {
    return Container(
      padding:  const EdgeInsets. all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:  BorderRadius.circular(16),
        border: Border.all(color: Colors.grey. shade100),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Private Group',
                  style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  'Only members can see posts',
                  style: TextStyle(color: Colors.grey. shade500, fontSize:  13),
                ),
              ],
            ),
          ),
          Switch(
            value: state. isPrivate,
            activeColor: const Color(0xFF0D5D33),
            onChanged: (val) =>
                blocContext. read<CreateGroupBloc>().add(TogglePrivate(val)),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style:  const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color:  Color(0xFF334155),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String hint, {
        int maxLines = 1,
      }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        border:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color:  Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius. circular(12),
          borderSide:  const BorderSide(color: Color(0xFF0D5D33)),
        ),
      ),
    );
  }
}