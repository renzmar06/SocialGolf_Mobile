import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_golf_app/core/utils/constants/colors.dart';
import 'post_text_field.dart';

class ScorePostContent extends StatelessWidget {
  const ScorePostContent({super.key});

  @override
  Widget build(BuildContext context) {
    final scoreController = TextEditingController(text: '72');
    final courseNameController = TextEditingController();
    final dateController = TextEditingController();
    final notesController = TextEditingController();

    return Column(
      children: [
        // Score display
        Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: ColorConstants.btnColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              children: [
                TextField(
                  controller: scoreController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: '72',
                    hintStyle: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your Score',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Course name
        PostTextField(
          controller: courseNameController,
          hintText: 'Course name',
        ),
        const SizedBox(height: 12),

        // Date picker
        PostTextField(
          controller: dateController,
          hintText: 'dd-mm-yyyy',
          readOnly: true,
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: ColorConstants.btnColor,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (date != null) {
              dateController.text =
                  '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
            }
          },
          prefixIcon: Icon(
            Icons.calendar_today,
            size: 20,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 12),

        // Notes
        PostTextField(
          controller: notesController,
          hintText: 'Notes about your round...',
          maxLines: 4,
        ),
      ],
    );
  }
}
