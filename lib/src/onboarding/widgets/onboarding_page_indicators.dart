import 'package:flutter/material.dart';
import 'package:social_golf_app/core/utils/constants/colors.dart';

class OnboardingPageIndicators extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const OnboardingPageIndicators({
    super.key,
    required this.currentPage,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 4,
          width: currentPage == index ? 32 : 4,
          decoration: BoxDecoration(
            color: currentPage == index
                ? ColorConstants.white
                : ColorConstants.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
