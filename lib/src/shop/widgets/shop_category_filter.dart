import 'package:flutter/material.dart';
import 'category_chip.dart';

class ShopCategoryFilter extends StatelessWidget {
  const ShopCategoryFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: const [
          CategoryChip(label: 'All', isSelected: true),
          CategoryChip(label: 'Clubs', isSelected: false),
          CategoryChip(label: 'Bags', isSelected: false),
          CategoryChip(label: 'Balls', isSelected: false),
          CategoryChip(label: 'Apparel', isSelected: false),
          CategoryChip(label: 'Accessories', isSelected: false),
        ],
      ),
    );
  }
}
