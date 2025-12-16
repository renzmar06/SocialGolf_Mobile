import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_golf_app/core/utils/constants/colors.dart';
import 'package:social_golf_app/core/common/widgets/custom_button.dart';

class OnboardingActionButton extends StatelessWidget {
  final bool isLastPage;
  final VoidCallback onPressed;

  const OnboardingActionButton({
    super.key,
    required this.isLastPage,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CustomButton(
        onPressed: () {
          if (isLastPage) {
            context.push('/signin');
          } else {
            onPressed();
          }
        },
        backgroundColor: ColorConstants.yellow,
        textColor: ColorConstants.white,
        borderRadius: 30,
        btnText: isLastPage ? 'Get Started' : 'Next',
      ),
    );
  }
}
