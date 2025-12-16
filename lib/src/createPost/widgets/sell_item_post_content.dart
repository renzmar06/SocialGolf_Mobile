import 'package:flutter/material.dart';
import 'post_text_field.dart';

class SellItemPostContent extends StatelessWidget {
  const SellItemPostContent({super.key});

  @override
  Widget build(BuildContext context) {
    final itemNameController = TextEditingController();
    final priceController = TextEditingController();
    final descriptionController = TextEditingController();

    return Column(
      children: [
        // Upload item photo area
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
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Item name
        PostTextField(controller: itemNameController, hintText: 'Item name'),
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
  }
}
