import 'package:flutter/material.dart';
import 'package:social_golf_app/core/utils/constants/colors.dart';
import 'package:social_golf_app/core/common/widgets/common_text_field.dart';

class ShopSearchBar extends StatelessWidget {
  final TextEditingController controller;

  const ShopSearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CommonTextField(
        controller: controller,
        hintText: 'Search items...',
        fillColor: Colors.grey[100]!,
        borderColor: Colors.transparent,
        borderRadius: 12,
        maxLines: 1,
        textInputAction: TextInputAction.search,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Icon(Icons.search, color: ColorConstants.grey),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
