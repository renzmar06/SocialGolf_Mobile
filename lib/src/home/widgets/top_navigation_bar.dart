import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TopNavigationBar extends StatelessWidget {
  const TopNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 12),
            _buildNavButton(
              context,
              'Create Round',
              Icons.add,
              isPrimary: true,
              onTap: () {
                // Navigate to Create Round Page
                print("Navigating to Create Round");
              },
            ),
            const SizedBox(width: 12),
            _buildNavButton(
              context,
              'Find Players',
              null,
              onTap: () => print("Navigating to Find Players"),
            ),
            const SizedBox(width: 12),
            _buildNavButton(
              context,
              'Add Score',
              null,
              onTap: () {
                // context.push("/ScoreTracker");
                },
            ),
            const SizedBox(width: 12),
            _buildNavButton(
              context,
              'Events Near Me',
              null,
              onTap: () {
                context.push("/EventList");
              },
            ),
            const SizedBox(width: 12),
            _buildNavButton(
              context,
              'GroupsList',
              Icons.groups_outlined,
                onTap: () {
                  // context.push("/GroupsList");
                }
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(
      BuildContext context,
      String label,
      IconData? icon, {
        bool isPrimary = false,
        required VoidCallback onTap, // Added required callback
      }) {
    return GestureDetector(
      onTap: onTap, // Logic to handle the click
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF1B5E20) : Colors.white,
          border: Border.all(
            color: isPrimary ? const Color(0xFF1B5E20) : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: isPrimary ? Colors.white : Colors.black,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}