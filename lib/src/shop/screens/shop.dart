import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_golf_app/core/common/widgets/common_app_bar.dart';
import '../../../core/utils/constants/colors.dart';
import '../widgets/shop_search_bar.dart';
import '../widgets/shop_category_filter.dart';
import '../widgets/shop_view_toggle.dart';
import '../widgets/shop_empty_state.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: 'Marketplace',
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: () {
                context.push('/CreateListing');
              },
              style: TextButton.styleFrom(
                backgroundColor: ColorConstants.btnColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.add,
                    size: 18,
                    color: Colors.white,
                  ),
                  SizedBox(width: 5,),
                  const Text(
                    'Sell',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          ShopSearchBar(controller: searchController),
          const ShopCategoryFilter(),
          const SizedBox(height: 16),
          const ShopViewToggle(),
          const Expanded(child: ShopEmptyState()),
        ],
      ),
    );
  }
}
