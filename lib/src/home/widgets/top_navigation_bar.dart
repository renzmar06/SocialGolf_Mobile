import 'package:flutter/material.dart';

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
            _buildNavButton('Create Round', Icons.add, isPrimary: true),
            const SizedBox(width: 12),
            _buildNavButton('Find Players', null),
            const SizedBox(width: 12),
            _buildNavButton('Add Score', null),
            const SizedBox(width: 12),
            _buildNavButton('Events Near Me', null),
            const SizedBox(width: 12),
            _buildNavButton('Groups', Icons.groups_outlined),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(
    String label,
    IconData? icon, {
    bool isPrimary = false,
  }) {
    return Container(
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
    );
  }
}
