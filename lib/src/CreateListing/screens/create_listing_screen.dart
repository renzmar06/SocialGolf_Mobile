import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/create_listing_bloc.dart';
import '../bloc/create_listing_event.dart';
import '../bloc/create_listing_state.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> categories = ["Clubs", "Bags", "Balls", "Apparel", "Accessories", "Carts", "Other"];
  final List<String> conditions = ["New", "Like New", "Good", "Fair", "Poor"];

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // --- IMAGE PICKING LOGIC ---
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
        // Dispatch to CreateListingBloc
        context.read<CreateListingBloc>().add(AddListingImage(File(image.path)));
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
      create: (context) => CreateListingBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const BackButton(color: Colors.black),
          title: const Text('Create Listing', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: BlocConsumer<CreateListingBloc, CreateListingState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
          builder: (context, state) {
            final bool isValid = _titleController.text.isNotEmpty &&
                _priceController.text.isNotEmpty &&
                state.selectedCategory.isNotEmpty &&
                state.selectedCondition.isNotEmpty;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Photos (up to 5)"),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      // Allow up to 5 photos
                      itemCount: state.images.length + (state.images.length < 5 ? 1 : 0),
                      itemBuilder: (ctx, index) {
                        if (index < state.images.length) {
                          return _buildImageThumbnail(ctx, state.images[index], index);
                        } else {
                          return _buildAddBox(context); // Pass main context for Bloc access
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildLabel("Title"),
                  _buildField(_titleController, "e.g., TaylorMade Stealth Driver"),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        _buildLabel("Category"),
                        _buildCategoryDropdown(context, state)
                      ])),
                      const SizedBox(width: 16),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        _buildLabel("Condition"),
                        _buildConditionDropdown(context, state)
                      ])),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildLabel("Price"),
                  _buildField(_priceController, "0.00", prefixText: "\$ "),
                  const SizedBox(height: 20),
                  _buildLabel("Location"),
                  _buildField(_locationController, "ttyt", icon: Icons.location_on_outlined),
                  const SizedBox(height: 20),
                  _buildLabel("Description"),
                  _buildField(_descriptionController, "Describe your item...", maxLines: 4),
                  const SizedBox(height: 30),
                  _buildSubmitButton(context, state, isValid),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildImageThumbnail(BuildContext ctx, File file, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(file, width: 80, height: 80, fit: BoxFit.cover),
          ),
          Positioned(
            top: 4, right: 4,
            child: GestureDetector(
              onTap: () => ctx.read<CreateListingBloc>().add(RemoveListingImage(index)),
              child: const CircleAvatar(
                radius: 10,
                backgroundColor: Colors.black54,
                child: Icon(Icons.close, color: Colors.white, size: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddBox(BuildContext context) => GestureDetector(
    onTap: () => _showImageSourceDialog(context), // Opens the Bottom Sheet
    child: Container(
      width: 80, height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt_outlined, color: Colors.grey),
          Text("Add", style: TextStyle(color: Colors.grey, fontSize: 12))
        ],
      ),
    ),
  );

  Widget _buildCategoryDropdown(BuildContext context, CreateListingState state) {
    return _buildDropdownContainer(
      DropdownButton<String>(
        value: state.selectedCategory.isEmpty ? null : state.selectedCategory,
        hint: const Text("Select", style: TextStyle(fontSize: 14)),
        isExpanded: true,
        dropdownColor: Colors.white,
        underline: const SizedBox(),
        items: categories.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
        onChanged: (val) => context.read<CreateListingBloc>().add(ChangeCategory(val!)),
      ),
    );
  }

  Widget _buildConditionDropdown(BuildContext context, CreateListingState state) {
    return _buildDropdownContainer(
      DropdownButton<String>(
        value: state.selectedCondition.isEmpty ? null : state.selectedCondition,
        hint: const Text("Select", style: TextStyle(fontSize: 14)),
        isExpanded: true,
        dropdownColor: Colors.white,
        underline: const SizedBox(),
        items: conditions.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
        onChanged: (val) => context.read<CreateListingBloc>().add(ChangeCondition(val!)),
      ),
    );
  }

  Widget _buildDropdownContainer(Widget child) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: DropdownButtonHideUnderline(child: child),
  );

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
  );

  Widget _buildField(TextEditingController ctrl, String hint, {int maxLines = 1, IconData? icon, String? prefixText}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey
        ),
        prefixText: prefixText,
        prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF91B19C))),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, CreateListingState state, bool isValid) {
    return GestureDetector(
      onTap: (state.isSubmitting || !isValid) ? null : () {
        context.read<CreateListingBloc>().add(SubmitListing(
          title: _titleController.text,
          price: _priceController.text,
          location: _locationController.text,
          description: _descriptionController.text,
        ));
      },
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: (state.isSubmitting || !isValid) ? Colors.grey.shade300 : const Color(0xFF91B19C),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: state.isSubmitting
              ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text("List Item for Sale", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
    );
  }
}