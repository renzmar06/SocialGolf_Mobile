import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_golf_app/core/utils/constants/colors.dart';
import 'post_text_field.dart';
import '../bloc/create_post_bloc.dart';
import '../bloc/create_post_event.dart';
import '../bloc/create_post_state.dart';

class FindPlayersPostContent extends StatelessWidget {
  const FindPlayersPostContent({super.key});

  @override
  Widget build(BuildContext context) {
    final courseNameController = TextEditingController();
    final teeTimeController = TextEditingController();
    final detailsController = TextEditingController();

    return Column(
      children: [
        // Course name
        PostTextField(
          controller: courseNameController,
          hintText: 'Course name',
        ),
        const SizedBox(height: 12),

        // Row for Tee Time and Players Needed
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tee Time',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  PostTextField(
                    controller: teeTimeController,
                    hintText: '--:--',
                    readOnly: true,
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
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
                      if (time != null) {
                        teeTimeController.text = time.format(context);
                      }
                    },
                    prefixIcon: Icon(
                      Icons.access_time,
                      size: 20,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Players Needed (1-3)',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<CreatePostBloc, CreatePostState>(
                    builder: (context, state) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: state.playersNeeded > 1
                                  ? () {
                                      context.read<CreatePostBloc>().add(
                                        const DecrementPlayersEvent(),
                                      );
                                    }
                                  : null,
                              icon: Icon(
                                Icons.remove,
                                color: state.playersNeeded > 1
                                    ? ColorConstants.btnColor
                                    : Colors.grey.shade400,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                state.playersNeeded.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: state.playersNeeded < 3
                                  ? () {
                                      context.read<CreatePostBloc>().add(
                                        const IncrementPlayersEvent(),
                                      );
                                    }
                                  : null,
                              icon: Icon(
                                Icons.add,
                                color: state.playersNeeded < 3
                                    ? ColorConstants.btnColor
                                    : Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Additional details
        PostTextField(
          controller: detailsController,
          hintText: 'Any additional details...',
          maxLines: 4,
        ),
      ],
    );
  }
}
