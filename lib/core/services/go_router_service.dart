import 'package:social_golf_app/bottomNavbar.dart';
import 'package:social_golf_app/src/auth/forgotPassword/forgotPassword.dart';
import 'package:social_golf_app/src/auth/signIn/signIn.dart';
import 'package:social_golf_app/src/auth/signUp/signUp.dart';
import 'package:social_golf_app/src/onboarding/screens/onboarding.dart';
import 'package:social_golf_app/src/shop/screens/shop.dart';
import 'package:social_golf_app/src/splash/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),

    GoRoute(
      path: '/bottom-navigation',
      builder: (BuildContext context, GoRouterState state) {
        final extra = state.extra as Map<String, dynamic>?;
        final initialIndex = extra != null
            ? extra['initialIndex'] as int? ?? 0
            : 0;
        return BottomNavbar(initialIndex: initialIndex);
      },
    ),
    GoRoute(
      path: '/onboarding',
      builder: (BuildContext context, GoRouterState state) {
        return const OnboardingScreen();
      },
    ),
    GoRoute(
      path: '/signin',
      builder: (BuildContext context, GoRouterState state) {
        return SignInScreen();
      },
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (BuildContext context, GoRouterState state) {
        return ForgotPasswordScreen();
      },
    ),
    GoRoute(
      path: '/signup',
      builder: (BuildContext context, GoRouterState state) {
        return SignUpScreen();
      },
    ),
    GoRoute(
      path: '/shop',
      builder: (BuildContext context, GoRouterState state) {
        return ShopScreen();
      },
    ),
  ],
);
