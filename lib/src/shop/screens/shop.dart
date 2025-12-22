import 'package:flutter/material.dart';
import 'package:social_golf_app/core/common/widgets/common_app_bar.dart';
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
      appBar: const CommonAppBar(
        title: 'Marketplace',
        automaticallyImplyLeading: false,
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
