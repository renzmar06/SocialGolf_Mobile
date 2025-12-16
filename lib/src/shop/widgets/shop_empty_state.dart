import 'package:flutter/material.dart';
import 'package:social_golf_app/core/utils/constants/colors.dart';
import 'package:social_golf_app/core/common/widgets/custom_button.dart';

class ShopEmptyState extends StatelessWidget {
  const ShopEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: ColorConstants.btnColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 50,
              color: ColorConstants.btnColor,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No items found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to list something for sale!',
            style: TextStyle(fontSize: 14, color: ColorConstants.grey),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: CustomButton(
              onPressed: () {
                // Navigate to create listing screen
              },
              backgroundColor: ColorConstants.btnColor,
              btnText: 'Create Listing',
              maxWidth: 200,
            ),
          ),
        ],
      ),
    );
  }
}
