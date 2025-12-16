import 'package:flutter/material.dart';
import 'package:social_golf_app/core/utils/constants/colors.dart';

class ShopViewToggle extends StatelessWidget {
  const ShopViewToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Text(
            '0 items found',
            style: TextStyle(color: ColorConstants.grey, fontSize: 14),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              // Toggle view
            },
            icon: const Icon(Icons.grid_view_rounded),
            color: ColorConstants.btnColor,
          ),
          IconButton(
            onPressed: () {
              // Toggle view
            },
            icon: const Icon(Icons.list),
            color: ColorConstants.grey,
          ),
        ],
      ),
    );
  }
}
