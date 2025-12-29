import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';
import '../../../../core/common/widgets/common_text_field.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/image_strings.dart';
import '../../GroupCreate/screens/create_group_screen.dart';

class GroupsListScreen extends StatelessWidget {
  const GroupsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('GroupsList',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 22)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: () {
                context.push("/CreateGroup");
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
                    'Create',
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CommonTextField(
              // controller: controller,
              hintText: 'Search groups...',
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
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('All GroupsList', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),
          // Group Card
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 1, // Example
              itemBuilder: (context, index) => _buildGroupCard(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(BuildContext context) {
    return GestureDetector(
      onTap: (){
        context.push("/GroupDetail");
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(ImageStrings.logo,width: 30,height: 30,),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Warrior Club', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(width: 4),
                      Icon(Icons.lock_outline, size: 14, color: Colors.grey.shade400),
                    ],
                  ),
                  Text('test', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                  Text('1 members', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade200),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Join', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}