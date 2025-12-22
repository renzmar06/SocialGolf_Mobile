import 'package:flutter/material.dart';
import 'package:social_golf_app/core/utils/constants/colors.dart';
import 'package:social_golf_app/src/createPost/screens/create_post_screen.dart';
import 'package:social_golf_app/src/explore/screens/explore.dart';
import 'package:social_golf_app/src/home/screens/home.dart';
import 'package:social_golf_app/src/shop/screens/shop.dart';

class BottomNavbar extends StatefulWidget {
  final int initialIndex;

  const BottomNavbar({super.key, this.initialIndex = 0});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  // Temporary screens - will be replaced later
  final List<Widget> _screens = [
    // const Center(child: Text('Home Screen', style: TextStyle(fontSize: 24))),
    const HomeScreen(),
    // const Center(child: Text('Explore Screen', style: TextStyle(fontSize: 24))),
    ExploreScreen(),
    // const Center(
    //   child: Text('Create Post Screen', style: TextStyle(fontSize: 24)),
    // ),
    CreatePostScreen(),
    const Center(child: Text('Shop Screen', style: TextStyle(fontSize: 24))),
    // ShopScreen(),
    const Center(child: Text('Profile Screen', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(
                  icon: Icons.home_outlined,
                  label: 'Home',
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.explore_outlined,
                  label: 'Explore',
                  index: 1,
                ),
                _buildCenterButton(),
                _buildNavItem(
                  icon: Icons.shopping_bag_outlined,
                  label: 'Shop',
                  index: 3,
                ),
                _buildNavItem(
                  icon: Icons.person_outline,
                  label: 'Profile',
                  index: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCenterButton() {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = 2;
          });
        },
        child: Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            color: ColorConstants.btnColor,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? ColorConstants.btnColor : ColorConstants.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? ColorConstants.btnColor
                    : ColorConstants.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
