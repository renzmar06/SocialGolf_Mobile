import 'package:flutter/material.dart';
import 'package:social_golf_app/core/utils/constants/colors.dart';
import 'package:social_golf_app/core/utils/constants/image_strings.dart';
import '../widgets/onboarding_data.dart';
import '../widgets/onboarding_page_view.dart';
import '../widgets/onboarding_page_indicators.dart';
import '../widgets/onboarding_action_button.dart';
// import 'package:social_golf_app/core/shared_pref/preferences_utils.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late AnimationController _scaleAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      image: ImageStrings.onBoardingImage1,
      background: ImageStrings.onBoardingBg1,
      title: 'Welcome to Social Golf',
      description:
          'Connect with fellow golfers, join tournaments, and improve your game in a vibrant community.',
      color: ColorConstants.yellow,
    ),
    OnboardingData(
      image: ImageStrings.onBoardingImage2,
      background: ImageStrings.onBoardingBg2,
      title: 'Track Your Performance',
      description:
          'Keep track of your scores, analyze your progress, and compete with friends on the leaderboard.',
      color: ColorConstants.btnColor,
    ),
    OnboardingData(
      image: ImageStrings.onBoardingImage3,
      background: ImageStrings.onBoardingBg3,
      title: 'Book Tee Times',
      description:
          'Easily book tee times at your favorite courses and discover new golf destinations.',
      color: ColorConstants.yellow,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Fade and slide animation for content
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Scale animation for images
    _scaleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _scaleAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _animationController.forward();
    _scaleAnimationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _scaleAnimationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _animationController.reset();
    _scaleAnimationController.reset();
    _animationController.forward();
    _scaleAnimationController.forward();
  }

  Future<void> _completeOnboarding() async {
    // await PreferencesUtil.setIsFirstLaunch(false);
    if (mounted) {
      // Navigate to your main screen or login screen
      // Example: context.go('/login');
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  // void _skipOnboarding() {
  //   _pageController.animateToPage(
  //     _pages.length - 1,
  //     duration: const Duration(milliseconds: 600),
  //     curve: Curves.easeInOut,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Page View - Full screen without SafeArea
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return OnboardingPageView(
                data: _pages[index],
                fadeAnimation: _fadeAnimation,
                scaleAnimation: _scaleAnimation,
                slideAnimation: _slideAnimation,
              );
            },
          ),

          // Bottom Section with indicators and button - Floating style with SafeArea
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 40,
                ),
                child: Column(
                  children: [
                    // Page Indicators
                    OnboardingPageIndicators(
                      currentPage: _currentPage,
                      pageCount: _pages.length,
                    ),
                    const SizedBox(height: 24),

                    // Next/Get Started Button
                    OnboardingActionButton(
                      isLastPage: _currentPage == _pages.length - 1,
                      onPressed: _nextPage,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
