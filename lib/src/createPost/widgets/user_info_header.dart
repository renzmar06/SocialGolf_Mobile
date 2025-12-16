import 'package:flutter/material.dart';
import 'package:social_golf_app/core/utils/constants/colors.dart';

class UserInfoHeader extends StatelessWidget {
  final String userName;
  final String? userInitial;

  const UserInfoHeader({super.key, required this.userName, this.userInitial});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: ColorConstants.btnColor.withOpacity(0.2),
            child: Text(
              userInitial ?? userName[0].toUpperCase(),
              style: TextStyle(
                color: ColorConstants.btnColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: ColorConstants.btnColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Add location',
                      style: TextStyle(
                        fontSize: 12,
                        color: ColorConstants.btnColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
